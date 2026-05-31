const express = require('express');
const { getColleges, getCollegeById } = require('./college.controller');

const router = express.Router();

router.route('/').get(getColleges);
router.route('/:id').get(getCollegeById);

module.exports = router;
