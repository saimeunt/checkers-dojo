import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import CreateBurner from "../connector/CreateBurner";
import InitGameBackground from "../assets/InitGameBackground.png";
import { SDK } from "@dojoengine/sdk";
import { schema } from "../bindings.ts";
import ControllerButton from '../connector/ControllerButton';
import Title from '../assets/Title.png';
import LoadingCreate from "../assets/LoadingCreate.png";
import ButtonCreate from "../assets/ButtonCreate.png";

// Imágenes de los diferentes jugadores
import Player1 from "../assets/Player1_0.png";
import Player2 from "../assets/Player2_0.png";
import Player3 from "../assets/Player3_0.png";
import Player4 from "../assets/Player4_0.png";

import { useSystemCalls } from "../hooks/useSystemCalls";
import { useDojo } from "../hooks/useDojo";

function CreateGame({ }: { sdk: SDK<typeof schema> }) {
  const { account } = useDojo();
  const { spawn } = useSystemCalls();
  const navigate = useNavigate();
  const [selectedPlayer, setSelectedPlayer] = useState<number | null>(null);
  const [isLoading, setIsLoading] = useState(false);

  const handleCreateGame = async () => {
    try {
      if (account) {
        setIsLoading(true);
        await spawn();
        console.log("Juego creado con éxito.");
        navigate('/initgame');
      } else {
        console.warn("Cuenta no conectada");
      }
    } catch (error) {
      console.error("Error al crear el juego:", error);
    } finally {
      setIsLoading(false);
    }
  };

  const handlePlayerSelect = (playerIndex: number) => {
    setSelectedPlayer(playerIndex);
  };

  // Array con las imágenes de los jugadores
  const playerImages = [Player1, Player2, Player3, Player4];

  return (
    <div
      style={{
        backgroundImage: `url(${InitGameBackground})`,
        backgroundSize: "cover",
        backgroundPosition: "center",
        height: "100vh",
        position: "relative",
        overflow: "hidden",
      }}
    >
      {/* Filtro de fondo oscuro */}
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

      {/* Título del juego */}
      <img
        src={Title}
        alt="Título"
        style={{
          position: 'absolute',
          top: '60px',
          left: '50%',
          transform: 'translateX(-50%)',
          zIndex: 2,
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

      {/* Barra de carga */}
      {isLoading && (
        <img
          src={LoadingCreate}
          alt="Cargando"
          style={{
            position: 'absolute',
            top: '100px',
            left: '50%',
            transform: 'translateX(-50%)',
            width: '100px',
            height: '10px',
            zIndex: 2,
          }}
        />
      )}

      {/* Selección de jugadores */}
      <div
        style={{
          position: 'absolute',
          top: '300px',
          left: '50%',
          transform: 'translateX(-50%)',
          display: 'flex',
          gap: '20px',
          zIndex: 2,
        }}
      >
        {playerImages.map((playerImage, index) => (
          <div
            key={index}
            onClick={() => handlePlayerSelect(index)}
            style={{
              width: '100px',
              height: '100px',
              borderRadius: '10px',
              border: `3px solid ${
                selectedPlayer === index ? '#EE7921' : '#520066'
              }`,
              backgroundImage: `url(${playerImage})`,
              backgroundSize: 'cover',
              cursor: 'pointer',
            }}
          />
        ))}
      </div>

      {/* Botón de "Create Game" */}
      <button
        onClick={handleCreateGame}
        style={{
          position: 'absolute',
          bottom: '200px',
          left: '50%',
          transform: 'translateX(-50%)',
          backgroundImage: `url(${ButtonCreate})`,
          backgroundSize: 'cover',
          color: 'white',
          padding: '46px 279px',
          borderRadius: '5px',
          fontWeight: 'bold',
          cursor: 'pointer',
          border: 'none',
          zIndex: 2,
        }}
      >
      </button>
    </div>
  );
}

export default CreateGame;
