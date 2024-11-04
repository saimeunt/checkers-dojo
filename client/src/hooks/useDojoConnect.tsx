import { useEffect, useMemo } from "react";
import { SDK, createDojoStore } from "@dojoengine/sdk";
import { getEntityIdFromKeys } from "@dojoengine/utils";
import { addAddressPadding } from "starknet";
import { schema } from "../bindings.ts";
import { useDojo } from "./useDojo.tsx";
// import useModel from "./useModel.tsx";
import { useSystemCalls } from "./useSystemCalls.ts";

export const useDojoStore = createDojoStore<typeof schema>();

function useDojoConnect({ sdk }: { sdk: SDK<typeof schema> }) {
  const { account } = useDojo();
  

  const state = useDojoStore((state) => state);
  const entities = useDojoStore((state) => state.entities);
  

  const { spawn } = useSystemCalls();

  const entityId = useMemo(
    () => getEntityIdFromKeys([BigInt(account?.account.address)]),
    [account?.account.address]
  );

  useEffect(() => {
    let unsubscribe: (() => void) | undefined;

    const subscribe = async () => {
      try {
        const subscription = await sdk.subscribeEntityQuery(
          {
            dojo_starter: {
              Piece: {
                $: {
                  where: {
                    player: { $is: addAddressPadding(account.account.address) },
                  },
                },
              },
            },
          },
          (response) => {
            if (response.error) {
              console.error("Error setting up entity sync:", response.error);
            } else if (response.data && response.data[0].entityId !== "0x0") {
              console.log("Subscribed:", response.data[0]);
              state.updateEntity(response.data[0]);
            }
          },
          { logging: true }
        );

        unsubscribe = () => subscription.cancel();
      } catch (error) {
        console.error("Subscription error:", error);
      }
    };

    subscribe();

    return () => {
      if (unsubscribe) {
        unsubscribe();
      }
    };
  }, [sdk, account?.account.address, state]);

  useEffect(() => {
    const fetchEntities = async () => {
      try {
        await sdk.getEntities(
          {
            dojo_starter: {
              Piece: {
                $: {
                  where: { player: { $eq: addAddressPadding(account.account.address) } },
                },
              },
            },
          },
          (response) => {
            if (response.error) {
              console.error("Error querying entities:", response.error.message);
              return;
            }
            if (response.data) {
              state.setEntities(response.data);
            }
          }
        );
      } catch (error) {
        console.error("Error querying entities:", error);
      }
    };

    fetchEntities();
  }, [sdk, account?.account.address, state]);


  return { spawn, account,  entities };
}

export default useDojoConnect;