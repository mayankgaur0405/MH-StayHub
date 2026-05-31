// ============================================
// MH StayHub - Sharing Utilities
// Growth engine: WhatsApp, Copy Link, Native Share
// ============================================

import { SITE_URL } from '@/constants';
import { trackShareProperty } from './analytics';

export function getAccommodationUrl(slug: string): string {
  return `${SITE_URL}/accommodations/${slug}`;
}

export function shareViaWhatsApp(slug: string, name: string, accommodationId: string) {
  const url = getAccommodationUrl(slug);
  const text = encodeURIComponent(`Check out ${name} on MH StayHub! 🏠\n${url}`);
  window.open(`https://wa.me/?text=${text}`, '_blank');
  trackShareProperty(accommodationId, 'whatsapp');
}

export async function copyLink(slug: string, accommodationId: string): Promise<boolean> {
  const url = getAccommodationUrl(slug);
  try {
    await navigator.clipboard.writeText(url);
    trackShareProperty(accommodationId, 'copy');
    return true;
  } catch {
    return false;
  }
}

export async function nativeShare(slug: string, name: string, accommodationId: string) {
  const url = getAccommodationUrl(slug);
  if (navigator.share) {
    try {
      await navigator.share({ title: name, text: `Check out ${name} on MH StayHub!`, url });
      trackShareProperty(accommodationId, 'native');
    } catch {
      // User cancelled
    }
  } else {
    // Fallback to copy
    await copyLink(slug, accommodationId);
  }
}
