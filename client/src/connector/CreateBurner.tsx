import React, { useState } from "react";
import { useDojo } from "../hooks/useDojo.tsx";
import ConnectWallet from "../assets/ConnectWallet.png";

const CreateBurner: React.FC = () => {
  const { account } = useDojo();
  const [isDropdownOpen, setIsDropdownOpen] = useState(false);

  const handleCreateBurner = async () => {
    if (account) {
      await account.create();
    }
  };

  const handleToggleDropdown = () => {
    setIsDropdownOpen(!isDropdownOpen);
  };

  const handleSelectAccount = (address: string) => {
    account?.select(address);
    setIsDropdownOpen(false);
  };

  const handleClearBurners = async () => {
    await account.clear();
    account.select("");
    setIsDropdownOpen(false);
  };

  const slicedAddress = account?.account.address
    ? `${account.account.address.slice(0, 5)}...${account.account.address.slice(-4)}`
    : "Connect Wallet";

  return (
    <div>
      <button
        onClick={handleToggleDropdown}
        className="flex items-center rounded-md overflow-hidden font-bold cursor-pointer pl-2"
        style={{
          background: "linear-gradient(to right, #EE7921 40%, #520066 40%)", // Gradiente con amarillo y violeta
          color: "white",
          width: "240px",
          height: "40px",
        }}
      >
        <img
          src={ConnectWallet}
          alt="Wallet Icon"
          className="h-6 w-6"
          style={{
            marginLeft: "30px",
          }}
        />
        <span
          className="flex-grow text-right" // Texto alineado a la derecha
          style={{
            lineHeight: "40px",
            marginRight: "5px",
          }}
        >
          {slicedAddress}
        </span>
        <span
          className={`ml-2 transform transition-transform duration-300 ${
            isDropdownOpen ? "rotate-180" : ""
          }`}
          style={{ 
            color: "white",
            marginRight: "10px" }} 
        >
          ▼
        </span>
      </button>
      {isDropdownOpen && (
        <div
          className="absolute mt-2 w-64 z-10 rounded-md shadow-lg"
          style={{
            backgroundColor: "#2C2F33", 
            border: "1px solid #520066", 
            color: "white",
          }}
        >
          <div className="p-4">
            <label
              htmlFor="signer-select"
              className="block text-sm font-medium mb-2"
              style={{ color: "#ffffff99" }}
            >
              Select Burner:
            </label>
            <select
              id="signer-select"
              className="w-full px-3 py-2 text-sm bg-white text-gray-800 rounded-md focus:outline-none"
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
            className="w-full mb-2 bg-[#520066] hover:bg-[#6A0080] text-white font-semibold text-sm py-1 px-3 rounded-md transition duration-300 ease-in-out"
            onClick={handleCreateBurner}
          >
            Create New Burner
          </button>
          <button
            className="w-full bg-[#520066] hover:bg-[#6A0080] text-white font-semibold text-sm py-1 px-3 rounded-md transition duration-300 ease-in-out"
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
