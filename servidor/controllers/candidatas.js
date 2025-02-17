import { db } from "../db.js"
import jwt from "jsonwebtoken";
import multer from 'multer';
import path from 'path';
import fs from 'fs';


export const getCandidatas = (req, res) => {
    const sqlSelect = "SELECT candidata.*, foto_candidata.foto_url FROM candidata NATURAL JOIN foto_candidata;";
    
    db.query(sqlSelect, (err, data) => {
        if (err) return res.status(500).json(err);
        return res.status(200).json(data);
    });
}


export const getJueces = (req, res) => {
    const sqlSelect = "SELECT * from users where rol = 'juez'";

    db.query(sqlSelect, (err, data) => {
        if (err) return res.status(500).json(err);
        // console.log(data);
        return res.status(200).json(data);
    });
}


export const getCandidatasFotos = (req, res) => {
    const id = req.params.id;
    //console.log(id);
    const sqlSelect = "SELECT * from foto_candidata where CANDIDATA_ID = ?;";
    db.query(sqlSelect, id, (err, result) => {
        if (err) 
            console.log(err);

        // console.log(result);
        res.send(result)
    })
}

export const getCandidatasTrajeTipico = (req, res) => {
    const sqlSelect = "SELECT candidata.*, foto_candidata.FOTO_URL from candidata join foto_candidata where candidata.CANDIDATA_ID = foto_candidata.CANDIDATA_ID and foto_candidata.FOTO_DESCRIPCION = 'FX' and candidata.CANDIDATA_ID not in (select CANDIDATA_ID from finales where finales.EVENTO_ID = 1);";
    db.query(sqlSelect, (err, result) => {
        if (err) 
            console.log(err);

        // console.log(result);
        res.send(result)
    })
}


export const getVotacionesNotario = async (req, res) => {
    try {
        const q = `
            SELECT 
                DISTINCT c.CANDIDATA_ID,
                c.EVENTO_ID,
                c.USUARIO_ID,
                'si' as VOT_ESTADO
            FROM calificacion c
            WHERE c.CALIFICACION_VALOR IS NOT NULL
        `;

        db.query(q, [], (err, data) => {
            if (err) {
                console.error("Error obteniendo votaciones:", err);
                return res.status(500).json(err);
            }
            return res.json(data);
        });
    } catch (err) {
        console.error("Error en getVotacionesNotario:", err);
        res.status(500).json(err);
    }
};


export const getCandidatasTrajeGala = (req, res) => {
    const sqlSelect = "SELECT candidata.*, foto_candidata.FOTO_URL from candidata join foto_candidata where candidata.CANDIDATA_ID = foto_candidata.CANDIDATA_ID and foto_candidata.FOTO_DESCRIPCION = 'FX' and candidata.CANDIDATA_ID not in (select CANDIDATA_ID from finales where finales.EVENTO_ID = 2);";
    db.query(sqlSelect, (err, result) => {
        if (err) 
            console.log(err);

        // console.log(result);
        res.send(result)
    })
}

export const getCandidatasBarra = (req, res) => {
    const sqlSelect = "SELECT candidata.*, foto_candidata.FOTO_URL from candidata join foto_candidata where candidata.CANDIDATA_ID = foto_candidata.CANDIDATA_ID and foto_candidata.FOTO_DESCRIPCION = 'FX' and candidata.CANDIDATA_ID not in (select CANDIDATA_ID from finales where finales.EVENTO_ID = 2);";
    db.query(sqlSelect, (err, result) => {
        if (err) 
            console.log(err);

        // console.log(result);
        res.send(result)
    })
}

