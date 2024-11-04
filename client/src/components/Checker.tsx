import { useState } from "react";
import { SDK, createDojoStore } from "@dojoengine/sdk";
import BackgroundCheckers from "../assets/BackgrounCheckers.png";
import Board from "../assets/Board.png";
import PieceBlack from "../assets/PieceBlack.svg";
import PieceOrange from "../assets/PieceOrange.svg";
import Player1 from "../assets/Player1.png";
import Player2 from "../assets/Player1.png";
import GameOver from "../components/GameOver";
import Winner from "../components/Winner";
//import useDojoConnect from "../hooks/useDojoConnect";
import { schema, Position, Coordinates, Piece } from "../bindings.ts";
import { useDojo } from "../hooks/useDojo.tsx";

// Crea el store de Dojo
export const useDojoStore = createDojoStore<typeof schema>();

function Checker({ sdk }: { sdk: SDK<typeof schema> }) {
  const [arePiecesVisible] = useState(true);
  const [isGameOver] = useState(false);
  const [isWinner] = useState(false);
  const [selectedPieceId, setSelectedPieceId] = useState<number | null>(null);
  const [validMoves, setValidMoves] = useState<Coordinates[]>([]);

  const {
	account: { account },
	setup: { setupWorld },
} = useDojo();

  // Todo: Fix this type, use export
  interface PieceUI {
    id: number;
    piece: Piece;
  }

  const initialBlackPieces: PieceUI[] = [
    { id: 1, piece: { player: account.address,  position: Position.Up, coordinates: {raw: 0, col: 1}, is_king: false, is_alive: true}},
    { id: 2, piece: { player: account.address,  position: Position.Up, coordinates: {raw: 0, col: 3}, is_king: false, is_alive: true}},
    { id: 3, piece: { player: account.address,  position: Position.Up, coordinates: {raw: 0, col: 5}, is_king: false, is_alive: true}},
    { id: 4, piece: { player: account.address,  position: Position.Up, coordinates: {raw: 0, col: 7}, is_king: false, is_alive: true}},
    { id: 5, piece: { player: account.address,  position: Position.Up, coordinates: {raw: 1, col: 0}, is_king: false, is_alive: true}},
    { id: 6, piece: { player: account.address,  position: Position.Up, coordinates: {raw: 1, col: 2}, is_king: false, is_alive: true}},
    { id: 7, piece: { player: account.address,  position: Position.Up, coordinates: {raw: 1, col: 4}, is_king: false, is_alive: true}},
    { id: 8, piece: { player: account.address,  position: Position.Up, coordinates: {raw: 1, col: 6}, is_king: false, is_alive: true}},
    { id: 9, piece: { player: account.address,  position: Position.Up, coordinates: {raw: 2, col: 1}, is_king: false, is_alive: true}},
    { id: 10, piece: { player: account.address,  position: Position.Up, coordinates: {raw: 2, col: 3}, is_king: false, is_alive: true}},
    { id: 11, piece: { player: account.address,  position: Position.Up, coordinates: {raw: 2, col: 5}, is_king: false, is_alive: true}},
    { id: 12, piece: { player: account.address,  position: Position.Up, coordinates: {raw: 2, col: 7}, is_king: false, is_alive: true}},
  ];

  const initialOrangePieces: PieceUI[] = [
    { id: 13, piece: { player: account.address,  position: Position.Down, coordinates: {raw: 5, col: 0}, is_king: false, is_alive: true}},
    { id: 14, piece: { player: account.address,  position: Position.Down, coordinates: {raw: 5, col: 2}, is_king: false, is_alive: true}},
    { id: 15, piece: { player: account.address,  position: Position.Down, coordinates: {raw: 5, col: 4}, is_king: false, is_alive: true}},
    { id: 16, piece: { player: account.address,  position: Position.Down, coordinates: {raw: 5, col: 6}, is_king: false, is_alive: true}},
    { id: 17, piece: { player: account.address,  position: Position.Down, coordinates: {raw: 6, col: 1}, is_king: false, is_alive: true}},
    { id: 18, piece: { player: account.address,  position: Position.Down, coordinates: {raw: 6, col: 3}, is_king: false, is_alive: true}},
    { id: 19, piece: { player: account.address,  position: Position.Down, coordinates: {raw: 6, col: 5}, is_king: false, is_alive: true}},
    { id: 20, piece: { player: account.address,  position: Position.Down, coordinates: {raw: 6, col: 7}, is_king: false, is_alive: true}},
    { id: 21, piece: { player: account.address,  position: Position.Down, coordinates: {raw: 7, col: 0}, is_king: false, is_alive: true}},
    { id: 22, piece: { player: account.address,  position: Position.Down, coordinates: {raw: 7, col: 2}, is_king: false, is_alive: true}},
    { id: 23, piece: { player: account.address,  position: Position.Down, coordinates: {raw: 7, col: 4}, is_king: false, is_alive: true}},
    { id: 24, piece: { player: account.address,  position: Position.Down, coordinates: {raw: 7, col: 6}, is_king: false, is_alive: true}},
  ];

  const [upPieces, setUpPieces] = useState<PieceUI[]>(initialBlackPieces);
  const [downPieces, setDownPieces] = useState<PieceUI[]>(initialOrangePieces);
  
  const cellSize = 88;

  const handlePieceClick = async (piece: PieceUI) => {
    const pieceId = piece.id;
    console.log("Selected piece ID:", pieceId);

    if (selectedPieceId === pieceId) {
      setSelectedPieceId(null);
      setValidMoves([]);
    } else {
      setSelectedPieceId(pieceId);
      const moves = calculateValidMoves(piece);
      console.log("Valid moves for piece", pieceId, ":", moves);
      setValidMoves(moves); 
    };

	try {
		if (account) {
			const position = piece.piece.position;
			const coordinates = piece.piece.coordinates;
			const canChoosePiece = await setupWorld.actions.canChoosePiece(account, position,coordinates);
			console.log("canChoosePiece", canChoosePiece?.transaction_hash);
		} else {
			console.warn("Cuenta no conectada");
		}
	} catch (error) {
		console.error("Error al mover la pieza:", error);
	};
  };

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

  const handleMoveClick = async (move: Coordinates) => {
    if (selectedPieceId !== null) {
      const selectedPiece = [...upPieces, ...downPieces].find(piece => piece.id === selectedPieceId);
   console.log("selectedPiece", selectedPiece?.piece.coordinates);
      if (selectedPiece) {
        let piecesToUpdate;
        if (selectedPiece.piece.position === Position.Up) {
          piecesToUpdate = upPieces;
        } else if (selectedPiece.piece.position === Position.Down) {
          piecesToUpdate = downPieces;
        } else {
          console.warn('Piece has invalid position: Position.None');
          return;
        }

        const updatedPieces = piecesToUpdate.map(piece => {
          if (piece.id === selectedPieceId) {
            return { ...piece, piece: { ...piece.piece, coordinates: move }}; 
          }
          return piece;
        });
        
        // Set pieces based on position
        if (selectedPiece.piece.position === Position.Down) {
          setDownPieces(updatedPieces);
        } else if (selectedPiece.piece.position === Position.Up) {
          setUpPieces(updatedPieces);
        } else {
          console.warn('Piece has invalid position: Position.None');
        }
  
        try {
          if (account) {
            const movedPiece = await setupWorld.actions.movePiece(account, selectedPiece.piece, move);
            console.log("movedPiece", movedPiece?.transaction_hash);
          } else {
            console.warn("Cuenta no conectada");
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
          //alt={`${piece.color} piece`}
          className="absolute"
          style={{
            left: `${piece.piece.coordinates.col * cellSize + 63}px`,
            top: `${piece.piece.coordinates.raw * cellSize + 65}px`,
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
          src={PieceOrange}
          //alt={`${piece.color} piece`}
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
}

export default Checker;
