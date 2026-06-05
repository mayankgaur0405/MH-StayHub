import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/api/api_client.dart';

part 'student_hub_providers.g.dart';

// ─── Coupons ────────────────────────────────────────────────────────
@riverpod
Future<List<Map<String, dynamic>>> coupons(CouponsRef ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('/coupons');
  final data = response.data['data'] as List? ?? [];
  return data.map((e) => Map<String, dynamic>.from(e)).toList();
}

// ─── Events ─────────────────────────────────────────────────────────
@riverpod
Future<List<Map<String, dynamic>>> events(EventsRef ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('/events');
  final data = response.data['data'] as List? ?? [];
  return data.map((e) => Map<String, dynamic>.from(e)).toList();
}

// ─── Roommate Profiles ──────────────────────────────────────────────
@riverpod
Future<List<Map<String, dynamic>>> roommateProfiles(RoommateProfilesRef ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('/roommates');
  final data = response.data['data'] as List? ?? [];
  return data.map((e) => Map<String, dynamic>.from(e)).toList();
}

// ─── Marketplace Items ──────────────────────────────────────────────
@riverpod
Future<List<Map<String, dynamic>>> marketplaceItems(MarketplaceItemsRef ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('/marketplace');
  final data = response.data['data'] as List? ?? [];
  return data.map((e) => Map<String, dynamic>.from(e)).toList();
}

// ─── Senior Connect Queries ─────────────────────────────────────────
@riverpod
Future<List<Map<String, dynamic>>> seniorQueries(SeniorQueriesRef ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('/senior-connect');
  final data = response.data['data'] as List? ?? [];
  return data.map((e) => Map<String, dynamic>.from(e)).toList();
}

// ─── Student Dashboard ──────────────────────────────────────────────
@riverpod
Future<Map<String, dynamic>> studentDashboard(StudentDashboardRef ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('/student-advantage/dashboard');
  return Map<String, dynamic>.from(response.data['data'] ?? {});
}

// ─── Verification Status ────────────────────────────────────────────
@riverpod
Future<Map<String, dynamic>> verificationStatus(VerificationStatusRef ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('/student-advantage/verification/status');
  return Map<String, dynamic>.from(response.data['data'] ?? {});
}