export const getCandidataCarrusel = (req, res) => {
    const sqlSelect = `
        SELECT 
            c.*, 
            carr.CARRERA_NOMBRE, 
            d.DEPARTMENTO_NOMBRE, 
            d.DEPARTAMENTO_SEDE, 
            MIN(fc.foto_url) AS foto_url,
            MIN(fc.FOTO_CARRUSEL_URL) AS FOTO_CARRUSEL_URL
        FROM 
            candidata AS c
        JOIN 
            carrera AS carr ON c.CARRERA_ID = carr.CARRERA_ID
        JOIN 
            departamento AS d ON carr.DEPARTAMENTO_ID = d.DEPARTAMENTO_ID
        LEFT JOIN 
            foto_candidata AS fc ON c.CANDIDATA_ID = fc.CANDIDATA_ID
        GROUP BY 
            c.CANDIDATA_ID;
    `;
    
    db.query(sqlSelect, (err, data) => {
        if (err) return res.status(500).json(err);
        return res.status(200).json(data);
    });
}




// Backend: Verificar si hay registros en la tabla de desempate y si el proceso de desempate ha terminado


// En candidatas.js
export const getTopCandidatas = (req, res) => {
    const sqlSelect = `
        SELECT CANDIDATA_ID, CAND_NOMBRE1, CAND_APELLIDOPATERNO, CAND_PUNTUACION_TOTAL
        FROM vista_puntuaciones
        ORDER BY CAND_PUNTUACION_TOTAL DESC
        LIMIT 12;
    `;
    db.query(sqlSelect, (err, data) => {
        if (err) {
            console.error("Error ejecutando la consulta:", err);
            return res.status(500).json(err);
        }
        console.log("Datos obtenidos:", data); // Log para depuración
        return res.status(200).json(data);
    });
};


export const getVistaPuntuaciones = (req, res) => {
  const q = "SELECT * FROM vista_puntuaciones";
  db.query(q, (err, data) => {
    if (err) return res.status(500).json(err);
    return res.status(200).json(data);
  });
};


//crud candidatas


// CREATE
export const createCandidata = (req, res) => {
  const sql = `
    INSERT INTO candidata (
      CARRERA_ID,
      ELECCION_ID,
      CAND_NOMBRE1,
      CAND_NOMBRE2,
      CAND_APELLIDOPATERNO,
      CAND_APELLIDOMATERNO,
      CAND_FECHANACIMIENTO,
      CAND_ACTIVIDAD_EXTRA,
      CAND_ESTATURA,
      CAND_HOBBIES,
      CAND_IDIOMAS,
      CAND_COLOROJOS,
      CAND_COLORCABELLO,
      CAND_LOGROS_ACADEMICOS,
      ID_ELECCION
    ) VALUES (?, 1, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1)
  `;

  const values = [
    req.body.CARRERA_ID,
    req.body.CAND_NOMBRE1,
    req.body.CAND_NOMBRE2 || null,
    req.body.CAND_APELLIDOPATERNO,
    req.body.CAND_APELLIDOMATERNO,
    req.body.CAND_FECHANACIMIENTO || null,
    req.body.CAND_ACTIVIDAD_EXTRA || null,
    req.body.CAND_ESTATURA || null,
    req.body.CAND_HOBBIES || null,
    req.body.CAND_IDIOMAS || null,
    req.body.CAND_COLOROJOS || null,
    req.body.CAND_COLORCABELLO || null,
    req.body.CAND_LOGROS_ACADEMICOS || null
  ];

  db.query(sql, values, (err, result) => {
    if (err) {
      console.error("Error al crear candidata:", err);
      return res.status(500).json({ error: err.message });
    }
    return res.status(201).json({
      message: "Candidata creada exitosamente",
      CANDIDATA_ID: result.insertId
    });
  });
};

// Obtener todas las carreras
export const getAllCarreras = (req, res) => {
  const sql = `
    SELECT 
      c.CARRERA_ID,
      c.CARRERA_NOMBRE,
      d.DEPARTMENTO_NOMBRE as DEPARTAMENTO_NOMBRE
    FROM carrera c
    INNER JOIN departamento d ON c.DEPARTAMENTO_ID = d.DEPARTAMENTO_ID
    ORDER BY d.DEPARTMENTO_NOMBRE, c.CARRERA_NOMBRE
  `;
  
  db.query(sql, (err, result) => {
    if (err) {
      console.error("Error al obtener carreras:", err);
      return res.status(500).json({ error: err.message });
    }
    return res.status(200).json(result);
  });
};

