"use client";

import React from 'react';
import { Calendar, MapPin, Users } from 'lucide-react';

export default function CareerHubPage() {
  const events = [
    { id: 1, title: "TCS Off-Campus Drive", type: "Placement", date: "Oct 15, 2026", location: "Online", seats: 500 },
    { id: 2, title: "Google Cloud Study Jam", type: "Workshop", date: "Oct 20, 2026", location: "Campus A", seats: 150 }
  ];

  return (
    <div className="container mx-auto px-4 py-8 max-w-7xl animate-fade-in" style={{ background: 'var(--background)' }}>
      <h1 className="text-3xl font-bold mb-2" style={{ color: 'var(--foreground)' }}>Career Hub</h1>
      <p className="mb-8" style={{ color: 'var(--muted)' }}>Discover placement drives, internships, and skill workshops.</p>
      
      <div className="space-y-4">
        {events.map(e => (
          <div key={e.id} className="card p-6 flex flex-col md:flex-row justify-between items-start md:items-center gap-4 hover:border-brand transition-colors">
            <div>
              <span className="px-3 py-1 rounded-full text-xs font-semibold uppercase tracking-wider mb-2 inline-block" style={{ background: 'rgba(108,60,225,0.1)', color: 'var(--brand-primary)' }}>{e.type}</span>
              <h3 className="text-xl font-bold" style={{ color: 'var(--foreground)' }}>{e.title}</h3>
              <div className="flex flex-wrap gap-4 mt-3 text-sm" style={{ color: 'var(--muted)' }}>
                <span className="flex items-center gap-1"><Calendar size={16}/> {e.date}</span>
                <span className="flex items-center gap-1"><MapPin size={16}/> {e.location}</span>
                <span className="flex items-center gap-1"><Users size={16}/> {e.seats} seats</span>
              </div>
            </div>
            <button className="w-full md:w-auto px-6 py-2.5 rounded-lg font-medium transition-colors bg-brand hover:bg-brand-dark text-white">
              Register Now
            </button>
          </div>
        ))}
      </div>
    </div>
  );
}
