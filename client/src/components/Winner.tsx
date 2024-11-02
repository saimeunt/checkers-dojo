import React from "react";
import Winner1 from "../assets/Winner1.png";
import Winner2 from "../assets/Winner2.png";

const Winner: React.FC = () => {
    return (
        <div
            className="absolute inset-0 flex flex-col items-center justify-center space-y-4"
            style={{
                backgroundColor: "rgba(0, 0, 0, 0.6)",
                zIndex: 1000, 
            }}
        >
            <img
                src={Winner1}
                alt="Game Over"
                className="w-[600px] h-auto" 
            />
            <img
                src={Winner2} 
                alt="Game Over 2"
                className="w-[1200px] h-auto" 
            />
        </div>
    );
};

export default Winner;
