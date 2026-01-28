import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:http/http.dart' as http;
import '../Farmers View/Sell_Item_Model.dart';
import 'local_storage_service.dart';

class WifiShareService {
  final LocalStorageService _localStorageService;
  
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

    final handler = const Pipeline()
        .addMiddleware(logRequests())
        .addHandler(router);

    final server = await shelf_io.serve(handler, '0.0.0.0', 8080);
    print('P2P Server running on port ${server.port}');
  }

  Future<bool> sendProduct(AgriculturalItem product, String targetIp) async {
    try {
      final response = await http.post(
        Uri.parse('http://$targetIp:8080/receive_product'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toJson()),
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      print('Error sending P2P product: $e');
      return false;
    }
  }

  Future<void> propagateUnsynced(String targetIp) async {
    final unsynced = _localStorageService.getUnsyncedProducts();
    for (var product in unsynced) {
      bool success = await sendProduct(product, targetIp);
      if (success) {
        print('Propagated ${product.name} to $targetIp');
      }
    }
  }
}
