import type { Metadata } from 'next';
import { getAccommodations } from '@/services/api';
import AccommodationsClient from './AccommodationsClient';

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

      {/* Client-side filters and listings */}
      <AccommodationsClient initialData={accommodations} />
    </div>
  );
}
