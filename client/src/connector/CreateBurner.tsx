import React, { useState } from "react";
import { useDojo } from "../hooks/useDojo.tsx";

const CreateBurner: React.FC = () => {
    const { account } = useDojo(); // Asumiendo que useDojo proporciona el contexto de la cuenta
    const [isDropdownOpen, setIsDropdownOpen] = useState(false); // Estado para manejar el desplegable

    const handleCreateBurner = async () => {
        if (account) {
            await account.create(); // Llama al método create de la cuenta
        }
    };

    const handleToggleDropdown = () => {
        setIsDropdownOpen(!isDropdownOpen); // Alternar el estado del desplegable
    };

    const handleSelectAccount = (address: string) => {
        account?.select(address); // Seleccionar la cuenta
        setIsDropdownOpen(false); // Cerrar el desplegable después de seleccionar
    };

    const handleClearBurners = async () => {
        await account.clear(); // Limpiar los burners
        account.select(""); // Restablecer la cuenta conectada
        setIsDropdownOpen(false); // Cerrar el desplegable
    };

    // Slice de 4 caracteres iniciales y finales de la dirección
    const slicedAddress = account?.account.address
        ? `${account.account.address.slice(0, 4)}...${account.account.address.slice(-4)}`
        : "Connect your Account"; // Mensaje cuando no hay cuenta conectada

    return (
        <div className="relative inline-block">
            <button
                className="flex items-center justify-between w-64 px-4 py-2 bg-black text-white text-sm sm:text-base rounded-md border border-purple-600 hover:bg-gray-800 transition-colors duration-300"
                onClick={handleToggleDropdown}
            >
                {account?.isDeploying ? "Deploying Burner..." : `Connected: ${slicedAddress}`}
                <span className={`transform transition-transform duration-300 ${isDropdownOpen ? "rotate-180" : ""}`}>
                    ▼
                </span>
            </button>
            {isDropdownOpen && (
                <div className="absolute bg-gray-100 shadow-md rounded-t-md p-4 w-64 z-10 border border-gray-300 mt-0 overflow-y-auto max-h-48">
                    <div className="mb-4">
                        <label
                            htmlFor="signer-select"
                            className="block text-sm font-medium text-gray-700 mb-2"
                        >
                            Select Burner:
                        </label>
                        <select
                            id="signer-select"
                            className="w-full px-3 py-2 text-base text-gray-800 bg-gray-200 border border-gray-400 rounded-md focus:outline-none focus:ring-2 focus:ring-purple-500"
                            value={account?.account.address || ""}
                            onChange={(e) => handleSelectAccount(e.target.value)}
                        >
                            {account?.list().map((acc, index) => (
                                <option value={acc.address} key={index}>
                                    {acc.address}
                                </option>
                            ))}
                        </select>
                    </div>
                    <button
                        className="w-full mb-2 bg-gray-200 hover:bg-gray-300 text-gray-800 font-bold py-2 px-4 rounded-md transition duration-300 ease-in-out"
                        onClick={handleCreateBurner}
                    >
                        Create New Burner
                    </button>
                    <button
                        className="w-full bg-gray-200 hover:bg-gray-300 text-gray-800 font-bold py-2 px-4 rounded-md transition duration-300 ease-in-out"
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
