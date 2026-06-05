const express = require('express');
const { getProfiles, createProfile } = require('./roommate.controller');
const { protect } = require('../../middleware/auth.middleware');
const router = express.Router();

router.use(protect);
router.get('/', getProfiles);
router.post('/', createProfile);
module.exports = router;
