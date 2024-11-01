import React, { useEffect } from "react";
import { SDK } from "@dojoengine/sdk";

interface CheckerProps {
    sdk: SDK<any>;
}

const Checker: React.FC<CheckerProps> = ({ sdk }) => {
    useEffect(() => {
        console.log(sdk);
    }, [sdk]);

    return (
        <div className="checker-game">
            <h1>Checkers</h1>
        </div>
    );
};

export default Checker;
