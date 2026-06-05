import Link from 'next/link';
import Image from 'next/image';
import type { College } from '@/types';

interface CollegeCardProps {
  college: College;
}

export default function CollegeCard({ college }: CollegeCardProps) {
  return (
    <Link
      href={`/colleges/${college.slug}`}
      className="group card flex items-center gap-4 rounded-xl p-4"
    >
      {/* Logo */}
      <div className="relative w-14 h-14 rounded-xl bg-brand/10 flex items-center justify-center flex-shrink-0 overflow-hidden">
        {college.logo ? (
          <Image src={college.logo} alt={college.name} fill className="object-contain p-2" />
        ) : (
          <span className="text-2xl font-bold text-brand">
            {college.name.charAt(0)}
          </span>
        )}
      </div>

      {/* Info */}
      <div className="flex-1 min-w-0">
        <h3 className="text-sm font-semibold group-hover:text-brand transition-colors line-clamp-1" style={{ color: 'var(--foreground)' }}>
          {college.name}
        </h3>
        <p className="text-xs mt-0.5" style={{ color: 'var(--muted)' }}>
          📍 {college.city}, {college.state}
        </p>
      </div>

      {/* Arrow */}
      <svg className="w-5 h-5 group-hover:text-brand transition-colors flex-shrink-0" style={{ color: 'var(--muted)' }} fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
      </svg>
    </Link>
  );
}
