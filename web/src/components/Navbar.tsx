'use client';

import Link from 'next/link';
import { useState, useEffect } from 'react';
import { useTheme } from 'next-themes';
import NotificationDropdown from './notifications/NotificationDropdown';

export default function Navbar() {
  const [mobileOpen, setMobileOpen] = useState(false);
  const [mounted, setMounted] = useState(false);
  const { theme, setTheme } = useTheme();

  useEffect(() => {
    setMounted(true);
  }, []);

  const navLinks = [
    { href: '/colleges', label: 'Colleges' },
    { href: '/accommodations', label: 'Accommodations' },
    { href: '/career-hub', label: 'Career Hub' },
    { href: '/about', label: 'About' },
  ];

  return (
    <nav className="fixed top-0 left-0 right-0 z-50 backdrop-blur-xl border-b" style={{ background: 'var(--nav-bg)', borderColor: 'var(--nav-border)' }}>
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          {/* Logo */}
          <Link href="/" className="flex items-center gap-2.5">
            <div className="w-9 h-9 rounded-lg bg-brand-gradient flex items-center justify-center">
              <span className="text-white font-bold text-lg">M</span>
            </div>
            <span className="text-xl font-bold" style={{ color: 'var(--foreground)' }}>
              MH <span className="text-brand">StayHub</span>
            </span>
          </Link>

          {/* Desktop Nav */}
          <div className="hidden lg:flex items-center gap-1">
            {navLinks.map(link => (
              <Link
                key={link.href}
                href={link.href}
                className="px-3.5 py-2 text-sm font-medium rounded-lg transition-colors"
                style={{ color: 'var(--muted)' }}
              >
                {link.label}
              </Link>
            ))}
            <Link
              href="/student-command-center"
              className="ml-1 px-3.5 py-2 text-sm font-semibold rounded-lg border transition-all"
              style={{ color: 'var(--brand-primary)', borderColor: 'rgba(108,60,225,0.2)', background: 'rgba(108,60,225,0.06)' }}
            >
              Command Center
            </Link>
          </div>

          {/* Right actions */}
          <div className="hidden lg:flex items-center gap-2">
            {/* Theme toggle */}
            <button
              onClick={() => setTheme(theme === 'dark' ? 'light' : 'dark')}
              className="p-2 rounded-lg transition-colors w-9 h-9 flex items-center justify-center"
              style={{ color: 'var(--muted)', background: 'transparent' }}
              aria-label="Toggle theme"
            >
              {mounted && (theme === 'dark' ? (
                <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z" />
                </svg>
              ) : (
                <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z" />
                </svg>
              ))}
            </button>

            <NotificationDropdown />

            <Link
              href="/accommodations"
              className="px-5 py-2.5 bg-brand text-white text-sm font-semibold rounded-full hover:bg-brand-dark transition-colors"
              style={{ boxShadow: '0 4px 14px rgba(108,60,225,0.3)' }}
            >
              Find Hostel
            </Link>
          </div>

          {/* Mobile Toggle */}
          <div className="flex lg:hidden items-center gap-2">
            <button
              onClick={() => setTheme(theme === 'dark' ? 'light' : 'dark')}
              className="p-2 rounded-lg w-9 h-9 flex items-center justify-center"
              style={{ color: 'var(--muted)' }}
              aria-label="Toggle theme"
            >
              {mounted && (theme === 'dark' ? (
                <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z" /></svg>
              ) : (
                <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z" /></svg>
              ))}
            </button>
            <NotificationDropdown />
            <button
              onClick={() => setMobileOpen(!mobileOpen)}
              className="p-2 rounded-lg transition-colors"
              style={{ color: 'var(--foreground)' }}
              aria-label="Toggle menu"
            >
              <svg className="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                {mobileOpen ? (
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                ) : (
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
                )}
              </svg>
            </button>
          </div>
        </div>
      </div>

      {/* Mobile Menu */}
      {mobileOpen && (
        <div className="lg:hidden animate-fade-in border-t" style={{ background: 'var(--surface)', borderColor: 'var(--border)' }}>
          <div className="px-4 py-4 flex flex-col gap-1">
            {navLinks.map(link => (
              <Link
                key={link.href}
                href={link.href}
                className="px-3 py-2.5 text-sm font-medium rounded-lg transition-colors"
                style={{ color: 'var(--muted)' }}
                onClick={() => setMobileOpen(false)}
              >
                {link.label}
              </Link>
            ))}
            <Link
              href="/student-command-center"
              className="px-3 py-2.5 text-sm font-semibold rounded-lg transition-colors"
              style={{ color: 'var(--brand-primary)' }}
              onClick={() => setMobileOpen(false)}
            >
              Command Center
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
