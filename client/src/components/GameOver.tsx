import React from "react";
import GameOver1 from "../assets/GameOver1.png";
import GameOver2 from "../assets/GameOver2.png"; 

const GameOver: React.FC = () => {
    return (
        <div
            className="absolute inset-0 flex flex-col items-center justify-center space-y-4"
            style={{
                backgroundColor: "rgba(0, 0, 0, 0.6)",
                zIndex: 1000, 
            }}
        >
            <img
                src={GameOver1}
                alt="Game Over"
                className="w-[300px] h-auto" 
            />
            <img
                src={GameOver2} 
                alt="Game Over 2"
                className="w-[300px] h-auto" 
            />
        </div>
    );
};

export default GameOver;
