"use client";

import React, { useState } from 'react';
import { Search, Filter, Check, X, Eye, ExternalLink } from 'lucide-react';

export default function AdminVerificationsPage() {
  const [activeTab, setActiveTab] = useState<'pending' | 'approved' | 'rejected'>('pending');

  // Mock data for UI demonstration
  const [requests, setRequests] = useState([
    {
      id: '1',
      studentName: 'Rahul Sharma',
      collegeEmail: 'rahul.s@du.ac.in',
      collegeName: 'Delhi University',
      status: 'pending',
      submittedAt: '2 hours ago',
      idUrl: 'https://via.placeholder.com/600x400.png?text=Student+ID'
    },
    {
      id: '2',
      studentName: 'Priya Patel',
      collegeEmail: 'priya@nitk.edu.in',
      collegeName: 'NIT Karnataka',
      status: 'pending',
      submittedAt: '5 hours ago',
      idUrl: 'https://via.placeholder.com/600x400.png?text=Student+ID'
    },
    {
      id: '3',
      studentName: 'Amit Kumar',
      collegeEmail: 'amit.k@iitb.ac.in',
      collegeName: 'IIT Bombay',
      status: 'approved',
      submittedAt: '1 day ago',
      idUrl: 'https://via.placeholder.com/600x400.png?text=Student+ID'
    }
  ]);

  const filteredRequests = requests.filter(req => req.status === activeTab);

  const handleAction = (id: string, action: 'approved' | 'rejected') => {
    setRequests(requests.map(req => req.id === id ? { ...req, status: action } : req));
  };

  return (
    <div className="container mx-auto px-4 py-8 max-w-7xl animate-fade-in">
      <div className="flex flex-col md:flex-row justify-between items-start md:items-center mb-8 gap-4">
        <div>
          <h1 className="text-3xl font-bold tracking-tight text-[var(--foreground)]">Student Verifications</h1>
          <p className="text-[var(--muted)] mt-1">Review and manage student identity verifications.</p>
        </div>
      </div>

      <div className="bg-[var(--surface)] border border-[var(--border)] rounded-[var(--radius-xl)] shadow-sm overflow-hidden mb-8">
        
        {/* Tabs and Filters */}
        <div className="flex flex-col sm:flex-row justify-between items-center border-b border-[var(--border)] p-4 gap-4">
          <div className="flex space-x-1 bg-[var(--surface-hover)] p-1 rounded-lg w-full sm:w-auto overflow-x-auto">
            {['pending', 'approved', 'rejected'].map((tab) => (
              <button
                key={tab}
                onClick={() => setActiveTab(tab as any)}
                className={`px-4 py-2 rounded-md text-sm font-medium transition-all capitalize whitespace-nowrap ${
                  activeTab === tab 
                    ? 'bg-[var(--surface)] shadow-sm text-[var(--foreground)]' 
                    : 'text-[var(--muted)] hover:text-[var(--foreground)] hover:bg-[var(--surface)]/50'
                }`}
              >
                {tab} ({requests.filter(r => r.status === tab).length})
              </button>
            ))}
          </div>

          <div className="flex w-full sm:w-auto gap-3">
            <div className="relative w-full sm:w-64">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-[var(--muted)]" size={18} />
              <input 
                type="text" 
                placeholder="Search students..." 
                className="w-full pl-10 pr-4 py-2 text-sm bg-transparent border border-[var(--border)] rounded-lg focus:outline-none focus:ring-2 focus:ring-[var(--brand-primary)]"
              />
            </div>
            <button className="p-2 border border-[var(--border)] rounded-lg hover:bg-[var(--surface-hover)] transition-colors text-[var(--muted)] flex items-center justify-center">
              <Filter size={18} />
            </button>
          </div>
        </div>

        {/* Table */}
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="border-b border-[var(--border)] bg-[var(--surface-hover)]/50 text-sm font-medium text-[var(--muted)]">
                <th className="p-4">Student</th>
                <th className="p-4">College</th>
                <th className="p-4">Submitted</th>
                <th className="p-4">ID Document</th>
                <th className="p-4 text-right">Actions</th>
              </tr>
            </thead>
            <tbody>
              {filteredRequests.length > 0 ? (
                filteredRequests.map((req) => (
                  <tr key={req.id} className="border-b border-[var(--border)] last:border-0 hover:bg-[var(--surface-hover)]/50 transition-colors">
                    <td className="p-4">
                      <div className="font-medium text-[var(--foreground)]">{req.studentName}</div>
                      <div className="text-sm text-[var(--muted)]">{req.collegeEmail}</div>
                    </td>
                    <td className="p-4 text-[var(--foreground)]">{req.collegeName}</td>
                    <td className="p-4 text-[var(--muted)] text-sm">{req.submittedAt}</td>
                    <td className="p-4">
                      <a href={req.idUrl} target="_blank" rel="noreferrer" className="flex items-center gap-2 text-[var(--brand-primary)] text-sm hover:underline font-medium">
                        <Eye size={16} /> View Document
                      </a>
                    </td>
                    <td className="p-4">
                      {req.status === 'pending' ? (
                        <div className="flex items-center justify-end gap-2">
                          <button 
                            onClick={() => handleAction(req.id, 'approved')}
                            className="bg-[var(--success)]/10 text-[var(--success)] hover:bg-[var(--success)] hover:text-white p-2 rounded-lg transition-colors"
                            title="Approve"
                          >
                            <Check size={18} />
                          </button>
                          <button 
                            onClick={() => handleAction(req.id, 'rejected')}
                            className="bg-[var(--danger)]/10 text-[var(--danger)] hover:bg-[var(--danger)] hover:text-white p-2 rounded-lg transition-colors"
                            title="Reject"
                          >
                            <X size={18} />
                          </button>
                        </div>
                      ) : (
                        <div className="flex justify-end">
                          <span className={`px-3 py-1 rounded-full text-xs font-medium capitalize border ${
                            req.status === 'approved' 
                              ? 'bg-[var(--success)]/10 text-[var(--success)] border-[var(--success)]/20' 
                              : 'bg-[var(--danger)]/10 text-[var(--danger)] border-[var(--danger)]/20'
                          }`}>
                            {req.status}
                          </span>
                        </div>
                      )}
                    </td>
                  </tr>
                ))
              ) : (
                <tr>
                  <td colSpan={5} className="p-8 text-center text-[var(--muted)]">
                    No {activeTab} verification requests found.
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
        
      </div>
    </div>
  );
}
