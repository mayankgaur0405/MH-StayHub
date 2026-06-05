const express = require('express');
const { getQueries, createQuery, addReply } = require('./seniorConnect.controller');
const { protect } = require('../../middleware/auth.middleware');
const router = express.Router();

router.use(protect);
router.get('/', getQueries);
router.post('/', createQuery);
router.post('/:id/reply', addReply);
module.exports = router;
