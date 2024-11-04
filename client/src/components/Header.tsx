import React from "react";
import LogoMarquis from "../assets/LogoMarquis.png";
import ConnectWallet from "../assets/ConnectWallet.svg";
import useControllerAccount from "../hooks/useControllerAccount"; 
import CreateBurner from "../connector/CreateBurner";

const LoginSignUpButton: React.FC = () => {
  return (
    <div
      style={{
        paddingLeft: 32,
        paddingRight: 32,
        paddingTop: 12,
        paddingBottom: 12,
        background: 'linear-gradient(109deg, black 0%, #313131 44%, black 100%)',
        borderRadius: 14,
        border: '1px #666666 solid',
        justifyContent: 'flex-start',
        alignItems: 'center',
        gap: 16,
        display: 'flex',
        cursor: 'pointer',
      }}
    >
      <img style={{ width: 21, height: 22 }} src={LogoMarquis} alt="Login Icon" />
      <div
        style={{
          fontSize: 20,
          fontFamily: 'Larsseit',
          fontWeight: '500',
          textTransform: 'capitalize',
          wordWrap: 'break-word',
          background: 'linear-gradient(90deg, #00ECFF, #24ECED, #FFEB81)',
          WebkitBackgroundClip: 'text',
          WebkitTextFillColor: 'transparent',
        }}
      >
        Login/ Sign Up
      </div>
    </div>
  );
};
const ConnectWalletButton: React.FC = () => {
    const {
        userAccountController,
        userName,
        isConnected,
        handleConnect,
        handleDisconnect,
    } = useControllerAccount();

    return (
        <div style={{ position: 'relative' }}>
            <div
                style={{
                    height: 52,
                    paddingLeft: 32,
                    paddingRight: 32,
                    paddingTop: 14,
                    paddingBottom: 14,
                    background: 'linear-gradient(139deg, black 0%, #313131 69%, black 100%)',
                    borderRadius: 14,
                    border: '1px #666666 solid',
                    justifyContent: 'center',
                    alignItems: 'center',
                    gap: 16,
                    display: 'flex',
                    cursor: 'pointer',
                }}
                onClick={() => {
                    if (isConnected) {
                        handleDisconnect(); // Desconectar billetera
                    } else {
                        handleConnect(); // Conectar billetera
                    }
                }}
            >
                <img style={{ width: 24, height: 24 }} src={ConnectWallet} alt="Connect Wallet Icon" />
                <div
                    style={{
                        color: 'white',
                        fontSize: 20,
                        fontFamily: 'Montserrat',
                        fontWeight: '700',
                        wordWrap: 'break-word',
                    }}
                >
                    {isConnected ? `Connected: ${userName}` : 'Connect Wallet'}
                </div>
            </div>
        </div>
    );
};

const Header: React.FC = () => {
    return (
        <div
            style={{
                width: '100%',
                paddingLeft: 94,
                paddingRight: 94,
                paddingTop: 20,
                paddingBottom: 150,
                opacity: 0.94,
                justifyContent: 'space-between',
                alignItems: 'center',
                display: 'flex',
            }}
        >
            <div style={{ height: 50, justifyContent: 'flex-start', alignItems: 'center', gap: 20, display: 'flex' }}>
                <img src={LogoMarquis} alt="The Marquis Logo" style={{ width: 50, height: 50 }} />
                <div
                    style={{
                        fontSize: 28,
                        fontFamily: 'Larsseit',
                        fontWeight: '700',
                        color: '#00ECFF',
                    }}
                >
                    The Marquis
                </div>
            </div>
            <div style={{ justifyContent: 'flex-start', alignItems: 'center', gap: 50, display: 'flex' }}>
            <LoginSignUpButton />
                <ConnectWalletButton />
            </div>
        </div>
    );
};

export default Header;
