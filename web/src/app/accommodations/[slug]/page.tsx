import type { Metadata } from 'next';
import Link from 'next/link';
import Image from 'next/image';
import { notFound } from 'next/navigation';
import { getAccommodationBySlug } from '@/services/api';
import { AMENITY_ICONS, VERIFICATION_BADGES, GENDER_LABELS, ACCOMMODATION_TYPE_LABELS, SITE_URL } from '@/constants';
import { ShareBar, OwnerActions } from '@/components/DetailActions';
import type { College } from '@/types';

interface Props {
  params: Promise<{ slug: string }>;
}

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { slug } = await params;
  const acc = await getAccommodationBySlug(slug);
  if (!acc) return { title: 'Accommodation Not Found' };

  const title = `${acc.name} - ${ACCOMMODATION_TYPE_LABELS[acc.type]} in ${acc.address}`;
  const description = `${acc.name} — Starting at ₹${acc.pricing.startingPrice.toLocaleString('en-IN')}/month. Amenities: ${acc.amenities.join(', ')}. Verified on MH StayHub.`;

  return {
    title,
    description,
    alternates: { canonical: `${SITE_URL}/accommodations/${slug}` },
    openGraph: {
      title: `${title} | MH StayHub`,
      description,
      images: acc.images.length > 0 ? [{ url: acc.images[0], width: 1200, height: 630 }] : undefined,
      url: `${SITE_URL}/accommodations/${slug}`,
      type: 'website',
    },
    twitter: {
      card: 'summary_large_image',
      title,
      description,
      images: acc.images.length > 0 ? [acc.images[0]] : undefined,
    }
  };
}

