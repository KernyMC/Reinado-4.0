import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import axios from "axios";
import "./register.scss";
import { API_BASE_URL } from "./ip.js";

const Register = () => {
  const [inputs, setInputs] = useState({
    email: "",
    password: "",
    nombre: "",
    lastname: "",
  });
  const [err, setError] = useState(null);
  const navigate = useNavigate();

  const handleChange = (e) => {
    setInputs((prev) => ({ ...prev, [e.target.name]: e.target.value }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await axios.post(`${API_BASE_URL}/auth/register`, inputs);
      navigate("/login");
    } catch (err) {
      setError(err.response.data);
    }
  };

  return (
    <div className="contenedor-registro1">
      <div className="rect-negro1">
        <img className="logoespereina1" src={require("../img/logoespereina.png")} alt="Logo ESPE REINA" />
      </div>
      <div className="container1">
        <div className="title">Registro</div>
        <div className="content">
          <form onSubmit={handleSubmit}>
            <div className="user-details">
              <div className="input-box">
                <span className="details">Correo Institucional</span>
                <input
                  required
                  type="email"
                  placeholder="correo@espe.edu.ec"
                  name="email"
                  onChange={handleChange}
                />
              </div>
              <div className="input-box">
                <span className="details">Contraseña</span>
                <input
                  required
                  type="password"
                  placeholder="contraseña"
                  name="password"
                  onChange={handleChange}
                />
              </div>
              <div className="input-box">
                <span className="details">Nombre</span>
                <input
                  required
                  type="text"
                  placeholder="nombre"
                  name="nombre"
                  onChange={handleChange}
                />
              </div>
              <div className="input-box">
                <span className="details">Apellido</span>
                <input
                  required
                  type="text"
                  placeholder="apellido"
                  name="lastname"
                  onChange={handleChange}
                />
              </div>
            </div>
            <div id="boton-de-registro" className="boton-siguiente">
              <button type="submit">Registrate</button>
              {err && <p>{err}</p>}
            </div>
          </form>
        </div>
      </div>
    </div>
  );
};

export default Register;