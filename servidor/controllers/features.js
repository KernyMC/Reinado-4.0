// api/controllers/features.js
import { db } from "../db.js";
import jwt from "jsonwebtoken";

export const getFeatures = (req, res) => {
  const sql = "SELECT * FROM features";
  db.query(sql, (err, data) => {
    if (err) return res.status(500).json(err);
    return res.status(200).json(data);
  });
};

export const createFeature = (req, res) => {
  // 1) Verificar que sea superadmin
  const token = req.cookies.access_token;
  if (!token) return res.status(401).json("No autenticado!");

  jwt.verify(token, "jwtkey", (err, userInfo) => {
    if (err) return res.status(403).json("Token no válido!");
    // Verificar rol
    const qUser = "SELECT rol FROM users WHERE id = ?";
    db.query(qUser, [userInfo.id], (err2, data2) => {
      if (err2) return res.status(500).json(err2);
      if (data2[0].rol !== "superadmin") {
        return res.status(403).json("No tienes permisos de superadmin");
      }
      // Si sí es superadmin, creamos la nueva feature
      const { name, enabled } = req.body;
      const sqlInsert = "INSERT INTO features (name, enabled) VALUES (?, ?)";
      db.query(sqlInsert, [name, enabled], (err3, result) => {
        if (err3) return res.status(500).json(err3);
        return res.status(200).json("Feature creada correctamente");
      });
    });
  });
};

export const updateFeature = (req, res) => {
    // 1) Buscar el header Authorization
    const authHeader = req.headers["authorization"];
    if (!authHeader) {
      return res.status(401).json("No autenticado!");
    }
  
    // 2) Extraer el token de "Bearer <token>"
    const token = authHeader.split(" ")[1];
  
    // 3) Verificarlo con jwt
    jwt.verify(token, "jwtkey", (err, userInfo) => {
      if (err) return res.status(403).json("Token no válido!");
  
      // 4) Chequear rol de superadmin
      const qUser = "SELECT rol FROM users WHERE id = ?";
      db.query(qUser, [userInfo.id], (err2, data2) => {
        if (err2) return res.status(500).json(err2);
        if (!data2.length || data2[0].rol !== "superadmin") {
          return res.status(403).json("No tienes permisos de superadmin");
        }
  
        // ... Ya verificado => hacer el UPDATE
        const featureId = req.params.id;
        const { enabled } = req.body;
        const sqlUpdate = "UPDATE features SET enabled = ? WHERE id_feature = ?";
        db.query(sqlUpdate, [enabled, featureId], (err3) => {
          if (err3) return res.status(500).json(err3);
          return res.status(200).json("Feature actualizada correctamente");
        });
      });
    });
  };
  

export const deleteFeature = (req, res) => {
  // 1) Verificar que sea superadmin
  const token = req.cookies.access_token;
  if (!token) return res.status(401).json("No autenticado!");

  jwt.verify(token, "jwtkey", (err, userInfo) => {
    if (err) return res.status(403).json("Token no válido!");
    const qUser = "SELECT rol FROM users WHERE id = ?";
    db.query(qUser, [userInfo.id], (err2, data2) => {
      if (err2) return res.status(500).json(err2);
      if (data2[0].rol !== "superadmin") {
        return res.status(403).json("No tienes permisos de superadmin");
      }
      // Si sí es superadmin, borramos la feature
      const featureId = req.params.id;
      const sqlDelete = "DELETE FROM features WHERE id_feature = ?";
      db.query(sqlDelete, [featureId], (err3, result) => {
        if (err3) return res.status(500).json(err3);
        return res.status(200).json("Feature eliminada correctamente");
      });
    });
  });
};
