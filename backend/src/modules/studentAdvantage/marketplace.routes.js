const express = require('express');
const { getItems, createItem } = require('./marketplace.controller');
const { protect } = require('../../middleware/auth.middleware');
const upload = require('../../middleware/upload.middleware');
const router = express.Router();

router.use(protect);
router.get('/', getItems);
router.post('/', upload.array('images', 3), createItem);
module.exports = router;
