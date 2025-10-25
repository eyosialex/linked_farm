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

  // Change location from String to Map
  Map<String, double>? location; // {'lat': 9.026202, 'lng': 9.026202}

  String sellerName;
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
      'location': location, // store as map directly
      'sellerName': sellerName,
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
}
