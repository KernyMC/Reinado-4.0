import { db } from "../db.js";
import jwt from "jsonwebtoken";

export const getCali = (req, res) => {
    const sqlSelect = "SELECT * from calificacion";

    db.query(sqlSelect, (err, data) => {
        if (err) return res.status(500).json(err);
        return res.status(200).json(data);
    });
};

export const addCali = (req, res) => {
  const { EVENTO_ID, USUARIO_ID, CANDIDATA_ID, CALIFICACION_NOMBRE, CALIFICACION_PESO, CALIFICACION_VALOR } = req.body;

  // Primero verificamos si ya existe una calificación para esta combinación
  const checkQuery = `
    SELECT * FROM calificacion 
    WHERE EVENTO_ID = ? AND USUARIO_ID = ? AND CANDIDATA_ID = ?
  `;

  db.query(checkQuery, [EVENTO_ID, USUARIO_ID, CANDIDATA_ID], (err, result) => {
    if (err) {
      console.error("Error verificando calificación existente:", err);
      return res.status(500).json(err);
    }

    if (result.length > 0) {
      // Si existe, actualizamos
      const updateQuery = `
        UPDATE calificacion 
        SET CALIFICACION_VALOR = ?, CALIFICACION_NOMBRE = ?, CALIFICACION_PESO = ?
        WHERE EVENTO_ID = ? AND USUARIO_ID = ? AND CANDIDATA_ID = ?
      `;

      db.query(updateQuery, 
        [CALIFICACION_VALOR, CALIFICACION_NOMBRE, CALIFICACION_PESO, EVENTO_ID, USUARIO_ID, CANDIDATA_ID], 
        (updateErr) => {
          if (updateErr) {
            console.error("Error actualizando calificación:", updateErr);
            return res.status(500).json(updateErr);
          }
          res.status(200).json("Calificación actualizada exitosamente");
        }
      );
    } else {
      // Si no existe, insertamos
      const insertQuery = `
          INSERT INTO calificacion 
          (EVENTO_ID, USUARIO_ID, CANDIDATA_ID, CALIFICACION_NOMBRE, CALIFICACION_PESO, CALIFICACION_VALOR)
          VALUES (?, ?, ?, ?, ?, ?)
        `;
        
      db.query(insertQuery, 
        [EVENTO_ID, USUARIO_ID, CANDIDATA_ID, CALIFICACION_NOMBRE, CALIFICACION_PESO, CALIFICACION_VALOR],
        (insertErr) => {
          if (insertErr) {
            console.error("Error insertando calificación:", insertErr);
            return res.status(500).json(insertErr);
          }
          res.status(200).json("Calificación agregada exitosamente");
        }
      );
    }
  });
};

export const getCalificacionCandidatas = (req, res) => {
    const sqlSelect = "SELECT c.CANDIDATA_ID, c.USUARIO_ID, c.EVENTO_ID from calificacion c WHERE CANDIDATA_ID = ? AND USUARIO_ID = ? AND EVENTO_ID = ?;";
    db.query(sqlSelect, [req.params.candidataId, userInfo.id, req.params.eventoId], (err, result) => {
        if (err) console.log(err);
        res.send(result);
    });
};

export const updateDesempate = (req, res) => {
    const token = req.cookies.access_token;
    if (!token) return res.status(401).json("No autenticado!");

    jwt.verify(token, "jwtkey", (err, userInfo) => {
        if (err) return res.status(403).json("Token no es valido!");

        const q = "UPDATE candidata SET CAND_NOTA_FINAL = CAND_NOTA_FINAL + ? WHERE CANDIDATA_ID = ?";
        const promises = req.body.notas.map(nota => {
            const values = [nota.nota_final, nota.candidata_id];
            return new Promise((resolve, reject) => {
                db.query(q, values, (err, data) => {
                    if (err) return reject(err);
                    resolve(data);
                });
            });
        });

        Promise.all(promises)
            .then(() => {
                res.status(200).json("Calificaciones de desempate actualizadas exitosamente.");
            })
            .catch(err => {
                res.status(500).json(err);
            });
    });
};

export const getDesempateNotas = (req, res) => {
    const sqlSelect = "SELECT candidata_id, nota_final FROM desempate";
    db.query(sqlSelect, (err, data) => {
        if (err) return res.status(500).json(err);
        return res.status(200).json(data);
    });
};

