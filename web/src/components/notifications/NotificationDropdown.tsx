"use client";

import React, { useState } from 'react';
import { Bell, CheckCircle, Ticket, Calendar, Info } from 'lucide-react';
import Link from 'next/link';

export default function NotificationDropdown() {
  const [isOpen, setIsOpen] = useState(false);
  
  // Mock notifications
  const [notifications, setNotifications] = useState([
    {
      id: 1,
      title: 'Verification Approved',
      message: 'Congratulations! Your student verification has been approved.',
      type: 'verification',
      isRead: false,
      time: '1h ago'
    },
    {
      id: 2,
      title: 'New Coupon Available',
      message: 'Get 20% off on study materials at our partner store.',
      type: 'coupon',
      isRead: true,
      time: '1d ago'
    }
  ]);

  const unreadCount = notifications.filter(n => !n.isRead).length;

  const markAllAsRead = () => {
    setNotifications(notifications.map(n => ({ ...n, isRead: true })));
  };

  const getIcon = (type: string) => {
    switch (type) {
      case 'verification': return <CheckCircle className="text-[var(--success)]" size={20} />;
      case 'coupon': return <Ticket className="text-[var(--brand-primary)]" size={20} />;
      case 'event': return <Calendar className="text-[var(--secondary)]" size={20} />;
      default: return <Info className="text-[var(--info)]" size={20} />;
    }
  };

  return (
    <div className="relative">
      <button 
        onClick={() => setIsOpen(!isOpen)}
        className="relative p-2 text-[var(--muted)] hover:text-[var(--foreground)] transition-colors rounded-full hover:bg-[var(--surface-hover)]"
      >
        <Bell size={22} />
        {unreadCount > 0 && (
          <span className="absolute top-1 right-1 w-2.5 h-2.5 bg-[var(--danger)] rounded-full ring-2 ring-white dark:ring-[var(--background)]"></span>
        )}
      </button>

      {isOpen && (
        <div className="absolute right-0 mt-2 w-80 sm:w-96 bg-[var(--surface)] border border-[var(--border)] rounded-[var(--radius-lg)] shadow-xl z-50 overflow-hidden animate-fade-in">
          <div className="p-4 border-b border-[var(--border)] flex justify-between items-center bg-[var(--surface-hover)]/30">
            <h3 className="font-semibold text-[var(--foreground)]">Notifications</h3>
            {unreadCount > 0 && (
              <button 
                onClick={markAllAsRead}
                className="text-xs text-[var(--brand-primary)] hover:underline font-medium"
              >
                Mark all as read
              </button>
            )}
          </div>
          
          <div className="max-h-[400px] overflow-y-auto">
            {notifications.length > 0 ? (
              notifications.map((notification) => (
                <div 
                  key={notification.id} 
                  className={`p-4 border-b border-[var(--border)] last:border-0 hover:bg-[var(--surface-hover)] transition-colors cursor-pointer flex gap-3 ${!notification.isRead ? 'bg-[var(--brand-primary)]/5' : ''}`}
                >
                  <div className="shrink-0 mt-1">
                    {getIcon(notification.type)}
                  </div>
                  <div>
                    <h4 className={`text-sm font-medium ${!notification.isRead ? 'text-[var(--foreground)]' : 'text-[var(--foreground)]/80'}`}>
                      {notification.title}
                    </h4>
                    <p className="text-xs text-[var(--muted)] mt-1">{notification.message}</p>
                    <span className="text-[10px] text-[var(--muted)]/80 mt-2 block font-medium">{notification.time}</span>
                  </div>
                  {!notification.isRead && (
                    <div className="w-2 h-2 bg-[var(--brand-primary)] rounded-full shrink-0 mt-2"></div>
                  )}
                </div>
              ))
            ) : (
              <div className="p-8 text-center text-[var(--muted)]">
                <Bell className="mx-auto mb-3 opacity-20" size={32} />
                <p>No new notifications</p>
              </div>
            )}
          </div>
          
          <div className="p-3 border-t border-[var(--border)] text-center bg-[var(--surface-hover)]/30">
            <Link href="/student-command-center" className="text-sm font-medium text-[var(--brand-primary)] hover:underline">
              View all in Command Center
            </Link>
          </div>
        </div>
      )}
    </div>
  );
}
