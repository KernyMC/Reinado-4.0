import { createBrowserRouter, Outlet, RouterProvider } from "react-router-dom";
import Register from "./pages/Register";
import Login from "./pages/Login";
import Recovery from "./pages/Recovery";
import ResetPassword from "./pages/ResetPassword";
import TTipico from "./pages/TTipico";
import TGala from "./pages/TGala";
import Preguntas from "./pages/Preguntas";
import Carrusel from "./pages/Carrusel";
import CRGGala from './pages/CRGGala';
import CRGTipico from './pages/CRGTipico';
import CRGBarra from './pages/CRGBarra';
import CRGDesempate from './pages/CRGDesempate';
import CRGPublica from './pages/CRGPublica';
import VotacionPublica from "./pages/VotacionPublica";
import Gracias from "./pages/Gracias";
import Navbar from "./components/Navbar";

import Reporte from "./pages/Reporte";
import "./style.scss";
import TablaNotario from "./pages/TablaNotario";
import PanelAdmin from "./pages/PanelAdmin";
import Desempate from "./pages/Desempate";
import ProtectedRoute from "./components/ProtectedRoute";

const Layout = () => {
  return (
    <>
      <Outlet />
    </>
  );
};

const Layout2 = () => {
  return (
    <>
      <Navbar />
      <Outlet />
    </>
  );
};

const router = createBrowserRouter([
  {
    path: "/",
    element: <Layout />,
    children: [
      {
        path: "/",
        element: <Login />,
      },
      {
        path: "/TrajeTipico",
        element: (
          <ProtectedRoute allowedRoles={["juez", "admin"]}>
            <TTipico />
          </ProtectedRoute>
        ),
      },
      {
        path: "/TrajeGala",
        element: (
          <ProtectedRoute allowedRoles={["juez", "admin"]}>
            <TGala />
          </ProtectedRoute>
        ),
      },
      {
        path: "/Desempate",
        element: (
          <ProtectedRoute allowedRoles={["juez", "admin"]}>
            <Desempate />
          </ProtectedRoute>
        ),
      },
      {
        path: "/Preguntas",
        element: (
          <ProtectedRoute allowedRoles={["juez", "admin"]}>
            <Preguntas />
          </ProtectedRoute>
        ),
      },
      {
        path: "/Carrusel",
        element: (
          <ProtectedRoute allowedRoles={["juez", "admin"]}>
            <Carrusel />
          </ProtectedRoute>
        ),
      },
      {
        path: "/CRG_Gala",
        element: (
          <ProtectedRoute allowedRoles={["juez"]}>
            <CRGGala/>
          </ProtectedRoute>
        ),
      },
      {
        path: "/CRG_Tipico",
        element: (
          <ProtectedRoute allowedRoles={["juez"]}>
            <CRGTipico />
          </ProtectedRoute>
        ),
      },
      {
        path: "/CRG_Barra",
        element: (
          <ProtectedRoute allowedRoles={["juez"]}>
            <CRGBarra />
          </ProtectedRoute>
        ),
      },
      {
        path: "/CRG_DEsempate",
        element: (
          <ProtectedRoute allowedRoles={["juez"]}>
            <CRGDesempate />
          </ProtectedRoute>

        ),
      },
      {
        path: "/CRG_Publica",
        element: (
          <ProtectedRoute allowedRoles={["usuario"]}>
            <CRGPublica />
          </ProtectedRoute>
        ),
      },
      {
        path: "/VotacionPublica",
        element: (
          <ProtectedRoute allowedRoles={["usuario"]}>
            <VotacionPublica />
          </ProtectedRoute>
        ),
      },
      {
        path: "/Gracias",
        element: <Gracias />,
      },
    ],
  },
  {
    path: "/",
    element: <Layout2 />,
    children: [
      {
        path: "/TablaNotario",
        element: (
          <ProtectedRoute allowedRoles={["notario", "admin"]}>
            <TablaNotario />
          </ProtectedRoute>
        ),
      },
      {
        path: "/Reporte",
        element: (
          <ProtectedRoute allowedRoles={["admin"]}>
            <Reporte />
          </ProtectedRoute>
        ),
      },
      {
        path: "/PanelAdmin",
        element: (
          <ProtectedRoute allowedRoles={["admin"]}>
            <PanelAdmin />
          </ProtectedRoute>
        ),
      },
    ],
  },
  {
    path: "/login",
    element: <Login />,
  },
  {
    path: "/register",
    element: <Register />,
  },
  {
    path: "/recovery",
    element: <Recovery />,
  },
  {
    path: "/reset-password",
    element: <ResetPassword />,
  },
]);

function App() {
  return (
    <div className="app">
      <div className="container">
        <RouterProvider router={router} />
      </div>
    </div>
  );
}

export default App;