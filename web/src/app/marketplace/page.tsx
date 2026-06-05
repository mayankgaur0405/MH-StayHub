"use client";

import React from 'react';
import { ShoppingBag, Tag } from 'lucide-react';

export default function MarketplacePage() {
  return (
    <div className="container mx-auto px-4 py-8 max-w-7xl animate-fade-in" style={{ background: 'var(--background)' }}>
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center mb-8 gap-4">
        <div>
          <h1 className="text-3xl font-bold mb-2" style={{ color: 'var(--foreground)' }}>Student Marketplace</h1>
          <p style={{ color: 'var(--muted)' }}>Buy and sell books, cycles, and furniture within the campus.</p>
        </div>
        <button className="px-6 py-2 bg-brand text-white rounded-lg hover:bg-brand-dark transition-colors flex items-center gap-2">
          <Tag size={18} /> Sell Item
        </button>
      </div>

      <div className="text-center py-20 card">
        <ShoppingBag className="mx-auto mb-4" size={48} style={{ color: 'var(--muted)' }} />
        <h2 className="text-xl font-medium" style={{ color: 'var(--foreground)' }}>Marketplace is currently empty</h2>
        <p className="mt-2" style={{ color: 'var(--muted)' }}>Be the first to list an item for sale!</p>
      </div>
    </div>
  );
}
