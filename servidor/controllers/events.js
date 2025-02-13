import { db } from "../db.js";

export const getAllEvents = (req, res) => {
  const sql = "SELECT * FROM evento";
  db.query(sql, (err, data) => {
    if (err) return res.status(500).json(err);
    return res.status(200).json(data);
  });
};

export const createEvent = (req, res) => {
  const { EVENTO_NOMBRE, EVENTO_PESO, EVENTO_ESTADO } = req.body;
  const sql = `
    INSERT INTO evento (EVENTO_NOMBRE, EVENTO_PESO, EVENTO_ESTADO)
    VALUES (?, ?, ?)
  `;
  db.query(sql, [EVENTO_NOMBRE, EVENTO_PESO, EVENTO_ESTADO], (err, result) => {
    if (err) return res.status(500).json(err);
    return res.status(200).json("Evento creado exitosamente.");
  });
};

export const updateEvent = (req, res) => {
  const eventId = req.params.id;
  const { EVENTO_ESTADO } = req.body;
  
  const sql = `
    UPDATE evento 
    SET EVENTO_ESTADO = ?
    WHERE EVENTO_ID = ?
  `;
  
  db.query(sql, [EVENTO_ESTADO, eventId], (err, result) => {
    if (err) {
      console.error("Error actualizando evento:", err);
      return res.status(500).json(err);
    }
    return res.status(200).json("Evento actualizado exitosamente.");
  });
};

export const deleteEvent = (req, res) => {
  const eventId = req.params.id;
  const sql = "DELETE FROM evento WHERE EVENTO_ID = ?";
  db.query(sql, [eventId], (err, result) => {
    if (err) return res.status(500).json(err);
    return res.status(200).json("Evento eliminado exitosamente.");
  });
};
