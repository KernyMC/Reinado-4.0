import { db } from "../db.js";

export const getEstadisticasVotacion = (req, res) => {
  const query = `
    SELECT 
      c.CANDIDATA_ID,
      c.CAND_NOMBRE1,
      c.CAND_APELLIDOPATERNO,
      COUNT(vp.ID) as total_votos,
      ROUND((COUNT(vp.ID) * 100.0 / (SELECT COUNT(*) FROM votaciones_publico)), 2) as porcentaje
    FROM candidata c
    LEFT JOIN votaciones_publico vp ON c.CANDIDATA_ID = vp.CANDIDATA_ID
    GROUP BY c.CANDIDATA_ID
    ORDER BY total_votos DESC`;

  db.query(query, (err, resultados) => {
    if (err) {
      console.error("Error al obtener estadísticas:", err);
      return res.status(500).json({ message: "Error al obtener estadísticas" });
    }
    res.status(200).json(resultados);
  });
};