'use client';

import { useState, useCallback } from 'react';

interface NearMeFilters {
  lat?: number;
  lng?: number;
  type?: string;
  gender?: string;
}

export default function NearMeButton({ onLocationChange }: { onLocationChange: (lat: number | null, lng: number | null) => void }) {
  const [active, setActive] = useState(false);
  const [loading, setLoading] = useState(false);

  const toggle = useCallback(() => {
    if (active) {
      setActive(false);
      onLocationChange(null, null);
      return;
    }

    if (!navigator.geolocation) {
      alert('Geolocation is not supported by your browser');
      return;
    }

    setLoading(true);
    navigator.geolocation.getCurrentPosition(
      (position) => {
        setActive(true);
        setLoading(false);
        onLocationChange(position.coords.latitude, position.coords.longitude);
      },
      (error) => {
        setLoading(false);
        alert('Could not get your location. Please allow location access.');
      },
      { enableHighAccuracy: false, timeout: 10000 }
    );
  }, [active, onLocationChange]);

  return (
    <button
      onClick={toggle}
      disabled={loading}
      className={`inline-flex items-center gap-2 px-4 py-2 rounded-full text-sm font-semibold transition-all ${
        active
          ? 'bg-brand text-white shadow-md'
          : 'bg-[var(--surface-alt)] text-[var(--foreground)] hover:bg-[var(--surface-hover)] border border-[var(--border)]'
      }`}
    >
      {loading ? (
        <svg className="animate-spin h-4 w-4" viewBox="0 0 24 24">
          <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" fill="none" />
          <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
        </svg>
      ) : (
        <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
          <path strokeLinecap="round" strokeLinejoin="round" d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z" />
          <circle cx="12" cy="9" r="2.5" />
        </svg>
      )}
      {active ? 'Near Me ✓' : 'Near Me'}
      {active && <span className="text-xs opacity-80 ml-1">(5 km)</span>}
    </button>
  );
}
