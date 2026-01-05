import 'package:cloud_user/core/network/api_client.dart';
import 'package:cloud_user/core/storage/token_storage.dart';
import 'package:dio/dio.dart';
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

  AuthRepository(this._dio, this._tokenStorage);

  Future<void> loginOrRegister(String phone) async {
    // In the React Native version, this called an endpoint that returned a token immediately or just verified.
    // Based on RN code: `apiClient.post('/user/login', { phone, location })`
    // Wait, the RN code generates a fake OTP locally, then navigates to OTP screen.
    // The ACTUAL API call happens after OTP verification?
    
    // Actually, look at the RN code again: 
    // `handleSendOTP`: Generates random OTP locally. Alerts it.
    // It does NOT call the backend yet.
    return;
  }

  Future<void> verifyOtp(String phone, String otp) async {
    // In RN, after OTP is verified locally (checking against the stored random number),
    // THEN it calls `api.loginOrRegister`.
    
    try {
      final response = await _dio.post('/user/login', data: {
        'phone': phone,
        // 'location': ... // We can add location later
      });

      if (response.data['token'] != null) {
        await _tokenStorage.saveToken(response.data['token']);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> checkAuth() async {
     // Check if token exists
  }
  
  Future<void> logout() async {
    await _tokenStorage.clearToken();
  }
}
