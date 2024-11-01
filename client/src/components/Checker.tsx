import React, { useEffect, useState } from "react";
import { SDK } from "@dojoengine/sdk";
import BackgroundCheckers from "../assets/BackgrounCheckers.png"; // Asegúrate de que la ruta sea correcta
import Board from "../assets/Board.png"; // Asegúrate de que la ruta sea correcta
import PieceBlack from "../assets/PieceBlack.svg"; // Asegúrate de que la ruta sea correcta
import PieceOrange from "../assets/PieceOrange.svg"; // Asegúrate de que la ruta sea correcta

interface CheckerProps {
    sdk: SDK<any>;
}

const Checker: React.FC<CheckerProps> = ({ sdk }) => {
    useEffect(() => {
        console.log(sdk);
    }, [sdk]);

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
        { id: 1, color: "black", position: { row: 4, col: 1 } },
        { id: 2, color: "black", position: { row: 4, col: 3 } },
        { id: 3, color: "black", position: { row: 4, col: 5 } },
        { id: 4, color: "black", position: { row: 4, col: 7 } },
        { id: 5, color: "black", position: { row: 5, col: 0 } },
        { id: 6, color: "black", position: { row: 5, col: 2 } },
        { id: 7, color: "black", position: { row: 5, col: 4 } },
        { id: 8, color: "black", position: { row: 5, col: 6 } },
        { id: 9, color: "black", position: { row: 6, col: 1 } },
        { id: 10, color: "black", position: { row: 6, col: 3 } },
        { id: 11, color: "black", position: { row: 6, col: 5 } },
        { id: 12, color: "black", position: { row: 6, col: 7 } },

    ];

    const initialOrangePieces: Piece[] = [
        { id: 13, color: "orange", position: { row: 1, col: 1 } },
        { id: 14, color: "orange", position: { row: 1, col: 3 } },
        { id: 15, color: "orange", position: { row: 1, col: 5 } },
        { id: 16, color: "orange", position: { row: 1, col: 7 } },
        { id: 17, color: "orange", position: { row: 2, col: 0 } },
        { id: 18, color: "orange", position: { row: 2, col: 2 } },
        { id: 19, color: "orange", position: { row: 2, col: 4 } },
        { id: 20, color: "orange", position: { row: 2, col: 6 } },
        { id: 21, color: "orange", position: { row: 3, col: 1 } },
        { id: 22, color: "orange", position: { row: 3, col: 3 } },
        { id: 23, color: "orange", position: { row: 3, col: 5 } },
        { id: 24, color: "orange", position: { row: 3, col: 7 } },
    ];

    const [blackPieces, setBlackPieces] = useState<Piece[]>(initialBlackPieces);
    const [orangePieces, setOrangePieces] = useState<Piece[]>(initialOrangePieces);
    const [selectedBlackPiece, setSelectedBlackPiece] = useState<number | null>(null);
    const [selectedOrangePiece, setSelectedOrangePiece] = useState<number | null>(null);
    const cellSize = 88; // Tamaño de cada celda en píxeles

    // Función para manejar el clic en una pieza negra
    const handleBlackPieceClick = (pieceId: number) => {
        const clickedPiece = blackPieces.find(piece => piece.id === pieceId);

        if (selectedBlackPiece === null) {
            // Selecciona la pieza si no hay ninguna seleccionada
            setSelectedBlackPiece(pieceId);
        } else {
            const pieceToMove = blackPieces.find(piece => piece.id === selectedBlackPiece);

            if (clickedPiece && clickedPiece.color === pieceToMove?.color) {
                // Mueve la pieza a la posición de la pieza clicada
                const updatedPieces = blackPieces.map(piece =>
                    piece.id === selectedBlackPiece
                        ? { ...piece, position: clickedPiece.position }
                        : piece
                );
                setBlackPieces(updatedPieces);
            }

            setSelectedBlackPiece(null); // Deselecciona la pieza
        }
    };

    // Función para manejar el clic en una pieza naranja
    const handleOrangePieceClick = (pieceId: number) => {
        const clickedPiece = orangePieces.find(piece => piece.id === pieceId);

        if (selectedOrangePiece === null) {
            // Selecciona la pieza si no hay ninguna seleccionada
            setSelectedOrangePiece(pieceId);
        } else {
            const pieceToMove = orangePieces.find(piece => piece.id === selectedOrangePiece);

            if (clickedPiece && clickedPiece.color === pieceToMove?.color) {
                // Mueve la pieza a la posición de la pieza clicada
                const updatedPieces = orangePieces.map(piece =>
                    piece.id === selectedOrangePiece
                        ? { ...piece, position: clickedPiece.position }
                        : piece
                );
                setOrangePieces(updatedPieces);
            }

            setSelectedOrangePiece(null); // Deselecciona la pieza
        }
    };

    // Renderiza las piezas en sus posiciones
    const renderPieces = () => {
        return (
            <>
                {blackPieces.map((piece) => (
                    <img
                        key={piece.id}
                        src={PieceBlack}
                        alt={`${piece.color} piece`}
                        className="absolute"
                        style={{
                            left: `${piece.position.col * cellSize + (cellSize + 115) / 3.2}px`, // Centra la pieza dentro de la celda
                            top: `${(7 - piece.position.row) * cellSize + (cellSize - 115 ) }px`, // Centra la pieza dentro de la celda
                            cursor: "pointer",
                            width: "60px", // Ajusta el tamaño de las piezas según sea necesario
                            height: "60px",
                        }}
                        onClick={() => handleBlackPieceClick(piece.id)}
                    />
                ))}
                {orangePieces.map((piece) => (
                    <img
                        key={piece.id}
                        src={PieceOrange}
                        alt={`${piece.color} piece`}
                        className="absolute"
                        style={{
                            right: `${piece.position.col * cellSize + (cellSize + 110) / 3.2}px`, // Centra la pieza dentro de la celda
                            top: `${(7 - piece.position.row) * cellSize + (cellSize + 6) * 1.5}px`, // Centra la pieza dentro de la celda
                            cursor: "pointer",
                            width: "60px", // Ajusta el tamaño de las piezas según sea necesario
                            height: "60px",
                        }}
                        onClick={() => handleOrangePieceClick(piece.id)}
                    />
                ))}
            </>
        );
    };

    return (
        <div
            className="relative h-screen w-full"
            style={{
                backgroundImage: `url(${BackgroundCheckers})`,
                backgroundSize: "cover",
                backgroundPosition: "center",
            }}
        >
            {/* Contenedor para el tablero */}
            <div className="flex items-center justify-center h-full">
                <div className="relative">
                    <img
                        src={Board}
                        alt="Board"
                        className="w-[800px] h-[800px] object-contain" 
                    />
                    {renderPieces()}
                </div>
            </div>
        </div>
    );
};

export default Checker;
