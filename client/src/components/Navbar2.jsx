import React, { useContext } from "react";
import { Link } from "react-router-dom";
import { AuthContext } from "../context/authContext";
import Logo from "../img/logoespereina.png";

const Navbar2 = (props) => {
  const { currentUser, logout } = useContext(AuthContext);
  return (
    <div>
      <div className='barraNavegacion'>
        <div className="logo1">
          <img src={Logo} alt="Logo Espereina" />
        </div>
        <h1>{props.texto}</h1>
      </div>

       <div className='barraNavegacion2'>
      </div>
      <div className='logueo'>
      <span>{"👤" + currentUser?.username}</span>
          {currentUser ? (
            <span onClick={logout}>Cerrar Sesion</span>
          ) : (
            <Link className="link" to="/login">
              Inicio Sesion
            </Link>
          )}
      </div>

      <nav class="menu">
        <input type="checkbox" href="#" class="menu-open" name="menu-open" id="menu-open" />
        <label class="menu-open-button" for="menu-open">
          <span class="hamburger hamburger-1"></span>
          <span class="hamburger hamburger-2"></span>
          
        </label>


        <span className="menu-item"><Link className="link" to="/TablaNotario"><h6>TABLA</h6></Link></span>
        <span className="menu-item"><Link className="link" to="/Register"><h6>REGISTRARSE</h6></Link></span>
        
        

      </nav>

      <svg xmlns="http://www.w3.org/2000/svg" version="1.1">
        <defs>
          <filter id="shadowed-goo">

            <feGaussianBlur in="SourceGraphic" result="blur" stdDeviation="10" />
            <feColorMatrix in="blur" mode="matrix" values="1 0 0 0 0  0 1 0 0 0  0 0 1 0 0  0 0 0 18 -7" result="goo" />
            <feGaussianBlur in="goo" stdDeviation="3" result="shadow" />
            <feColorMatrix in="shadow" mode="matrix" values="0 0 0 0 0  0 0 0 0 0  0 0 0 0 0  0 0 0 1 -0.2" result="shadow" />
            <feOffset in="shadow" dx="1" dy="1" result="shadow" />
            <feComposite in2="shadow" in="goo" result="goo" />
            <feComposite in2="goo" in="SourceGraphic" result="mix" />
          </filter>
          <filter id="goo">
            <feGaussianBlur in="SourceGraphic" result="blur" stdDeviation="10" />
            <feColorMatrix in="blur" mode="matrix" values="1 0 0 0 0  0 1 0 0 0  0 0 1 0 0  0 0 0 18 -7" result="goo" />
            <feComposite in2="goo" in="SourceGraphic" result="mix" />
          </filter>
        </defs>
      </svg>

     





    </div>
    






  );
};
export default Navbar2;
