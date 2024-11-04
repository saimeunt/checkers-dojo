import React, { useEffect, useState } from "react";
import { SDK, createDojoStore } from "@dojoengine/sdk";
import BackgroundCheckers from "../assets/BackgrounCheckers.png";
import Board from "../assets/Board.png";
import PieceBlack from "../assets/PieceBlack.svg";
import PieceOrange from "../assets/PieceOrange.svg";
import Player1 from "../assets/Player1.png";
import Player2 from "../assets/Player1.png";
import GameOver from "../components/GameOver";
import Winner from "../components/Winner";
import useDojoConnect from "../hooks/useDojoConnect";
import { schema } from "../bindings.ts";

// Crea el store de Dojo
export const useDojoStore = createDojoStore<typeof schema>();

interface CheckerProps {
  sdk: SDK<any>;
}

const Checker: React.FC<CheckerProps> = ({ sdk }) => {
  const { position } = useDojoConnect({ sdk }); // Solo obtiene la posición del juego
  const [arePiecesVisible, setArePiecesVisible] = useState(false);
  const [isGameOver] = useState(false);
  const [isWinner] = useState(false);

  useEffect(() => {
    if (position) {
      setArePiecesVisible(true);
    }
  }, [position]);

  // Definición de las posiciones iniciales de las piezas
  interface Position {
    row: number;
    col: number;
  }

  interface Piece {
    id: number;
    color: string;
    position: Position;
  }

  const initialBlackPieces: Piece[] = [
    { id: 1, color: "black", position: { row: 0, col: 1 } },
    { id: 2, color: "black", position: { row: 0, col: 3 } },
    { id: 3, color: "black", position: { row: 0, col: 5 } },
    { id: 4, color: "black", position: { row: 0, col: 7 } },
    { id: 5, color: "black", position: { row: 1, col: 0 } },
    { id: 6, color: "black", position: { row: 1, col: 2 } },
    { id: 7, color: "black", position: { row: 1, col: 4 } },
    { id: 8, color: "black", position: { row: 1, col: 6 } },
    { id: 9, color: "black", position: { row: 2, col: 1 } },
    { id: 10, color: "black", position: { row: 2, col: 3 } },
    { id: 11, color: "black", position: { row: 2, col: 5 } },
    { id: 12, color: "black", position: { row: 2, col: 7 } },
  ];

  const initialOrangePieces: Piece[] = [
    { id: 13, color: "orange", position: { row: 5, col: 0 } },
    { id: 14, color: "orange", position: { row: 5, col: 2 } },
    { id: 15, color: "orange", position: { row: 5, col: 4 } },
    { id: 16, color: "orange", position: { row: 5, col: 6 } },
    { id: 17, color: "orange", position: { row: 6, col: 1 } },
    { id: 18, color: "orange", position: { row: 6, col: 3 } },
    { id: 19, color: "orange", position: { row: 6, col: 5 } },
    { id: 20, color: "orange", position: { row: 6, col: 7 } },
    { id: 21, color: "orange", position: { row: 7, col: 0 } },
    { id: 22, color: "orange", position: { row: 7, col: 2 } },
    { id: 23, color: "orange", position: { row: 7, col: 4 } },
    { id: 24, color: "orange", position: { row: 7, col: 6 } },
  ];

  const [blackPieces] = useState<Piece[]>(initialBlackPieces);
  const [orangePieces] = useState<Piece[]>(initialOrangePieces);
  const [selectedPieceId, setSelectedPieceId] = useState<number | null>(null);

  const cellSize = 88;

  const handlePieceClick = (pieceId: number) => {
    setSelectedPieceId(selectedPieceId === pieceId ? null : pieceId);
  };

  const renderPieces = () => (
    <>
      {blackPieces.map((piece) => (
        <img
          key={piece.id}
          src={PieceBlack}
          alt={`${piece.color} piece`}
          className="absolute"
          style={{
            left: `${piece.position.col * cellSize + 63}px`,
            top: `${piece.position.row * cellSize + 65}px`,
            cursor: "pointer",
            width: "60px",
            height: "60px",
            border: selectedPieceId === piece.id ? "2px solid yellow" : "none",
          }}
          onClick={() => handlePieceClick(piece.id)}
        />
      ))}
      {orangePieces.map((piece) => (
        <img
          key={piece.id}
          src={PieceOrange}
          alt={`${piece.color} piece`}
          className="absolute"
          style={{
            left: `${piece.position.col * cellSize + 63}px`,
            top: `${piece.position.row * cellSize + 55}px`,
            cursor: "pointer",
            width: "60px",
            height: "60px",
            border: selectedPieceId === piece.id ? "2px solid yellow" : "none",
          }}
          onClick={() => handlePieceClick(piece.id)}
        />
      ))}
    </>
  );

  return (
    <div
      className="relative h-screen w-full"
      style={{
        backgroundImage: `url(${BackgroundCheckers})`,
        backgroundSize: "cover",
        backgroundPosition: "center",
      }}
    >
      {isGameOver && <GameOver />}
      {isWinner && <Winner />}
      <img src={Player1} alt="Player 1" className="fixed" style={{ top: "100px", left: "80px", width: "400px" }} />
      <img src={Player2} alt="Player 2" className="fixed" style={{ top: "770px", right: "80px", width: "400px" }} />
      <div className="flex items-center justify-center h-full">
        <div className="relative">
          <img src={Board} alt="Board" className="w-[800px] h-[800px] object-contain" />
          {arePiecesVisible && renderPieces()}
        </div>
      </div>
    </div>
  );
};

export default Checker;
