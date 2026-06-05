"use client";

import React from 'react';
import Link from 'next/link';
import { ShieldCheck, Calendar, Ticket, User, ArrowRight, Briefcase, Users, ShoppingBag, MessagesSquare } from 'lucide-react';

export default function StudentCommandCenter() {
  const user = {
    name: 'Student Name',
    collegeName: 'Demo College',
    verificationStatus: 'verified',
    membershipTier: 'verified',
  };

  const stats = {
    activeCoupons: 3,
    upcomingEvents: 1,
    notifications: 2,
  };

  const quickLinks = [
    { href: '/student-advantage', label: 'Student Advantage', desc: 'Exclusive student discounts and local deals.', icon: <Ticket size={22} />, color: 'var(--brand-primary)' },
    { href: '/career-hub', label: 'Career Hub', desc: 'Placements, internships, and drives.', icon: <Briefcase size={22} />, color: 'var(--brand-secondary)' },
    { href: '/roommate-finder', label: 'Roommate Finder', desc: 'Find the perfect hostel roommate.', icon: <Users size={22} />, color: '#F59E0B' },
    { href: '/marketplace', label: 'Marketplace', desc: 'Buy and sell within the campus.', icon: <ShoppingBag size={22} />, color: '#10B981' },
    { href: '/senior-connect', label: 'Senior Connect', desc: 'Get guidance and referrals.', icon: <MessagesSquare size={22} />, color: '#3B82F6' },
  ];

  return (
    <div className="min-h-screen" style={{ background: 'var(--background)' }}>
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 animate-fade-in">
        {/* Header */}
        <div className="flex flex-col md:flex-row justify-between items-start md:items-center mb-8 gap-4">
          <div>
            <h1 className="text-3xl font-bold tracking-tight" style={{ color: 'var(--foreground)' }}>Student Command Center</h1>
            <p style={{ color: 'var(--muted)' }} className="mt-1">Welcome back, {user.name}!</p>
          </div>
          {user.verificationStatus === 'verified' && (
            <div className="px-4 py-2 rounded-full flex items-center gap-2 font-medium text-sm" style={{ background: 'rgba(16,185,129,0.1)', color: 'var(--success)', border: '1px solid rgba(16,185,129,0.2)' }}>
              <ShieldCheck size={18} />
              MH Verified Student
            </div>
          )}
          {user.verificationStatus === 'pending' && (
            <div className="px-4 py-2 rounded-full flex items-center gap-2 font-medium text-sm" style={{ background: 'rgba(245,158,11,0.1)', color: 'var(--warning)', border: '1px solid rgba(245,158,11,0.2)' }}>
              <User size={18} />
              Verification Pending
            </div>
          )}
        </div>

        {user.verificationStatus === 'none' && (
          <div className="card p-6 mb-8 flex flex-col md:flex-row items-center justify-between gap-6">
            <div>
              <h2 className="text-xl font-semibold mb-2" style={{ color: 'var(--foreground)' }}>Unlock Student Advantage</h2>
              <p style={{ color: 'var(--muted)' }}>Verify your student status to get access to exclusive deals, career opportunities, and premium features.</p>
            </div>
            <Link href="/verification" className="bg-brand hover:bg-brand-dark text-white px-6 py-3 rounded-lg font-medium transition-colors whitespace-nowrap flex items-center gap-2">
              Verify Now <ArrowRight size={18} />
            </Link>
          </div>
        )}

        {/* Stats row */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
          <div className="card p-6">
            <div className="w-12 h-12 rounded-lg flex items-center justify-center mb-4" style={{ background: 'rgba(108,60,225,0.1)', color: 'var(--brand-primary)' }}>
              <Ticket size={24} />
            </div>
            <h3 className="text-3xl font-bold" style={{ color: 'var(--foreground)' }}>{stats.activeCoupons}</h3>
            <p className="font-medium" style={{ color: 'var(--muted)' }}>Active Coupons</p>
          </div>
          <div className="card p-6">
            <div className="w-12 h-12 rounded-lg flex items-center justify-center mb-4" style={{ background: 'rgba(20,184,166,0.1)', color: 'var(--brand-secondary)' }}>
              <Calendar size={24} />
            </div>
            <h3 className="text-3xl font-bold" style={{ color: 'var(--foreground)' }}>{stats.upcomingEvents}</h3>
            <p className="font-medium" style={{ color: 'var(--muted)' }}>Upcoming Events</p>
          </div>
          <div className="card p-6">
            <div className="w-12 h-12 rounded-lg flex items-center justify-center mb-4" style={{ background: 'rgba(245,158,11,0.1)', color: 'var(--brand-accent)' }}>
              <User size={24} />
            </div>
            <h3 className="text-xl font-semibold" style={{ color: 'var(--foreground)' }}>{user.membershipTier.charAt(0).toUpperCase() + user.membershipTier.slice(1)}</h3>
            <p className="font-medium" style={{ color: 'var(--muted)' }}>Membership Tier</p>
          </div>
        </div>

        {/* Quick Access Grid */}
        <h2 className="text-2xl font-bold mb-6" style={{ color: 'var(--foreground)' }}>Quick Access</h2>
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
          {quickLinks.map(link => (
            <Link key={link.href} href={link.href} className="card p-5 flex items-start gap-4 group">
              <div className="w-11 h-11 rounded-lg flex items-center justify-center shrink-0" style={{ background: `${link.color}15`, color: link.color }}>
                {link.icon}
              </div>
              <div className="flex-1 min-w-0">
                <h3 className="font-semibold group-hover:text-brand transition-colors" style={{ color: 'var(--foreground)' }}>{link.label}</h3>
                <p className="text-sm mt-0.5" style={{ color: 'var(--muted)' }}>{link.desc}</p>
              </div>
              <ArrowRight size={18} className="shrink-0 mt-1 group-hover:text-brand transition-colors" style={{ color: 'var(--muted)' }} />
            </Link>
          ))}
        </div>
      </div>
    </div>
  );
}
