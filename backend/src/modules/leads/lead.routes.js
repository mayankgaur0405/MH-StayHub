const express = require('express');
const { createLead, getMyLeads } = require('./lead.controller');
const { protect } = require('../../middleware/auth.middleware');

const router = express.Router();

router.route('/')
  .post(protect, createLead);

router.get('/my-leads', protect, getMyLeads);

module.exports = router;
