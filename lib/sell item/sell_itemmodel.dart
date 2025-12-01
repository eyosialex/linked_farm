import 'package:firebase_auth/firebase_auth.dart';

class AgriculturalItem {
  String? id;
  String name;
  String category;
  String? subcategory;
  String description;
  double price;
  int quantity;
  String unit;
  String condition;
  List<String>? imageUrls;
  Map<String, double>? location;
  String sellerName;
  String sellerId;
  String contactInfo;
  DateTime? availableFrom;
  bool deliveryAvailable;
  List<String>? tags;
  DateTime createdAt;
  DateTime updatedAt;

  AgriculturalItem({
    this.id,
    required this.name,
    required this.category,
    this.subcategory,
    required this.description,
    required this.price,
    required this.quantity,
    required this.unit,
    required this.condition,
    this.imageUrls,
    required this.location,
    required this.sellerName,
    required this.sellerId,
    required this.contactInfo,
    this.availableFrom,
    this.deliveryAvailable = false,
    this.tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'subcategory': subcategory,
      'description': description,
      'price': price,
      'quantity': quantity,
      'unit': unit,
      'condition': condition,
      'imageUrls': imageUrls,
      'location': location,
      'sellerName': sellerName,
      'sellerId': sellerId,
      'contactInfo': contactInfo,
      'availableFrom': availableFrom?.toIso8601String(),
      'deliveryAvailable': deliveryAvailable,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory AgriculturalItem.fromFirestore(Map<String, dynamic> data, String documentId) {
    Map<String, dynamic> locData = data['location'] ?? {'lat': 0.0, 'lng': 0.0};

    return AgriculturalItem(
      id: documentId,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      subcategory: data['subcategory'],
      description: data['description'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      quantity: (data['quantity'] ?? 0).toInt(),
      unit: data['unit'] ?? 'kg',
      condition: data['condition'] ?? 'Fresh',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      location: {
        'lat': (locData['lat'] ?? 0.0).toDouble(),
        'lng': (locData['lng'] ?? 0.0).toDouble(),
      },
      sellerName: data['sellerName'] ?? '',
      sellerId: data['sellerId'] ?? '',
      contactInfo: data['contactInfo'] ?? '',
      availableFrom: data['availableFrom'] != null
          ? DateTime.parse(data['availableFrom'])
          : null,
      deliveryAvailable: data['deliveryAvailable'] ?? false,
      tags: data['tags'] != null ? List<String>.from(data['tags']) : null,
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: DateTime.parse(data['updatedAt']),
    );
  }

  AgriculturalItem copyWith({
    String? name,
    String? category,
    String? subcategory,
    String? description,
    double? price,
    int? quantity,
    String? unit,
    String? condition,
    List<String>? imageUrls,
    Map<String, double>? location,
    String? sellerName,
    String? sellerId,
    String? contactInfo,
    DateTime? availableFrom,
    bool? deliveryAvailable,
    List<String>? tags,
  }) {
    return AgriculturalItem(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      description: description ?? this.description,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      condition: condition ?? this.condition,
      imageUrls: imageUrls ?? this.imageUrls,
      location: location ?? this.location,
      sellerName: sellerName ?? this.sellerName,
      sellerId: sellerId ?? this.sellerId,
      contactInfo: contactInfo ?? this.contactInfo,
      availableFrom: availableFrom ?? this.availableFrom,
      deliveryAvailable: deliveryAvailable ?? this.deliveryAvailable,
      tags: tags ?? this.tags,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  bool get isAvailable {
    if (availableFrom == null) return true;
    return DateTime.now().isAfter(availableFrom!);
  }

  String get formattedPrice {
    return 'ETB $price per $unit';
  }

  String get locationString {
    if (location == null) return 'Location not specified';
    return 'Lat: ${location!['lat']?.toStringAsFixed(4)}, Lng: ${location!['lng']?.toStringAsFixed(4)}';
  }

  bool get isCurrentUserSeller {
    final currentUser = FirebaseAuth.instance.currentUser;
    return currentUser != null && currentUser.uid == sellerId;
  }
}