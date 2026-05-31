import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/lead_repository.dart';

part 'lead_provider.g.dart';

@riverpod
class SubmitLead extends _$SubmitLead {
  @override
  FutureOr<void> build() {}

  Future<void> submit({
    required String accommodationId,
    required String preferredDate,
    String? notes,
  }) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(leadRepositoryProvider).createLead(
        accommodationId: accommodationId,
        preferredDate: preferredDate,
        notes: notes,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