// Obtener todas las candidatas
export const getAllCandidatas = (req, res) => {
  const sql = `
    SELECT 
      c.CANDIDATA_ID,
      c.CARRERA_ID,
      c.CAND_NOMBRE1,
      c.CAND_NOMBRE2,
      c.CAND_APELLIDOPATERNO,
      c.CAND_APELLIDOMATERNO,
      c.CAND_FECHANACIMIENTO,
      c.CAND_ACTIVIDAD_EXTRA,
      c.CAND_ESTATURA,
      c.CAND_HOBBIES,
      c.CAND_IDIOMAS,
      c.CAND_COLOROJOS,
      c.CAND_COLORCABELLO,
      c.CAND_LOGROS_ACADEMICOS,
      car.CARRERA_NOMBRE,
      d.DEPARTMENTO_NOMBRE as DEPARTAMENTO_NOMBRE
    FROM candidata c
    INNER JOIN carrera car ON c.CARRERA_ID = car.CARRERA_ID
    INNER JOIN departamento d ON car.DEPARTAMENTO_ID = d.DEPARTAMENTO_ID
    WHERE c.CAND_NOTA_FINAL IS NULL OR c.CAND_NOTA_FINAL >= 0
  `;
  
  db.query(sql, (err, result) => {
    if (err) {
      console.error("Error al obtener candidatas:", err);
      return res.status(500).json({ error: err.message });
    }
    return res.status(200).json(result);
  });
};

// Actualizar candidata
export const updateCandidata = (req, res) => {
  const sql = `
    UPDATE candidata 
    SET 
      CARRERA_ID = ?,
      CAND_NOMBRE1 = ?,
      CAND_NOMBRE2 = ?,
      CAND_APELLIDOPATERNO = ?,
      CAND_APELLIDOMATERNO = ?,
      CAND_FECHANACIMIENTO = ?,
      CAND_ACTIVIDAD_EXTRA = ?,
      CAND_ESTATURA = ?,
      CAND_HOBBIES = ?,
      CAND_IDIOMAS = ?,
      CAND_COLOROJOS = ?,
      CAND_COLORCABELLO = ?,
      CAND_LOGROS_ACADEMICOS = ?
    WHERE CANDIDATA_ID = ?
  `;

  const values = [
    req.body.CARRERA_ID || null,
    req.body.CAND_NOMBRE1 || null,
    req.body.CAND_NOMBRE2 || null,
    req.body.CAND_APELLIDOPATERNO || null,
    req.body.CAND_APELLIDOMATERNO || null,
    req.body.CAND_FECHANACIMIENTO || null,
    req.body.CAND_ACTIVIDAD_EXTRA || null,
    req.body.CAND_ESTATURA || null,
    req.body.CAND_HOBBIES || null,
    req.body.CAND_IDIOMAS || null,
    req.body.CAND_COLOROJOS || null,
    req.body.CAND_COLORCABELLO || null,
    req.body.CAND_LOGROS_ACADEMICOS || null,
    req.params.id
  ];

  db.query(sql, values, (err, result) => {
    if (err) {
      console.error("Error al actualizar candidata:", err);
      return res.status(500).json({ error: err.message });
    }
    return res.status(200).json({ message: "Candidata actualizada exitosamente" });
  });
};

// DELETE
export const deleteCandidata = (req, res) => {
  // En lugar de eliminar, podríamos marcar como inactiva estableciendo CAND_NOTA_FINAL a -1
  const sql = "UPDATE candidata SET CAND_NOTA_FINAL = -1 WHERE CANDIDATA_ID = ?";

  db.query(sql, [req.params.id], (err, result) => {
    if (err) {
      console.error("Error al eliminar candidata:", err);
      return res.status(500).json({ error: err.message });
    }
    return res.status(200).json({ message: "Candidata eliminada exitosamente" });
  });
};

//subir fotos de las candidatas

