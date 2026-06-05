import Link from 'next/link';

export default function Footer() {
  return (
    <footer style={{ background: 'var(--footer-bg)', color: 'var(--footer-text)' }}>
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-10">
          {/* Brand */}
          <div className="col-span-1 md:col-span-1">
            <div className="flex items-center gap-2 mb-4">
              <div className="w-9 h-9 rounded-lg bg-brand-gradient flex items-center justify-center">
                <span className="text-white font-bold text-lg">M</span>
              </div>
              <span className="text-xl font-bold" style={{ color: 'var(--footer-heading)' }}>
                MH <span className="text-brand-light">StayHub</span>
              </span>
            </div>
            <p className="text-sm leading-relaxed" style={{ color: 'var(--footer-text)' }}>
              Helping students find verified, affordable accommodation near their college in Greater Noida.
            </p>
          </div>

          {/* Quick Links */}
          <div>
            <h4 className="text-sm font-semibold uppercase tracking-wider mb-4" style={{ color: 'var(--footer-heading)' }}>Explore</h4>
            <ul className="space-y-3">
              <li><Link href="/accommodations" className="text-sm hover:text-brand-light transition-colors">All Accommodations</Link></li>
              <li><Link href="/colleges" className="text-sm hover:text-brand-light transition-colors">Colleges</Link></li>
              <li><Link href="/career-hub" className="text-sm hover:text-brand-light transition-colors">Career Hub</Link></li>
              <li><Link href="/student-advantage" className="text-sm hover:text-brand-light transition-colors">Student Advantage</Link></li>
            </ul>
          </div>

          {/* Company */}
          <div>
            <h4 className="text-sm font-semibold uppercase tracking-wider mb-4" style={{ color: 'var(--footer-heading)' }}>Company</h4>
            <ul className="space-y-3">
              <li><Link href="/about" className="text-sm hover:text-brand-light transition-colors">About Us</Link></li>
              <li><Link href="/contact" className="text-sm hover:text-brand-light transition-colors">Contact</Link></li>
              <li><Link href="/privacy" className="text-sm hover:text-brand-light transition-colors">Privacy Policy</Link></li>
              <li><Link href="/terms" className="text-sm hover:text-brand-light transition-colors">Terms &amp; Conditions</Link></li>
            </ul>
          </div>

          {/* Contact */}
          <div>
            <h4 className="text-sm font-semibold uppercase tracking-wider mb-4" style={{ color: 'var(--footer-heading)' }}>Get in Touch</h4>
            <ul className="space-y-3">
              <li className="text-sm">📍 Greater Noida, UP, India</li>
              <li className="text-sm">📧 support@mhstayhub.com</li>
              <li className="text-sm">📱 +91-XXXXXXXXXX</li>
            </ul>
          </div>
        </div>

        <div className="mt-12 pt-8 flex flex-col sm:flex-row items-center justify-between gap-4" style={{ borderTop: '1px solid var(--footer-border)' }}>
          <p className="text-xs" style={{ color: 'var(--footer-text)' }}>
            © {new Date().getFullYear()} MH StayHub. All rights reserved.
          </p>
          <p className="text-xs" style={{ color: 'var(--footer-text)' }}>
            Made with ❤️ for students in Greater Noida
          </p>
        </div>
      </div>
    </footer>
  );
}
