import { db } from "../db.js";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import nodemailer from "nodemailer";

export const register = (req, res) => {
    const email = req.body.email;

    // Validar dominio del correo
    if (!email.endsWith("@espe.edu.ec")) {
        return res.status(400).json("Debe usar un correo institucional con dominio @espe.edu.ec.");
    }

    const q = "SELECT * FROM users WHERE email = ?";
    db.query(q, [email], (err, data) => {
        if (err) return res.status(500).json(err);
        if (data.length) return res.status(409).json("El usuario ya existe.");

        // Encriptar contraseña
        const salt = bcrypt.genSaltSync(10);
        const hash = bcrypt.hashSync(req.body.password, salt);

        const sqlInsert = `
            INSERT INTO users (username, email, password, name, lastname, rol)
            VALUES (?, ?, ?, ?, ?, ?);
        `;
        const values = [
            email, // El usuario será el correo mismo
            email,
            hash,
            req.body.nombre,
            req.body.lastname,
            "usuario", // Rol predeterminado para nuevos registros
        ];

        db.query(sqlInsert, values, (err, result) => {
            if (err) return res.status(500).json(err);

            // Configurar y enviar el correo
            const transporter = nodemailer.createTransport({
                service: "gmail",
                auth: {
                    user: "kalexandervargas@gmail.com",
                    pass: "dniajoxqdawpjchm",
                },
            });

            const mailOptions = {
                from: "kalexandervargas@gmail.com",
                to: email,
                subject: "Registro Exitoso",
                html: `
                  <div style="background: linear-gradient(0deg, #0D4F02, #002401); padding: 40px; font-family: Arial, sans-serif;">
                    <div style="max-width: 600px; margin: auto; background: white; border-radius: 8px; padding: 20px; box-shadow: 0px 4px 8px rgba(0,0,0,0.2);">
                      <h1 style="color: #0D4F02; text-align: center;">¡Registro Exitoso!</h1>
                      <p style="font-size: 16px; color: #333;">Hola,</p>
                      <p style="font-size: 16px; color: #333;">
                        Te has registrado exitosamente en nuestro sistema. Aquí tienes tus credenciales:
                      </p>
                      <ul style="font-size: 16px; color: #333; list-style: none; padding: 0;">
                        <li><strong>Usuario:</strong> ${email}</li>
                        <li><strong>Contraseña:</strong> ${req.body.password}</li>
                      </ul>
                      <p style="font-size: 16px; color: #333;">
                        Por favor, guarda esta información en un lugar seguro.
                      </p>
                      <p style="text-align: center; color: #0D4F02; font-size: 14px;">
                        © 2025 - Universidad de las Fuerzas Armadas ESPE
                      </p>
                    </div>
                  </div>
                `,
            };
            

            transporter.sendMail(mailOptions, (error, info) => {
                if (error) return res.status(500).json(error);
                res.status(200).json("Usuario registrado correctamente y correo enviado.");
            });
        });
    });
};

export const login = (req, res) => {
  const q = "SELECT * FROM users WHERE username = ?";

  db.query(q, [req.body.username], (err, data) => {
    if (err) return res.status(500).json(err);
    if (data.length === 0) return res.status(404).json("Usuario no encontrado");

    const isPasswordCorrect = bcrypt.compareSync(
      req.body.password,
      data[0].password
    );

    if (!isPasswordCorrect)
      return res.status(400).json("Usuario o contraseña incorrectos");

    const userId = data[0].id;
    
    // Consultar los features del usuario
    const featuresQuery = `
      SELECT feature_name 
      FROM user_features 
      WHERE user_id = ? AND enabled = 1
    `;

    db.query(featuresQuery, [userId], (err, featuresData) => {
      if (err) return res.status(500).json(err);

      const features = featuresData.map(f => f.feature_name);
      const { password, ...other } = data[0];
      
      const token = jwt.sign({ id: data[0].id }, "jwtkey");
      
      res.status(200).json({
        token,
        user: other,
        features: features
      });
    });
  });
};



export const logout = (req, res) => {
    res.clearCookie("access_token", {
        sameSite: "none",
        secure: true
    }
        
    ).status(200).json("User has been logged out.");
};

export const salirDispositivo = (req, res) => {
    const q = "UPDATE users SET activo = 0 WHERE username = ?";

    db.query(q, [req.params.username], (err, data) => {
        if (err) return res.status(500).json(err);
        return res.status(200).json("Ha salido el usuario del dispositivo");
    });
};


