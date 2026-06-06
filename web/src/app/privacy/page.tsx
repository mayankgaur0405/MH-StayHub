import { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Privacy Policy',
  description: 'Privacy Policy for MH StayHub',
};

export default function PrivacyPolicy() {
  return (
    <div className="max-w-4xl mx-auto px-4 py-12 sm:px-6 lg:px-8">
      <h1 className="text-3xl font-bold tracking-tight text-foreground sm:text-4xl mb-8">
        Privacy Policy
      </h1>
      
      <div className="prose prose-sm sm:prose-base dark:prose-invert max-w-none space-y-6 text-muted-foreground">
        <p>Last updated: June 2026</p>

        <section>
          <h2 className="text-xl font-semibold text-foreground mt-8 mb-4">1. Information We Collect</h2>
          <p>
            When you use MH StayHub, we may collect the following types of information:
          </p>
          <ul className="list-disc pl-6 mt-2 space-y-2">
            <li><strong>Personal Information:</strong> Name, email address, phone number, and college details when you register.</li>
            <li><strong>Usage Data:</strong> Information about how you use our website and mobile application, including saved properties and search history.</li>
            <li><strong>Device Information:</strong> IP address, browser type, operating system, and mobile device identifiers.</li>
          </ul>
        </section>

        <section>
          <h2 className="text-xl font-semibold text-foreground mt-8 mb-4">2. How We Use Your Information</h2>
          <p>We use the collected information to:</p>
          <ul className="list-disc pl-6 mt-2 space-y-2">
            <li>Provide, maintain, and improve our services.</li>
            <li>Process your accommodation visit requests and priority holds.</li>
            <li>Send you administrative messages, OTPs, and notifications regarding your bookings.</li>
            <li>Respond to your comments, questions, and customer service requests.</li>
          </ul>
        </section>

        <section>
          <h2 className="text-xl font-semibold text-foreground mt-8 mb-4">3. Data Sharing and Disclosure</h2>
          <p>
            We may share your information with:
          </p>
          <ul className="list-disc pl-6 mt-2 space-y-2">
            <li><strong>Property Owners:</strong> When you schedule a visit or hold a property, we share your basic contact info with the property owner/manager.</li>
            <li><strong>Service Providers:</strong> Third-party vendors who provide services like payment processing (Razorpay) and SMS delivery (MSG91).</li>
            <li><strong>Legal Requirements:</strong> If required to do so by law or in the good faith belief that such action is necessary to comply with a legal obligation.</li>
          </ul>
        </section>

        <section>
          <h2 className="text-xl font-semibold text-foreground mt-8 mb-4">4. Security</h2>
          <p>
            We implement industry-standard security measures to protect your personal information. However, no method of transmission over the Internet or electronic storage is 100% secure.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-semibold text-foreground mt-8 mb-4">5. Your Rights</h2>
          <p>
            You have the right to access, update, or delete your personal information. You can do this by logging into your account settings or contacting our support team.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-semibold text-foreground mt-8 mb-4">6. Contact Us</h2>
          <p>
            If you have any questions about this Privacy Policy, please contact us at:
            <br />
            Email: privacy@mhstayhub.com
          </p>
        </section>
      </div>
    </div>
  );
}
