import 'package:cloud_user/core/network/api_client.dart';
import 'package:cloud_user/core/storage/token_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(
    ref.watch(apiClientProvider),
    ref.watch(tokenStorageProvider),
  );
}

class AuthRepository {
  final Dio _dio;
  final TokenStorage _tokenStorage;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '864806051234-ioslqq625a88mpejsj1chsn0bm4cunrf.apps.googleusercontent.com',
  );

  AuthRepository(this._dio, this._tokenStorage);

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      // Get backend JWT token using Firebase UID
      if (userCredential.user != null) {
        try {
          final response = await _dio.post(
            'user/login',
            data: {'firebaseUid': userCredential.user!.uid},
          );

          if (response.data['token'] != null) {
            await _tokenStorage.saveToken(response.data['token']);
            print(
              '✅ Google Sign-In: Token saved for ${userCredential.user!.email}',
            );
          }
        } catch (e) {
          print(
            '⚠️ Google Sign-In: User not registered in backend. Please complete registration.',
          );
          // User exists in Firebase but not in MongoDB - they need to complete registration
        }
      }

      return userCredential;
    } catch (e) {
      print('❌ Google Sign-In Error: $e');
      rethrow;
    }
  }

  Future<void> completeRegistration({
    required String uid,
    required String name,
    required String email,
    required String phone,
    required String password,
    String? profileImage,
  }) async {
    try {
      // 1. Update Firebase Firestore (Real-time)
      await _firestore.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'phone': phone,
        'profileImage': profileImage,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // 2. Update MongoDB (Backend)
      final response = await _dio.post(
        'user/register',
        data: {
          'firebaseUid': uid,
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'profileImage': profileImage,
        },
      );

      if (response.data['token'] != null) {
        await _tokenStorage.saveToken(response.data['token']);
      }

      // 3. Save returning Cloudinary URL back to Firebase
      final cloudinaryUrl = response.data['profileImage'];
      if (cloudinaryUrl != null) {
        await _firestore.collection('users').doc(uid).set({
          'name': name,
          'email': email,
          'phone': phone,
          'profileImage': cloudinaryUrl,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loginOrRegister(String phone) async {
    return;
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        'user/login',
        data: {'email': email, 'password': password},
      );

      print('🔑 Login Response: ${response.data}');

      if (response.data['token'] != null) {
        await _tokenStorage.saveToken(response.data['token']);
        print('✅ Token saved successfully');
      } else {
        print('⚠️ No token found in login response');
      }

      return response.data;
    } catch (e) {
      print('❌ Login Error: $e');
      rethrow;
    }
  }

  Future<void> verifyOtp(String phone, String otp) async {
    try {
      final response = await _dio.post('user/login', data: {'phone': phone});

      if (response.data['token'] != null) {
        await _tokenStorage.saveToken(response.data['token']);
      }

      // Sync Cloudinary profile image to Firebase after login
      final profileImage = response.data['profileImage'];
      final name = response.data['name'];
      final firebaseUser = _auth.currentUser;
      if (firebaseUser != null && profileImage != null) {
        await _firestore.collection('users').doc(firebaseUser.uid).set({
          'name': name,
          'profileImage': profileImage,
          'phone': phone,
        }, SetOptions(merge: true));
      }

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isAuthenticated() async {
    final token = await _tokenStorage.getToken();
    return token != null;
  }

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _dio.get('user/profile');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String phone,
    String? profileImage,
  }) async {
    try {
      final response = await _dio.put(
        'user/profile',
        data: {
          'name': name,
          'phone': phone,
          if (profileImage != null) 'profileImage': profileImage,
        },
      );

      // Update Firebase if Cloudinary URL returned
      final firebaseUser = _auth.currentUser;
      if (firebaseUser != null && response.data['profileImage'] != null) {
        await _firestore.collection('users').doc(firebaseUser.uid).update({
          'name': name,
          'phone': phone,
          'profileImage': response.data['profileImage'],
        });
      }

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _tokenStorage.clearToken();
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