export const getCandidatasEmpatadas = (req, res) => {
    const sql = `
        SELECT 
            ca.CANDIDATA_ID,
            ca.CAND_NOMBRE1, 
            ca.CAND_APELLIDOPATERNO,
            dpto.DEPARTAMENTO_SEDE,
            dpto.DEPARTMENTO_NOMBRE, 
            fc.FOTO_URL 
        FROM 
            desempate d
            INNER JOIN candidata ca ON d.candidata_id = ca.CANDIDATA_ID
            INNER JOIN carrera car ON ca.CARRERA_ID = car.CARRERA_ID
            INNER JOIN departamento dpto ON car.DEPARTAMENTO_ID = dpto.DEPARTAMENTO_ID
            INNER JOIN foto_candidata fc ON ca.CANDIDATA_ID = fc.CANDIDATA_ID AND fc.FOTO_DESCRIPCION = 'FX';
    `;
    db.query(sql, (err, result) => {
        if (err) {
            console.log(err);
            res.status(500).json({ error: 'An error occurred' });
        } else {
            res.status(200).json({ candidatasEmpatadas: result });
        }
    });
};

export const checkVotacionPublica = async (req, res) => {
    try {
        const query = "SELECT EVENTO_ESTADO FROM evento WHERE EVENTO_ID = 4";
        
        db.query(query, (err, rows) => {
    if (err) {
                console.error("Error en consulta:", err);
                return res.status(500).json({
                    enabled: false,
                    message: 'Error al verificar el estado de la votación'
                });
            }

            if (!rows || rows.length === 0) {
                return res.status(404).json({
                    enabled: false,
                    message: 'Votación no disponible en este momento'
                });
            }

            const votacionActiva = rows[0].EVENTO_ESTADO === 'si';
            
            if (votacionActiva) {
                const juecesQuery = `
                    SELECT 
                        COUNT(DISTINCT u.id) as total_jueces,
                        COUNT(DISTINCT CASE WHEN c.CALIFICACION_VALOR > 0 THEN c.USUARIO_ID END) as jueces_calificaron
                    FROM users u
                    LEFT JOIN calificacion c ON u.id = c.USUARIO_ID AND c.EVENTO_ID = 3
                    WHERE u.rol = 'juez'
                `;
                
                db.query(juecesQuery, (err, juecesResult) => {
      if (err) {
                        console.error("Error verificando jueces:", err);
                        return res.status(500).json({
                            enabled: false,
                            message: 'Error al verificar estado de jueces'
                        });
                    }

                    if (juecesResult[0].total_jueces === 0 || 
                        juecesResult[0].total_jueces !== juecesResult[0].jueces_calificaron) {
                        return res.json({
                            enabled: false,
                            message: 'Esperando a que los jueces terminen de calificar...'
                        });
                    }

                    res.json({
                        enabled: true,
                        message: '¡La votación está abierta! Puedes votar ahora.'
                    });
                });
            } else {
                res.json({
                    enabled: false,
                    message: 'La votación pública aún no está habilitada.'
                });
            }
        });
    } catch (err) {
        console.error("Error verificando estado de votación pública:", err);
        res.status(500).json({
            enabled: false,
            message: 'Error al verificar el estado de la votación'
        });
    }
};

export const votarPublico = (req, res) => {
    const { USUARIO_ID, CANDIDATA_ID } = req.body;
    const EVENTO_ID = 4; // ID del evento de votación pública

    // Primero verificar si el evento está activo
    db.query("SELECT EVENTO_ESTADO FROM evento WHERE EVENTO_ID = ?", [EVENTO_ID], (err, eventoRows) => {
        if (err) {
            console.error("Error verificando estado del evento:", err);
            return res.status(500).json({ message: "Error al procesar el voto" });
        }

        if (!eventoRows[0] || eventoRows[0].EVENTO_ESTADO !== 'si') {
            return res.status(400).json({
                message: "La votación pública no está activa en este momento"
            });
        }

        // Verificar si el usuario ya votó
        db.query(
            "SELECT * FROM calificacion WHERE USUARIO_ID = ? AND EVENTO_ID = ?",
            [USUARIO_ID, EVENTO_ID],
            (err, voteRows) => {
                if (err) {
                    console.error("Error verificando voto existente:", err);
                    return res.status(500).json({ message: "Error al procesar el voto" });
                }

                if (voteRows.length > 0) {
                    return res.status(400).json({
                        message: "Ya has emitido tu voto"
                    });
                }

                // Registrar el voto
                const insertQuery = `
                    INSERT INTO calificacion 
                    (EVENTO_ID, USUARIO_ID, CANDIDATA_ID, CALIFICACION_NOMBRE, CALIFICACION_PESO, CALIFICACION_VALOR) 
                    VALUES (?, ?, ?, 'Voto Público', 100, 1)
                `;

                db.query(insertQuery, [EVENTO_ID, USUARIO_ID, CANDIDATA_ID], (err) => {
                    if (err) {
                        console.error("Error registrando voto:", err);
                        return res.status(500).json({ message: "Error al procesar el voto" });
                    }

                    res.status(200).json({ message: "Voto registrado exitosamente" });
                });
            }
        );
  });
};

