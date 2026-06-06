import { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Terms & Conditions',
  description: 'Terms and Conditions for MH StayHub',
};

export default function TermsAndConditions() {
  return (
    <div className="max-w-4xl mx-auto px-4 py-12 sm:px-6 lg:px-8">
      <h1 className="text-3xl font-bold tracking-tight text-foreground sm:text-4xl mb-8">
        Terms & Conditions
      </h1>
      
      <div className="prose prose-sm sm:prose-base dark:prose-invert max-w-none space-y-6 text-muted-foreground">
        <p>Last updated: June 2026</p>

        <section>
          <h2 className="text-xl font-semibold text-foreground mt-8 mb-4">1. Acceptance of Terms</h2>
          <p>
            By accessing or using the MH StayHub website and mobile application, you agree to be bound by these Terms & Conditions. If you disagree with any part of the terms, you may not access our services.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-semibold text-foreground mt-8 mb-4">2. Description of Service</h2>
          <p>
            MH StayHub provides a platform connecting students with accommodation providers (hostels, PGs, co-living spaces). We facilitate discovery, scheduling visits, and processing priority hold payments.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-semibold text-foreground mt-8 mb-4">3. User Responsibilities</h2>
          <ul className="list-disc pl-6 mt-2 space-y-2">
            <li>You must provide accurate and complete information when creating an account.</li>
            <li>You are responsible for safeguarding the password and OTPs you use to access the service.</li>
            <li>You agree not to use the service for any illegal or unauthorized purpose.</li>
          </ul>
        </section>

        <section>
          <h2 className="text-xl font-semibold text-foreground mt-8 mb-4">4. Property Listings and Accuracy</h2>
          <p>
            While we strive to verify properties marked as "Verified" or "Premium Verified", we do not guarantee the absolute accuracy of photos, amenities, or pricing. Users are encouraged to schedule a physical visit before making long-term commitments.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-semibold text-foreground mt-8 mb-4">5. Payments and Priority Holds</h2>
          <ul className="list-disc pl-6 mt-2 space-y-2">
            <li>Priority hold payments are processed securely via third-party gateways (e.g., Razorpay).</li>
            <li>Hold amounts and refund policies vary by property owner. Please review the specific cancellation policy before paying.</li>
            <li>MH StayHub is not responsible for disputes regarding rent, deposits, or refunds between the student and the property owner.</li>
          </ul>
        </section>

        <section>
          <h2 className="text-xl font-semibold text-foreground mt-8 mb-4">6. Limitation of Liability</h2>
          <p>
            In no event shall MH StayHub, nor its directors, employees, or partners, be liable for any indirect, incidental, special, consequential or punitive damages resulting from your use of the service or interactions with property owners.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-semibold text-foreground mt-8 mb-4">7. Contact Us</h2>
          <p>
            If you have any questions about these Terms, please contact us at:
            <br />
            Email: legal@mhstayhub.com
          </p>
        </section>
      </div>
    </div>
  );
}
