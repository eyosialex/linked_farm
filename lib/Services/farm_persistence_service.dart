import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Vendors View/WantedProductModel.dart';
import '../Models/notification_model.dart';

class UserLand {
  final String id;
  final String name;
  final double size; // hectares
  final String soilType;
  final String? activeCrop;
  final int currentDay;
  final double growthProgress;
  final double moisture;
  final double nutrients;
  final double health;
  final List<Map<String, dynamic>> customActivities;
  final DateTime updatedAt;

  UserLand({
    required this.id,
    required this.name,
    required this.size,
    required this.soilType,
    this.activeCrop,
    this.currentDay = 1,
    this.growthProgress = 0.0,
    this.moisture = 0.5,
    this.nutrients = 0.5,
    this.health = 1.0,
    this.customActivities = const [],
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'size': size,
    'soilType': soilType,
    'activeCrop': activeCrop,
    'currentDay': currentDay,
    'growthProgress': growthProgress,
    'moisture': moisture,
    'nutrients': nutrients,
    'health': health,
    'customActivities': customActivities,
    'updatedAt': FieldValue.serverTimestamp(),
  };

  factory UserLand.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return UserLand(
      id: doc.id,
      name: data['name'] ?? 'Unnamed Plot',
      size: (data['size'] ?? 1.0).toDouble(),
      soilType: data['soilType'] ?? 'Loamy',
      activeCrop: data['activeCrop'],
      currentDay: data['currentDay'] ?? 1,
      growthProgress: (data['growthProgress'] ?? 0.0).toDouble(),
      moisture: (data['moisture'] ?? 0.5).toDouble(),
      nutrients: (data['nutrients'] ?? 0.5).toDouble(),
      health: (data['health'] ?? 1.0).toDouble(),
      customActivities: List<Map<String, dynamic>>.from(
        (data['customActivities'] ?? []).map((v) {
          final map = Map<String, dynamic>.from(v);
          map['isCompleted'] ??= false;
          return map;
        }),
      ),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

class FarmPersistenceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  CollectionReference get _landsCollection => 
    _firestore.collection('users').doc(_userId).collection('user_lands');

  Future<void> saveLand(UserLand land) async {
    if (_userId == null) return;
    await _landsCollection.doc(land.id.isEmpty ? null : land.id).set(land.toJson(), SetOptions(merge: true));
  }

  Stream<List<UserLand>> streamUserLands() {
    if (_userId == null) return Stream.value([]);
    return _landsCollection.snapshots().map((snapshot) => 
      snapshot.docs.map((doc) => UserLand.fromFirestore(doc)).toList()
    );
  }

  Future<void> deleteLand(String landId) async {
    if (_userId == null) return;
    await _landsCollection.doc(landId).delete();
  }

  // --- Wanted Products (Vendor Requests) ---
  
  CollectionReference get _wantedProductsCollection => 
    _firestore.collection('wanted_products');

  Future<void> saveWantedProduct(WantedProduct request) async {
    await _wantedProductsCollection.doc(request.id.isEmpty ? null : request.id).set(request.toJson());
  }

  Stream<List<WantedProduct>> streamWantedProducts() {
    return _wantedProductsCollection
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => 
        snapshot.docs.map((doc) => WantedProduct.fromFirestore(doc)).toList()
      );
  }

  Future<void> deleteWantedProduct(String id) async {
    await _wantedProductsCollection.doc(id).delete();
  }

  // --- Notifications ---

  CollectionReference get _notificationsCollection => 
    _firestore.collection('users').doc(_userId).collection('notifications');

  Future<void> saveNotification(AppNotification notification) async {
    if (_userId == null) return;
    await _notificationsCollection.doc(notification.id.isEmpty ? null : notification.id).set(notification.toJson());
  }

  Stream<List<AppNotification>> streamNotifications() {
    if (_userId == null) return Stream.value([]);
    return _notificationsCollection
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) => 
        snapshot.docs.map((doc) => AppNotification.fromFirestore(doc)).toList()
      );
  }

  Future<void> markNotificationAsRead(String id) async {
    if (_userId == null) return;
    await _notificationsCollection.doc(id).update({'isRead': true});
  }

  Future<void> deleteNotification(String id) async {
    if (_userId == null) return;
    await _notificationsCollection.doc(id).delete();
  }
}
