import { useDojoStore } from "../components/Checker";
import { useDojo } from "./useDojo";
import { v4 as uuidv4 } from "uuid";

export const useSystemCalls = () => {
    const state = useDojoStore((state) => state);

    const {
        setup: { setupWorld },
        account: { account },
    } = useDojo();

    const spawn = async () => {
        const transactionId = uuidv4();
        
        try {
            await (await setupWorld.actions).spawn(account);
        } catch (error) {
            throw new Error(`Spawn failed: ${error}`);
        } finally {
            state.confirmTransaction(transactionId);
        }
    };

    return {
        spawn,
    };
};