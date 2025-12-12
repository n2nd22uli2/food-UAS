// models/address_model.dart
class Address {
  final String? id;
  final String name;
  final String address;
  final String phone;

  Address({
    this.id,
    required this.name,
    required this.address,
    required this.phone,
  });

  // Convert to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'phone': phone,
    };
  }

  // Create from Firebase document
  factory Address.fromMap(String id, Map<String, dynamic> map) {
    return Address(
      id: id,
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      phone: map['phone'] ?? '',
    );
  }
}