const Razorpay = require('razorpay');
const crypto = require('crypto');
const Payment = require('./payment.model');
const Lead = require('../leads/lead.model');

const isRazorpayConfigured = Boolean(
  process.env.RAZORPAY_KEY_ID && process.env.RAZORPAY_KEY_SECRET
);

const razorpay = isRazorpayConfigured
  ? new Razorpay({
      key_id: process.env.RAZORPAY_KEY_ID,
      key_secret: process.env.RAZORPAY_KEY_SECRET,
    })
  : null;

const PRIORITY_HOLD_AMOUNT = 99; // MVP amount in INR
const PAYMENT_NOT_CONFIGURED_MESSAGE = 'Payment service not configured';

const sendPaymentNotConfigured = (res) => {
  return res.status(503).json({
    success: false,
    message: PAYMENT_NOT_CONFIGURED_MESSAGE,
  });
};

const createOrder = async (req, res) => {
  try {
    if (!isRazorpayConfigured) {
      return sendPaymentNotConfigured(res);
    }

    const { accommodationId } = req.body;
    if (!accommodationId) {
      return res.status(400).json({ success: false, message: 'Accommodation ID is required' });
    }

    const options = {
      amount: PRIORITY_HOLD_AMOUNT * 100, // amount in the smallest currency unit
      currency: 'INR',
      receipt: `receipt_order_${Date.now()}`,
    };

    const order = await razorpay.orders.create(options);

    if (!order) {
      return res.status(500).json({ success: false, message: 'Failed to create Razorpay order' });
    }

    const payment = await Payment.create({
      orderId: order.id,
      amount: PRIORITY_HOLD_AMOUNT,
      user: req.user._id,
      accommodation: accommodationId,
      status: 'pending'
    });

    res.status(200).json({
      success: true,
      data: {
        orderId: order.id,
        amount: order.amount,
        currency: order.currency,
      }
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

const verifyPayment = async (req, res) => {
  try {
    if (!isRazorpayConfigured) {
      return sendPaymentNotConfigured(res);
    }

    const { razorpay_order_id, razorpay_payment_id, razorpay_signature } = req.body;

    if (!razorpay_order_id || !razorpay_payment_id || !razorpay_signature) {
      return res.status(400).json({ success: false, message: 'Missing payment details' });
    }

    // 1. Fetch payment record
    const payment = await Payment.findOne({ orderId: razorpay_order_id });
    if (!payment) {
      return res.status(404).json({ success: false, message: 'Payment order not found' });
    }

    // 2. Make it idempotent
    if (payment.status === 'paid') {
      return res.status(200).json({ success: true, message: 'Payment already verified successfully' });
    }

    // 3. Verify Signature
    const body = razorpay_order_id + '|' + razorpay_payment_id;
    const expectedSignature = crypto.createHmac('sha256', process.env.RAZORPAY_KEY_SECRET)
                                    .update(body.toString())
                                    .digest('hex');

    if (expectedSignature !== razorpay_signature) {
      payment.status = 'failed';
      await payment.save();
      return res.status(400).json({ success: false, message: 'Invalid signature' });
    }

    // 4. Update Payment status
    payment.paymentId = razorpay_payment_id;
    payment.signature = razorpay_signature;
    payment.status = 'paid';
    await payment.save();

    // 5. Create/Update Lead as priority token_booking
    await Lead.findOneAndUpdate(
      { studentId: payment.user, accommodation: payment.accommodation },
      { 
        type: 'token_booking', 
        status: 'pending_owner_approval',
        source: 'app',
        payment: {
          amount: payment.amount,
          transactionId: payment.paymentId,
          status: 'success'
        }
      },
      { upsert: true, new: true }
    );

    // 6. Send Email Notifications
    const { sendEmail } = require('../../utils/email.service');
    const User = require('../users/user.model');
    const Accommodation = require('../accommodations/accommodation.model');
    
    const user = await User.findById(payment.user);
    const accommodation = await Accommodation.findById(payment.accommodation);

    if (user && accommodation) {
      const emailHtml = `
        <h2>Priority Hold Confirmed!</h2>
        <p>Hi ${user.name},</p>
        <p>We have successfully received your priority hold payment of ₹${payment.amount} for <strong>${accommodation.name}</strong>.</p>
        <p><strong>Order ID:</strong> ${razorpay_order_id}<br/>
        <strong>Transaction ID:</strong> ${razorpay_payment_id}</p>
        <p>The property manager will contact you shortly to confirm the next steps. Thank you for choosing MH StayHub!</p>
      `;
      
      // Send to User (if email exists)
      if (user.email) {
        await sendEmail({ to: user.email, subject: 'MH StayHub - Payment Receipt', html: emailHtml });
      }

      // Always send to Admin
      await sendEmail({ to: 'bookings@mhstayhub.com', subject: `New Priority Hold: ${accommodation.name}`, html: emailHtml });
    }

    res.status(200).json({ success: true, message: 'Payment verified successfully' });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Webhook endpoint preparation for future use
const webhookVerification = async (req, res) => {
  try {
    if (!process.env.RAZORPAY_WEBHOOK_SECRET) {
      return sendPaymentNotConfigured(res);
    }

    const secret = process.env.RAZORPAY_WEBHOOK_SECRET;
    const signature = req.headers['x-razorpay-signature'];
    
    const isValid = crypto.createHmac('sha256', secret)
                          .update(JSON.stringify(req.body))
                          .digest('hex') === signature;

    if (!isValid) return res.status(400).send('Invalid Signature');

    // Handle webhook event...
    res.status(200).json({ success: true });
  } catch (error) {
    res.status(500).send('Webhook Error');
  }
};

const getHistory = async (req, res) => {
  try {
    const payments = await Payment.find({ user: req.user._id })
      .populate('accommodation', 'name images')
      .sort({ createdAt: -1 });

    res.status(200).json({ success: true, data: payments });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

module.exports = { createOrder, verifyPayment, getHistory, webhookVerification };
