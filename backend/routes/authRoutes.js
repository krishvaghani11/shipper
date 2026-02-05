const express = require("express");
const User = require("../models/User");
const { generateOtp } = require("../utils/generateOtp");
const { sendOtpEmail } = require("../services/emailService");
const jwt = require("jsonwebtoken");

const router = express.Router();

/* ================= INIT LOGIN ================= */
router.post("/init-login", async (req, res) => {
  try {
    // ✅ Use mobileNumber to match the frontend and the check below
    const { mobileNumber, email } = req.body;
    console.log("🔐 INIT LOGIN:", { mobileNumber, email });

    // ✅ ALLOW MOBILE ONLY LOGIN
    if (!mobileNumber) {
      return res.status(400).json({
        success: false,
        message: "Mobile number is required",
      });
    }

    // Find by mobile OR email (if provided)
    let query = { mobileNumber };
    if (email) query = { $or: [{ mobileNumber }, { email }] };

    let user = await User.findOne(query);

    if (!user) {
      user = await User.create({
        mobileNumber,
        email: email || "", // Allow empty email
      });
      console.log("🆕 New user created");
    } else {
      console.log("👤 Existing user found");
      // Update email if provided and currently empty
      if (email && !user.email) {
        user.email = email;
        await user.save();
      }
    }

    res.json({ success: true });
  } catch (err) {
    console.error("❌ INIT LOGIN ERROR:", err.message);
    res.status(500).json({ success: false, message: err.message });
  }
});

/* ================= SEND EMAIL OTP ================= */
router.post("/send-email-otp", async (req, res) => {
  try {
    const { email } = req.body;
    console.log("📩 SEND OTP REQUEST:", email);

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ success: false, message: "User not found" });
    }

    const otp = generateOtp();
    console.log("🔐 OTP GENERATED:", otp);

    user.otp = otp;
    user.otpExpiresAt = Date.now() + 60 * 1000; // ✅ 60 seconds
    await user.save();

    await sendOtpEmail(email, otp);
    console.log("✉️ OTP EMAIL SENT");

    res.json({ success: true });
  } catch (error) {
    console.error("❌ SEND OTP ERROR:", error.response?.data || error.message);
    res.status(500).json({ success: false });
  }
});

/* ================= VERIFY OTP ================= */
router.post("/verify-otp", async (req, res) => {
  try {
    const { email, otp, mobileNumber } = req.body;
    console.log("✅ VERIFY OTP:", { email, mobileNumber, otp });

    let query = {};
    if (mobileNumber) query.mobileNumber = mobileNumber;
    else if (email) query.email = email;
    else return res.status(400).json({ success: false, message: "Email or Mobile required" });

    const user = await User.findOne(query);
    if (!user) {
      return res.status(404).json({ success: false });
    }

    if (
      user.otp !== otp ||
      !user.otpExpiresAt ||
      user.otpExpiresAt < Date.now()
    ) {
      return res.status(400).json({ success: false });
    }

    user.isVerified = true;
    user.otp = null;
    user.otpExpiresAt = null;
    await user.save();

    console.log("✅ OTP VERIFIED");

    // Check if registration is complete (e.g., checks for companyName)
    const isRegistrationComplete = !!user.companyName;

    // ✅ GENERATE TOKEN
    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET || "fallbacksecret", {
      expiresIn: "30d",
    });

    res.json({ success: true, isRegistrationComplete, token });
  } catch (err) {
    console.error("❌ VERIFY OTP ERROR:", err.message);
    res.status(500).json({ success: false });
  }
});

/* ================= GET USER DETAILS ================= */
router.get("/me", async (req, res) => {
  try {
    const { email } = req.query; // Get email from query params
    console.log("👤 GET USER DETAILS:", email);

    if (!email) {
      return res.status(400).json({ success: false, message: "Email is required" });
    }

    const user = await User.findOne({ email });

    if (!user) {
      return res.status(404).json({ success: false, message: "User not found" });
    }

    res.json({ success: true, user });
  } catch (error) {
    console.error("❌ GET USER ERROR:", error.message);
    res.status(500).json({ success: false, message: error.message });
  }
});

/* ================= COMPLETE REGISTRATION ================= */
router.post("/register", async (req, res) => {
  try {
    const { email } = req.body;
    console.log("📝 REGISTER REQUEST BODY:", req.body);

    const user = await User.findOneAndUpdate(
      { email },
      { $set: req.body },
      { new: true, upsert: true }
    );

    if (!user) {
      return res.status(404).json({
        success: false,
        message: "User not found",
      });
    }

    res.json({
      success: true,
      message: "Login successfully completed",
      user,
    });
  } catch (error) {
    console.error("REGISTER ERROR:", error.message);
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
});

module.exports = router;
