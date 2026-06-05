const express = require('express');
const { getEvents, registerForEvent } = require('./event.controller');
const { protect } = require('../../middleware/auth.middleware');
const router = express.Router();

router.use(protect);
router.get('/', getEvents);
router.post('/:id/register', registerForEvent);
module.exports = router;
