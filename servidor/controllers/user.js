import { db } from "../db.js"
import bcrypt from "bcryptjs"

export const getUsuarios = (req, res) => {
  const sqlSelect = "SELECT * FROM users";
  
  db.query(sqlSelect, (err, result) => {
    if (err) {
      console.log("Error en getUsuarios:", err);
      return res.status(500).json(err);
    }
    res.status(200).json(result);
  });
};

export const actualizarActivo = (req, res) => {
  const username = req.params.username;
  const sqlUpdate = "UPDATE users SET activo = 1 WHERE username = ?;";
  db.query(sqlUpdate, username, (err, result) => {
    if (err) {
      res.status(500).json({ message: "Internal server error" });
    } else {
      res.status(200).json({ message: "Se ha actualizado el estatus" });
    }
  });
};

export const actualizarEstadoEvento = (req, res) => {
  const idEvento = req.params.idEvento;
  const estado = req.params.estado;
  const sqlUpdate = "UPDATE evento SET evento_estado = ? WHERE evento_id = ?;";
  db.query(sqlUpdate, [estado, idEvento], (err, result) => {
    if (err) {
      console.log(err);
    } else {
      res.send(result);
    }
  });
};

export const limpiarVotaciones = (req, res) => {
  const sqlLimpiar = [
    "UPDATE votaciones SET vot_estado = 'no';",
    "UPDATE candidata SET cand_nota_final = 0;",
    "UPDATE candidata SET CAND_CALIFICACIONFINAL = 0;",
    "UPDATE candidata SET id_eleccion = 0;",
    "TRUNCATE TABLE calificacion;",
    "TRUNCATE TABLE finales;",
    "TRUNCATE TABLE votaciones;",
    "TRUNCATE TABLE votaciones_publicos;"
    
  ];

  sqlLimpiar.forEach((sql) => {
    db.query(sql, (err, result) => {
      if (err) {
        console.log(err);
      }
    });
  });

  res.send("Votaciones limpiadas correctamente");
};

export const limpiarTabla = (req, res) => {
  const sqlLimpiar = "UPDATE votaciones SET vot_estado = 'no'";
  db.query(sqlLimpiar, (err, result) => {
    if (err) {
      console.log(err);
    } else {
      res.send(result);
    }
  });
};

export const checkVotes1 = (req, res) => {
  const { id } = req.query;
  const sqlSelect = 'SELECT COUNT(*) AS total FROM finales where CANDIDATA_ID = ? and EVENTO_ID=1;';
  
  db.query(sqlSelect, [id], (err, result) => {
    if (err) {
      console.log(err);
      res.status(500).json({ error: 'An error occurred' });
    } else {
      res.status(200).json(result);
    }
  });
};

export const checkVotes2 = (req, res) => {
  const { id } = req.query;
  const sqlSelect = 'SELECT COUNT(*) AS total FROM finales where CANDIDATA_ID = ? and EVENTO_ID=2;';
  
  db.query(sqlSelect, [id], (err, result) => {
    if (err) {
      console.log(err);
      res.status(500).json({ error: 'An error occurred' });
    } else {
      res.status(200).json(result);
    }
  });
};

export const checkVotes3 = (req, res) => {
  // Definir sqlSelect antes de usarlo
  const sqlSelect = 'SELECT COUNT(*) AS total FROM finales where CANDIDATA_ID = 12 and EVENTO_ID=3;';
  
  db.query(sqlSelect, (err, result) => {
    if (err) {
      console.log(err);
      res.status(500).json({ error: 'An error occurred' });
    } else {
      res.status(200).json(result);
    }
  });
}

export const activarEventoPublico = (req, res) => {
  const eventoId = 4;
  const sqlUpdate = "UPDATE evento SET EVENTO_ESTADO = 'activo' WHERE EVENTO_ID = ?";
  
  db.query(sqlUpdate, [eventoId], (err, result) => {
      if (err) return res.status(500).json(err);
      res.status(200).json("Evento público activado.");
  });
};

export const createUser = (req, res) => {
  const { username, email, password, name, lastname, rol } = req.body;
  
  // Verificar usuario duplicado
  const checkUser = "SELECT * FROM users WHERE username = ?";
  db.query(checkUser, [username], (err, result) => {
    if (err) return res.status(500).json(err);
    if (result.length) return res.status(409).json("Usuario ya existe");

    // Hash password
    const salt = bcrypt.genSaltSync(10);
    const hashedPassword = bcrypt.hashSync(password, salt);

    // Insertar nuevo usuario
    const sqlInsert = `
      INSERT INTO users (username, email, password, name, lastname, rol, activo)
      VALUES (?, ?, ?, ?, ?, ?, true)
    `;
    
    db.query(sqlInsert, [username, email, hashedPassword, name, lastname, rol], (err, result) => {
      if (err) return res.status(500).json(err);
      res.status(200).json("Usuario creado exitosamente");
    });
  });
};

// READ all users
export const getAllUsers = (req, res) => {
  const sql = "SELECT * FROM users";
  db.query(sql, (err, data) => {
    if (err) return res.status(500).json(err);
    return res.status(200).json(data);
  });
};

