import React, { useState } from "react";
import axios from "axios";
import { API_BASE_URL } from "./ip";
import "./recovery.scss";
import Logo from "../img/logoespereina.png";

const Recovery = () => {
  const [email, setEmail] = useState("");
  const [message, setMessage] = useState("");
  const [error, setError] = useState("");

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const res = await axios.post(`${API_BASE_URL}/auth/enviarCorreoRestablecimiento`, { email });
      setMessage(res.data);
      setError("");
    } catch (err) {
      setError(err.response?.data || "Error al procesar la solicitud.");
    }
  };

  return (
    <div className="Recovery">
      <section className="containerR">
        <div className="card-1">
          <div className="rect-negro">
            <div className="negro-imagen">
              <div className="logoContainer" id="logoRecovery">
                <img src={Logo} alt="Logo Espereina" />
              </div>
            </div>
          </div>
          <h2 className="iniciar-sesion">Recuperar Contraseña</h2>
          <div className="contenedorFormulario">
            <form onSubmit={handleSubmit}>
              <div className="input-container">
                <label>Correo Institucional</label>
                <input
                  type="email"
                  name="email"
                  placeholder="correo@espe.edu.ec"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  required
                />
              </div>
              <button className="recoveryBut" type="submit">Enviar Correo</button>
              {message && <p className="success-message">{message}</p>}
              {error && <p className="error-message">{error}</p>}
            </form>
          </div>
        </div>
      </section>
    </div>
  );
};

export default Recovery;
