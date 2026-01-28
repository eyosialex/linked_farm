import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'local_storage_service.dart';
import '../Farmers View/FireStore_Config.dart';
import '../Farmers View/Cloudnary_Store.dart';
import '../Farmers View/Sell_Item_Model.dart';

class SyncService {
  final LocalStorageService _localStorageService;
  final FirestoreService _firestoreService;
  final CloudinaryService _cloudinaryService = CloudinaryService();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  SyncService(this._localStorageService, this._firestoreService);

  void startMonitoring() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((results) {
      if (results.any((result) => result != ConnectivityResult.none)) {
        print('Internet back! Starting sync...');
        syncNow();
      }
    });
  }

  Future<void> syncNow() async {
    final unsynced = _localStorageService.getUnsyncedProducts();
    if (unsynced.isEmpty) return;

    print('Attempting to sync ${unsynced.length} products to cloud...');
    
    for (var product in unsynced) {
      // 1. If product has local images but no cloud URLs, upload images first
      if ((product.imageUrls == null || product.imageUrls!.isEmpty) && 
          (product.localImagePaths != null && product.localImagePaths!.isNotEmpty)) {
        
        print('Uploading images for ${product.name}...');
        final files = product.localImagePaths!.map((path) => File(path)).toList();
        try {
          final imageUrls = await _cloudinaryService.uploadMultipleImages(files);
          if (imageUrls.isNotEmpty) {
            product.imageUrls = imageUrls;
            await _localStorageService.saveProduct(product); // Update local cache with URLs
          }
        } catch (e) {
          print('Error uploading images during sync: $e');
          continue; // Skip this product for now
        }
      }

      // 2. Upload product to Firestore
      final docId = await _firestoreService.addAgriculturalItem(product);
      if (docId != null) {
        await _localStorageService.markAsSynced(product.id!);
        print('Synced: ${product.name}');
      }
    }

    // Cleanup old records to save memory
    await _localStorageService.cleanupOldSyncedProducts();
  }

  void dispose() {
    _connectivitySubscription?.cancel();
  }
}
