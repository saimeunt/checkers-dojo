// InitPieces.ts
import { Position } from "../bindings";

export interface Coordinates {
  row: number;
  col: number;
}

export interface Piece {
  player: string;
  position: Position;

  row: number;
  col: number;
  // coordinates: Coordinates;

  is_king: boolean;
  is_alive: boolean;
}

export interface PieceUI {
  id: number;
  piece: Piece;
}

export const createInitialPieces = (playerAddress: string) => {

  const initialOrangePieces: PieceUI[] = [
    { id: 1, piece: { player: playerAddress, position: Position.Down, row: 7, col: 0, is_king: false, is_alive: true}},
    { id: 2, piece: { player: playerAddress, position: Position.Down, row: 7, col: 2, is_king: false, is_alive: true}},
    { id: 3, piece: { player: playerAddress, position: Position.Down, row: 7, col: 4, is_king: false, is_alive: true}},
    { id: 4, piece: { player: playerAddress, position: Position.Down, row: 7, col: 6, is_king: false, is_alive: true}},
    { id: 5, piece: { player: playerAddress, position: Position.Down, row: 6, col: 1, is_king: false, is_alive: true}},
    { id: 6, piece: { player: playerAddress, position: Position.Down, row: 6, col: 3, is_king: false, is_alive: true}},
    { id: 7, piece: { player: playerAddress, position: Position.Down, row: 6, col: 5, is_king: false, is_alive: true}},
    { id: 8, piece: { player: playerAddress, position: Position.Down, row: 6, col: 7, is_king: false, is_alive: true}},
    { id: 9, piece: { player: playerAddress, position: Position.Down, row: 5, col: 0, is_king: false, is_alive: true}},
    { id: 10, piece: { player: playerAddress, position: Position.Down, row: 5, col: 2, is_king: false, is_alive: true}},
    { id: 11, piece: { player: playerAddress, position: Position.Down, row: 5, col: 4, is_king: false, is_alive: true}},
    { id: 12, piece: { player: playerAddress, position: Position.Down, row: 5, col: 6, is_king: false, is_alive: true}},
  ];

  const initialBlackPieces: PieceUI[] = [
    { id: 13, piece: { player: playerAddress, position: Position.Up, row: 2, col: 1, is_king: false, is_alive: true } },
    { id: 14, piece: { player: playerAddress, position: Position.Up, row: 2, col: 3, is_king: false, is_alive: true } },
    { id: 15, piece: { player: playerAddress, position: Position.Up, row: 2, col: 5, is_king: false, is_alive: true } },
    { id: 16, piece: { player: playerAddress, position: Position.Up, row: 2, col: 7, is_king: false, is_alive: true } },
    { id: 17, piece: { player: playerAddress, position: Position.Up, row: 1, col: 0, is_king: false, is_alive: true } },
    { id: 18, piece: { player: playerAddress, position: Position.Up, row: 1, col: 2, is_king: false, is_alive: true } },
    { id: 19, piece: { player: playerAddress, position: Position.Up, row: 1, col: 4, is_king: false, is_alive: true } },
    { id: 20, piece: { player: playerAddress, position: Position.Up, row: 1, col: 6, is_king: false, is_alive: true } },
    { id: 21, piece: { player: playerAddress, position: Position.Up, row: 0, col: 1, is_king: false, is_alive: true } },
    { id: 22, piece: { player: playerAddress, position: Position.Up, row: 0, col: 3, is_king: false, is_alive: true } },
    { id: 23, piece: { player: playerAddress, position: Position.Up, row: 0, col: 5, is_king: false, is_alive: true } },
    { id: 24, piece: { player: playerAddress, position: Position.Up, row: 0, col: 7, is_king: false, is_alive: true } },
  ];
  

  return {
    initialBlackPieces,
    initialOrangePieces
  };
};