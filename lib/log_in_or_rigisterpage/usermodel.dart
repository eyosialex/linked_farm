import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String fullName;
  final String phoneNumber;
  final String userType; // 'farmer' or 'vendor'
  final String? farmName;
  final String? farmLocation;
  final String? farmSize;
  final String? crops;
  final String? businessName;
  final String? businessType;
  final String? contactPerson;
  final String? businessAddress;
  final String? products;
  final bool profileCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Add these new fields for online status
  final bool isOnline;
  final DateTime? lastseen;
  final String? photoUrl; // Add photoUrl field

  UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.userType,
    this.farmName,
    this.farmLocation,
    this.farmSize,
    this.crops,
    this.businessName,
    this.businessType,
    this.contactPerson,
    this.businessAddress,
    this.products,
    this.profileCompleted = false,
    required this.createdAt,
    required this.updatedAt,
    this.isOnline = false,
    this.lastseen,
    this.photoUrl, // Initialize photoUrl
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'userType': userType,
      'farmName': farmName,
      'farmLocation': farmLocation,
      'farmSize': farmSize,
      'crops': crops,
      'businessName': businessName,
      'businessType': businessType,
      'contactPerson': contactPerson,
      'businessAddress': businessAddress,
      'products': products,
      'profileCompleted': profileCompleted,
      'isOnline': isOnline,
      'lastseen': lastseen != null ? Timestamp.fromDate(lastseen!) : FieldValue.serverTimestamp(),
      'photoUrl': photoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      userType: map['userType'] ?? '',
      farmName: map['farmName'],
      farmLocation: map['farmLocation'],
      farmSize: map['farmSize'],
      crops: map['crops'],
      businessName: map['businessName'],
      businessType: map['businessType'],
      contactPerson: map['contactPerson'],
      businessAddress: map['businessAddress'],
      products: map['products'],
      profileCompleted: map['profileCompleted'] ?? false,
      isOnline: map['isOnline'] ?? false,
      lastseen: map['lastseen'] != null ? (map['lastseen'] as Timestamp).toDate() : null,
      photoUrl: map['photoUrl'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  UserModel copyWith({
    String? fullName,
    String? phoneNumber,
    String? userType,
    String? farmName,
    String? farmLocation,
    String? farmSize,
    String? crops,
    String? businessName,
    String? businessType,
    String? contactPerson,
    String? businessAddress,
    String? products,
    bool? profileCompleted,
    bool? isOnline,
    DateTime? lastseen,
    String? photoUrl,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userType: userType ?? this.userType,
      farmName: farmName ?? this.farmName,
      farmLocation: farmLocation ?? this.farmLocation,
      farmSize: farmSize ?? this.farmSize,
      crops: crops ?? this.crops,
      businessName: businessName ?? this.businessName,
      businessType: businessType ?? this.businessType,
      contactPerson: contactPerson ?? this.contactPerson,
      businessAddress: businessAddress ?? this.businessAddress,
      products: products ?? this.products,
      profileCompleted: profileCompleted ?? this.profileCompleted,
      isOnline: isOnline ?? this.isOnline,
      lastseen: lastseen ?? this.lastseen,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}