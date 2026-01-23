import 'package:cloud_firestore/cloud_firestore.dart';

class WantedProduct {
  final String id;
  final String productName;
  final String category;
  final String quantityNeeded;
  final String vendorId;
  final String vendorName;
  final String? location;
  final DateTime createdAt;
  final bool isMet;

  WantedProduct({
    required this.id,
    required this.productName,
    required this.category,
    required this.quantityNeeded,
    required this.vendorId,
    required this.vendorName,
    this.location,
    required this.createdAt,
    this.isMet = false,
  });

  Map<String, dynamic> toJson() => {
    'productName': productName,
    'category': category,
    'quantityNeeded': quantityNeeded,
    'vendorId': vendorId,
    'vendorName': vendorName,
    'location': location,
    'createdAt': FieldValue.serverTimestamp(),
    'isMet': isMet,
  };

  factory WantedProduct.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return WantedProduct(
      id: doc.id,
      productName: data['productName'] ?? '',
      category: data['category'] ?? 'Others',
      quantityNeeded: data['quantityNeeded'] ?? '',
      vendorId: data['vendorId'] ?? '',
      vendorName: data['vendorName'] ?? 'Vendor',
      location: data['location'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isMet: data['isMet'] ?? false,
    );
  }
}
