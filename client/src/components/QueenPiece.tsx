import React, { useEffect, useState } from "react";
import QueenBlack from "../assets/QueenBlack.svg";
import QueenOrange from "../assets/QueenOrange.svg";
import PieceBlack from "../assets/PieceBlack.svg";
import PieceOrange from "../assets/PieceOrange.svg";
import { PieceUI, Position, Coordinates } from "./InitPieces";

interface QueenPieceProps {
  piece: PieceUI;
  cellSize: number;
  onMove: (move: Coordinates) => void;
}

const QueenPiece: React.FC<QueenPieceProps> = ({ piece, cellSize, onMove }) => {
  const [isQueen, setIsQueen] = useState(piece.piece.is_king);

  useEffect(() => {
    if (!isQueen) {
      const isFinalRow =
        (piece.piece.position === Position.Up && piece.piece.row === 7) ||
        (piece.piece.position === Position.Down && piece.piece.row === 0);
      if (isFinalRow) {
        setIsQueen(true);
      }
    }
  }, [piece.piece.row, piece.piece.position, isQueen]);

  const handleMove = (move: Coordinates) => {
    onMove(move);
  };

  return (
    <img
      src={isQueen ? (piece.piece.position === Position.Up ? QueenBlack : QueenOrange) : (piece.piece.position === Position.Up ? PieceBlack : PieceOrange)}
      className="absolute"
      style={{
        left: `${piece.piece.col * cellSize + 63}px`,
        top: `${piece.piece.row * cellSize + 65}px`,
        cursor: "pointer",
        width: "70px",
        height: "70px",
        border: isQueen ? "2px solid blue" : "none",
      }}
      onClick={() => handleMove({ row: piece.piece.row, col: piece.piece.col })}
    />
  );
};

export default QueenPiece;
