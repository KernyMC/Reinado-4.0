import React from "react";
import Carta from "../img/carta.png"
import Llamada from "../img/llamada-telefonica.png"
import Ubicacion from "../img/ubicacion.png"

const Footer =()=>{
    return(
        <footer>            
            <img src={Ubicacion} alt="" />
            <span>Universidad de las Fuerzas Armadas</span>
            <img src={Carta} alt="" />
            <span>help.ayudaestudiantil@gmail.com</span>
            <img src={Llamada} alt="" />
            <span>099 504 7657 - 096 963 6094</span>
            
            
        </footer>
    )

}
export default Footer