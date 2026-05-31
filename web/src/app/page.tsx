import Link from 'next/link';
import AccommodationCard from '@/components/AccommodationCard';
import CollegeCard from '@/components/CollegeCard';
import { getColleges, getAccommodations } from '@/services/api';

export default async function HomePage() {
  // Server Components: Fetch data at build/request time
  const [colleges, accommodations] = await Promise.all([
    getColleges(),
    getAccommodations(),
  ]);

  const featuredAccommodations = accommodations.slice(0, 6);

  return (
    <>
      {/* ========== HERO SECTION ========== */}
      <section className="bg-hero-gradient text-white relative overflow-hidden">
        {/* Decorative circles */}
        <div className="absolute top-10 right-10 w-72 h-72 bg-white/5 rounded-full blur-3xl" />
        <div className="absolute bottom-10 left-10 w-96 h-96 bg-white/5 rounded-full blur-3xl" />

        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20 sm:py-28 lg:py-36 relative z-10">
          <div className="max-w-3xl">
            <span className="inline-block px-4 py-1.5 bg-white/15 backdrop-blur-sm rounded-full text-sm font-medium mb-6 animate-fade-in">
              🎓 Trusted by 1000+ students in Greater Noida
            </span>

            <h1 className="text-4xl sm:text-5xl lg:text-6xl font-extrabold leading-tight animate-slide-up">
              Find Your Perfect
              <br />
              <span className="text-amber-300">Student Stay</span>
            </h1>

            <p className="mt-6 text-lg sm:text-xl text-white/80 max-w-xl leading-relaxed animate-slide-up" style={{ animationDelay: '0.15s' }}>
              Verified hostels, PGs, and co-living spaces near your college. Real photos. Transparent pricing. Zero broker fees.
            </p>

            <div className="mt-10 flex flex-col sm:flex-row gap-4 animate-slide-up" style={{ animationDelay: '0.3s' }}>
              <Link
                href="/accommodations"
                className="px-8 py-4 bg-white text-brand font-bold rounded-full text-center shadow-xl hover:shadow-2xl hover:scale-105 transition-all duration-300"
              >
                🔍 Browse Accommodations
              </Link>
              <Link
                href="/colleges"
                className="px-8 py-4 bg-white/15 backdrop-blur-sm text-white font-semibold rounded-full text-center border border-white/25 hover:bg-white/25 transition-all duration-300"
              >
                🏫 Search by College
              </Link>
            </div>
          </div>
        </div>
      </section>

      {/* ========== SEARCH BY COLLEGE ========== */}
      <section className="py-16 sm:py-20 bg-gray-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <h2 className="text-3xl sm:text-4xl font-extrabold text-foreground">
              Find Stays Near Your <span className="text-brand">College</span>
            </h2>
            <p className="mt-3 text-muted text-lg max-w-2xl mx-auto">
              Select your college and discover nearby verified accommodations instantly.
            </p>
          </div>

          {colleges.length > 0 ? (
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 animate-stagger">
              {colleges.map((college) => (
                <CollegeCard key={college._id} college={college} />
              ))}
            </div>
          ) : (
            <div className="text-center py-10">
              <p className="text-muted">Colleges coming soon. We&apos;re onboarding Greater Noida colleges.</p>
            </div>
          )}

          <div className="text-center mt-10">
            <Link
              href="/colleges"
              className="text-sm font-semibold text-brand hover:text-brand-dark transition-colors"
            >
              View All Colleges →
            </Link>
          </div>
        </div>
      </section>

      {/* ========== FEATURED ACCOMMODATIONS ========== */}
      <section className="py-16 sm:py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <h2 className="text-3xl sm:text-4xl font-extrabold text-foreground">
              Featured <span className="text-brand">Accommodations</span>
            </h2>
            <p className="mt-3 text-muted text-lg max-w-2xl mx-auto">
              Hand-picked, verified places loved by students.
            </p>
          </div>

          {featuredAccommodations.length > 0 ? (
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 animate-stagger">
              {featuredAccommodations.map((acc) => (
                <AccommodationCard key={acc._id} accommodation={acc} />
              ))}
            </div>
          ) : (
            <div className="text-center py-10">
              <p className="text-muted">Accommodations coming soon! We&apos;re onboarding verified stays.</p>
            </div>
          )}

          <div className="text-center mt-10">
            <Link
              href="/accommodations"
              className="inline-block px-8 py-3 bg-brand text-white font-semibold rounded-full hover:bg-brand-dark transition-colors shadow-md"
            >
              View All Accommodations
            </Link>
          </div>
        </div>
      </section>

      {/* ========== WHY MH STAYHUB ========== */}
      <section className="py-16 sm:py-20 bg-gray-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-14">
            <h2 className="text-3xl sm:text-4xl font-extrabold text-foreground">
              Why Students Choose <span className="text-brand">MH StayHub</span>
            </h2>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-8 animate-stagger">
            {[
              {
                icon: '✅',
                title: 'Verified Listings',
                desc: 'Every accommodation is personally visited and photos are real. No surprises.',
              },
              {
                icon: '💰',
                title: 'Zero Brokerage',
                desc: 'Connect directly with owners. No middlemen. No hidden charges.',
              },
              {
                icon: '🏫',
                title: 'College-Wise Search',
                desc: 'Find stays specifically near your college with accurate distances.',
              },
              {
                icon: '🔒',
                title: 'Secure Token Booking',
                desc: 'Pay a small refundable token to hold your room before moving in.',
              },
            ].map((item) => (
              <div key={item.title} className="bg-white rounded-xl p-6 shadow-sm hover:shadow-lg transition-all duration-300 text-center border border-border">
                <div className="text-4xl mb-4">{item.icon}</div>
                <h3 className="text-base font-bold text-foreground mb-2">{item.title}</h3>
                <p className="text-sm text-muted leading-relaxed">{item.desc}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ========== CTA SECTION ========== */}
      <section className="py-16 sm:py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="bg-brand-gradient rounded-2xl px-8 py-14 sm:px-16 sm:py-20 text-center text-white relative overflow-hidden">
            <div className="absolute top-0 right-0 w-64 h-64 bg-white/10 rounded-full blur-3xl" />
            <div className="absolute bottom-0 left-0 w-80 h-80 bg-white/5 rounded-full blur-3xl" />

            <div className="relative z-10">
              <h2 className="text-3xl sm:text-4xl font-extrabold">
                Ready to Find Your Stay?
              </h2>
              <p className="mt-4 text-lg text-white/80 max-w-xl mx-auto">
                Browse verified accommodations now. It takes less than 2 minutes to schedule a visit.
              </p>
              <div className="mt-8 flex flex-col sm:flex-row gap-4 justify-center">
                <Link
                  href="/accommodations"
                  className="px-8 py-4 bg-white text-brand font-bold rounded-full shadow-xl hover:shadow-2xl hover:scale-105 transition-all duration-300"
                >
                  Explore Now
                </Link>
              </div>
            </div>
          </div>
        </div>
      </section>
    </>
  );
}
