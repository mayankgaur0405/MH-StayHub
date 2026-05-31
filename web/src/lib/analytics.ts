// ============================================
// MH StayHub - Analytics Event Tracker
// Reusable tracking functions. Currently logs to console.
// Replace with Firebase Analytics / Mixpanel in production.
// ============================================

type EventParams = Record<string, string | number | boolean>;

function trackEvent(eventName: string, params?: EventParams) {
  // In production, wire up Firebase Analytics:
  // import { logEvent } from 'firebase/analytics';
  // logEvent(analytics, eventName, params);
  if (typeof window !== 'undefined') {
    console.log(`[Analytics] ${eventName}`, params);
  }
}

export function trackViewProperty(accommodationId: string, accommodationName: string) {
  trackEvent('view_property', { accommodationId, accommodationName });
}

export function trackShareProperty(accommodationId: string, method: 'whatsapp' | 'copy' | 'native') {
  trackEvent('share_property', { accommodationId, method });
}

export function trackCallOwner(accommodationId: string) {
  trackEvent('call_owner', { accommodationId });
}

export function trackWhatsAppOwner(accommodationId: string) {
  trackEvent('whatsapp_owner', { accommodationId });
}

export function trackScheduleVisit(accommodationId: string) {
  trackEvent('schedule_visit', { accommodationId });
}

export function trackSearchPerformed(query: string, filters?: EventParams) {
  trackEvent('search_performed', { query, ...filters });
}

export function trackFilterApplied(filters: EventParams) {
  trackEvent('filter_applied', filters);
}
