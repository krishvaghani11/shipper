const mongoose = require("mongoose");

const userSchema = new mongoose.Schema(
  {
    // Registration fields (filled later)
    fullName: { type: String, trim: true },
    companyName: { type: String, trim: true },
    designation: { type: String, default: "Manager" },

    // Required at login
    mobileNumber: {
      type: String,
      required: true,
      unique: true,
    },
    email: {
      type: String,
      required: true,
      unique: true,
      lowercase: true,
      trim: true,
    },

    // Registration details
    password: { type: String },

    buildingNumber: { type: String },
    areaName: { type: String },
    landmark: { type: String },
    city: { type: String },
    state: { type: String },
    country: { type: String, default: "India" },
    pinCode: { type: String },

    gstNumber: { type: String },
    tdsNumber: { type: String },
    panNumber: { type: String },
    aadhaarNumber: { type: String },

    bankAccountNumber: { type: String },
    ifscCode: { type: String },
    bankName: { type: String },
    accountHolderName: { type: String },

    // OTP
    otp: { type: String },
    otpExpiresAt: { type: Date },
    isVerified: { type: Boolean, default: false },
  },
  {
    timestamps: true,
  }
);

// Indexes
userSchema.index({ email: 1 });
userSchema.index({ mobileNumber: 1 });

module.exports = mongoose.model("User", userSchema);
