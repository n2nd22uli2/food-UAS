// services/address_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/address_model.dart';

class AddressService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final String _collection = 'addresses';

  // Create - Tambah alamat baru
  static Future<String?> createAddress(Address address) async {
    try {
      DocumentReference docRef = await _firestore
          .collection(_collection)
          .add(address.toMap());
      return docRef.id;
    } catch (e) {
      print('Error creating address: $e');
      return null;
    }
  }

  // Read - Ambil semua alamat
  static Stream<List<Address>> getAddresses() {
    return _firestore
        .collection(_collection)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Address.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  // Update - Update alamat
  static Future<bool> updateAddress(String id, Address address) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(id)
          .update(address.toMap());
      return true;
    } catch (e) {
      print('Error updating address: $e');
      return false;
    }
  }

  // Delete - Hapus alamat
  static Future<bool> deleteAddress(String id) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(id)
          .delete();
      return true;
    } catch (e) {
      print('Error deleting address: $e');
      return false;
    }
  }
}