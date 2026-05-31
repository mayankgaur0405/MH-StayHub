// ============================================
// MH StayHub - Application Constants
// ============================================

export const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 'https://mh-stayhub.onrender.com/api/v1';

export const SITE_NAME = 'MH StayHub';
export const SITE_TAGLINE = 'Find Your Perfect Student Accommodation';
export const SITE_DESCRIPTION = 'Discover verified hostels, PGs, and coliving spaces near top colleges in Greater Noida. Transparent pricing, real photos, and instant booking.';
export const SITE_URL = process.env.NEXT_PUBLIC_SITE_URL || 'https://mhstayhub.com';

export const AMENITY_ICONS: Record<string, string> = {
  'AC': '❄️',
  'WiFi': '📶',
  'Food': '🍽️',
  'Gym': '💪',
  'Laundry': '👕',
  'Parking': '🅿️',
  'CCTV': '📹',
  'Power Backup': '🔋',
  'Hot Water': '🚿',
  'Study Room': '📚',
};

export const ACCOMMODATION_TYPE_LABELS: Record<string, string> = {
  hostel: 'Hostel',
  pg: 'PG',
  coliving: 'Co-Living',
  flat: 'Flat',
};

export const GENDER_LABELS: Record<string, string> = {
  boys: 'Boys',
  girls: 'Girls',
  coed: 'Co-Ed',
};

export const VERIFICATION_BADGES: Record<string, { label: string; color: string }> = {
  premium_verified: { label: 'Premium Verified', color: 'text-amber-500' },
  verified: { label: 'Verified', color: 'text-emerald-500' },
  unverified: { label: '', color: '' },
};
