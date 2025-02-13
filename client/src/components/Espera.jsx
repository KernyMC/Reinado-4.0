import React, { useEffect, useState } from "react";
import Logo from "../img/espelogo.png";
import gif from "../img/Reina-Espera.gif";

const Espera = () => {
    return (
        <div id="espera" className="esperaInterfaz">
            <img className = "logo" src={Logo} alt="logo" />
            <div>
                <img className = "gif" src={gif} alt="Gif" />
                <span id="voto">
                    Voto registrado.
                </span>
                <br />
                <span id="wait">
                    Procesando la información...
                </span>
            </div>
        </div>
    )
}

export default Espera;