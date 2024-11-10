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

    const getSessionId= async()=>{
      try{
        const id= await (await setupWorld.actions).getSessionId(account);
        console.log(id,'id')
        return id
      } catch(err){
        throw new Error(`getSessionId failed: ${err}`);
      }
    }

    return {
      createLobby,
      getSessionId,
    };
};