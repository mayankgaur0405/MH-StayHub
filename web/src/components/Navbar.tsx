'use client';

import Link from 'next/link';
import { useState } from 'react';

export default function Navbar() {
  const [mobileOpen, setMobileOpen] = useState(false);

  return (
    <nav className="fixed top-0 left-0 right-0 z-50 bg-white/80 backdrop-blur-lg border-b border-border">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          {/* Logo */}
          <Link href="/" className="flex items-center gap-2">
            <div className="w-9 h-9 rounded-lg bg-brand-gradient flex items-center justify-center">
              <span className="text-white font-bold text-lg">M</span>
            </div>
            <span className="text-xl font-bold text-foreground">
              MH <span className="text-brand">StayHub</span>
            </span>
          </Link>

          {/* Desktop Nav */}
          <div className="hidden md:flex items-center gap-8">
            <Link href="/colleges" className="text-sm font-medium text-muted hover:text-brand transition-colors">
              Colleges
            </Link>
            <Link href="/accommodations" className="text-sm font-medium text-muted hover:text-brand transition-colors">
              Accommodations
            </Link>
            <Link href="/about" className="text-sm font-medium text-muted hover:text-brand transition-colors">
              About
            </Link>
            <Link href="/contact" className="text-sm font-medium text-muted hover:text-brand transition-colors">
              Contact
            </Link>
            <Link
              href="/accommodations"
              className="px-5 py-2.5 bg-brand text-white text-sm font-semibold rounded-full hover:bg-brand-dark transition-colors shadow-md"
            >
              Find Hostel
            </Link>
          </div>

          {/* Mobile Toggle */}
          <button
            onClick={() => setMobileOpen(!mobileOpen)}
            className="md:hidden p-2 rounded-lg hover:bg-surface-hover transition-colors"
            aria-label="Toggle menu"
          >
            <svg className="w-6 h-6 text-foreground" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              {mobileOpen ? (
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
              ) : (
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
              )}
            </svg>
          </button>
        </div>
      </div>

      {/* Mobile Menu */}
      {mobileOpen && (
        <div className="md:hidden bg-white border-t border-border animate-fade-in">
          <div className="px-4 py-4 flex flex-col gap-3">
            <Link href="/colleges" className="text-sm font-medium text-muted hover:text-brand py-2" onClick={() => setMobileOpen(false)}>
              Colleges
            </Link>
            <Link href="/accommodations" className="text-sm font-medium text-muted hover:text-brand py-2" onClick={() => setMobileOpen(false)}>
              Accommodations
            </Link>
            <Link href="/about" className="text-sm font-medium text-muted hover:text-brand py-2" onClick={() => setMobileOpen(false)}>
              About
            </Link>
            <Link href="/contact" className="text-sm font-medium text-muted hover:text-brand py-2" onClick={() => setMobileOpen(false)}>
              Contact
            </Link>
            <Link
              href="/accommodations"
              className="mt-2 px-5 py-2.5 bg-brand text-white text-sm font-semibold rounded-full text-center hover:bg-brand-dark transition-colors"
              onClick={() => setMobileOpen(false)}
            >
              Find Hostel
            </Link>
          </div>
        </div>
      )}
    </nav>
  );
}
