import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Contact Us',
  description: 'Get in touch with MH StayHub. We\'re here to help students find the perfect accommodation and help owners list their properties.',
};

export default function ContactPage() {
  return (
    <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-12 sm:py-20">
      <h1 className="text-3xl sm:text-4xl font-extrabold text-foreground mb-3">
        Get in <span className="text-brand">Touch</span>
      </h1>
      <p className="text-muted text-lg mb-12 max-w-xl">
        Have a question, want to list your property, or need support? We&apos;d love to hear from you.
      </p>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-12">
        {/* Contact Info */}
        <div className="space-y-8">
          <div>
            <h2 className="text-sm font-semibold text-foreground uppercase tracking-wider mb-4">For Students</h2>
            <p className="text-muted text-sm leading-relaxed">
              Need help finding a place? Have trouble with a listing? Reach out and we&apos;ll assist you personally.
            </p>
          </div>

          <div>
            <h2 className="text-sm font-semibold text-foreground uppercase tracking-wider mb-4">For Property Owners</h2>
            <p className="text-muted text-sm leading-relaxed">
              Want to list your hostel, PG, or co-living space? We onboard properties for free. Contact us to get started.
            </p>
          </div>

          <div className="space-y-4 pt-4">
            <div className="flex items-center gap-4">
              <div className="w-10 h-10 rounded-xl bg-brand/10 flex items-center justify-center text-lg">📧</div>
              <div>
                <p className="text-xs text-muted">Email</p>
                <p className="text-sm font-medium text-foreground">support@mhstayhub.com</p>
              </div>
            </div>
            <div className="flex items-center gap-4">
              <div className="w-10 h-10 rounded-xl bg-brand/10 flex items-center justify-center text-lg">📱</div>
              <div>
                <p className="text-xs text-muted">Phone / WhatsApp</p>
                <p className="text-sm font-medium text-foreground">+91-XXXXXXXXXX</p>
              </div>
            </div>
            <div className="flex items-center gap-4">
              <div className="w-10 h-10 rounded-xl bg-brand/10 flex items-center justify-center text-lg">📍</div>
              <div>
                <p className="text-xs text-muted">Location</p>
                <p className="text-sm font-medium text-foreground">Greater Noida, Uttar Pradesh, India</p>
              </div>
            </div>
          </div>
        </div>

        {/* Contact Form */}
        <div className="bg-white rounded-2xl border border-border shadow-lg p-6 sm:p-8">
          <h2 className="text-lg font-bold text-foreground mb-6">Send us a Message</h2>
          <form className="space-y-5">
            <div>
              <label className="block text-sm font-medium text-foreground mb-1.5" htmlFor="contact-name">
                Name
              </label>
              <input
                id="contact-name"
                type="text"
                placeholder="Your name"
                className="w-full px-4 py-3 rounded-xl border border-border text-sm focus:outline-none focus:ring-2 focus:ring-brand/30 focus:border-brand transition"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-foreground mb-1.5" htmlFor="contact-phone">
                Phone
              </label>
              <input
                id="contact-phone"
                type="tel"
                placeholder="+91 XXXXX XXXXX"
                className="w-full px-4 py-3 rounded-xl border border-border text-sm focus:outline-none focus:ring-2 focus:ring-brand/30 focus:border-brand transition"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-foreground mb-1.5" htmlFor="contact-message">
                Message
              </label>
              <textarea
                id="contact-message"
                rows={4}
                placeholder="How can we help?"
                className="w-full px-4 py-3 rounded-xl border border-border text-sm focus:outline-none focus:ring-2 focus:ring-brand/30 focus:border-brand transition resize-none"
              />
            </div>
            <button
              type="submit"
              className="w-full py-3 bg-brand text-white font-semibold rounded-xl hover:bg-brand-dark transition-colors shadow-md"
            >
              Send Message
            </button>
          </form>
        </div>
      </div>
    </div>
  );
}
