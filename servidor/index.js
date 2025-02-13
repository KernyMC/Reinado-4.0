import express from "express";
import cors from "cors";
import authRoutes from "./routes/auth.js";
import userRoutes from "./routes/user.js";
import candidatasRoutes from "./routes/candidatas.js";
import caliRoutes from "./routes/cali.js";
import barraRoutes from "./routes/barra.js";
import featuresRoutes from "./routes/features.js";
import rolesRoutes from "./routes/roles.js";
import eventsRoutes from "./routes/events.js";

import cookieParser from "cookie-parser";
import multer from "multer";

const app = express();

app.use(cors({
  origin: true, // Permite todas las conexiones en desarrollo
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));

app.use(express.json());
app.use(cookieParser());

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, '../client/public/upload');
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + file.originalname);
  },
});

const upload = multer({ storage });

app.post('/api/upload', upload.single('file'), function (req, res) {
  const file = req.file;
  res.status(200).json(file.filename);
});

app.use("/api/auth", authRoutes);
app.use("/api/user", userRoutes);
app.use("/api/candidatas", candidatasRoutes);
app.use("/api/cali", caliRoutes);
app.use("/api/barra", barraRoutes);
app.use("/api/features", featuresRoutes);
app.use("/api/roles", rolesRoutes);
app.use("/api/events", eventsRoutes);

app.listen(8800, () => {
  console.log("Backend server is running!");
});