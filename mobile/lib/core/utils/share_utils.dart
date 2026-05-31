import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'analytics_tracker.dart';

class ShareUtils {
  static const String baseUrl = 'https://mhstayhub.com/accommodations';

  static Future<void> nativeShare(String slug, String name, String id) async {
    final url = '$baseUrl/$slug';
    AnalyticsTracker.trackShareProperty(id, 'native');
    await Clipboard.setData(ClipboardData(text: 'Check out $name on MH StayHub!\n$url'));
  }

  static Future<void> copyLink(String slug, String id) async {
    final url = '$baseUrl/$slug';
    await Clipboard.setData(ClipboardData(text: url));
    AnalyticsTracker.trackShareProperty(id, 'copy');
  }

  static Future<void> shareViaWhatsApp(String slug, String name, String id) async {
    final url = '$baseUrl/$slug';
    final text = Uri.encodeComponent('Check out $name on MH StayHub! 🏠\n$url');
    final whatsappUrl = Uri.parse('whatsapp://send?text=$text');
    
    AnalyticsTracker.trackShareProperty(id, 'whatsapp');
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl);
    } else {
      // Fallback
      await nativeShare(slug, name, id);
    }
  }

  static Future<void> callOwner(String phone, String id) async {
    final url = Uri.parse('tel:$phone');
    AnalyticsTracker.trackCallOwner(id);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  static Future<void> whatsappOwner(String phone, String name, String id) async {
    final text = Uri.encodeComponent("Hi $name, I found your property on MH StayHub. I'm interested in learning more.");
    final url = Uri.parse('whatsapp://send?phone=${phone.replaceAll('+', '')}&text=$text');
    AnalyticsTracker.trackWhatsAppOwner(id);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}
