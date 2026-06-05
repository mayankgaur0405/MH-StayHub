"use client";

import React from 'react';
import { User, MessageCircle } from 'lucide-react';

export default function RoommateFinderPage() {
  const profiles = [
    { id: 1, name: "Rahul S.", college: "Delhi University", year: "3rd Year", budget: "₹8000/mo", food: "Veg" },
    { id: 2, name: "Amit K.", college: "DTU", year: "2nd Year", budget: "₹10000/mo", food: "Any" }
  ];

  return (
    <div className="container mx-auto px-4 py-8 max-w-7xl animate-fade-in" style={{ background: 'var(--background)' }}>
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center mb-8 gap-4">
        <div>
          <h1 className="text-3xl font-bold mb-2" style={{ color: 'var(--foreground)' }}>Roommate Finder</h1>
          <p style={{ color: 'var(--muted)' }}>Find the perfect verified roommate for your stay.</p>
        </div>
        <button className="px-4 py-2 border rounded-lg hover:bg-brand hover:text-white hover:border-brand transition-colors" style={{ borderColor: 'var(--brand-primary)', color: 'var(--brand-primary)' }}>
          Create Profile
        </button>
      </div>
      
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        {profiles.map(p => (
          <div key={p.id} className="card p-6 text-center">
            <div className="w-20 h-20 rounded-full mx-auto mb-4 flex items-center justify-center" style={{ background: 'var(--surface-hover)', color: 'var(--muted)' }}>
              <User size={40} />
            </div>
            <h3 className="text-xl font-bold" style={{ color: 'var(--foreground)' }}>{p.name}</h3>
            <p className="font-medium mb-4" style={{ color: 'var(--brand-primary)' }}>{p.college}</p>
            <div className="grid grid-cols-2 gap-2 text-sm mb-6 text-left" style={{ color: 'var(--muted)' }}>
              <div className="p-2 rounded" style={{ background: 'var(--surface-hover)' }}><strong style={{ color: 'var(--foreground)' }}>Year:</strong><br/>{p.year}</div>
              <div className="p-2 rounded" style={{ background: 'var(--surface-hover)' }}><strong style={{ color: 'var(--foreground)' }}>Budget:</strong><br/>{p.budget}</div>
              <div className="p-2 rounded" style={{ background: 'var(--surface-hover)' }}><strong style={{ color: 'var(--foreground)' }}>Food:</strong><br/>{p.food}</div>
            </div>
            <button className="w-full flex items-center justify-center gap-2 py-2 rounded transition-colors font-medium hover:bg-brand hover:text-white" style={{ background: 'rgba(108,60,225,0.1)', color: 'var(--brand-primary)' }}>
              <MessageCircle size={18} /> Connect
            </button>
          </div>
        ))}
      </div>
    </div>
  );
}
