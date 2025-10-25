import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echat/sell%20item/sell_itemmodel.dart';
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
}