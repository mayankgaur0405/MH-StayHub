'use client';

import { shareViaWhatsApp, copyLink, nativeShare } from '@/lib/share';
import { trackCallOwner, trackWhatsAppOwner } from '@/lib/analytics';
import { useState } from 'react';

interface ShareBarProps {
  slug: string;
  name: string;
  accommodationId: string;
}

export function ShareBar({ slug, name, accommodationId }: ShareBarProps) {
  const [copied, setCopied] = useState(false);

  const handleCopy = async () => {
    const success = await copyLink(slug, accommodationId);
    if (success) {
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    }
  };

  return (
    <div className="flex items-center gap-3">
      <button
        onClick={() => shareViaWhatsApp(slug, name, accommodationId)}
        className="flex items-center gap-2 px-4 py-2 bg-green-500 text-white text-sm font-medium rounded-full hover:bg-green-600 transition-colors"
      >
        <svg className="w-4 h-4" fill="currentColor" viewBox="0 0 24 24"><path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347z"/><path d="M12 0C5.373 0 0 5.373 0 12c0 2.625.846 5.059 2.284 7.034L.789 23.492a.5.5 0 00.612.638l4.682-1.228A11.953 11.953 0 0012 24c6.627 0 12-5.373 12-12S18.627 0 12 0zm0 22c-2.239 0-4.308-.726-5.992-1.957l-.418-.303-2.784.73.744-2.717-.333-.43A9.96 9.96 0 012 12C2 6.486 6.486 2 12 2s10 4.486 10 10-4.486 10-10 10z"/></svg>
        Share
      </button>
      <button
        onClick={handleCopy}
        className="flex items-center gap-2 px-4 py-2 bg-gray-100 text-gray-700 text-sm font-medium rounded-full hover:bg-gray-200 transition-colors"
      >
        📋 {copied ? 'Copied!' : 'Copy Link'}
      </button>
      <button
        onClick={() => nativeShare(slug, name, accommodationId)}
        className="flex items-center gap-2 px-4 py-2 bg-gray-100 text-gray-700 text-sm font-medium rounded-full hover:bg-gray-200 transition-colors"
      >
        📤 Share
      </button>
    </div>
  );
}

interface OwnerActionsProps {
  phone?: string;
  name?: string;
  accommodationId: string;
}

export function OwnerActions({ phone, name, accommodationId }: OwnerActionsProps) {
  if (!phone) return null;

  const handleCall = () => {
    trackCallOwner(accommodationId);
    window.open(`tel:${phone}`);
  };

  const handleWhatsApp = () => {
    trackWhatsAppOwner(accommodationId);
    const text = encodeURIComponent(`Hi ${name || ''}, I found your property on MH StayHub. I'm interested in learning more.`);
    window.open(`https://wa.me/${phone.replace('+', '')}?text=${text}`, '_blank');
  };

  return (
    <div className="flex flex-col sm:flex-row gap-3">
      <button
        onClick={handleCall}
        className="flex-1 flex items-center justify-center gap-2 px-6 py-3 bg-brand text-white font-semibold rounded-xl hover:bg-brand-dark transition-colors shadow-md"
      >
        📞 Call Owner
      </button>
      <button
        onClick={handleWhatsApp}
        className="flex-1 flex items-center justify-center gap-2 px-6 py-3 bg-green-500 text-white font-semibold rounded-xl hover:bg-green-600 transition-colors shadow-md"
      >
        💬 WhatsApp
      </button>
    </div>
  );
}