// 1) Configurar multer
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
      // Carpta temporal en el server, por ejemplo
      cb(null, 'uploads/');
    },
    filename: function (req, file, cb) {
      // Deja que sea el server el que decida luego renombrar
      cb(null, Date.now() + path.extname(file.originalname));
    },
  });
  export const upload = multer({ storage: storage });
  
  // 2) Supongamos un endpoint "updateCandidataFoto"
  export const updateCandidataFoto = async (req, res) => {
    try {
      const candidataId = req.params.id; // ID de la candidata
      // req.body con los datos: CAND_NOMBRE1, CAND_NOMBRE2, etc.
      const { CAND_NOMBRE1, CAND_NOMBRE2, CAND_APELLIDOPATERNO, CAND_APELLIDOMATERNO } = req.body;
      // req.file con la foto
      if (!req.file) {
        return res.status(400).json("No se recibió archivo de imagen.");
      }
  
      // 3) Generar el "nuevo nombre" con las iniciales
      //    Ej: N1(0), N2(0), ApP(0), ApM(0)
      //    "Wendy Elizabeth Morillo Rodríguez" => "WEMR.jpg"
      const n1 = CAND_NOMBRE1?.charAt(0) || '';
      const n2 = CAND_NOMBRE2?.charAt(0) || '';
      const ap1 = CAND_APELLIDOPATERNO?.charAt(0) || '';
      const ap2 = CAND_APELLIDOMATERNO?.charAt(0) || '';
  
      // Sufijo = extension
      const ext = path.extname(req.file.originalname); // .jpg, .png, etc.
      const nuevoNombre = `${n1}${n2}${ap1}${ap2}${ext}`.toUpperCase(); 
      // Ej: "WEMR.jpg"
  
      // 4) Mover/copiar el archivo a "D:\\ReinasApp\\assets\\candidatas\\"
      const folderDestino = `D:\\ReinasApp\\assets\\candidatas\\`;
      const newPath = path.join(folderDestino, nuevoNombre);
  
      fs.renameSync(req.file.path, newPath); 
      // Mueve el archivo subido de 'uploads/<temporal>' -> 'D:\ReinasApp\assets\candidatas\WEMR.jpg'
  
      // 5) Guardar en BD la ruta "C:\\fakepath\\WEMRH.jpg" u otra
      //    Podrías guardar: "D:\\ReinasApp\\assets\\candidatas\\WEMR.jpg"
      //    O la "fakepath" que usas, o algo similar
      const fotoUrl = `C:\\fakepath\\${nuevoNombre}`; 
      // O la que quieras
      const sqlUpdate = `
        UPDATE candidata 
        SET CAND_NOMBRE1=?, CAND_NOMBRE2=?, CAND_APELLIDOPATERNO=?, CAND_APELLIDOMATERNO=?, 
            foto_url=?
        WHERE CANDIDATA_ID=?
      `;
      db.query(sqlUpdate, [CAND_NOMBRE1, CAND_NOMBRE2, CAND_APELLIDOPATERNO, CAND_APELLIDOMATERNO, fotoUrl, candidataId], 
      (err, result) => {
        if (err) {
          console.log(err);
          return res.status(500).json("Error al actualizar la candidata en BD.");
        }
        return res.status(200).json("Candidata actualizada con foto.");
      });
    } catch (err) {
      console.log(err);
      return res.status(500).json("Error en updateCandidataFoto.");
    }
  };

