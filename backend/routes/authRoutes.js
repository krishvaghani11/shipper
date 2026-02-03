const express = require("express");
const User = require("../models/User");
const { generateOtp } = require("../utils/generateOtp");
const { sendOtpEmail } = require("../services/emailService");

const router = express.Router();

/* ================= INIT LOGIN ================= */
router.post("/init-login", async (req, res) => {
  try {
    // ✅ Use mobileNumber to match the frontend and the check below
    const { mobileNumber, email } = req.body;
    console.log("🔐 INIT LOGIN:", { mobileNumber, email });

    if (!mobileNumber || !email) {
      return res.status(400).json({
        success: false,
        message: "Mobile number and email are required",
      });
    }

    let user = await User.findOne({ email });

    if (!user) {
      user = await User.create({
        mobileNumber,
        email,
      });
      console.log("🆕 New user created");
    } else {
      console.log("👤 Existing user found");
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
    const { email, otp } = req.body;
    console.log("✅ VERIFY OTP:", { email, otp });

    const user = await User.findOne({ email });
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
    res.json({ success: true });
  } catch (err) {
    console.error("❌ VERIFY OTP ERROR:", err.message);
    res.status(500).json({ success: false });
  }
});

/* ================= COMPLETE REGISTRATION ================= */
router.post("/register", async (req, res) => {
  try {
    const { email } = req.body;

    const user = await User.findOneAndUpdate(
      { email },
      { $set: req.body },
      { new: true }
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
