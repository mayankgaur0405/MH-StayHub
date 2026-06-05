"use client";

import React from 'react';
import { Ticket } from 'lucide-react';

export default function StudentAdvantagePage() {
  const coupons = [
    { id: 1, partner: "Domino's Pizza", desc: "50% off on all pizzas", expiry: "2026-12-31" },
    { id: 2, partner: "Lenskart", desc: "Buy 1 Get 1 Free for Students", expiry: "2026-10-15" }
  ];

  return (
    <div className="container mx-auto px-4 py-8 max-w-7xl animate-fade-in" style={{ background: 'var(--background)' }}>
      <h1 className="text-3xl font-bold mb-2" style={{ color: 'var(--foreground)' }}>Student Advantage</h1>
      <p className="mb-8" style={{ color: 'var(--muted)' }}>Exclusive deals and coupons for verified students.</p>
      
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {coupons.map(c => (
          <div key={c.id} className="card p-6 flex flex-col justify-between">
            <div>
              <div className="w-12 h-12 rounded-full flex items-center justify-center mb-4" style={{ background: 'rgba(108,60,225,0.1)', color: 'var(--brand-primary)' }}>
                <Ticket size={24} />
              </div>
              <h3 className="text-xl font-bold mb-1" style={{ color: 'var(--foreground)' }}>{c.partner}</h3>
              <p style={{ color: 'var(--muted)' }}>{c.desc}</p>
              <p className="text-xs mt-4" style={{ color: 'var(--danger)' }}>Expires: {c.expiry}</p>
            </div>
            <button className="mt-6 w-full py-2 border rounded-lg hover:bg-brand hover:border-brand hover:text-white transition-colors font-medium" style={{ borderColor: 'var(--border)', color: 'var(--foreground)', background: 'var(--surface-hover)' }}>
              Redeem Code
            </button>
          </div>
        ))}
      </div>
    </div>
  );
}
