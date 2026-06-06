'use client';

import { useState } from 'react';
import { API_BASE_URL } from '@/constants';

interface RazorpayCheckoutButtonProps {
  accommodationId: string;
  accommodationName: string;
  amount: number;
  // In a real app with auth, you'd pull the token from context/storage
  token?: string; 
}

export default function RazorpayCheckoutButton({ accommodationId, accommodationName, amount, token }: RazorpayCheckoutButtonProps) {
  const [loading, setLoading] = useState(false);

  const loadRazorpayScript = () => {
    return new Promise((resolve) => {
      const script = document.createElement('script');
      script.src = 'https://checkout.razorpay.com/v1/checkout.js';
      script.onload = () => {
        resolve(true);
      };
      script.onerror = () => {
        resolve(false);
      };
      document.body.appendChild(script);
    });
  };

  const handlePayment = async () => {
    // Web currently does not have auth state. We direct users to the app for secure payments.
    alert('To secure your Priority Hold, please download the MH StayHub app and complete the payment securely.');
  };

  return (
    <button
      onClick={handlePayment}
      disabled={loading}
      className="block w-full text-center px-6 py-3 bg-accent text-white font-semibold rounded-xl hover:opacity-90 transition-opacity shadow-md disabled:opacity-50"
    >
      {loading ? 'Processing...' : '💳 Priority Hold (₹99)'}
    </button>
  );
}
