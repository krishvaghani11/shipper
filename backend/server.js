const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
require("dotenv").config();

const authRoutes = require("./routes/authRoutes"); // ✅ CORRECT FILE NAME

const app = express();

app.use(cors());
app.use(express.json());

// ✅ ONLY ONE AUTH ROUTE
app.use("/api/auth", authRoutes);

mongoose
  .connect(process.env.MONGO_URI)
  .then(() => console.log("✅ MongoDB Connected"))
  .catch((err) => console.error("❌ MongoDB Error:", err));

app.listen(5000,"0.0.0.0", () => {
  console.log("🚀 Server running on port 5000");
});


