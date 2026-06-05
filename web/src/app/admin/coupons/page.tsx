import React from 'react';
import { Plus } from 'lucide-react';

export default function AdminCouponsPage() {
  return (
    <div className="container mx-auto px-4 py-8 max-w-7xl animate-fade-in">
      <div className="flex justify-between items-center mb-8">
        <div>
          <h1 className="text-3xl font-bold mb-2">Manage Coupons</h1>
          <p className="text-[var(--muted)]">Add and edit Student Advantage coupons.</p>
        </div>
        <button className="px-4 py-2 bg-[var(--brand-primary)] text-white rounded-lg flex items-center gap-2">
          <Plus size={18} /> Add Coupon
        </button>
      </div>
      <div className="bg-[var(--surface)] border border-[var(--border)] rounded-[var(--radius-lg)] p-8 text-center text-[var(--muted)]">
        Coupon management table will be rendered here.
      </div>
    </div>
  );
}
