import 'package:hive_flutter/hive_flutter.dart';
import '../Farmers View/Sell_Item_Model.dart';

class LocalStorageService {
  static const String productBoxName = 'products';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(AgriculturalItemAdapter());
    await Hive.openBox<AgriculturalItem>(productBoxName);
  }

  Box<AgriculturalItem> get _productBox => Hive.box<AgriculturalItem>(productBoxName);

  Future<void> saveProduct(AgriculturalItem product) async {
    await _productBox.put(product.id, product);
  }

  List<AgriculturalItem> getAllProducts() {
    return _productBox.values.toList();
  }

  List<AgriculturalItem> getUnsyncedProducts() {
    return _productBox.values.where((p) => !p.isSynced).toList();
  }

  Future<void> markAsSynced(String id) async {
    final product = _productBox.get(id);
    if (product != null) {
      product.isSynced = true;
      await product.save();
    }
  }

  Future<void> deleteProduct(String id) async {
    await _productBox.delete(id);
  }
}
