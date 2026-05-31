import type { Metadata } from 'next';
import AccommodationCard from '@/components/AccommodationCard';
import { getAccommodations } from '@/services/api';

export const metadata: Metadata = {
  title: 'Hostels, PGs & Co-Living in Greater Noida',
  description: 'Browse verified hostels, PGs, and co-living spaces in Greater Noida. Filter by price, type, and gender. Real photos. Zero brokerage.',
  openGraph: {
    title: 'Hostels, PGs & Co-Living in Greater Noida | MH StayHub',
    description: 'Browse verified hostels, PGs, and co-living spaces in Greater Noida.',
  },
};

export default async function AccommodationsPage() {
  const accommodations = await getAccommodations();

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12 sm:py-16">
      {/* Header */}
      <div className="mb-12">
        <h1 className="text-3xl sm:text-4xl font-extrabold text-foreground">
          All <span className="text-brand">Accommodations</span>
        </h1>
        <p className="mt-3 text-muted text-lg max-w-2xl">
          Verified hostels, PGs, and co-living spaces across Greater Noida.
        </p>
      </div>

      {/* TODO: Client-side filter bar (V2) */}

      {/* Listings */}
      {accommodations.length > 0 ? (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 animate-stagger">
          {accommodations.map((acc) => (
            <AccommodationCard key={acc._id} accommodation={acc} />
          ))}
        </div>
      ) : (
        <div className="text-center py-20">
          <p className="text-5xl mb-4">🏠</p>
          <h3 className="text-lg font-semibold text-foreground mb-2">Coming Soon</h3>
          <p className="text-muted">We&apos;re actively onboarding verified accommodations. Check back soon!</p>
        </div>
      )}
    </div>
  );
}
