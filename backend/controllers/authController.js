const User = require("../models/User");
const SibApiV3Sdk = require("sib-api-v3-sdk");

// Brevo setup
const client = SibApiV3Sdk.ApiClient.instance;
client.authentications["api-key"].apiKey = process.env.BREVO_API_KEY;

// REGISTER USER (Save phone + email)
exports.registerUser = async (req, res) => {
  const { mobileNumber, email } = req.body;

  if (!mobileNumber || !email) {
    return res.status(400).json({ message: "Missing fields" });
  }

  try {
    let user = await User.findOne({ mobileNumber });

    if (!user) {
      user = await User.create({
        mobileNumber,
        email,
      });
    }

    res.status(200).json({ success: true });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};


// SEND OTP (Generate + Save + Email)
exports.sendOtp = async (req, res) => {
  const { email } = req.body;
  const otp = Math.floor(100000 + Math.random() * 900000);

  try {
    await User.findOneAndUpdate({ email }, { otp });

    const api = new SibApiV3Sdk.TransactionalEmailsApi();

    await api.sendTransacEmail({
      sender: { email: "mrvaghani137@gmail.com", name: "Apexcel Move" },
      to: [{ email }],
      subject: "Your OTP for Apexcel Move",
      htmlContent: `<h2>Your OTP is <b>${otp}</b></h2>`,
    });

    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

// VERIFY OTP
exports.verifyOtp = async (req, res) => {
  const { email, otp } = req.body;

  const user = await User.findOne({ email, otp });

  if (!user) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid OTP" });
  }

  user.isVerified = true;
  user.otp = null;
  await user.save();

  res.json({ success: true });
};

