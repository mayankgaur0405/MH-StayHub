// ============================================
// MH StayHub - Type Definitions
// Mirrors the backend Mongoose schemas exactly
// ============================================

export interface College {
  _id: string;
  name: string;
  slug: string;
  city: string;
  state: string;
  location: {
    type: string;
    coordinates: [number, number]; // [lng, lat]
  };
  logo?: string;
  isActive: boolean;
  createdAt: string;
  updatedAt: string;
}

export interface NearbyCollege {
  collegeId: College | string;
  distanceMeters: number;
}

export interface Accommodation {
  _id: string;
  name: string;
  slug: string;
  type: 'hostel' | 'pg' | 'coliving' | 'flat';
  gender: 'boys' | 'girls' | 'coed';
  location: {
    type: string;
    coordinates: [number, number];
  };
  address: string;
  nearbyColleges: NearbyCollege[];
  verification: {
    status: 'unverified' | 'verified' | 'premium_verified';
    verifiedAt?: string;
    verifiedBy?: string;
  };
  images: string[];
  amenities: string[];
  pricing: {
    startingPrice: number;
    deposit?: number;
  };
  ownerId: string;
  ownerContact?: {
    phone?: string;
    email?: string;
    name?: string;
  };
  status: 'active' | 'hidden';
  createdAt: string;
  updatedAt: string;
}

export interface Lead {
  _id: string;
  studentId: string;
  accommodationId: string | Accommodation;
  type: 'visit' | 'token_booking';
  status: 'pending' | 'visited' | 'converted' | 'cancelled' | 'pending_owner_approval';
  source: 'web' | 'app' | 'referral' | 'organic';
  payment?: {
    amount: number;
    transactionId?: string;
    status: 'pending' | 'success' | 'failed' | 'refunded';
  };
  scheduledDate?: string;
  createdAt: string;
  updatedAt: string;
}

export interface ApiResponse<T> {
  success: boolean;
  data: T;
  message?: string;
  count?: number;
}

export interface AccommodationFilters {
  lat?: number;
  lng?: number;
  radius?: number;
  type?: string;
  gender?: string;
  maxPrice?: number;
  collegeId?: string;
}
