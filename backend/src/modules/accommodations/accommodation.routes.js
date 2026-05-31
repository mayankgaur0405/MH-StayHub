const express = require('express');
const { getAccommodations, getAccommodationById } = require('./accommodation.controller');

const router = express.Router();

router.route('/').get(getAccommodations);
router.route('/:id').get(getAccommodationById);

module.exports = router;
