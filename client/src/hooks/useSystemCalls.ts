import { useDojoStore } from "../components/Checker";
import { useDojo } from "./useDojo";

export const useSystemCalls = () => {

    const {
        setup: { setupWorld },
        account: { account },
    } = useDojo();


    const createLobby = async () =>{
        try {
          const createLobby = await(await setupWorld.actions).createLobby(
            account
          );
          return createLobby;
        } catch (error) {
          throw new Error(`createLobby failed: ${error}`);
        } 
    }

    return {
      createLobby,
    };
};