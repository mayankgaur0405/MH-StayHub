import type { Metadata } from 'next';
import { notFound } from 'next/navigation';
import Image from 'next/image';
import AccommodationCard from '@/components/AccommodationCard';
import { getCollegeBySlug, getAccommodationsByCollege } from '@/services/api';

interface Props {
  params: Promise<{ slug: string }>;
}

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { slug } = await params;
  const college = await getCollegeBySlug(slug);
  if (!college) return { title: 'College Not Found' };

  return {
    title: `Hostels & PGs Near ${college.name}`,
    description: `Find verified hostels, PGs, and co-living spaces near ${college.name}, ${college.city}. Transparent pricing, real photos, and instant booking on MH StayHub.`,
    openGraph: {
      title: `Hostels & PGs Near ${college.name} | MH StayHub`,
      description: `Find verified accommodations near ${college.name}`,
    },
  };
}

export default async function CollegeDetailPage({ params }: Props) {
  const { slug } = await params;
  const college = await getCollegeBySlug(slug);
  if (!college) notFound();

  const accommodations = await getAccommodationsByCollege(college._id);

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12 sm:py-16">
      {/* College Header */}
      <div className="flex items-center gap-5 mb-12">
        <div className="relative w-20 h-20 rounded-2xl bg-brand/10 flex items-center justify-center flex-shrink-0 overflow-hidden">
          {college.logo ? (
            <Image src={college.logo} alt={college.name} fill className="object-contain p-2" />
          ) : (
            <span className="text-4xl font-bold text-brand">{college.name.charAt(0)}</span>
          )}
        </div>
        <div>
          <h1 className="text-2xl sm:text-3xl font-extrabold text-foreground">
            Accommodations Near <span className="text-brand">{college.name}</span>
          </h1>
          <p className="mt-1 text-muted">📍 {college.city}, {college.state}</p>
        </div>
      </div>

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
          <h3 className="text-lg font-semibold text-foreground mb-2">No Accommodations Listed Yet</h3>
          <p className="text-muted">We&apos;re currently onboarding stays near {college.name}. Check back soon!</p>
        </div>
      )}
    </div>
  );
}
