import 'package:logger/logger.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsTracker {
  static final Logger _logger = Logger();
  
  static FirebaseAnalytics? get _analytics {
    try {
      return FirebaseAnalytics.instance;
    } catch (e) {
      return null;
    }
  }

  static void trackEvent(String name, Map<String, dynamic> parameters) {
    _logger.i('Analytics Event: $name', error: parameters);
    _analytics?.logEvent(
      name: name, 
      parameters: parameters.map((k, v) => MapEntry(k, v.toString()))
    );
  }

  static void trackSearchPerformed(Map<String, dynamic> filters) {
    _logger.i('Analytics Event: search_performed', error: filters);
    _analytics?.logEvent(name: 'search_performed', parameters: filters.map((k, v) => MapEntry(k, v.toString())));
  }

  static void trackViewCollege(String collegeId, String name) {
    _logger.i('Analytics Event: view_college', error: {'id': collegeId, 'name': name});
    _analytics?.logEvent(name: 'view_college', parameters: {'id': collegeId, 'name': name});
  }

  static void trackViewAccommodation(String accommodationId, String name) {
    _logger.i('Analytics Event: view_accommodation', error: {'id': accommodationId, 'name': name});
    _analytics?.logEvent(name: 'view_accommodation', parameters: {'id': accommodationId, 'name': name});
  }

  static void trackCallOwner(String accommodationId) {
    _logger.i('Analytics Event: call_owner', error: {'id': accommodationId});
  }

  static void trackWhatsAppOwner(String accommodationId) {
    _logger.i('Analytics Event: whatsapp_owner', error: {'id': accommodationId});
  }

  static void trackShareProperty(String accommodationId, String method) {
    _logger.i('Analytics Event: share_property', error: {'id': accommodationId, 'method': method});
  }

  static void trackSaveProperty(String accommodationId, bool saved) {
    _logger.i('Analytics Event: ${saved ? "save_property" : "unsave_property"}', error: {'id': accommodationId});
  }

  static void trackScheduleVisitStarted(String accommodationId) {
    _logger.i('Analytics Event: schedule_visit_started', error: {'id': accommodationId});
  }

  static void trackScheduleVisitSubmitted(String accommodationId) {
    _logger.i('Analytics Event: schedule_visit_submitted', error: {'id': accommodationId});
  }

  static void trackScheduleVisitSuccess(String accommodationId) {
    _logger.i('Analytics Event: schedule_visit_success', error: {'id': accommodationId});
  }

  static void trackViewProfile() {
    _logger.i('Analytics Event: view_profile');
  }

  static void trackEditProfile() {
    _logger.i('Analytics Event: edit_profile');
  }

  static void trackLogout() {
    _logger.i('Analytics Event: logout');
  }

  static void trackViewSavedProperties() {
    _logger.i('Analytics Event: view_saved_properties');
  }

  static void trackViewVisitHistory() {
    _logger.i('Analytics Event: view_visit_history');
  }

  static void trackPaymentStarted(String accommodationId) {
    _logger.i('Analytics Event: payment_started', error: {'id': accommodationId});
  }

  static void trackPaymentSuccess(String orderId) {
    _logger.i('Analytics Event: payment_success', error: {'orderId': orderId});
  }

  static void trackPaymentFailed(String errorMsg) {
    _logger.i('Analytics Event: payment_failed', error: {'message': errorMsg});
    _analytics?.logEvent(name: 'payment_failed', parameters: {'message': errorMsg});
  }
}