// READ one user
export const getUserById = (req, res) => {
  const userId = req.params.id;
  const sqlSelect = "SELECT * FROM users WHERE id = ?";
  
  db.query(sqlSelect, [userId], (err, result) => {
    if (err) return res.status(500).json(err);
    if (result.length === 0) return res.status(404).json("Usuario no encontrado");
    res.status(200).json(result[0]);
  });
};

// UPDATE user (para cambiar rol o email, etc.)
export const updateUser = (req, res) => {
  const userId = req.params.id;
  const { email, name, lastname, rol } = req.body;

  const sqlUpdate = `
    UPDATE users 
    SET email = ?, name = ?, lastname = ?, rol = ?
    WHERE id = ?
  `;

  db.query(sqlUpdate, [email, name, lastname, rol, userId], (err, result) => {
    if (err) {
      console.log("Error en updateUser:", err);
      return res.status(500).json(err);
    }
    if (result.affectedRows === 0) {
      return res.status(404).json("Usuario no encontrado");
    }
    res.status(200).json("Usuario actualizado exitosamente");
  });
};

// DELETE user
export const deleteUser = (req, res) => {
  const userId = req.params.id;
  const sqlDelete = "DELETE FROM users WHERE id = ?";
  
  db.query(sqlDelete, [userId], (err, result) => {
    if (err) return res.status(500).json(err);
    if (result.affectedRows === 0) return res.status(404).json("Usuario no encontrado");
    res.status(200).json("Usuario eliminado exitosamente");
  });
};

// Agregar este método para obtener usuarios con sus features
export const getUsersWithFeatures = (req, res) => {
  const sql = `
    SELECT 
      u.id, u.username, u.name, u.lastname, u.rol,
      JSON_OBJECT(
        'admin_eventos', MAX(CASE WHEN uf.feature_name = 'admin_eventos' THEN uf.enabled ELSE 0 END),
        'top_candidatas', MAX(CASE WHEN uf.feature_name = 'top_candidatas' THEN uf.enabled ELSE 0 END),
        'tabla_notario', MAX(CASE WHEN uf.feature_name = 'tabla_notario' THEN uf.enabled ELSE 0 END),
        'crud_candidatas', MAX(CASE WHEN uf.feature_name = 'crud_candidatas' THEN uf.enabled ELSE 0 END)
      ) as features
    FROM users u
    LEFT JOIN user_features uf ON u.id = uf.user_id
    WHERE u.rol IN ('admin', 'notario')
    GROUP BY u.id
  `;

  db.query(sql, (err, result) => {
    if (err) {
      console.error("Error:", err);
      return res.status(500).json(err);
    }

    const processedResult = result.map(user => ({
      ...user,
      features: JSON.parse(user.features)
    }));

    return res.status(200).json(processedResult);
  });
};

// Agregar método para actualizar features de usuario
export const updateUserFeatures = (req, res) => {
  const userId = req.params.userId;
  const { features } = req.body;

  db.query("DELETE FROM user_features WHERE user_id = ?", [userId], async (err) => {
    if (err) return res.status(500).json(err);

    if (!features || features.length === 0) {
      return res.status(200).json({ message: "Features actualizadas" });
    }

    const values = features.map(feature => [userId, feature, 1]);
    const sql = "INSERT INTO user_features (user_id, feature_name, enabled) VALUES ?";

    db.query(sql, [values], (err) => {
      if (err) return res.status(500).json(err);
      res.status(200).json({ 
        message: "Features actualizadas exitosamente",
        features: features
      });
    });
  });
};

export const cambioDesempate = (req, res) => {
  const { estado } = req.params;
  const sqlUpdate = "UPDATE evento SET EVENTO_ESTADO = ? WHERE EVENTO_ID = 5";
  
  db.query(sqlUpdate, [estado], (err, result) => {
    if (err) {
      console.error("Error en cambioDesempate:", err);
      return res.status(500).json(err);
    }
    res.status(200).json("Estado de desempate actualizado correctamente");
  });
};

export const checkDesempate = (req, res) => {
  const sqlSelect = "SELECT EVENTO_ESTADO FROM evento WHERE EVENTO_ID = 5";
  
  db.query(sqlSelect, (err, result) => {
    if (err) {
      console.error("Error en checkDesempate:", err);
      return res.status(500).json(err);
    }
    res.status(200).json(result[0]);
  });
};

export const cerrarVotacionPublica = async (req, res) => {
    try {
        // 1. Desactivar el evento de votación pública
        await db.query("UPDATE evento SET EVENTO_ESTADO = 'no' WHERE EVENTO_ID = 4");
        
        // 2. Hacer la petición para contabilizar votos
        const response = await fetch(`${process.env.API_URL}/candidatas/contabilizar-votos`);
        const resultado = await response.json();

        res.status(200).json(resultado);
    } catch (err) {
        console.error("Error cerrando votación pública:", err);
        res.status(500).json({ error: "Error interno del servidor" });
    }
};