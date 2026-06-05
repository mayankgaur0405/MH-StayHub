import React from 'react';
import { Plus } from 'lucide-react';

export default function AdminEventsPage() {
  return (
    <div className="container mx-auto px-4 py-8 max-w-7xl animate-fade-in">
      <div className="flex justify-between items-center mb-8">
        <div>
          <h1 className="text-3xl font-bold mb-2">Manage Events</h1>
          <p className="text-[var(--muted)]">Schedule and manage Career Hub events.</p>
        </div>
        <button className="px-4 py-2 bg-[var(--brand-primary)] text-white rounded-lg flex items-center gap-2">
          <Plus size={18} /> Create Event
        </button>
      </div>
      <div className="bg-[var(--surface)] border border-[var(--border)] rounded-[var(--radius-lg)] p-8 text-center text-[var(--muted)]">
        Event management table will be rendered here.
      </div>
    </div>
  );
}
