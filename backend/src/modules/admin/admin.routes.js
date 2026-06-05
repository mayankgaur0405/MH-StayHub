const express = require('express');
const { getVerifications, approveVerification, rejectVerification } = require('./admin.controller');
const { protect, authorize } = require('../../middleware/auth.middleware');

const router = express.Router();

// Apply middleware to all routes in this router
router.use(protect);
router.use(authorize('admin', 'owner'));

router.get('/verifications', getVerifications);
router.put('/verifications/:id/approve', approveVerification);
router.put('/verifications/:id/reject', rejectVerification);

module.exports = router;
