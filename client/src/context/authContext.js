import axios from "axios";
import { createContext, useEffect, useState } from "react";

export const AuthContext = createContext();

export const AuthContexProvider = ({ children }) => {
  const [currentUser, setCurrentUser] = useState(
    JSON.parse(localStorage.getItem("user")) || null
  );

  const login = async (inputs) => {
    try {
      const res = await axios.post("/auth/login", inputs);
      setCurrentUser(res.data.user); // Asegúrate de que el backend devuelve un objeto con `user`
      return res.data.user; // Devuelve los datos del usuario para su manejo en el frontend
    } catch (err) {
      throw err; // Propaga el error para manejarlo en el frontend
    }
  };

  const logout = async () => {
    try {
      await axios.put(`/auth/${currentUser.username}`); // Cambia estado en el backend si es necesario
      await axios.post("/auth/logout");
      setCurrentUser(null);
    } catch (err) {
      console.error("Error al cerrar sesión:", err);
    }
  };

  useEffect(() => {
    localStorage.setItem("user", JSON.stringify(currentUser));
  }, [currentUser]);

  return (
    <AuthContext.Provider value={{ currentUser, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
};