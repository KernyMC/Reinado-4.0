import React from 'react'
// import "./carrusel.css"

function CarruselItem( {item}) {
  function cortarParteDerecha(cadena) {
    let parteDerecha = '';
    let i = cadena.length - 1;
  
    while (i >= 0 && cadena[i] !== '\\') {
      parteDerecha = cadena[i] + parteDerecha;
      i--;
    }
  
    return parteDerecha;
  }
  return (
    <div className='carousel-item'>
        <div></div>
        <figure className='carousel-img'>
          <img src={'/reinas/'+cortarParteDerecha(item.FOTO_URL)} alt = "imagen"/>
        </figure>
    </div>
  );
};

export default CarruselItem;