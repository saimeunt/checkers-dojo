// QueenMoves.tsx
import React, { useEffect, useState } from 'react';
import { PieceUI, Coordinates } from './InitPieces';
import { Position } from '../bindings';

interface QueenMovesProps {
  queenPiece: PieceUI;
  cellSize: number;
  onMove: (move: Coordinates) => void;
  onCapture: (move: Coordinates, capturedPiece: PieceUI) => void;
  upPieces: PieceUI[];
  downPieces: PieceUI[];
}

const QueenMoves: React.FC<QueenMovesProps> = ({
  queenPiece,
  cellSize,
  onMove,
  onCapture,
  upPieces,
  downPieces
}) => {
  const [queenMoves, setQueenMoves] = useState<Coordinates[]>([]);
  const enemyPieces = queenPiece.piece.position === Position.Up ? downPieces : upPieces;

  useEffect(() => {
    calculateQueenMoves();
  }, [queenPiece]);

  const calculateQueenMoves = () => {
    const moves: Coordinates[] = [];
    const { row, col } = queenPiece.piece;

    const directions = [
      [-1, -1], [-1, 1], [1, -1], [1, 1], // Diagonal en todas direcciones
    ];

    directions.forEach(([rowOffset, colOffset]) => {
      let r = row + rowOffset;
      let c = col + colOffset;

      // Continuar en cada dirección hasta encontrar una pieza o el borde del tablero
      while (r >= 0 && r < 8 && c >= 0 && c < 8) {
        const blockingPiece = [...upPieces, ...downPieces].find(
          (p) => p.piece.row === r && p.piece.col === c
        );

        if (blockingPiece) {
          if (blockingPiece.piece.position !== queenPiece.piece.position) {
            const landingRow = r + rowOffset;
            const landingCol = c + colOffset;

            if (
              landingRow >= 0 && landingRow < 8 &&
              landingCol >= 0 && landingCol < 8 &&
              ![...upPieces, ...downPieces].some(
                (p) => p.piece.row === landingRow && p.piece.col === landingCol
              )
            ) {
              moves.push({ row: landingRow, col: landingCol });
              onCapture({ row: landingRow, col: landingCol }, blockingPiece);
            }
          }
          break; // No puede saltar sobre múltiples piezas en una dirección
        } else {
          moves.push({ row: r, col: c });
        }

        r += rowOffset;
        c += colOffset;
      }
    });

    setQueenMoves(moves);
  };

  return (
    <>
      {queenMoves.map((move, index) => (
        <div
          key={index}
          className="absolute border border-blue-500"
          style={{
            left: `${move.col * cellSize + 63}px`,
            top: `${move.row * cellSize + 63}px`,
            width: '60px',
            height: '60px',
            cursor: 'pointer',
            backgroundColor: 'rgba(0, 0, 255, 0.5)',
          }}
          onClick={() => onMove(move)}
        />
      ))}
    </>
  );
};

export default QueenMoves;
