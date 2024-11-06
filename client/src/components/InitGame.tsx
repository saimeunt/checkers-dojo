import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import CreateBurner from "../connector/CreateBurner";
import InitGameBackground from "../assets/InitGameBackground.png";
import { SDK, createDojoStore } from "@dojoengine/sdk";
import CreateGame from "../assets/CreateGame.png";
import CreateGame2 from "../assets/CreateGame2.png";
import JoinGame from "../assets/JoinGame.png";
import JoinGame2 from "../assets/JoinGame2.png";
import ControllerButton from '../connector/ControllerButton';
import Title from '../assets/Title.png';
import { schema } from "../bindings.ts";
import { useSystemCalls } from "../hooks/useSystemCalls.ts";
import { useDojo } from "../hooks/useDojo.tsx";

export const useDojoStore = createDojoStore<typeof schema>();

function InitGame({ }: { sdk: SDK<typeof schema> }) {
  const { account } = useDojo();
  const { spawn } = useSystemCalls();
  const navigate = useNavigate();

  // Estados para controlar el hover
  const [isHoveredCreate, setIsHoveredCreate] = useState(false);
  const [isHoveredJoin, setIsHoveredJoin] = useState(false);

  const handleCreateGame = async () => {
    try {
      if (account) {
        await spawn();
        console.log("Juego creado con éxito.");
        navigate('/checkers');
      } else {
        console.warn("Cuenta no conectada");
      }
    } catch (error) {
      console.error("Error al crear el juego:", error);
    }
  };

  return (
    <div
      style={{
        backgroundImage: `url(${InitGameBackground})`,
        backgroundSize: "cover",
        backgroundPosition: "center",
        height: "100vh",
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
        justifyContent: "flex-start",
        position: "relative",
        overflow: "hidden",
      }}
    >
      <div
        style={{
          position: 'absolute',
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          backgroundColor: 'rgba(0, 0, 0, 0.5)',
          zIndex: 0,
        }}
      />

      <img
        src={Title}
        alt="Título"
        style={{
          zIndex: 2,
          marginTop: '60px',
          width: 'auto',
          height: '100px',
        }}
      />

      {/* Sección superior derecha con CreateBurner y ControllerButton */}
      <div
        style={{
          position: 'absolute',
          top: '20px',
          right: '20px',
          display: 'flex',
          gap: '20px',
          zIndex: 2,
        }}
      >
        <ControllerButton />
        <CreateBurner />
      </div>

      {/* Botón de "Crear Juego" */}
      <img
        src={isHoveredCreate ? CreateGame : CreateGame2}
        alt="Crear Juego"
        onClick={handleCreateGame}
        onMouseEnter={() => setIsHoveredCreate(true)}
        onMouseLeave={() => setIsHoveredCreate(false)}
        style={{
          position: 'absolute',
          top: '40%',
          left: '50%',
          transform: `translate(-50%, -50%) scale(${isHoveredCreate ? 1.1 : 1})`, // Zoom hacia adelante
          width: '700px',
          height: 'auto',
          zIndex: 2,
          cursor: 'pointer',
          transition: 'transform 0.2s',
        }}
      />

      {/* Botón de "Unirse al Juego" */}
      <img
        src={isHoveredJoin ? JoinGame2 : JoinGame}
        alt="Unirse al Juego"
        onMouseEnter={() => setIsHoveredJoin(true)}
        onMouseLeave={() => setIsHoveredJoin(false)}
        style={{
          position: 'absolute',
          top: '60%', // Ajustado para que esté debajo del botón de "Crear Juego"
          left: '50%',
          transform: `translate(-50%, -50%) scale(${isHoveredJoin ? 1.1 : 1})`, // Zoom hacia adelante
          width: '700px',
          height: 'auto',
          zIndex: 2,
          cursor: 'pointer',
          transition: 'transform 0.2s',
        }}
      />
    </div>
  );
}

export default InitGame;