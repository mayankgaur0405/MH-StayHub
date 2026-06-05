"use client";

import React, { useState } from 'react';
import { UploadCloud, CheckCircle2, AlertCircle } from 'lucide-react';
import Link from 'next/link';

export default function VerificationPage() {
  const [file, setFile] = useState<File | null>(null);
  const [email, setEmail] = useState('');
  const [college, setCollege] = useState('');
  const [status, setStatus] = useState<'idle' | 'submitting' | 'success' | 'error'>('idle');

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files && e.target.files[0]) {
      setFile(e.target.files[0]);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!file || !email || !college) return;
    
    setStatus('submitting');
    
    // Simulate API call
    setTimeout(() => {
      setStatus('success');
    }, 2000);
  };

  return (
    <div className="container mx-auto px-4 py-12 max-w-3xl animate-fade-in">
      <div className="text-center mb-10">
        <h1 className="text-4xl font-bold tracking-tight mb-4">Student Verification</h1>
        <p className="text-[var(--muted)] text-lg max-w-2xl mx-auto">
          Verify your student status to unlock exclusive discounts, career opportunities, and premium features on MH StayHub.
        </p>
      </div>

      <div className="bg-[var(--surface)] border border-[var(--border)] rounded-[var(--radius-xl)] shadow-lg overflow-hidden">
        {status === 'success' ? (
          <div className="p-12 text-center flex flex-col items-center">
            <div className="w-20 h-20 bg-[var(--success)]/10 text-[var(--success)] rounded-full flex items-center justify-center mb-6">
              <CheckCircle2 size={40} />
            </div>
            <h2 className="text-2xl font-bold mb-2">Verification Submitted!</h2>
            <p className="text-[var(--muted)] mb-8 max-w-md mx-auto">
              Your student ID has been successfully submitted. Our team will review it within 24-48 hours. You'll receive a notification once verified.
            </p>
            <Link 
              href="/student-command-center" 
              className="bg-[var(--brand-primary)] hover:bg-[var(--brand-primary-dark)] text-white px-8 py-3 rounded-[var(--radius-md)] font-medium transition-colors"
            >
              Go to Command Center
            </Link>
          </div>
        ) : (
          <form onSubmit={handleSubmit} className="p-8 md:p-10">
            <div className="space-y-6">
              
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                  <label htmlFor="college" className="block text-sm font-medium mb-2 text-[var(--foreground)]">College/University Name</label>
                  <input 
                    type="text" 
                    id="college"
                    value={college}
                    onChange={(e) => setCollege(e.target.value)}
                    className="w-full px-4 py-3 rounded-[var(--radius-md)] border border-[var(--border)] bg-transparent focus:outline-none focus:ring-2 focus:ring-[var(--brand-primary)] focus:border-transparent transition-all"
                    placeholder="e.g. Delhi University"
                    required
                  />
                </div>
                <div>
                  <label htmlFor="email" className="block text-sm font-medium mb-2 text-[var(--foreground)]">College Email Address</label>
                  <input 
                    type="email" 
                    id="email"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    className="w-full px-4 py-3 rounded-[var(--radius-md)] border border-[var(--border)] bg-transparent focus:outline-none focus:ring-2 focus:ring-[var(--brand-primary)] focus:border-transparent transition-all"
                    placeholder="student@college.edu.in"
                    required
                  />
                </div>
              </div>

              <div>
                <label className="block text-sm font-medium mb-2 text-[var(--foreground)]">Upload Student ID Card</label>
                <div className="mt-1 flex justify-center px-6 pt-10 pb-12 border-2 border-[var(--border)] border-dashed rounded-[var(--radius-lg)] hover:bg-[var(--surface-hover)] transition-colors group cursor-pointer relative">
                  <input 
                    type="file" 
                    className="absolute inset-0 w-full h-full opacity-0 cursor-pointer" 
                    accept="image/jpeg,image/png,application/pdf"
                    onChange={handleFileChange}
                    required
                  />
                  <div className="space-y-2 text-center pointer-events-none">
                    <div className="mx-auto flex justify-center text-[var(--muted)] group-hover:text-[var(--brand-primary)] transition-colors">
                      <UploadCloud size={48} />
                    </div>
                    <div className="text-sm text-[var(--foreground)]">
                      {file ? (
                        <span className="font-semibold text-[var(--brand-primary)]">{file.name}</span>
                      ) : (
                        <>
                          <span className="font-semibold text-[var(--brand-primary)]">Click to upload</span> or drag and drop
                        </>
                      )}
                    </div>
                    <p className="text-xs text-[var(--muted)]">
                      PNG, JPG, PDF up to 5MB
                    </p>
                  </div>
                </div>
              </div>

              <div className="bg-[var(--info)]/5 border border-[var(--info)]/20 rounded-[var(--radius-md)] p-4 flex gap-3">
                <AlertCircle className="text-[var(--info)] shrink-0 mt-0.5" size={18} />
                <p className="text-sm text-[var(--muted)]">
                  Make sure your name, college name, and valid academic year are clearly visible in the uploaded document.
                </p>
              </div>

              <button 
                type="submit" 
                disabled={status === 'submitting' || !file || !email || !college}
                className="w-full bg-[var(--brand-primary)] hover:bg-[var(--brand-primary-dark)] text-white py-4 rounded-[var(--radius-md)] font-semibold transition-all disabled:opacity-70 disabled:cursor-not-allowed flex justify-center items-center gap-2"
              >
                {status === 'submitting' ? (
                  <>
                    <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin"></div>
                    Submitting...
                  </>
                ) : 'Submit Verification'}
              </button>

            </div>
          </form>
        )}
      </div>
    </div>
  );
}
