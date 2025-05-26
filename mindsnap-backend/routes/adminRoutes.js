const express = require('express');
const router = express.Router();
const adminController = require('../controllers/adminController');
const { verifyToken, requireAdmin } = require('../middleware/authMiddleware');

router.get('/users', verifyToken, requireAdmin, adminController.getAllUsers);
router.delete('/users/:id', verifyToken, requireAdmin, adminController.deleteUser);
router.put('/users/:id/role', verifyToken, requireAdmin, adminController.updateUserRole);

module.exports = router;
