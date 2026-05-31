import Link from 'next/link';
import Image from 'next/image';
import type { Accommodation } from '@/types';
import { AMENITY_ICONS, VERIFICATION_BADGES, GENDER_LABELS, ACCOMMODATION_TYPE_LABELS } from '@/constants';

interface AccommodationCardProps {
  accommodation: Accommodation;
}

export default function AccommodationCard({ accommodation }: AccommodationCardProps) {
  const badge = VERIFICATION_BADGES[accommodation.verification.status];

  return (
    <Link
      href={`/accommodations/${accommodation.slug}`}
      className="group block bg-white rounded-xl overflow-hidden shadow-md hover:shadow-xl transition-all duration-300 hover:-translate-y-1"
    >
      {/* Image */}
      <div className="relative h-48 sm:h-52 overflow-hidden bg-gray-100">
        {accommodation.images.length > 0 ? (
          <Image
            src={accommodation.images[0]}
            alt={accommodation.name}
            fill
            sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
            className="object-cover group-hover:scale-105 transition-transform duration-500"
          />
        ) : (
          <div className="w-full h-full flex items-center justify-center text-gray-400 text-sm">
            No Image
          </div>
        )}

        {/* Badges */}
        <div className="absolute top-3 left-3 flex gap-2">
          <span className="px-2.5 py-1 bg-white/90 backdrop-blur-sm rounded-full text-xs font-semibold text-brand">
            {ACCOMMODATION_TYPE_LABELS[accommodation.type]}
          </span>
          <span className="px-2.5 py-1 bg-white/90 backdrop-blur-sm rounded-full text-xs font-medium text-gray-700">
            {GENDER_LABELS[accommodation.gender]}
          </span>
        </div>

        {badge.label && (
          <div className="absolute top-3 right-3">
            <span className={`px-2.5 py-1 bg-white/90 backdrop-blur-sm rounded-full text-xs font-semibold ${badge.color}`}>
              ✓ {badge.label}
            </span>
          </div>
        )}
      </div>

      {/* Content */}
      <div className="p-4">
        <h3 className="text-base font-semibold text-foreground group-hover:text-brand transition-colors line-clamp-1">
          {accommodation.name}
        </h3>
        <p className="text-sm text-muted mt-1 line-clamp-1">
          📍 {accommodation.address}
        </p>

        {/* Amenities */}
        <div className="flex flex-wrap gap-1.5 mt-3">
          {accommodation.amenities.slice(0, 4).map((amenity) => (
            <span key={amenity} className="text-xs bg-gray-50 text-gray-600 px-2 py-1 rounded-md">
              {AMENITY_ICONS[amenity] || '•'} {amenity}
            </span>
          ))}
          {accommodation.amenities.length > 4 && (
            <span className="text-xs text-muted px-2 py-1">
              +{accommodation.amenities.length - 4} more
            </span>
          )}
        </div>

        {/* Price */}
        <div className="mt-4 flex items-end justify-between">
          <div>
            <span className="text-lg font-bold text-brand">
              ₹{accommodation.pricing.startingPrice.toLocaleString('en-IN')}
            </span>
            <span className="text-xs text-muted">/month</span>
          </div>
          <span className="text-xs font-medium text-brand bg-brand/5 px-3 py-1.5 rounded-full group-hover:bg-brand group-hover:text-white transition-colors">
            View Details →
          </span>
        </div>
      </div>
    </Link>
  );
}
