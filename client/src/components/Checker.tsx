// Checker.tsx
import { useState } from "react";
import { SDK, createDojoStore } from "@dojoengine/sdk";
import { schema, Position } from "../bindings";
import { useDojo } from "../hooks/useDojo";
import GameOver from "../components/GameOver";
import Winner from "../components/Winner";
import { createInitialPieces, PieceUI, Coordinates } from "./InitPieces";
import ControllerButton from '../connector/ControllerButton';

import BackgroundCheckers from "../assets/BackgrounCheckers.png";
import Board from "../assets/Board.png";
import PieceBlack from "../assets/PieceBlack.svg";
import PieceOrange from "../assets/PieceOrange.svg";
import Player1 from "../assets/Player1.png";
import Player2 from "../assets/Player2.png";
import Return from "../assets/Return.png";

export const useDojoStore = createDojoStore<typeof schema>();

function Checker({ }: { sdk: SDK<typeof schema> }) {
  const {
    account: { account },
    setup: { setupWorld },
  } = useDojo();

  const [arePiecesVisible] = useState(true);
  const [isGameOver] = useState(false);
  const [isWinner] = useState(false);
  const [selectedPieceId, setSelectedPieceId] = useState<number | null>(null);
  const [validMoves, setValidMoves] = useState<Coordinates[]>([]);

  // Inicializar piezas usando la función de InitPieces
  const { initialBlackPieces, initialOrangePieces } = createInitialPieces(account.address);
  const [upPieces, setUpPieces] = useState<PieceUI[]>(initialBlackPieces);
  const [downPieces, setDownPieces] = useState<PieceUI[]>(initialOrangePieces);
  
  const cellSize = 88;

  const calculateValidMoves = (piece: PieceUI): Coordinates[] => {
    const moves: Coordinates[] = [];
    const { raw, col } = piece.piece.coordinates;

    if (piece.piece.position === Position.Up) {
      if (raw + 1 < 8) {
        if (col - 1 >= 0) moves.push({ raw: raw + 1, col: col - 1 });
        if (col + 1 < 8) moves.push({ raw: raw + 1, col: col + 1 });
      }
    } else {
      if (raw - 1 >= 0) {
        if (col - 1 >= 0) moves.push({ raw: raw - 1, col: col - 1 });
        if (col + 1 < 8) moves.push({ raw: raw - 1, col: col + 1 });
      }
    }

    return moves;
  };

  const handlePieceClick = async (piece: PieceUI) => {
    const pieceId = piece.id;
    
    if (selectedPieceId === pieceId) {
      setSelectedPieceId(null);
      setValidMoves([]);
    } else {
      setSelectedPieceId(pieceId);
      const moves = calculateValidMoves(piece);
      setValidMoves(moves);
    }

    try {
      if (account) {
        let {raw,col} = piece.piece.coordinates
        const canChoosePiece = await(await setupWorld.actions).canChoosePiece(
          account,
          piece.piece.position,
          { row: raw, col:col  }
        );
        console.log("canChoosePiece", canChoosePiece?.transaction_hash);
      }
    } catch (error) {
      console.error("Error al mover la pieza:", error);
    }
  };

  const handleMoveClick = async (move: Coordinates) => {
    if (selectedPieceId !== null) {
      const selectedPiece = [...upPieces, ...downPieces].find(
        (piece) => piece.id === selectedPieceId
      );

      if (selectedPiece) {
        const piecesToUpdate =
          selectedPiece.piece.position === Position.Up ? upPieces : downPieces;

        const updatedPieces = piecesToUpdate.map((piece) => {
          if (piece.id === selectedPieceId) {
            return {
              ...piece,
              piece: { ...piece.piece, coordinates: move },
            };
          }
          return piece;
        });

        if (selectedPiece.piece.position === Position.Down) {
          setDownPieces(updatedPieces);
        } else {
          setUpPieces(updatedPieces);
        }

        try {
          if (account) {
            const movedPiece = await (await setupWorld.actions).movePiece(
              account,
              selectedPiece.piece,
              move
            );
            console.log("movedPiece", movedPiece?.transaction_hash);
          }
        } catch (error) {
          console.error("Error al mover la pieza:", error);
        }

        setSelectedPieceId(null);
        setValidMoves([]);
      }
    }
  };

  const renderPieces = () => (
    <>
      {upPieces.map((piece) => (
        <img
          key={piece.id}
          src={PieceBlack}
          className="absolute"
          style={{
            left: `${piece.piece.coordinates.col * cellSize + 63}px`,
            top: `${piece.piece.coordinates.raw * cellSize + 65}px`,
            cursor: "pointer",
            width: "60px",
            height: "60px",
            border: selectedPieceId === piece.id ? "2px solid yellow" : "none",
          }}
          onClick={async () => await handlePieceClick(piece)}
        />
      ))}
      {downPieces.map((piece) => (
        <img
          key={piece.id}
          src={PieceOrange}
          className="absolute"
          style={{
            left: `${piece.piece.coordinates.col * cellSize + 63}px`,
            top: `${piece.piece.coordinates.raw * cellSize + 55}px`,
            cursor: "pointer",
            width: "60px",
            height: "60px",
            border: selectedPieceId === piece.id ? "2px solid yellow" : "none",
          }}
          onClick={() => handlePieceClick(piece)}
        />
      ))}
      {validMoves.map((move, index) => (
        <div
          key={index}
          className="absolute border border-green-500"
          style={{
            left: `${move.col * cellSize + 63}px`,
            top: `${move.raw * cellSize + 58}px`,
            width: "60px",
            height: "60px",
            cursor: "pointer",
            backgroundColor: "rgba(0, 255, 0, 0.5)",
          }}
          onClick={() => handleMoveClick(move)}
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
        {/* <ControllerButton /> */}
    
      </div>
      {isGameOver && <GameOver />}
      {isWinner && <Winner />}
      <img
        src={Player1}
        alt="Player 1"
        className="fixed"
        style={{ top: "100px", left: "80px", width: "400px" }}
      />
      <img
        src={Player2}
        alt="Player 2"
        className="fixed"
        style={{ top: "770px", right: "80px", width: "400px" }}
      />
      <div className="flex items-center justify-center h-full">
        <div className="relative">
          <img
            src={Board}
            alt="Board"
            className="w-[800px] h-[800px] object-contain"
          />
          {arePiecesVisible && renderPieces()}
        </div>

        <button
          onClick={() => {
            window.location.href = '/initgame';
          }}
          style={{
            position: 'absolute',
            top: '20px',
            left: '20px',
            background: 'none',
            border: 'none',
            cursor: 'pointer',
            zIndex: 2,
          }}
        >
          <img
            src={Return}
            alt="Return"
            style={{
              width: '50px',
              height: '50px',
            }}
          />
        </button>
      </div>
    </div>
  );
}

export default Checker;