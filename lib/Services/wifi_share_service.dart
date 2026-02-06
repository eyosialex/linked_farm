import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:http/http.dart' as http;
import 'package:nsd/nsd.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../Farmers View/Sell_Item_Model.dart';
import 'local_storage_service.dart';

class WifiShareService {
  final LocalStorageService _localStorageService;

  static const int _port = 8080;
  static const String _serviceType = '_agrilead._tcp';
  static const String _serviceName = 'AgriLead';

  Registration? _registration;

  WifiShareService(this._localStorageService);

  Future<void> startServer() async {
    final router = Router();

    router.post('/receive_product', (Request request) async {
      try {
        final payload = await request.readAsString();
        final data = json.decode(payload);
        
        // Use fromFirestore as it handles the logic for data + id
        // In P2P, we assume the JSON already contains the id field.
        final product = AgriculturalItem.fromFirestore(data, data['id']);
        
        // Save locally and mark as unsynced so this device can also sync to cloud
        await _localStorageService.saveProduct(product.copyWith(isSynced: false));
        
        print('Received via P2P: ${product.name}');
        return Response.ok(json.encode({'status': 'success'}));
      } catch (e) {
        print('Error receiving P2P product: $e');
        return Response.internalServerError(body: e.toString());
      }
    });

    // New endpoint: receive product + offline images (base64) + location in one payload
    router.post('/receive_product_bundle', (Request request) async {
      try {
        final payload = await request.readAsString();
        final data = json.decode(payload) as Map<String, dynamic>;

        final productJson = (data['product'] as Map).cast<String, dynamic>();
        final productId = (productJson['id'] ?? data['id'] ?? '') as String;
        final product = AgriculturalItem.fromFirestore(productJson, productId);

        final images = (data['images'] as List?)?.cast<String>() ?? const <String>[];
        final savedPaths = <String>[];
        if (images.isNotEmpty) {
          savedPaths.addAll(await _saveIncomingImages(productId: productId, base64Images: images));
        }

        final toSave = product.copyWith(
          isSynced: false,
          // Prefer local images for offline usage
          localImagePaths: savedPaths.isNotEmpty ? savedPaths : product.localImagePaths,
          imageUrls: savedPaths.isNotEmpty ? <String>[] : product.imageUrls,
        );

        await _localStorageService.saveProduct(toSave);
        print('Received via P2P bundle: ${product.name} (${savedPaths.length} images)');
        return Response.ok(json.encode({'status': 'success'}));
      } catch (e) {
        print('Error receiving P2P bundle: $e');
        return Response.internalServerError(body: e.toString());
      }
    });

    final handler = const Pipeline()
        .addMiddleware(logRequests())
        .addHandler(router);

    final server = await shelf_io.serve(handler, '0.0.0.0', _port);
    print('P2P Server running on port ${server.port}');

    // Advertise this device on the LAN (Wi‑Fi or hotspot LAN)
    await _startAdvertising();
  }

  Future<bool> sendProduct(AgriculturalItem product, String targetIp) async {
    try {
      final response = await http.post(
        Uri.parse('http://$targetIp:$_port/receive_product'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toJson()),
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      print('Error sending P2P product: $e');
      return false;
    }
  }

  /// Sends the product plus local images (offline) in a single request.
  /// This avoids "image not available" when the receiver has no internet.
  Future<bool> sendProductBundle(AgriculturalItem product, String targetHostOrIp) async {
    try {
      final images = await _readLocalImagesAsBase64(product.localImagePaths);
      final payload = {
        'id': product.id,
        'product': product.toJson(),
        'images': images,
      };

      final response = await http
          .post(
            Uri.parse('http://$targetHostOrIp:$_port/receive_product_bundle'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(payload),
          )
          .timeout(const Duration(seconds: 15));

      return response.statusCode == 200;
    } catch (e) {
      print('Error sending P2P bundle: $e');
      return false;
    }
  }

  Future<void> propagateUnsynced(String targetIp) async {
    final unsynced = _localStorageService.getUnsyncedProducts();
    for (var product in unsynced) {
      bool success = await sendProductBundle(product, targetIp);
      if (success) {
        print('Propagated ${product.name} to $targetIp');
      }
    }
  }

  Future<void> _startAdvertising() async {
    try {
      if (_registration != null) return;
      _registration = await register(const Service(
        name: _serviceName,
        type: _serviceType,
        port: _port,
      ));
      print('✅ NSD advertised: $_serviceName ($_serviceType:$_port)');
    } catch (e) {
      print('❌ NSD advertise failed: $e');
    }
  }

  Future<void> stopAdvertising() async {
    try {
      final reg = _registration;
      if (reg != null) {
        await unregister(reg);
      }
    } catch (e) {
      print('❌ NSD unadvertise failed: $e');
    } finally {
      _registration = null;
    }
  }

  /// Discover nearby farmers automatically (no IP typing).
  /// Returns hostnames/IPs that can be used in HTTP calls.
  Future<List<Service>> discoverPeers({Duration timeout = const Duration(seconds: 2)}) async {
    final discovery = await startDiscovery(_serviceType, ipLookupType: IpLookupType.any);
    await Future.delayed(timeout);
    await stopDiscovery(discovery);

    // Deduplicate by (host+port) best-effort
    final seen = <String>{};
    final out = <Service>[];
    for (final s in discovery.services) {
      final String host = (s.addresses != null && s.addresses!.isNotEmpty)
          ? s.addresses!.first.address
          : (s.host ?? 'unknown');
      final key = '$host:${s.port}';
      if (seen.add(key)) out.add(s);
    }
    return out;
  }

  Future<List<String>> _readLocalImagesAsBase64(List<String>? paths) async {
    if (paths == null || paths.isEmpty) return const <String>[];
    final out = <String>[];
    for (final filePath in paths) {
      try {
        final f = File(filePath);
        if (!await f.exists()) continue;
        final bytes = await f.readAsBytes();
        // Lightweight guard to avoid huge payloads over hotspot/Wi‑Fi
        if (bytes.lengthInBytes > 6 * 1024 * 1024) continue; // skip > 6MB
        out.add(base64Encode(bytes));
      } catch (_) {
        // ignore individual failures
      }
    }
    return out;
  }

  Future<List<String>> _saveIncomingImages({
    required String productId,
    required List<String> base64Images,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    final root = Directory(p.join(dir.path, 'p2p_images', productId));
    if (!await root.exists()) {
      await root.create(recursive: true);
    }

    final saved = <String>[];
    for (var i = 0; i < base64Images.length; i++) {
      try {
        final Uint8List bytes = base64Decode(base64Images[i]);
        final file = File(p.join(root.path, 'img_$i.jpg'));
        await file.writeAsBytes(bytes, flush: true);
        saved.add(file.path);
      } catch (_) {
        // ignore individual failures
      }
    }
    return saved;
  }
}
