import { useEffect, } from "react";
import { SDK, createDojoStore } from "@dojoengine/sdk";
import { addAddressPadding } from "starknet";
import { schema } from "../bindings.ts";
import { useDojo } from "./useDojo.tsx";
import { useSystemCalls } from "./useSystemCalls.ts";

export const useDojoStore = createDojoStore<typeof schema>();

function useDojoConnect({ sdk }: { sdk: SDK<typeof schema> }) {
  const { account } = useDojo();
  const state = useDojoStore((state) => state);
  const entities = useDojoStore((state) => state.entities);
  const { spawn } = useSystemCalls();

  useEffect(() => {
    const fetchEntities = async () => {
      try {
        await sdk.client.getEntities(
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

  return { spawn, account, entities };
}
export default useDojoConnect;
