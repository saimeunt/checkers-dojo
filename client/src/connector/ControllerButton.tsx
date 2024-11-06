import useControllerAccount from "../hooks/useControllerAccount";
import Cartridge from "../assets/Cartridge.png";

const ControllerButton: React.FC = () => {
  const {
    userName,
    isConnected,
    handleConnect,
    handleDisconnect,
  } = useControllerAccount();

  return (
    <div>
      <button
        onClick={isConnected ? handleDisconnect : handleConnect}
        className="flex items-center rounded-md overflow-hidden font-bold cursor-pointer pl-2"
        style={{
          background: "linear-gradient(to right, #EE7921 40%, #520066 40%)", // Gradiente con amarillo a la izquierda y violeta a la derecha
          color: 'white', 
          width: '200px',
          height: '40px',
        }}
      >
        <img
          src={Cartridge}
          alt="User Icon"
          className="h-8 w-8 rounded-full"
          style={{
            marginRight: '8px', 
            marginLeft: '15px' 
          }}
        />
        <span
          className="flex-grow text-left"
          style={{
            lineHeight: '40px',
            marginLeft: '40px' 
          }}
        >
          {isConnected ? userName : "Controller"}
        </span>
      </button>
    </div>
  );
};

export default ControllerButton;
