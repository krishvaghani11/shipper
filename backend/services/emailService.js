const axios = require("axios");

const sendOtpEmail = async (email, otp) => {
  console.log("📤 Sending OTP email...");

  try {
    const response = await axios.post(
      "https://api.brevo.com/v3/smtp/email",
      {
        sender: {
          email: process.env.BREVO_SENDER_EMAIL,
          name: "Shipper App",
        },
        to: [{ email }],
        subject: "Your OTP for Shipper App",
        htmlContent: `
          <div style="font-family: Arial, sans-serif;">
            <h2>OTP Verification</h2>
            <p>Your OTP is:</p>
            <h1 style="color:#ff9800;">${otp}</h1>
            <p>Valid for 5 minutes</p>
          </div>
        `,
      },
      {
        headers: {
          "api-key": process.env.BREVO_API_KEY,
          "content-type": "application/json",
          accept: "application/json",
        },
      }
    );

    console.log("✅ Brevo response status:", response.status);
  } catch (err) {
    console.error(
      "❌ BREVO ERROR:",
      err.response?.data || err.message
    );
    throw err; // 🔴 VERY IMPORTANT
  }
};

module.exports = { sendOtpEmail };



