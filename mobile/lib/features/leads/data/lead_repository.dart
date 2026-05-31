import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/utils/errors/api_error_handler.dart';
import '../domain/lead_model.dart';

part 'lead_repository.g.dart';

class LeadRepository {
  final Dio _dio;

  LeadRepository(this._dio);

  Future<Lead> createLead({
    required String accommodationId,
    required String preferredDate,
    String? notes,
  }) async {
    try {
      final response = await _dio.post('/leads', data: {
        'accommodation': accommodationId,
        'preferredDate': preferredDate,
        if (notes != null) 'notes': notes,
      });
      return Lead.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  // To be used for Profile/My Visits screen later
  Future<List<Lead>> getMyLeads() async {
    try {
      final response = await _dio.get('/leads/my-leads');
      final List data = response.data['data'];
      return data.map((json) => Lead.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}

@riverpod
LeadRepository leadRepository(LeadRepositoryRef ref) {
  return LeadRepository(ref.watch(dioProvider));
}
