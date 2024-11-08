import React, { useEffect, useState } from 'react';
import { PieceUI, Coordinates } from './InitPieces';
import { Position } from '../bindings';

interface CaptureMovesProps {
  selectedPiece: PieceUI | null;
  upPieces: PieceUI[];
  downPieces: PieceUI[];
  cellSize: number;
  onCapture: (move: Coordinates, capturedPiece: PieceUI) => void;
}

const CaptureMoves: React.FC<CaptureMovesProps> = ({
  selectedPiece,
  upPieces,
  downPieces,
  cellSize,
  onCapture,
}) => {
  const [captureMoves, setCaptureMoves] = useState<{ move: Coordinates; capturedPiece: PieceUI }[]>([]);

  useEffect(() => {
    if (selectedPiece) {
      calculateCaptureMoves(selectedPiece);
    }
  }, [selectedPiece]);

  const calculateCaptureMoves = (piece: PieceUI) => {
    const moves: { move: Coordinates; capturedPiece: PieceUI }[] = [];
    const { row, col } = piece.piece;
    const enemyPieces = piece.piece.position === Position.Up ? downPieces : upPieces;

    const directions = piece.piece.position === Position.Up ? [[1, -1], [1, 1]] : [[-1, -1], [-1, 1]];

    directions.forEach(([rowOffset, colOffset]) => {
      const enemyRow = row + rowOffset;
      const enemyCol = col + colOffset;
      const landingRow = row + rowOffset * 2;
      const landingCol = col + colOffset * 2;

      const capturedPiece = enemyPieces.find(
        (p) => p.piece.row === enemyRow && p.piece.col === enemyCol
      );

      const isLandingEmpty =
        ![...upPieces, ...downPieces].some(
          (p) => p.piece.row === landingRow && p.piece.col === landingCol
        );

      if (capturedPiece && isLandingEmpty && landingRow >= 0 && landingRow < 8 && landingCol >= 0 && landingCol < 8) {
        moves.push({
          move: { row: landingRow, col: landingCol },
          capturedPiece,
        });
      }
    });

    setCaptureMoves(moves);
  };

  return (
    <>
      {captureMoves.map(({ move, capturedPiece }, index) => (
        <div
          key={index}
          className="absolute border border-red-500"
          style={{
            left: `${move.col * cellSize + 63}px`,
            top: `${move.row * cellSize + 63}px`,
            width: '60px',
            height: '60px',
            cursor: 'pointer',
            backgroundColor: 'rgba(255, 0, 0, 0.5)',
          }}
          onClick={() => onCapture(move, capturedPiece)}
        />
      ))}
    </>
  );
};

export default CaptureMoves;
