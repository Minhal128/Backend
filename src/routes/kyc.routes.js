const express = require('express');
<<<<<<< HEAD
const kycController = require('../controllers/kyc.controller');
const { authenticate, authorize } = require('../middleware/auth.middleware');
=======
const { submitKYC, getKYCStatus } = require('../controllers/kyc.controller');
const { authenticate } = require('../middleware/auth.middleware');
>>>>>>> a350889d6733f71c4c47a9c38140f3906a9dbc12
const { uploadKYCDocs } = require('../middleware/upload.middleware');

const router = express.Router();

router.use(authenticate);

<<<<<<< HEAD
router.post('/submit', uploadKYCDocs, kycController.submitKYC);
router.get('/status', kycController.getKYCStatus);
router.post('/review', authorize('admin'), kycController.reviewKYC);
=======
router.post('/submit', uploadKYCDocs, submitKYC);
router.get('/status', getKYCStatus);
>>>>>>> a350889d6733f71c4c47a9c38140f3906a9dbc12

module.exports = router;