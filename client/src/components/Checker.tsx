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
import QueenBlack from "../assets/QueenBlack.png";  
import QueenOrange from "../assets/QueenOrange.png";  
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
  const [mustCapture, setMustCapture] = useState(false);
  
  const { initialBlackPieces, initialOrangePieces } = createInitialPieces(account.address);
  const [upPieces, setUpPieces] = useState<PieceUI[]>(initialBlackPieces);
  const [downPieces, setDownPieces] = useState<PieceUI[]>(initialOrangePieces);
  
  const cellSize = 88;

  const isCellOccupied = (row: number, col: number): boolean => {
    return [...upPieces, ...downPieces].some(piece => piece.piece.row === row && piece.piece.col === col);
  };

  const calculateQueenMoves = (piece: PieceUI): Coordinates[] => {
    const moves: Coordinates[] = [];
    const directions = [
      [-1, -1], [-1, 1], // Diagonal arriba
      [1, -1], [1, 1]    // Diagonal abajo
    ];

    for (const [deltaRow, deltaCol] of directions) {
      let currentRow = piece.piece.row + deltaRow;
      let currentCol = piece.piece.col + deltaCol;
      
      while (currentRow >= 0 && currentRow < 8 && currentCol >= 0 && currentCol < 8) {
        if (!isCellOccupied(currentRow, currentCol)) {
          moves.push({
            row: currentRow, col: currentCol,
            capturedPiece: undefined,
            isCapture: undefined
          });
        } else {
          // Si encuentra una pieza, verifica si puede capturar
          const isEnemy = isCellOccupiedByEnemy(currentRow, currentCol, piece.piece.position);
          if (isEnemy) {
            const nextRow = currentRow + deltaRow;
            const nextCol = currentCol + deltaCol;
            if (
              nextRow >= 0 && nextRow < 8 && 
              nextCol >= 0 && nextCol < 8 && 
              !isCellOccupied(nextRow, nextCol)
            ) {
              moves.push({
                row: nextRow,
                col: nextCol,
                capturedPiece: { row: currentRow, col: currentCol },
                isCapture: true,
              });
            }
          }
          break;
        }
        currentRow += deltaRow;
        currentCol += deltaCol;
      }
    }
    return moves;
  };

  const calculateCaptureMoves = (piece: PieceUI): Coordinates[] => {
    if (piece.piece.is_king) {
      return calculateQueenMoves(piece).filter(move => move.isCapture);
    }

    const captureMoves: Coordinates[] = [];
    const { row, col } = piece.piece;
    const directions = piece.piece.is_king ? [1, -1] : [piece.piece.position === Position.Up ? 1 : -1];
    
    for (const dir of directions) {
      [-2, 2].forEach(deltaCol => {
        const targetRow = row + (2 * dir);
        const targetCol = col + deltaCol;
        const middleRow = row + dir;
        const middleCol = col + (deltaCol / 2);

        if (
          targetRow >= 0 && targetRow < 8 && 
          targetCol >= 0 && targetCol < 8 && 
          !isCellOccupied(targetRow, targetCol)
        ) {
          const isEnemyPiece = isCellOccupiedByEnemy(middleRow, middleCol, piece.piece.position);
          if (isEnemyPiece) {
            captureMoves.push({ 
              row: targetRow, 
              col: targetCol,
              isCapture: true,
              capturedPiece: { row: middleRow, col: middleCol }
            });
          }
        }
      });
    }
    
    return captureMoves;
  };

  const calculateValidMoves = (piece: PieceUI): Coordinates[] => {
    // Primero verifica si hay capturas disponibles para cualquier pieza
    const allPieces = piece.piece.position === Position.Up ? upPieces : downPieces;
    const hasAnyCaptures = allPieces.some(p => calculateCaptureMoves(p).length > 0);
    
    if (hasAnyCaptures) {
      setMustCapture(true);
      return calculateCaptureMoves(piece);
    }
    
    setMustCapture(false);
    
    if (piece.piece.is_king) {
      return calculateQueenMoves(piece);
    }

    const regularMoves: Coordinates[] = [];
    const { row, col } = piece.piece;
    const direction = piece.piece.position === Position.Up ? 1 : -1;

    [-1, 1].forEach(deltaCol => {
      const newRow = row + direction;
      const newCol = col + deltaCol;
      
      if (
        newRow >= 0 && newRow < 8 && 
        newCol >= 0 && newCol < 8 && 
        !isCellOccupied(newRow, newCol)
      ) {
        regularMoves.push({
          row: newRow, col: newCol,
          capturedPiece: undefined,
          isCapture: undefined
        });
      }
    });

    return regularMoves;
  };

  const isCellOccupiedByEnemy = (row: number, col: number, position: Position): boolean => {
    const enemyPieces = position === Position.Up ? downPieces : upPieces;
    return enemyPieces.some(piece => piece.piece.row === row && piece.piece.col === col);
  };

  const handlePieceClick = async (piece: PieceUI) => {
    if (selectedPieceId === piece.id) {
      setSelectedPieceId(null);
      setValidMoves([]);
      return;
    }

    const moves = calculateValidMoves(piece);
    
    // Si hay capturas obligatorias y esta pieza no tiene capturas, no permitir selección
    if (mustCapture && !moves.some(move => move.isCapture)) {
      return;
    }

    setSelectedPieceId(piece.id);
    setValidMoves(moves);

    try {
      if (account) {
        await (await setupWorld.actions).canChoosePiece(account, piece.piece.position, { row: piece.piece.row, col: piece.piece.col });
      }
    } catch (error) {
      console.error("Error verificando la pieza seleccionada:", error);
    }
  };

  const handleMoveClick = async (move: Coordinates) => {
    if (!selectedPieceId) return;

    const selectedPiece = [...upPieces, ...downPieces].find(piece => piece.id === selectedPieceId);
    if (!selectedPiece) return;
    console.log("Moviendo la pieza:", selectedPiece);

    const piecesToUpdate = selectedPiece.piece.position === Position.Up ? upPieces : downPieces;
    const enemyPieces = selectedPiece.piece.position === Position.Up ? downPieces : upPieces;

    // Manejar captura
    if (move.isCapture && move.capturedPiece) {
      const updatedEnemyPieces = enemyPieces.filter(
        piece => !(piece.piece.row === move.capturedPiece.row && piece.piece.col === move.capturedPiece.col)
      );
      
      if (selectedPiece.piece.position === Position.Up) {
        setDownPieces(updatedEnemyPieces);
      } else {
        setUpPieces(updatedEnemyPieces);
      }
    }

    // Actualizar posición de la pieza movida
    const shouldPromoteToQueen = 
      (selectedPiece.piece.position === Position.Up && move.row === 7) ||
      (selectedPiece.piece.position === Position.Down && move.row === 0);

    const updatedPieces = piecesToUpdate.map((piece: PieceUI) => {
      if (piece.id === selectedPieceId) {
        return {
          ...piece,
          piece: {
            ...piece.piece,
            row: move.row,
            col: move.col,
            is_king: shouldPromoteToQueen || piece.piece.is_king
          }
        };
      }
      return piece;
    });

    if (selectedPiece.piece.position === Position.Up) {
      setUpPieces(updatedPieces);
    } else {
      setDownPieces(updatedPieces);
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
  };

  return (
    <div
      className="relative h-screen w-full"
      style={{
        backgroundImage: `url(${BackgroundCheckers})`,
        backgroundSize: "cover",
        backgroundPosition: "center",      }}
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
          {arePiecesVisible && (
            <>
              {upPieces.map((piece) => (
                <img
                  key={piece.id}
                  src={piece.piece.is_king ? QueenBlack : PieceBlack}
                  className="absolute"
                  style={{
                    left: `${piece.piece.col * cellSize + 63}px`,
                    top: `${piece.piece.row * cellSize + 63}px`,
                    cursor: "pointer",
                    width: "60px",
                    height: "60px",
                    border: selectedPieceId === piece.id ? "2px solid yellow" : "none",
                  }}
                  onClick={() => handlePieceClick(piece)}
                />
              ))}
              {downPieces.map((piece) => (
                <img
                  key={piece.id}
                  src={piece.piece.is_king ? QueenOrange : PieceOrange}
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
                  key={`move-${index}`}
                  className="absolute"
                  style={{
                    left: `${move.col * cellSize + 63}px`,
                    top: `${move.row * cellSize + 63}px`,
                    width: "60px",
                    height: "60px",
                    backgroundColor: move.isCapture ? "rgba(255, 0, 0, 0.3)" : "rgba(0, 255, 0, 0.3)",
                    borderRadius: "50%",
                    cursor: "pointer",
                  }}
                  onClick={() => handleMoveClick(move)}
                />
              ))}
            </>
          )}
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