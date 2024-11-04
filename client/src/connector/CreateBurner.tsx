import React, { useState } from "react";
import { useDojo } from "../hooks/useDojo.tsx";

const CreateBurner: React.FC = () => {
    const { account } = useDojo(); // Contexto de la cuenta
    const [isDropdownOpen, setIsDropdownOpen] = useState(false); // Estado para manejar el desplegable

    const handleCreateBurner = async () => {
        if (account) {
            await account.create(); // Crear un nuevo burner
        }
    };

    const handleToggleDropdown = () => {
        setIsDropdownOpen(!isDropdownOpen); // Alternar el estado del desplegable
    };

    const handleSelectAccount = (address: string) => {
        account?.select(address); // Seleccionar la cuenta
        setIsDropdownOpen(false); // Cerrar el desplegable
    };

    const handleClearBurners = async () => {
        await account.clear(); // Limpiar los burners
        account.select(""); // Restablecer la cuenta conectada
        setIsDropdownOpen(false); // Cerrar el desplegable
    };

    // Obtener dirección de la cuenta conectada
    const slicedAddress = account?.account.address
        ? `${account.account.address.slice(0, 4)}...${account.account.address.slice(-4)}`
        : "Connect your Account"; // Mensaje cuando no hay cuenta conectada

    return (
        <div className="relative inline-block">
            <button
                className="flex items-center justify-between w-64 px-4 py-2 bg-gray-800 text-white text-sm sm:text-base rounded-md border border-purple-600 hover:bg-gray-700 transition-colors duration-300"
                onClick={handleToggleDropdown}
            >
                {account?.isDeploying ? "Deploying Burner..." : `Connected: ${slicedAddress}`}
                <span className={`transform transition-transform duration-300 ${isDropdownOpen ? "rotate-180" : ""}`}>
                    ▼
                </span>
            </button>
            {isDropdownOpen && (
                <div
                    className="absolute p-4 w-64 z-10 border rounded-md overflow-y-auto max-h-48"
                    style={{
                        backgroundColor: '#2C2F33', // Fondo gris oscuro
                        boxShadow: '0 4px 8px rgba(0, 0, 0, 0.3)', // Sombra sutil
                        borderColor: '#8602B64D', // Borde con el tono proporcionado
                    }}
                >
                    <div className="mb-4">
                        <label
                            htmlFor="signer-select"
                            className="block text-sm font-medium text-gray-300 mb-2" // Texto gris claro para contraste
                        >
                            Select Burner:
                        </label>
                        <select
                            id="signer-select"
                            className="w-full px-3 py-2 text-base text-gray-800 bg-white border border-white rounded-md focus:outline-none focus:ring-2 focus:ring-purple-500"
                            value={account?.account.address || ""}
                            onChange={(e) => handleSelectAccount(e.target.value)}
                        >
                            {account?.list().map((acc, index) => (
                                <option value={acc.address} key={index} className="text-gray-800">
                                    {acc.address}
                                </option>
                            ))}
                        </select>
                    </div>
                    <button
                        className="w-full mb-2 bg-purple-600 hover:bg-purple-700 text-white font-bold py-2 px-4 rounded-md transition duration-300 ease-in-out"
                        onClick={handleCreateBurner}
                    >
                        Create New Burner
                    </button>
                    <button
                        className="w-full bg-purple-600 hover:bg-purple-700 text-white font-bold py-2 px-4 rounded-md transition duration-300 ease-in-out"
                        onClick={handleClearBurners}
                    >
                        Clear Burners
                    </button>
                </div>
            )}
        </div>
    );
};

export default CreateBurner;