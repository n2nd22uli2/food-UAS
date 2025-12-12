// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream untuk mendengarkan perubahan auth state
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Register dengan email dan password
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      // Buat user di Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Simpan data user ke Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': name,
        'email': email,
        'phone': phone,
        'createdAt': FieldValue.serverTimestamp(),
        'photoUrl': '',
        'address': '',
      });

      return {
        'success': true,
        'message': 'Registration successful',
        'user': userCredential.user,
      };
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'Password terlalu lemah';
      } else if (e.code == 'email-already-in-use') {
        message = 'Email sudah terdaftar';
      } else if (e.code == 'invalid-email') {
        message = 'Email tidak valid';
      } else {
        message = 'Terjadi kesalahan: ${e.message}';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  // Login dengan email dan password
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return {
        'success': true,
        'message': 'Login successful',
        'user': userCredential.user,
      };
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = 'User tidak ditemukan';
      } else if (e.code == 'wrong-password') {
        message = 'Password salah';
      } else if (e.code == 'invalid-email') {
        message = 'Email tidak valid';
      } else if (e.code == 'user-disabled') {
        message = 'User telah dinonaktifkan';
      } else {
        message = 'Terjadi kesalahan: ${e.message}';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Get user data dari Firestore
  // Future<Map<String, dynamic>?> getUserData(String uid) async {
  //   try {
  //     DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
  //     if (doc.exists) {
  //       return doc.data() as Map<String, dynamic>;
  //     }
  //     return null;
  //   } catch (e) {
  //     print('Error getting user data: $e');
  //     return null;
  //   }
  // }
  // Get user data dari Firestore
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      print('Fetching user data for uid: $uid'); // Debug log
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();

      if (doc.exists) {
        print('User data found: ${doc.data()}'); // Debug log
        return doc.data() as Map<String, dynamic>;
      }

      print('User data not found'); // Debug log
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      rethrow; // Lempar error agar bisa di-catch di UI
    }
  }

  // Update user data
  Future<bool> updateUserData(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).update(data);
      return true;
    } catch (e) {
      print('Error updating user data: $e');
      return false;
    }
  }

  // Reset password
  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return {
        'success': true,
        'message': 'Email reset password telah dikirim',
      };
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = 'Email tidak terdaftar';
      } else if (e.code == 'invalid-email') {
        message = 'Email tidak valid';
      } else {
        message = 'Terjadi kesalahan: ${e.message}';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  // Fungsi untuk menambahkan data dummy users (hanya untuk development)
  Future<void> seedDummyUsers() async {
    try {
      // Cek apakah sudah ada dummy users
      QuerySnapshot existingUsers = await _firestore
          .collection('users')
          .where('email', isEqualTo: 'user1@test.com')
          .get();

      if (existingUsers.docs.isEmpty) {
        // Buat dummy users
        List<Map<String, dynamic>> dummyUsers = [
          {
            'email': 'user1@test.com',
            'password': 'password123',
            'name': 'John Doe',
            'phone': '081234567890',
          },
          {
            'email': 'user2@test.com',
            'password': 'password123',
            'name': 'Jane Smith',
            'phone': '081234567891',
          },
          {
            'email': 'admin@test.com',
            'password': 'admin123',
            'name': 'Admin User',
            'phone': '081234567892',
          },
        ];

        for (var userData in dummyUsers) {
          await register(
            email: userData['email'],
            password: userData['password'],
            name: userData['name'],
            phone: userData['phone'],
          );
        }

        // Logout setelah membuat dummy users
        await logout();
        print('Dummy users berhasil ditambahkan!');
      } else {
        print('Dummy users sudah ada');
      }
    } catch (e) {
      print('Error seeding dummy users: $e');
    }
  }
}