const express = require('express');
const { 
  register, 
  login, 
  verifyOTP, 
  requestPasswordReset, 
  resetPassword, 
<<<<<<< HEAD
  completeRegistration,
=======
>>>>>>> a350889d6733f71c4c47a9c38140f3906a9dbc12
  changeDevice,
  requestPhoneLogin,
  verifyPhoneLogin,
  verifyDeviceChange
} = require('../controllers/auth.controller');
const { authenticate } = require('../middleware/auth.middleware');

const router = express.Router();
<<<<<<< HEAD
router.post('/complete-registration', completeRegistration);
=======

>>>>>>> a350889d6733f71c4c47a9c38140f3906a9dbc12
router.post('/verify-otp', verifyOTP);
router.post('/register', register);
router.post('/login', login);
router.post('/request-password-reset', requestPasswordReset);
router.post('/reset-password', resetPassword);
router.post('/change-device', authenticate, changeDevice);
router.post('/verify-device-change', authenticate, verifyDeviceChange);
router.post('/request-phone-login', requestPhoneLogin);
router.post('/verify-phone-login', verifyPhoneLogin);

module.exports = router;