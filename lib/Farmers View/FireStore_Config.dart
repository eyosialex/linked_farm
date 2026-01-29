import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echat/Farmers%20View/Sell_Item_Model.dart';
import 'package:firebase_auth/firebase_auth.dart';
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'agricultural_items';
  Future<String?> addAgriculturalItem(AgriculturalItem item) async {
    try {
      if (item.id != null) {
        // Use the existing ID to prevent duplicates
        await _firestore
            .collection(_collectionName)
            .doc(item.id)
            .set(item.toJson(), SetOptions(merge: true));
        return item.id;
      } else {
        // Create a new ID
        DocumentReference docRef = await _firestore
            .collection(_collectionName)
            .add(item.toJson());
        print('Item saved to Firestore with ID: ${docRef.id}');
        return docRef.id;
      }
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
        // Removed server-side orderBy to avoid creating a composite index
        // .orderBy('createdAt', descending: true) 
        .snapshots()
        .map((snapshot) {
      final items = snapshot.docs
          .map((doc) => AgriculturalItem.fromFirestore(doc.data(), doc.id))
          .toList();
      
      // Sort client-side instead
      items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return items;
    });
  }

  Future<void> incrementProductView(String productId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    String userId = user.uid;

    try {
      DocumentReference docRef = _firestore.collection(_collectionName).doc(productId);
      
      // Use a transaction to check if user already viewed
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(docRef);
        
        if (!snapshot.exists) return;
        
        List<dynamic> viewedBy = snapshot.get('viewedBy') ?? [];
        
        if (!viewedBy.contains(userId)) {
          transaction.update(docRef, {
            'viewedBy': FieldValue.arrayUnion([userId]),
            'views': FieldValue.increment(1),
          });
        }
      });
    } catch (e) {
      print('Error incrementing view: $e');
    }
  }

  Future<void> toggleProductLike(String productId, String userId) async {
    try {
      DocumentReference docRef = _firestore.collection(_collectionName).doc(productId);
      
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(docRef);
        
        if (!snapshot.exists) return;
        
        List<dynamic> likedBy = snapshot.get('likedBy') ?? [];
        
        if (likedBy.contains(userId)) {
          // Unlike
           transaction.update(docRef, {
            'likedBy': FieldValue.arrayRemove([userId]),
            'likes': FieldValue.increment(-1),
          });
        } else {
          // Like
          transaction.update(docRef, {
            'likedBy': FieldValue.arrayUnion([userId]),
            'likes': FieldValue.increment(1),
          });
        }
      });
    } catch (e) {
      print('Error updating like: $e');
    }
  }

  Future<bool> updateProductStock(String productId, int newQuantity) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(productId)
          .update({
            'quantity': newQuantity,
            'updatedAt': DateTime.now().toIso8601String(),
          });
      return true;
    } catch (e) {
      print('Firestore stock update error: $e');
      return false;
    }
  }
}