// Agregar función para verificar si todos los jueces votaron en un evento
export const verificarEvento = async (req, res) => {
  const { id: eventoId } = req.params;
  const { userId } = req.query;

  try {
    // Consulta para verificar voto del usuario actual
    const votacionResult = await new Promise((resolve, reject) => {
      db.query(
        'SELECT COUNT(*) as count FROM calificacion WHERE EVENTO_ID = ? AND USUARIO_ID = ?',
        [eventoId, userId],
        (err, result) => {
          if (err) reject(err);
          else resolve(result);
        }
      );
    });
    const usuarioYaVoto = votacionResult[0].count > 0;

    // Consulta para verificar total de jueces y votos
    const juecesResult = await new Promise((resolve, reject) => {
      db.query(
        `SELECT 
          (SELECT COUNT(*) FROM users WHERE rol = 'juez' AND activo = 1) as total_jueces,
          (SELECT COUNT(DISTINCT USUARIO_ID) FROM calificacion WHERE EVENTO_ID = ?) as jueces_votaron`,
        [eventoId],
        (err, result) => {
          if (err) reject(err);
          else resolve(result);
        }
      );
    });

    const votacionCompleta = juecesResult[0].jueces_votaron >= juecesResult[0].total_jueces;

    // Verificar empate solo si es el último evento
    let hayEmpate = false;
    if (votacionCompleta && eventoId === "3") {
      const resultados = await new Promise((resolve, reject) => {
        db.query(
          `SELECT CANDIDATA_ID, SUM(CALIFICACION_VALOR) as total
           FROM calificacion 
           WHERE EVENTO_ID IN (1,2,3)
           GROUP BY CANDIDATA_ID 
           ORDER BY total DESC 
           LIMIT 2`,
          (err, result) => {
            if (err) reject(err);
            else resolve(result);
          }
        );
      });

      if (resultados.length >= 2) {
        hayEmpate = resultados[0].total === resultados[1].total;
      }
    }

    res.json({
      completo: votacionCompleta,
      debeEsperar: usuarioYaVoto && !votacionCompleta,
      hayEmpate
    });

  } catch (error) {
    console.error('Error en verificarEvento:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
};

// Nuevo endpoint para verificar estado global
export const verificarEstadoGlobal = async (req, res) => {
  try {
    // Verificar si todos los eventos anteriores están completos
    const [votacionesCompletadas] = await db.query(`
      SELECT EVENTO_ID, COUNT(DISTINCT USUARIO_ID) as jueces_votaron
      FROM calificacion
      WHERE EVENTO_ID IN (1, 2, 3)
      GROUP BY EVENTO_ID
    `);

    const [totalJueces] = await db.query(
      'SELECT COUNT(*) as total FROM users WHERE rol = "juez" AND activo = 1'
    );

    const todosEventosCompletos = votacionesCompletadas.length === 3 && 
      votacionesCompletadas.every(v => v.jueces_votaron >= totalJueces[0].total);

    res.json({ 
      estado: todosEventosCompletos ? 'completo' : 'pendiente',
      mensaje: todosEventosCompletos ? 'Todos los eventos completados' : 'Esperando votaciones'
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Error verificando estado global" });
  }
};

// Agregar al final del archivo
export const verificarDesempateCompleto = async (req, res) => {
    try {
        const sqlVotacion = `
            SELECT COUNT(DISTINCT u.id) as total_jueces,
                   COUNT(DISTINCT c.USUARIO_ID) as jueces_votaron
            FROM users u
            LEFT JOIN calificacion c ON u.id = c.USUARIO_ID AND c.EVENTO_ID = 4
            WHERE u.rol = 'juez' AND u.activo = 1
        `;

        const [result] = await db.query(sqlVotacion);
        const { total_jueces, jueces_votaron } = result[0];
        
        res.json({
            completo: total_jueces === jueces_votaron
        });
    } catch (err) {
        console.error(err);
        res.status(500).json(err);
    }
};

export const submitVotacionPublica = async (req, res) => {
    const { USUARIO_ID, CANDIDATA_ID, EVENTO_ID } = req.body;
    
    try {
        // Verificar si el usuario ya votó
        const [existingVote] = await db.query(
            "SELECT * FROM votaciones WHERE USUARIO_ID = ? AND EVENTO_ID = ?",
            [USUARIO_ID, EVENTO_ID]
        );

        if (existingVote.length > 0) {
            return res.status(400).json({ message: "Ya has votado anteriormente" });
        }

        // Solo registrar el voto en la tabla votaciones
        await db.query(
            "INSERT INTO votaciones (USUARIO_ID, CANDIDATA_ID, EVENTO_ID) VALUES (?, ?, ?)",
            [USUARIO_ID, CANDIDATA_ID, EVENTO_ID]
        );

        res.status(200).json({ message: "Voto registrado exitosamente" });
    } catch (err) {
        console.error("Error en votación pública:", err);
        res.status(500).json(err);
    }
};

export const contabilizarVotosPublicos = async (req, res) => {
    try {
        // 1. Obtener el conteo de votos por candidata
        const [votaciones] = await db.query(`
            SELECT CANDIDATA_ID, COUNT(*) as total_votos 
            FROM votaciones 
            WHERE EVENTO_ID = 4
            GROUP BY CANDIDATA_ID 
            ORDER BY total_votos DESC
        `);

        if (votaciones.length === 0) {
            return res.status(200).json({ message: "No hay votos registrados" });
        }

        const maxVotos = votaciones[0].total_votos;
        const candidatasMaxVotos = votaciones.filter(v => v.total_votos === maxVotos);

        let candidataGanadora;

        if (candidatasMaxVotos.length === 1) {
            // Si hay una única ganadora
            candidataGanadora = candidatasMaxVotos[0].CANDIDATA_ID;
        } else {
            // Si hay empate, usar calificación de jueces como desempate
            const [resultadoJueces] = await db.query(`
                SELECT CANDIDATA_ID, SUM(CALIFICACION_VALOR) as total_puntos
                FROM calificacion 
                WHERE CANDIDATA_ID IN (${candidatasMaxVotos.map(c => c.CANDIDATA_ID).join(',')})
                AND EVENTO_ID IN (1, 2, 3)
                GROUP BY CANDIDATA_ID 
                ORDER BY total_puntos DESC 
                LIMIT 1
            `);
            
            candidataGanadora = resultadoJueces[0].CANDIDATA_ID;
        }

        // Aplicar el bono de 5 puntos a la ganadora
        await db.query(
            "UPDATE candidata SET CAND_NOTA_FINAL = CAND_NOTA_FINAL + 5 WHERE CANDIDATA_ID = ?",
            [candidataGanadora]
        );

        res.status(200).json({ 
            message: "Votos contabilizados exitosamente",
            candidataGanadora,
            bonoPuntos: 5
        });
    } catch (err) {
        console.error("Error contabilizando votos públicos:", err);
        res.status(500).json({ error: "Error interno del servidor" });
    }
};

export const checkUserVoted = async (req, res) => {
    const { userId } = req.params;
    
    try {
        const [result] = await db.query(
            "SELECT COUNT(*) as count FROM calificacion WHERE USUARIO_ID = ? AND EVENTO_ID = 4",
            [userId]
        );
        
        res.json({ hasVoted: result[0].count > 0 });
    } catch (err) {
        console.error("Error verificando voto de usuario:", err);
        res.status(500).json(err);
    }
};

export const verificarEmpate = async (req, res) => {
  try {
    // Consulta para obtener las 3 mejores puntuaciones
    const query = `
      SELECT c.CANDIDATA_ID, 
             c.CAND_NOMBRE1,
             c.CAND_APELLIDOPATERNO,
             SUM(cal.CALIFICACION_VALOR) as total_puntos
      FROM candidata c
      JOIN calificacion cal ON c.CANDIDATA_ID = cal.CANDIDATA_ID
      WHERE cal.EVENTO_ID IN (1, 2, 3)
      GROUP BY c.CANDIDATA_ID
      ORDER BY total_puntos DESC
      LIMIT 3
    `;

    db.query(query, (err, results) => {
      if (err) {
        console.error("Error verificando empate:", err);
        return res.status(500).json({ error: "Error al verificar empate" });
      }

      // Verificar si hay empate entre los primeros lugares
      const hayEmpate = results.length >= 2 && 
        (results[0].total_puntos === results[1].total_puntos ||
         (results[2] && results[1].total_puntos === results[2].total_puntos));

      res.json({
        hayEmpate,
        candidatasEmpatadas: hayEmpate ? results : [],
        message: hayEmpate ? 
          "Hay empate entre candidatas" : 
          "No hay empate entre candidatas"
      });
    });
  } catch (error) {
    console.error("Error en verificarEmpate:", error);
    res.status(500).json({ error: "Error interno del servidor" });
  }
};
