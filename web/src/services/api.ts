// ============================================
// MH StayHub - API Service Layer
// Centralized data fetching for Server Components
// ============================================

import { API_BASE_URL } from '@/constants';
import type { Accommodation, AccommodationFilters, ApiResponse, College } from '@/types';

// Generic fetch wrapper with error handling
async function apiFetch<T>(endpoint: string, options?: RequestInit): Promise<T> {
  const url = `${API_BASE_URL}${endpoint}`;
  const res = await fetch(url, {
    ...options,
    headers: {
      'Content-Type': 'application/json',
      ...options?.headers,
    },
  });

  if (!res.ok) {
    throw new Error(`API Error: ${res.status} ${res.statusText}`);
  }

  return res.json();
}

// ---- Colleges ----

export async function getColleges(): Promise<College[]> {
  try {
    const res = await apiFetch<ApiResponse<College[]>>('/colleges', {
      next: { revalidate: 3600 }, // Cache for 1 hour (ISR)
    });
    return res.data;
  } catch {
    return [];
  }
}

export async function getCollegeBySlug(slug: string): Promise<College | null> {
  try {
    const res = await apiFetch<ApiResponse<College>>(`/colleges/${slug}`, {
      next: { revalidate: 3600 },
    });
    return res.data;
  } catch {
    return null;
  }
}

// ---- Accommodations ----

export async function getAccommodations(filters?: AccommodationFilters): Promise<Accommodation[]> {
  try {
    const params = new URLSearchParams();
    if (filters?.lat) params.set('lat', String(filters.lat));
    if (filters?.lng) params.set('lng', String(filters.lng));
    if (filters?.radius) params.set('radius', String(filters.radius));
    if (filters?.type) params.set('type', filters.type);
    if (filters?.gender) params.set('gender', filters.gender);
    if (filters?.maxPrice) params.set('maxPrice', String(filters.maxPrice));
    if (filters?.collegeId) params.set('collegeId', filters.collegeId);

    const query = params.toString() ? `?${params.toString()}` : '';
    const res = await apiFetch<ApiResponse<Accommodation[]>>(`/accommodations${query}`, {
      next: { revalidate: 300 }, // Cache for 5 min
    });
    return res.data;
  } catch {
    return [];
  }
}

export async function getAccommodationBySlug(slug: string): Promise<Accommodation | null> {
  try {
    const res = await apiFetch<ApiResponse<Accommodation>>(`/accommodations/${slug}`, {
      next: { revalidate: 300 },
    });
    return res.data;
  } catch {
    return null;
  }
}

export async function getAccommodationsByCollege(collegeId: string): Promise<Accommodation[]> {
  try {
    const res = await apiFetch<ApiResponse<Accommodation[]>>(
      `/accommodations?collegeId=${collegeId}`,
      { next: { revalidate: 300 } }
    );
    return res.data;
  } catch {
    return [];
  }
}
