import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echat/Farmers%20View/Sell_Item_Model.dart';
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'agricultural_items';
  Future<String?> addAgriculturalItem(AgriculturalItem item) async {
    try {
      DocumentReference docRef = await _firestore
          .collection(_collectionName)
          .add(item.toJson());
      print('Item saved to Firestore with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('Firestore error: $e');
      return null;
    }
  }

  Future<bool> updateAgriculturalItem(String docId, AgriculturalItem item) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(docId)
          .update(item.toJson());
      return true;
    } catch (e) {
      print('Firestore update error: $e');
      return false;
    }
  }

  Stream<List<AgriculturalItem>> getAgriculturalItems() {
    return _firestore
        .collection(_collectionName)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AgriculturalItem.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  Future<AgriculturalItem?> getAgriculturalItem(String docId) async {
    try {
      DocumentSnapshot snapshot = await _firestore
          .collection(_collectionName)
          .doc(docId)
          .get();
      
      if (snapshot.exists) {
        return AgriculturalItem.fromFirestore(
          snapshot.data() as Map<String, dynamic>,
          snapshot.id,
        );
      }
      return null;
    } catch (e) {
      print('Firestore get error: $e');
      return null;
    }
  }
  Future<void> deleteAgriculturalItem(String docId) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(docId)
          .delete();
    } catch (e) {
      print('Firestore delete error: $e');
    }
  }

  // New specific methods
  Stream<List<AgriculturalItem>> getAgriculturalItemsBySeller(String sellerId) {
    return _firestore
        .collection(_collectionName)
        .where('sellerId', isEqualTo: sellerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AgriculturalItem.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  Future<void> incrementProductView(String productId) async {
    try {
      await _firestore.collection(_collectionName).doc(productId).update({
        'views': FieldValue.increment(1),
      });
    } catch (e) {
      print('Error incrementing view: $e');
    }
  }

  Future<void> toggleProductLike(String productId, String userId) async {
    // Note: For a robust like system, you should store likes in a separate collection 
    // or an array of user IDs on the product document to prevent double-liking.
    // For this simple implementation, we'll just increment/decrement a counter, 
    // but in a real app, you'd check if the user already liked it.
    
    // Here we will just increment for now as per the "number of like" request
    try {
      await _firestore.collection(_collectionName).doc(productId).update({
        'likes': FieldValue.increment(1),
      });
    } catch (e) {
      print('Error updating like: $e');
    }
  }
}