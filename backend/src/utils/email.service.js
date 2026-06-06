const { Resend } = require('resend');

const resend = new Resend(process.env.RESEND_API_KEY);

const isResendConfigured = Boolean(process.env.RESEND_API_KEY);

const sendEmail = async ({ to, subject, html }) => {
  if (!process.env.RESEND_API_KEY) {
    throw new Error('RESEND_API_KEY is not configured');
  }

  try {
    const data = await resend.emails.send({
      from: 'MH StayHub <onboarding@resend.dev>',
      to,
      subject,
      html,
    });
    return { success: true, data };
  } catch (error) {
    console.error('Error sending email via Resend:', error);
    return { success: false, error };
  }
};

module.exports = { sendEmail };
