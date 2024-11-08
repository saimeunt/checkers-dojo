import { useState } from "react";
import { SDK, createDojoStore } from "@dojoengine/sdk";
import { schema, Position } from "../bindings";
import { useDojo } from "../hooks/useDojo";
import GameOver from "../components/GameOver";
import Winner from "../components/Winner";
import { createInitialPieces, PieceUI, Coordinates } from "./InitPieces";
import ControllerButton from '../connector/ControllerButton';
import CaptureMoves from "./CaptureMove";

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
  
  const { initialBlackPieces, initialOrangePieces } = createInitialPieces(account.address);
  const [upPieces, setUpPieces] = useState<PieceUI[]>(initialBlackPieces);
  const [downPieces, setDownPieces] = useState<PieceUI[]>(initialOrangePieces);
  
  const cellSize = 88;

  const isCellOccupied = (row: number, col: number): boolean => {
    return [...upPieces, ...downPieces].some(piece => piece.piece.row === row && piece.piece.col === col);
  };

  const calculateValidMoves = (piece: PieceUI): Coordinates[] => {
    const regularMoves: Coordinates[] = [];
    const captureMoves = calculateCaptureMoves(piece);
  
    if (captureMoves.length > 0) {
      return captureMoves;
    }
  
    const { row, col } = piece.piece;
    const direction = piece.piece.position === Position.Up ? 1 : -1;
  
    if (row + direction >= 0 && row + direction < 8) {
      if (col - 1 >= 0 && !isCellOccupied(row + direction, col - 1)) {
        regularMoves.push({ row: row + direction, col: col - 1 });
      }
      if (col + 1 < 8 && !isCellOccupied(row + direction, col + 1)) {
        regularMoves.push({ row: row + direction, col: col + 1 });
      }
    }
  
    return regularMoves;
  };
  
  const calculateCaptureMoves = (piece: PieceUI): Coordinates[] => {
    const captureMoves: Coordinates[] = [];
    const { row, col } = piece.piece;
    const direction = piece.piece.position === Position.Up ? 1 : -1;

    if (row + 2 * direction >= 0 && row + 2 * direction < 8) {
      if (col - 2 >= 0) {
        const enemyRow = row + direction;
        const enemyCol = col - 1;
        const targetRow = row + 2 * direction;
        const targetCol = col - 2;
  
        const isEnemyPiece = isCellOccupiedByEnemy(enemyRow, enemyCol, piece.piece.position);
        const isTargetEmpty = !isCellOccupied(targetRow, targetCol);
        if (isEnemyPiece && isTargetEmpty) {
          captureMoves.push({ row: targetRow, col: targetCol });
        }
      }
      if (col + 2 < 8) {
        const enemyRow = row + direction;
        const enemyCol = col + 1;
        const targetRow = row + 2 * direction;
        const targetCol = col + 2;
  
        const isEnemyPiece = isCellOccupiedByEnemy(enemyRow, enemyCol, piece.piece.position);
        const isTargetEmpty = !isCellOccupied(targetRow, targetCol);
        if (isEnemyPiece && isTargetEmpty) {
          captureMoves.push({ row: targetRow, col: targetCol });
        }
      }
    }
  
    return captureMoves;
  };
  
  const isCellOccupiedByEnemy = (row: number, col: number, position: Position): boolean => {
    const enemyPieces = position === Position.Up ? downPieces : upPieces;
    return enemyPieces.some(piece => piece.piece.row === row && piece.piece.col === col);
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
        const { row, col } = piece.piece;
        await (await setupWorld.actions).canChoosePiece(account, piece.piece.position, { row, col });
      }
    } catch (error) {
      console.error("Error verificando la pieza seleccionada:", error);
    }
  };
  

  const handleMoveClick = async (move: Coordinates) => {
    if (selectedPieceId !== null) {
      const selectedPiece = [...upPieces, ...downPieces].find(
        (piece) => piece.id === selectedPieceId
      );
  
      if (selectedPiece) {
        console.log("Moviendo la pieza:", selectedPiece);

        const piecesToUpdate =
          selectedPiece.piece.position === Position.Up ? upPieces : downPieces;
  
        const updatedPieces = piecesToUpdate.map((piece: PieceUI) => {
          if (piece.id === selectedPieceId) {
            return {
              ...piece,
              piece: { ...piece.piece, row: move.row, col: move.col },
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
            console.log(
              movedPiece.transaction_hash,
              "movePiece transaction_hash success"
            );
          }
        } catch (error) {
          console.error("Error al mover la pieza:", error);
        }
  
        setSelectedPieceId(null);
        setValidMoves([]);
      }
    }
  };

  const handleCapture = async (move: Coordinates, capturedPiece: PieceUI) => {

    const updatePieces = (pieces: PieceUI[]) =>
      pieces.filter((piece) => piece.id !== capturedPiece.id);

    if (capturedPiece.piece.position === Position.Up) {
      setUpPieces(updatePieces(upPieces));
    } else {
      setDownPieces(updatePieces(downPieces));
    }

    await handleMoveClick(move);
  };

  const renderPieces = () => (
    <>
      {upPieces.map((piece) => (
        <img
          key={piece.id}
          src={PieceBlack}
          className="absolute"
          style={{
            left: `${piece.piece.col * cellSize + 63}px`,
            top: `${piece.piece.row * cellSize + 63}px`,
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
            left: `${piece.piece.col * cellSize + 64}px`,
            top: `${piece.piece.row * cellSize + 55}px`,
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
            top: `${move.row * cellSize + 63}px`,
            width: "60px",
            height: "60px",
            cursor: "pointer",
            backgroundColor: "rgba(0, 255, 0, 0.5)",
          }}
          onClick={() => handleMoveClick(move)}
        />
      ))}
      <CaptureMoves
        selectedPiece={selectedPieceId !== null ? [...upPieces, ...downPieces].find(piece => piece.id === selectedPieceId) || null : null}
        upPieces={upPieces}
        downPieces={downPieces}
        cellSize={cellSize}
        onCapture={handleCapture}
      />
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