export const cerrarVotaciones = async (req, res) => {
  try {
    // 1. Cerrar todos los eventos
    await db.query("UPDATE evento SET EVENTO_ESTADO = 'no'");

    // 2. Obtener la candidata con más votos públicos
    const votacionQuery = `
      SELECT CANDIDATA_ID, COUNT(*) as total_votos 
      FROM votaciones 
      WHERE EVENTO_ID = 4 
      GROUP BY CANDIDATA_ID 
      ORDER BY total_votos DESC`;

    db.query(votacionQuery, async (err, results) => {
      if (err) throw err;

      if (results.length > 0) {
        const maxVotos = results[0].total_votos;
        const candidatasMaxVotos = results.filter(r => r.total_votos === maxVotos);

        let candidataGanadora;

        if (candidatasMaxVotos.length === 1) {
          // Si hay una única ganadora
          candidataGanadora = candidatasMaxVotos[0].CANDIDATA_ID;
        } else {
          // Si hay empate, usar calificación de jueces como desempate
          const desempateQuery = `
            SELECT CANDIDATA_ID, SUM(CALIFICACION_VALOR) as total_puntos
            FROM calificacion 
            WHERE CANDIDATA_ID IN (${candidatasMaxVotos.map(c => c.CANDIDATA_ID).join(',')})
            GROUP BY CANDIDATA_ID 
            ORDER BY total_puntos DESC 
            LIMIT 1`;

          const [ganadora] = await db.promise().query(desempateQuery);
          candidataGanadora = ganadora[0].CANDIDATA_ID;
        }

        // Agregar bono a la ganadora (10 puntos adicionales)
        const bonoQuery = `
          UPDATE candidata 
          SET CAND_NOTA_FINAL = CAND_NOTA_FINAL + 10 
          WHERE CANDIDATA_ID = ?`;

        await db.promise().query(bonoQuery, [candidataGanadora]);
      }

      res.status(200).json({ message: "Votaciones cerradas y bono aplicado exitosamente" });
    });
  } catch (error) {
    console.error("Error en cerrarVotaciones:", error);
    res.status(500).json({ error: "Error interno del servidor" });
  }
};

export const actualizarPuntajeFinal = (req, res) => {
  const sqlUpdate = `
    UPDATE candidata c
    JOIN (
      SELECT CANDIDATA_ID, SUM(CALIFICACION_VALOR) AS total_votos
      FROM calificacion
      WHERE EVENTO_ID IN (1, 2, 3, 4)
      GROUP BY CANDIDATA_ID
    ) v ON c.CANDIDATA_ID = v.CANDIDATA_ID
    SET c.CAND_NOTA_FINAL = v.total_votos
  `;
  db.query(sqlUpdate, (err, result) => {
    if (err) return res.status(500).json(err);
    res.status(200).json("Puntaje final actualizado correctamente.");
  });
};

export const getCandidatasParaVotacion = (req, res) => {
    const sql = `
        SELECT 
            ca.CANDIDATA_ID,
            ca.CAND_NOMBRE1, 
            ca.CAND_APELLIDOPATERNO,
            dpto.DEPARTAMENTO_SEDE,
            dpto.DEPARTMENTO_NOMBRE, 
            fc.FOTO_URL,
            car.CARRERA_NOMBRE
        FROM candidata ca
        INNER JOIN carrera car ON ca.CARRERA_ID = car.CARRERA_ID
        INNER JOIN departamento dpto ON car.DEPARTAMENTO_ID = dpto.DEPARTAMENTO_ID
        INNER JOIN foto_candidata fc ON ca.CANDIDATA_ID = fc.CANDIDATA_ID 
        WHERE fc.FOTO_DESCRIPCION = 'FX'
        ORDER BY ca.CANDIDATA_ID
    `;

    db.query(sql, (err, rows) => {
    if (err) {
            console.error("Error obteniendo candidatas para votación:", err);
            return res.status(500).json({ message: "Error al obtener las candidatas" });
        }
        res.status(200).json(rows);
    });
};

export const checkUserVoted = (req, res) => {
    const { userId } = req.params;
    const query = "SELECT COUNT(*) as count FROM votaciones WHERE USUARIO_ID = ? AND EVENTO_ID = 4";
    
    db.query(query, [userId], (err, rows) => {
      if (err) {
            console.error("Error verificando voto de usuario:", err);
            return res.status(500).json({ message: "Error al verificar el voto" });
        }
        res.json({ hasVoted: rows[0].count > 0 });
  });
};
