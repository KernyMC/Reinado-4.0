import React, { useContext } from "react";
import { Link, useNavigate } from "react-router-dom";
import { AuthContext } from "../context/authContext";
import Logo from "../img/logoespereina.png";

const Navbar = (props) => {
  const { currentUser, logout } = useContext(AuthContext);
  const navigate = useNavigate();
  const redirect = () => {
    logout();
    navigate("/");
  } 
  return (
    <div>
      <div className='barraNavegacion'>
        <div className="logoContainer" id="logoNav">
          <img src={Logo} alt="Logo Espereina" />
        </div>
        <div className="titleContainer">
          <h1>{props.texto}</h1>
        </div>
        <div className="userContainer">
          {<div className='logueo'>
            <br />
            <span>{currentUser?.name + " " + currentUser?.lastname}</span>
            <br />
            {currentUser ? (
              <span className='cerrarSesion' onClick={() => {redirect()}}><i>Cerrar Sesión</i></span>
            ) : (
              <Link className="link" to="/login">
                Inicio Sesion
              </Link>
            )}
          </div>}
        </div>
      </div>
    </div>
  );
};
export default Navbar;