export const enviarCorreoRestablecimiento = (req, res) => {
    const { email } = req.body;

    console.log("Recibido email:", email); // Log para confirmar el email recibido

    const sqlSelect = "SELECT * FROM users WHERE email = ?";
    db.query(sqlSelect, [email], (err, data) => {
        if (err) {
            console.error("Error en la consulta SQL:", err);
            return res.status(500).json("Error en el servidor.");
        }
        if (data.length === 0) return res.status(404).json("Usuario no encontrado.");

        // Generar un token numérico de 4 cifras
        const resetToken = Math.floor(1000 + Math.random() * 9000).toString();

        const sqlUpdate = "UPDATE users SET password_reset_token = ? WHERE email = ?";
        db.query(sqlUpdate, [resetToken, email], (err) => {
            if (err) {
                console.error("Error al actualizar token:", err);
                return res.status(500).json("Error al actualizar el token.");
            }

            // Configurar y enviar el correo
            const transporter = nodemailer.createTransport({
                service: "gmail",
                auth: {
                    user: "kalexandervargas@gmail.com",
                    pass: "dniajoxqdawpjchm",
                },
            });

            const mailOptions = {
                from: "kalexandervargas@gmail.com",
                to: email,
                subject: "Restablecimiento de Contraseña",
                html: `
                  <div style="background: linear-gradient(0deg, #0D4F02, #002401); padding: 40px; font-family: Arial, sans-serif;">
                    <div style="max-width: 600px; margin: auto; background: white; border-radius: 8px; padding: 20px; box-shadow: 0px 4px 8px rgba(0,0,0,0.2);">
                      <h1 style="color: #0D4F02; text-align: center;">Restablecimiento de Contraseña</h1>
                      <p style="font-size: 16px; color: #333;">Hola,</p>
                      <p style="font-size: 16px; color: #333;">
                        Hemos recibido una solicitud para restablecer tu contraseña. Por favor, utiliza el siguiente código para completar el proceso:
                      </p>
                      <div style="text-align: center; margin: 20px 0;">
                        <span style="font-size: 20px; font-weight: bold; color: #0D4F02;">${resetToken}</span>
                      </div>
                      <p style="font-size: 16px; color: #333;">
                        Si no solicitaste este restablecimiento, ignora este correo.
                      </p>
                      <p style="text-align: center; color: #0D4F02; font-size: 14px;">
                        © 2025 - Universidad de las Fuerzas Armadas ESPE
                      </p>
                    </div>
                  </div>
                `,
            };

            transporter.sendMail(mailOptions, (error, info) => {
                if (error) {
                    console.error("Error al enviar correo:", error);
                    return res.status(500).json("Error al enviar el correo.");
                }
                res.status(200).json("Correo de restablecimiento enviado.");
            });
        });
    });
};


export const resetPassword = (req, res) => {
    const { token, password } = req.body;

    const q = "SELECT * FROM users WHERE password_reset_token = ?";
    db.query(q, [token], (err, data) => {
        if (err || data.length === 0) return res.status(404).json("Token no válido.");

        // Encriptar nueva contraseña
        const salt = bcrypt.genSaltSync(10);
        const hash = bcrypt.hashSync(password, salt);

        const sqlUpdate = "UPDATE users SET password = ?, password_reset_token = NULL WHERE password_reset_token = ?";
        db.query(sqlUpdate, [hash, token], (err) => {
            if (err) return res.status(500).json(err);
            res.status(200).json("Contraseña restablecida exitosamente.");
        });
    });
};

export const verifyToken = (req, res) => {
    const { token } = req.body;
  
    const q = "SELECT * FROM users WHERE password_reset_token = ?";
    db.query(q, [token], (err, data) => {
      if (err || data.length === 0) return res.status(404).json("Token no válido.");
      res.status(200).json("Token válido.");
    });
  };


  export const registerSuperadmin = (req, res) => {
    const { username, password, name, lastname } = req.body;
  
    // 1) Verificar si ya existe el usuario
    const q = "SELECT * FROM users WHERE username = ?";
    db.query(q, [username], (err, data) => {
      if (err) return res.status(500).json(err);
      if (data.length) {
        return res.status(409).json("El usuario ya existe.");
      }
  
      // 2) Encriptar la contraseña con bcrypt
      const salt = bcrypt.genSaltSync(10);
      const hash = bcrypt.hashSync(password, salt);
  
      // 3) Insertar en la BD con rol superadmin
      const sqlInsert = `
        INSERT INTO users (username, email, password, name, lastname, rol)
        VALUES (?, ?, ?, ?, ?, ?);
      `;
  
      // Puedes usar el mismo valor para 'username' y 'email'
      // o poner un correo dummy. Lo importante es cumplir el esquema de tu BD.
      const values = [
        username,          // username
        `${username}@espe.edu.ec`, // email (o lo que gustes)
        hash,             // contraseña encriptada
        name,
        lastname,
        "superadmin"      // Rol final que queremos
      ];
  
      db.query(sqlInsert, values, (err, result) => {
        if (err) return res.status(500).json(err);
        return res.status(200).json("Usuario superadmin creado con éxito.");
      });
    });
  };


 