const jwt = require('jsonwebtoken');
const User = require('../modules/users/user.model');

const protect = async (req, res, next) => {
  let token;
  if (req.headers.authorization && req.headers.authorization.startsWith('Bearer')) {
    try {
      token = req.headers.authorization.split(' ')[1];
      const decoded = jwt.verify(token, process.env.JWT_SECRET || 'fallback_secret');
      req.user = await User.findById(decoded.id);
      
      if (!req.user) {
        return res.status(401).json({ message: 'Not authorized, user not found', success: false });
      }
      next();
    } catch (error) {
      return res.status(401).json({ message: 'Not authorized, token failed', success: false });
    }
  } else {
    return res.status(401).json({ message: 'Not authorized, no token', success: false });
  }
};

const authorize = (...roles) => {
  return (req, res, next) => {
    if (!req.user || !roles.includes(req.user.role)) {
      return res.status(403).json({
        success: false,
        message: `User role is not authorized to access this route`,
      });
    }
    next();
  };
};

module.exports = { protect, authorize };
