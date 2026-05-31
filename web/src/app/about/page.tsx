import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'About MH StayHub',
  description: 'MH StayHub is a student-first accommodation platform helping students find verified hostels, PGs, and co-living spaces in Greater Noida.',
};

export default function AboutPage() {
  return (
    <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-12 sm:py-20">
      <h1 className="text-3xl sm:text-4xl font-extrabold text-foreground mb-6">
        About <span className="text-brand">MH StayHub</span>
      </h1>

      <div className="prose prose-lg max-w-none text-muted space-y-6">
        <p className="text-lg leading-relaxed">
          MH StayHub is Greater Noida&apos;s first student-focused accommodation discovery platform. We&apos;re on a mission to eliminate the pain of finding hostels, PGs, and co-living spaces for college students.
        </p>

        <div className="bg-brand/5 rounded-2xl p-8 my-10 border border-brand/10">
          <h2 className="text-xl font-bold text-foreground mb-4">Our Mission</h2>
          <p className="text-base leading-relaxed">
            Every year, thousands of students arrive in Greater Noida with no idea where to stay. They waste days roaming under the sun, dealing with brokers, and relying on fake listings. MH StayHub changes that by providing verified, real-photo listings with transparent pricing—all without any brokerage.
          </p>
        </div>

        <h2 className="text-xl font-bold text-foreground">What Makes Us Different</h2>
        <ul className="space-y-3">
          <li className="flex items-start gap-3">
            <span className="text-brand font-bold">✓</span>
            <span><strong>Personally Verified:</strong> Our team visits every accommodation before listing it.</span>
          </li>
          <li className="flex items-start gap-3">
            <span className="text-brand font-bold">✓</span>
            <span><strong>College-Specific Search:</strong> Find stays mapped to your exact college.</span>
          </li>
          <li className="flex items-start gap-3">
            <span className="text-brand font-bold">✓</span>
            <span><strong>Zero Brokerage:</strong> We connect you directly with verified owners.</span>
          </li>
          <li className="flex items-start gap-3">
            <span className="text-brand font-bold">✓</span>
            <span><strong>Transparent:</strong> Real photos, real prices, real reviews.</span>
          </li>
        </ul>

        <h2 className="text-xl font-bold text-foreground mt-10">Our Vision</h2>
        <p className="text-base leading-relaxed">
          We&apos;re starting with hostels in Greater Noida, but our vision is to become India&apos;s most trusted student accommodation platform—expanding into PGs, co-living spaces, student rentals, and eventually a full student services ecosystem.
        </p>
      </div>
    </div>
  );
}
