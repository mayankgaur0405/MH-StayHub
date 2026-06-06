'use client';

import { useState, useEffect, useCallback } from 'react';
import AccommodationCard from '@/components/AccommodationCard';
import NearMeButton from '@/components/NearMeButton';
import { API_BASE_URL } from '@/constants';
import type { Accommodation } from '@/types';

export default function AccommodationsClient({ initialData }: { initialData: Accommodation[] }) {
  const [accommodations, setAccommodations] = useState<Accommodation[]>(initialData);
  const [loading, setLoading] = useState(false);
  const [selectedType, setSelectedType] = useState<string | null>(null);
  const [selectedGender, setSelectedGender] = useState<string | null>(null);
  const [lat, setLat] = useState<number | null>(null);
  const [lng, setLng] = useState<number | null>(null);

  const fetchFiltered = useCallback(async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams();
      if (selectedType) params.set('type', selectedType);
      if (selectedGender) params.set('gender', selectedGender);
      if (lat !== null) params.set('lat', String(lat));
      if (lng !== null) params.set('lng', String(lng));
      if (lat !== null && lng !== null) params.set('radius', '5000');

      const query = params.toString() ? `?${params.toString()}` : '';
      const res = await fetch(`${API_BASE_URL}/accommodations${query}`);
      const json = await res.json();
      setAccommodations(json.data || []);
    } catch {
      // Keep existing data on error
    } finally {
      setLoading(false);
    }
  }, [selectedType, selectedGender, lat, lng]);

  // Refetch when any filter changes (but skip on initial render)
  const [didMount, setDidMount] = useState(false);
  useEffect(() => {
    if (!didMount) {
      setDidMount(true);
      return;
    }
    fetchFiltered();
  }, [selectedType, selectedGender, lat, lng, fetchFiltered, didMount]);

  const handleLocationChange = (newLat: number | null, newLng: number | null) => {
    setLat(newLat);
    setLng(newLng);
  };

  const types = ['hostel', 'pg', 'coliving'] as const;
  const genders = ['boys', 'girls', 'coed'] as const;

  return (
    <>
      {/* Filter Bar */}
      <div className="flex flex-wrap items-center gap-3 mb-10">
        <NearMeButton onLocationChange={handleLocationChange} />
        <div className="h-6 w-px bg-[var(--border)] mx-1 hidden sm:block" />
        {types.map((type) => (
          <button
            key={type}
            onClick={() => setSelectedType(selectedType === type ? null : type)}
            className={`px-4 py-2 rounded-full text-sm font-semibold transition-all border ${
              selectedType === type
                ? 'bg-brand text-white border-brand shadow-md'
                : 'bg-[var(--surface-alt)] text-[var(--foreground)] border-[var(--border)] hover:bg-[var(--surface-hover)]'
            }`}
          >
            {type.charAt(0).toUpperCase() + type.slice(1)}
          </button>
        ))}
        <div className="h-6 w-px bg-[var(--border)] mx-1 hidden sm:block" />
        {genders.map((gender) => (
          <button
            key={gender}
            onClick={() => setSelectedGender(selectedGender === gender ? null : gender)}
            className={`px-4 py-2 rounded-full text-sm font-semibold transition-all border ${
              selectedGender === gender
                ? 'bg-brand text-white border-brand shadow-md'
                : 'bg-[var(--surface-alt)] text-[var(--foreground)] border-[var(--border)] hover:bg-[var(--surface-hover)]'
            }`}
          >
            {gender.charAt(0).toUpperCase() + gender.slice(1)}
          </button>
        ))}
      </div>

      {/* Loading overlay */}
      {loading && (
        <div className="flex justify-center py-8">
          <div className="w-8 h-8 border-4 border-brand/30 border-t-brand rounded-full animate-spin" />
        </div>
      )}

      {/* Listings */}
      {!loading && accommodations.length > 0 ? (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 animate-stagger">
          {accommodations.map((acc) => (
            <AccommodationCard key={acc._id} accommodation={acc} />
          ))}
        </div>
      ) : !loading ? (
        <div className="text-center py-20">
          <p className="text-5xl mb-4">🏠</p>
          <h3 className="text-lg font-semibold text-foreground mb-2">No Results</h3>
          <p className="text-muted">Try adjusting your filters or clearing &quot;Near Me&quot;.</p>
        </div>
      ) : null}
    </>
  );
}
