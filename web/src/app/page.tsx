import Link from 'next/link';
import AccommodationCard from '@/components/AccommodationCard';
import CollegeCard from '@/components/CollegeCard';
import { getColleges, getAccommodations } from '@/services/api';

export default async function HomePage() {
  const [colleges, accommodations] = await Promise.all([
    getColleges(),
    getAccommodations(),
  ]);

  const featuredAccommodations = accommodations.slice(0, 6);

  return (
    <>
      {/* ========== HERO SECTION ========== */}
      <section className="relative overflow-hidden min-h-[90vh] flex items-center justify-center pt-20 pb-16" style={{ background: 'var(--background)' }}>
        {/* Modern animated background elements */}
        <div className="absolute inset-0 w-full h-full bg-[linear-gradient(to_right,#80808012_1px,transparent_1px),linear-gradient(to_bottom,#80808012_1px,transparent_1px)] bg-[size:24px_24px]"></div>
        <div className="absolute left-0 right-0 top-0 -z-10 m-auto h-[310px] w-[310px] rounded-full bg-brand opacity-20 blur-[100px]"></div>
        <div className="absolute right-0 top-1/4 -z-10 h-[250px] w-[250px] rounded-full bg-brand-secondary opacity-20 blur-[100px]"></div>
        <div className="absolute left-1/4 bottom-0 -z-10 h-[300px] w-[300px] rounded-full bg-brand-accent opacity-10 blur-[120px]"></div>

        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10 w-full">
          <div className="flex flex-col items-center text-center">
            {/* Trusted Badge */}
            <div className="inline-flex items-center gap-2 px-4 py-2 rounded-full border mb-8 animate-fade-in" style={{ background: 'var(--surface)', borderColor: 'var(--border)', boxShadow: 'var(--shadow-sm)' }}>
              <span className="flex h-2 w-2 rounded-full bg-green-500 animate-pulse"></span>
              <span className="text-sm font-medium" style={{ color: 'var(--foreground)' }}>Trusted by 1000+ students in Greater Noida</span>
            </div>

            {/* Main Headline */}
            <h1 className="text-5xl sm:text-6xl md:text-7xl font-extrabold tracking-tight mb-6 animate-slide-up" style={{ color: 'var(--foreground)' }}>
              Find Your Perfect <br className="hidden sm:block" />
              <span className="text-brand-gradient">
                Student Stay
              </span>
            </h1>

            {/* Subheadline */}
            <p className="text-lg sm:text-xl max-w-2xl mx-auto mb-10 leading-relaxed animate-slide-up" style={{ color: 'var(--muted)', animationDelay: '0.1s' }}>
              Discover verified hostels, PGs, and co-living spaces near your college. Real photos, transparent pricing, and zero broker fees.
            </p>

            {/* CTA Buttons */}
            <div className="flex flex-col sm:flex-row gap-4 w-full sm:w-auto animate-slide-up" style={{ animationDelay: '0.2s' }}>
              <Link
                href="/accommodations"
                className="px-8 py-4 rounded-full font-bold text-white transition-all hover:scale-105 hover:shadow-lg flex items-center justify-center gap-2"
                style={{ background: 'var(--brand-primary)', boxShadow: '0 8px 20px -6px var(--brand-primary)' }}
              >
                <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" /></svg>
                Browse Accommodations
              </Link>
              <Link
                href="/colleges"
                className="px-8 py-4 rounded-full font-semibold transition-all hover:bg-surface-hover flex items-center justify-center gap-2 border"
                style={{ background: 'var(--surface)', color: 'var(--foreground)', borderColor: 'var(--border)' }}
              >
                <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" /></svg>
                Search by College
              </Link>
            </div>
            
            {/* Stats/Trust markers below buttons */}
            <div className="mt-16 grid grid-cols-2 md:grid-cols-4 gap-8 pt-8 border-t w-full max-w-4xl animate-slide-up" style={{ borderColor: 'var(--border)', animationDelay: '0.3s' }}>
              <div className="flex flex-col items-center">
                <span className="text-3xl font-bold" style={{ color: 'var(--foreground)' }}>500+</span>
                <span className="text-sm mt-1" style={{ color: 'var(--muted)' }}>Verified Properties</span>
              </div>
              <div className="flex flex-col items-center">
                <span className="text-3xl font-bold" style={{ color: 'var(--foreground)' }}>₹0</span>
                <span className="text-sm mt-1" style={{ color: 'var(--muted)' }}>Brokerage Fee</span>
              </div>
              <div className="flex flex-col items-center">
                <span className="text-3xl font-bold" style={{ color: 'var(--foreground)' }}>24/7</span>
                <span className="text-sm mt-1" style={{ color: 'var(--muted)' }}>Student Support</span>
              </div>
              <div className="flex flex-col items-center">
                <span className="text-3xl font-bold" style={{ color: 'var(--foreground)' }}>10+</span>
                <span className="text-sm mt-1" style={{ color: 'var(--muted)' }}>Partner Colleges</span>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* ========== SEARCH BY COLLEGE ========== */}
      <section className="py-16 sm:py-20" style={{ background: 'var(--background)' }}>
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <h2 className="text-3xl sm:text-4xl font-extrabold" style={{ color: 'var(--foreground)' }}>
              Find Stays Near Your <span className="text-brand">College</span>
            </h2>
            <p className="mt-3 text-lg max-w-2xl mx-auto" style={{ color: 'var(--muted)' }}>
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
              <p style={{ color: 'var(--muted)' }}>Colleges coming soon. We&apos;re onboarding Greater Noida colleges.</p>
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
      <section className="py-16 sm:py-20" style={{ background: 'var(--surface-alt)' }}>
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <h2 className="text-3xl sm:text-4xl font-extrabold" style={{ color: 'var(--foreground)' }}>
              Featured <span className="text-brand">Accommodations</span>
            </h2>
            <p className="mt-3 text-lg max-w-2xl mx-auto" style={{ color: 'var(--muted)' }}>
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
              <p style={{ color: 'var(--muted)' }}>Accommodations coming soon! We&apos;re onboarding verified stays.</p>
            </div>
          )}

          <div className="text-center mt-10">
            <Link
              href="/accommodations"
              className="inline-block px-8 py-3 bg-brand text-white font-semibold rounded-full hover:bg-brand-dark transition-colors"
              style={{ boxShadow: '0 4px 14px rgba(108,60,225,0.3)' }}
            >
              View All Accommodations
            </Link>
          </div>
        </div>
      </section>

      {/* ========== WHY MH STAYHUB ========== */}
      <section className="py-16 sm:py-20" style={{ background: 'var(--background)' }}>
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-14">
            <h2 className="text-3xl sm:text-4xl font-extrabold" style={{ color: 'var(--foreground)' }}>
              Why Students Choose <span className="text-brand">MH StayHub</span>
            </h2>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 animate-stagger">
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
              <div key={item.title} className="card p-6 text-center">
                <div className="text-4xl mb-4">{item.icon}</div>
                <h3 className="text-base font-bold mb-2" style={{ color: 'var(--foreground)' }}>{item.title}</h3>
                <p className="text-sm leading-relaxed" style={{ color: 'var(--muted)' }}>{item.desc}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ========== CTA SECTION ========== */}
      <section className="py-16 sm:py-20" style={{ background: 'var(--surface-alt)' }}>
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
