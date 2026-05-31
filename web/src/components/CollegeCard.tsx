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
      className="group flex items-center gap-4 bg-white rounded-xl p-4 shadow-sm hover:shadow-lg transition-all duration-300 hover:-translate-y-0.5 border border-border"
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
        <h3 className="text-sm font-semibold text-foreground group-hover:text-brand transition-colors line-clamp-1">
          {college.name}
        </h3>
        <p className="text-xs text-muted mt-0.5">
          📍 {college.city}, {college.state}
        </p>
      </div>

      {/* Arrow */}
      <svg className="w-5 h-5 text-muted group-hover:text-brand transition-colors flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
      </svg>
    </Link>
  );
}
