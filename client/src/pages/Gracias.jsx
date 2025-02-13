import { useContext, useState, useEffect } from "react";
import React from "react";
import { AuthContext } from "../context/authContext";
import "./Gracias.scss";
import logoEspeBarra from "../img/logoespereina.png";
import Confetti from "react-confetti";
import { Box } from "@mui/material";
const Gracias = () => {
  const { currentUser } = useContext(AuthContext);
  const [showConfetti, setShowConfetti] = useState(true);

  useEffect(() => {
    const confettiDuration = 6000;

    const timeout = setTimeout(() => {
      setShowConfetti(false);
    }, confettiDuration);

    return () => clearTimeout(timeout);
  }, []);

  if (
    currentUser === null ||
    (currentUser.rol !== "juez" && currentUser.rol !== "admin")
  ) {
    return (
      <div classNameName="App">
        <main>
          <div>
            <h1>Lo sentimos, no tienes permiso para ver esta página.</h1>
          </div>
        </main>
      </div>
    );
  } else {
    return (
      <>
        {
          <div
            className="contenedorGracias"
            style={{ width: "100%", height: "100vh", overflowX: "hidden" }}
          >
            {showConfetti && (
              <Confetti
                width={window.innerWidth}
                height={window.innerHeight}
                recycle={true}
                gravity={0.02}
                numberOfPieces={300}
                friction={0.99}
              />
            )}
            <section className="intro">
              Muchas gracias por su participación en el concurso de la Elección
              de la Reina ESPE 2024
            </section>
            <section className="logoEspeBarra">
              <img src={logoEspeBarra} alt="Logo de la ESPE de la Reina" />
            </section>
            <Box sx={{ justifyContent: 'flex-end' }}>
            <div id="scroller">
              <div id="content">

                <h1 id="subtitle">Desarrolladores Principales</h1>
                
                <p id="nombreMiembro">Luca De Veintemilla</p>
                <p id="nombreMiembro">Dylan Hernández</p>
                <p id="nombreMiembro">Juan Reyes</p>
                <p id="nombreMiembro">Kevin Vargas</p>

                <h1 id="subtitle">Equipo de Apoyo del DCCO</h1>
                
                <p id="nombreMiembro">PhD. Sonia Cárdenas</p>
                <p id="nombreMiembro">PhD. Mauricio Loachamín</p>

                <h1 id="subtitle">Arquitectura de Red del Proyecto</h1>
                <p id="nombreMiembro">PhD. Gustavo Salazar</p>
              </div>
            </div>
            </Box>
            
          </div>
        }
      </>
    );
  }
};
export default Gracias;