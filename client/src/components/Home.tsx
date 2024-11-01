import React from 'react';
import Header from './Header';
import checkersImage from '../assets/Checkers.png';
import { useNavigate } from 'react-router-dom';

const Home: React.FC = () => {
    const navigate = useNavigate();

    const handleSignUp = () => {
        navigate('/checkers');
    };

    return (
        <div
            style={{
                width: '100%',
                height: '100vh',
                background: '#0F151A',
                display: 'flex',
                flexDirection: 'column',
                alignItems: 'center',
                justifyContent: 'flex-start',
            }}
        >
            <Header />
            <div
                style={{
                    width: '100%',
                    maxWidth: 1600,
                    height: '60%',
                    padding: '56px 5%',
                    background: 'linear-gradient(144deg, black 29%, #0F151A 47%, #0E1318 78%, #040507 100%)',
                    borderRadius: 20,
                    border: '1px #6E6E6E solid',
                    display: 'flex',
                    flexDirection: 'row',
                    justifyContent: 'space-between',
                    alignItems: 'center',
                    position: 'relative',
                }}
            >
                <div style={{ flex: 1, flexDirection: 'column', justifyContent: 'flex-start', alignItems: 'flex-start', gap: 62, display: 'flex' }}>
                    <div style={{ alignSelf: 'stretch', flexDirection: 'column', justifyContent: 'flex-start', alignItems: 'flex-start', gap: 26, display: 'flex' }}>
                        <div style={{ alignSelf: 'stretch', color: 'white', fontSize: 48, fontFamily: 'Larsseit', fontWeight: '700', textTransform: 'uppercase', lineHeight: '55.97px', wordWrap: 'break-word' }}>
                            CHECKERS
                        </div>
                        <div style={{ alignSelf: 'stretch', color: 'white', fontSize: 18, fontFamily: 'Larsseit', fontWeight: '500', lineHeight: '31px', wordWrap: 'break-word' }}>
                            Strategy board game for two players, in which the players race their two tokens from start to finish according to the rolls of a single die.
                        </div>
                    </div>
                    <div style={{ flexDirection: 'column', justifyContent: 'flex-start', alignItems: 'flex-start', gap: 16, display: 'flex' }}>
                        <div style={{ width: 301, height: 77.21, position: 'relative' }}>
                            <div style={{ width: 249, height: 70.60, left: 52, top: 0, position: 'absolute' }}>
                                <div style={{ width: 249, height: 67, left: 0, top: 3.60, position: 'absolute', background: 'linear-gradient(263deg, #3ADCFF 0%, rgba(58, 220, 255, 0) 100%)', boxShadow: '82.44px 82.44px 82.44px', filter: 'blur(82.44px)' }} />
                                <div style={{ width: 143, height: 70, left: 100, top: 0, position: 'absolute', background: 'linear-gradient(263deg, #3ADCFF 0%, rgba(58, 220, 255, 0) 100%)', boxShadow: '30.92px 30.92px 30.92px', filter: 'blur(30.92px)' }} />
                                <div style={{ width: 143, height: 70, left: 100, top: 0, position: 'absolute', background: 'linear-gradient(263deg, #3ADCFF 0%, rgba(58, 220, 255, 0) 100%)', boxShadow: '10.31px 10.31px 10.31px', filter: 'blur(10.31px)' }} />
                            </div>
                            <div style={{ width: 288, height: 74, left: 0, top: 3.21, position: 'absolute', borderRadius: 20, border: '1.29px #3ADCFF solid' }} />
                            <div
                                onClick={handleSignUp}
                                style={{
                                    width: 288,
                                    height: 73,
                                    padding: '20px 62px',
                                    left: 0,
                                    top: 3.79,
                                    position: 'absolute',
                                    background: '#01111F',
                                    borderRadius: 20,
                                    border: '2.58px rgba(255, 255, 255, 0.12) solid',
                                    justifyContent: 'center',
                                    alignItems: 'center',
                                    display: 'flex',
                                    cursor: 'pointer',
                                }}
                            >
                                <div
                                    style={{
                                        color: 'white',
                                        fontSize: 20,
                                        fontFamily: 'Arial',
                                        fontWeight: '400',
                                        textTransform: 'uppercase',
                                        lineHeight: '28.80px',
                                        wordWrap: 'break-word',
                                    }}
                                >
                                    sign up now
                                </div>
                            </div>
                        </div>
                        <div>
                            <span style={{ color: '#CACACA', fontSize: 20, fontFamily: 'Montserrat', fontWeight: '400', wordWrap: 'break-word' }}>
                                Already have an account?
                            </span>
                            <span style={{ color: '#00ECFF', fontSize: 20, fontFamily: 'Montserrat', fontWeight: '700', wordWrap: 'break-word' }}>
                                Login
                            </span>
                        </div>
                    </div>
                </div>
                <div style={{ width: '50%', height: '296px', position: 'relative' }}>
                    <div style={{ width: '100%', height: '100%', left: 0, top: 0, position: 'absolute', background: '#D9D9D9', borderRadius: 24 }} />
                    <img
                        style={{
                            width: '100%',
                            height: 'auto',
                            borderRadius: 24,
                            position: 'absolute',
                            top: 0,
                            left: 0,
                        }}
                        src={checkersImage}
                        alt="Checkers"
                    />
                </div>
            </div>
        </div>
    );
};

export default Home;
