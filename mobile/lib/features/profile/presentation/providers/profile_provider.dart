import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../auth/domain/user_model.dart';
import '../../../leads/domain/lead_model.dart';
import '../../data/profile_repository.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

part 'profile_provider.g.dart';

@riverpod
Future<User> userProfile(UserProfileRef ref) async {
  return ref.watch(profileRepositoryProvider).getProfile();
}

@riverpod
Future<List<Lead>> visitRequests(VisitRequestsRef ref) async {
  return ref.watch(profileRepositoryProvider).getMyVisitRequests();
}

@riverpod
class UpdateProfile extends _$UpdateProfile {
  @override
  FutureOr<void> build() {}

  Future<bool> submit({String? name, String? email}) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(profileRepositoryProvider).updateProfile(name: name, email: email);
      // Invalidate profile cache so it re-fetches
      ref.invalidate(userProfileProvider);
      // Also refresh the global auth state so the home screen greeting updates immediately
      await ref.read(authControllerProvider.notifier).refreshUser();
      
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}