export default async function AccommodationDetailPage({ params }: Props) {
  const { slug } = await params;
  const acc = await getAccommodationBySlug(slug);
  if (!acc) notFound();

  const badge = VERIFICATION_BADGES[acc.verification.status];

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 sm:py-12">
      {/* Breadcrumb */}
      <nav className="mb-6 text-sm text-muted">
        <Link href="/" className="hover:text-brand transition-colors">Home</Link>
        <span className="mx-2">/</span>
        <Link href="/accommodations" className="hover:text-brand transition-colors">Accommodations</Link>
        <span className="mx-2">/</span>
        <span className="text-foreground font-medium">{acc.name}</span>
      </nav>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        {/* Left Column - Details */}
        <div className="lg:col-span-2 space-y-8">
          {/* Image Gallery */}
          <div className="relative rounded-2xl overflow-hidden bg-gray-100 aspect-video">
            {acc.images.length > 0 ? (
              <Image
                src={acc.images[0]}
                alt={acc.name}
                fill
                priority
                sizes="(max-width: 1024px) 100vw, 66vw"
                className="object-cover"
              />
            ) : (
              <div className="w-full h-full flex items-center justify-center text-gray-400">
                No Image Available
              </div>
            )}
          </div>

          {/* Thumbnails */}
          {acc.images.length > 1 && (
            <div className="flex gap-3 overflow-x-auto pb-2">
              {acc.images.slice(1, 5).map((img, i) => (
                <div key={i} className="relative w-24 h-20 rounded-lg overflow-hidden flex-shrink-0 bg-gray-100">
                  <Image src={img} alt={`${acc.name} image ${i + 2}`} fill sizes="96px" className="object-cover" />
                </div>
              ))}
            </div>
          )}

          {/* Header */}
          <div>
            <div className="flex flex-wrap items-center gap-2 mb-3">
              <span className="px-3 py-1 bg-brand/10 text-brand text-xs font-semibold rounded-full">
                {ACCOMMODATION_TYPE_LABELS[acc.type]}
              </span>
              <span className="px-3 py-1 bg-gray-100 text-gray-700 text-xs font-medium rounded-full">
                {GENDER_LABELS[acc.gender]}
              </span>
              {badge.label && (
                <span className={`px-3 py-1 bg-amber-50 text-xs font-semibold rounded-full ${badge.color}`}>
                  ✓ {badge.label}
                </span>
              )}
            </div>
            <h1 className="text-2xl sm:text-3xl font-extrabold text-foreground">{acc.name}</h1>
            <p className="mt-2 text-muted">📍 {acc.address}</p>
          </div>

          {/* Sharing */}
          <ShareBar slug={acc.slug} name={acc.name} accommodationId={acc._id} />

          {/* Amenities */}
          <div>
            <h2 className="text-lg font-bold text-foreground mb-4">Amenities</h2>
            <div className="grid grid-cols-2 sm:grid-cols-3 gap-3">
              {acc.amenities.map((amenity) => (
                <div
                  key={amenity}
                  className="flex items-center gap-3 bg-surface-alt rounded-xl px-4 py-3 border border-border"
                >
                  <span className="text-xl">{AMENITY_ICONS[amenity] || '•'}</span>
                  <span className="text-sm font-medium text-foreground">{amenity}</span>
                </div>
              ))}
            </div>
          </div>

          {/* Nearby Colleges */}
          {acc.nearbyColleges.length > 0 && (
            <div>
              <h2 className="text-lg font-bold text-foreground mb-4">Nearby Colleges</h2>
              <div className="space-y-3">
                {acc.nearbyColleges.map((nc, i) => {
                  const college = nc.collegeId as College;
                  return (
                    <div key={i} className="flex items-center justify-between bg-surface-alt rounded-xl px-4 py-3 border border-border">
                      <div className="flex items-center gap-3">
                        <span className="text-xl">🏫</span>
                        <div>
                          <p className="text-sm font-medium text-foreground">{college.name || 'College'}</p>
                          {college.city && <p className="text-xs text-muted">{college.city}</p>}
                        </div>
                      </div>
                      <span className="text-sm font-semibold text-brand">
                        {nc.distanceMeters ? `${(nc.distanceMeters / 1000).toFixed(1)} km` : '--'}
                      </span>
                    </div>
                  );
                })}
              </div>
            </div>
          )}
        </div>

        {/* Right Column - Sticky Sidebar */}
        <div className="lg:col-span-1">
          <div className="sticky top-24 space-y-6">
            {/* Pricing Card */}
            <div className="bg-surface rounded-2xl border border-border shadow-lg p-6">
              <div className="mb-6">
                <span className="text-sm text-muted">Starting from</span>
                <div className="mt-1">
                  <span className="text-3xl font-extrabold text-brand">
                    ₹{acc.pricing.startingPrice.toLocaleString('en-IN')}
                  </span>
                  <span className="text-muted text-sm">/month</span>
                </div>
                {acc.pricing.deposit && (
                  <p className="text-sm text-muted mt-1">
                    Security Deposit: ₹{acc.pricing.deposit.toLocaleString('en-IN')}
                  </p>
                )}
              </div>

              {/* Owner Actions */}
              <OwnerActions
                phone={acc.ownerContact?.phone}
                name={acc.ownerContact?.name}
                accommodationId={acc._id}
              />

              {/* Schedule Visit CTA */}
              <div className="mt-4">
                <Link
                  href={`/accommodations/${acc.slug}#visit`}
                  className="block w-full text-center px-6 py-3 bg-accent text-white font-semibold rounded-xl hover:opacity-90 transition-opacity shadow-md"
                >
                  📅 Schedule a Visit
                </Link>
              </div>

              <p className="text-xs text-muted text-center mt-4">
                Free visit. No brokerage.
              </p>
            </div>

            {/* Download App CTA */}
            <div className="bg-brand-gradient rounded-2xl p-6 text-white text-center">
              <p className="text-sm font-semibold mb-2">Get the MH StayHub App</p>
              <p className="text-xs text-white/80 mb-4">Save properties, get alerts, and book instantly.</p>
              <button className="px-6 py-2.5 bg-white text-brand text-sm font-bold rounded-full hover:shadow-lg transition-all">
                Download App
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
