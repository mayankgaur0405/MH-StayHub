import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/utils/errors/api_error_handler.dart';
import '../../../discovery/domain/accommodation_model.dart';

part 'saved_accommodation_provider.g.dart';

@riverpod
class SavedAccommodations extends _$SavedAccommodations {
  @override
  FutureOr<List<Accommodation>> build() async {
    return _fetchSaved();
  }

  Future<List<Accommodation>> _fetchSaved() async {
    try {
      final response = await ref.read(dioProvider).get('/auth/saved-accommodations');
      final List data = response.data['data'];
      return data.map((json) => Accommodation.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<void> save(String accommodationId) async {
    // Optimistic update could go here
    try {
      await ref.read(dioProvider).post('/auth/save-accommodation/$accommodationId');
      // Refresh list
      ref.invalidateSelf();
    } catch (e) {
      // Revert optimistic update
      rethrow;
    }
  }

  Future<void> unsave(String accommodationId) async {
    try {
      await ref.read(dioProvider).delete('/auth/unsave-accommodation/$accommodationId');
      // Refresh list
      ref.invalidateSelf();
    } catch (e) {
      rethrow;
    }
  }
}
