import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/api/secure_storage.dart';
import '../../data/auth_repository.dart';
import 'auth_state.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  AuthState build() {
    // Initial state before checking token
    _checkAuthStatus();
    return const AuthInitial();
  }

  Future<void> _checkAuthStatus() async {
    state = const AuthLoading();
    try {
      final token = await ref.read(secureStorageProvider).getToken();
      if (token == null) {
        state = const AuthUnauthenticated();
        return;
      }

      // Token exists, verify it by fetching user profile
      final user = await ref.read(authRepositoryProvider).getMe();
      state = AuthAuthenticated(user);
    } catch (e) {
      // Token is invalid or expired
      await logout();
    }
  }

  Future<void> sendOTP(String phone) async {
    try {
      await ref.read(authRepositoryProvider).sendOTP(phone);
    } catch (e) {
      // Re-throw to let the UI handle the error (e.g., show SnackBar)
      rethrow;
    }
  }

  Future<void> verifyOTP(String phone, String otp) async {
    state = const AuthLoading();
    try {
      final result = await ref.read(authRepositoryProvider).verifyOTP(phone, otp);
      
      // Save token in secure storage
      await ref.read(secureStorageProvider).saveToken(result.token);
      
      state = AuthAuthenticated(result.user);
    } catch (e) {
      state = AuthError(e.toString());
      // Re-throw so UI can catch it and show error immediately
      rethrow;
    }
  }

  Future<void> logout() async {
    await ref.read(secureStorageProvider).deleteToken();
    state = const AuthUnauthenticated();
  }
}
