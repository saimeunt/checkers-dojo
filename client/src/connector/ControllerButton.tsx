// ControllerButton.tsx
import useControllerAccount from "../hooks/useControllerAccount";

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
          background: isConnected
            ? "linear-gradient(to right, #191a1d 40%, #800000 40%)"
            : "linear-gradient(to right, #191a1d 40%, rgba(172, 148, 25, 1) 40%)",
          width: '200px',
          height: '40px',
        }}
      >
        <img
          src="https://x.cartridge.gg/favicon-48x48.png"
          alt="User Icon"
          className="h-8 w-8 rounded-full"
          style={{
            marginRight: '8px', 
            marginLeft: '15px' 
          }}
        />
        <span
          className="text-white flex-grow text-left"
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
