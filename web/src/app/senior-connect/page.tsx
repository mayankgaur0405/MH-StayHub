import React from 'react';
import { HelpCircle, MessagesSquare } from 'lucide-react';

export default function SeniorConnectPage() {
  const queries = [
    { id: 1, title: "How to prepare for off-campus placements?", author: "Priya P.", status: "answered", replies: 3 },
    { id: 2, title: "Looking for referral at Amazon", author: "Rahul S.", status: "open", replies: 0 }
  ];

  return (
    <div className="container mx-auto px-4 py-8 max-w-7xl animate-fade-in">
      <div className="flex justify-between items-center mb-8">
        <div>
          <h1 className="text-3xl font-bold mb-2">Senior Connect</h1>
          <p className="text-[var(--muted)]">Ask seniors for guidance, referrals, and academic help.</p>
        </div>
        <button className="px-6 py-2 bg-[var(--brand-primary)] text-white rounded-lg hover:bg-[var(--brand-primary-dark)] transition-colors flex items-center gap-2">
          <HelpCircle size={18} /> Ask Question
        </button>
      </div>

      <div className="space-y-4">
        {queries.map(q => (
          <div key={q.id} className="bg-[var(--surface)] border border-[var(--border)] rounded-[var(--radius-lg)] p-6 shadow-sm hover:border-[var(--brand-primary)] transition-colors cursor-pointer flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
            <div>
              <div className="flex items-center gap-3 mb-2">
                <span className={`px-2.5 py-0.5 rounded-full text-xs font-medium capitalize ${q.status === 'answered' ? 'bg-[var(--success)]/10 text-[var(--success)]' : 'bg-[var(--info)]/10 text-[var(--info)]'}`}>
                  {q.status}
                </span>
                <span className="text-sm text-[var(--muted)]">Posted by {q.author}</span>
              </div>
              <h3 className="text-lg font-semibold">{q.title}</h3>
            </div>
            <div className="flex items-center gap-2 text-[var(--muted)] bg-[var(--surface-hover)] px-4 py-2 rounded-lg">
              <MessagesSquare size={18} />
              <span>{q.replies} Replies</span>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
