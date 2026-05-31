import type { Metadata } from 'next';
import CollegeCard from '@/components/CollegeCard';
import { getColleges } from '@/services/api';

export const metadata: Metadata = {
  title: 'Colleges in Greater Noida',
  description: 'Browse all colleges in Greater Noida and find verified hostels, PGs, and co-living spaces near each campus.',
  openGraph: {
    title: 'Colleges in Greater Noida | MH StayHub',
    description: 'Browse all colleges in Greater Noida and find verified hostels, PGs, and co-living spaces near each campus.',
  },
};

export default async function CollegesPage() {
  const colleges = await getColleges();

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12 sm:py-16">
      <div className="mb-12">
        <h1 className="text-3xl sm:text-4xl font-extrabold text-foreground">
          Colleges in <span className="text-brand">Greater Noida</span>
        </h1>
        <p className="mt-3 text-muted text-lg max-w-2xl">
          Select your college to discover verified accommodations nearby.
        </p>
      </div>

      {colleges.length > 0 ? (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 animate-stagger">
          {colleges.map((college) => (
            <CollegeCard key={college._id} college={college} />
          ))}
        </div>
      ) : (
        <div className="text-center py-20">
          <p className="text-5xl mb-4">🏫</p>
          <p className="text-lg text-muted">We&apos;re onboarding colleges in Greater Noida. Check back soon!</p>
        </div>
      )}
    </div>
  );
}
