import { getEntityIdFromKeys } from "@dojoengine/utils";
import { useDojoStore } from "../components/Checker";
import { useDojo } from "./useDojo";
import { v4 as uuidv4 } from "uuid";
import { Position } from "../bindings";

export const useSystemCalls = () => {
    const state = useDojoStore((state) => state);

    const {
        setup: { setupWorld },
        account: { account },
    } = useDojo();

    const generateEntityId = () => {
        if (!account) throw new Error("Account is not defined");
        return getEntityIdFromKeys([BigInt(account.address)]);
    };

    const spawn = async () => {
        const entityId = generateEntityId();
        const transactionId = uuidv4();

        state.applyOptimisticUpdate(transactionId, (draft) => {
            if (!draft.entities[entityId]) {
                draft.entities[entityId] = {
                    entityId,
                    models: {
                        dojo_starter: {
                            PieceValue: {
                                fieldOrder: ["position", "is_king", "is_alive"],
                                position: Position.None,
                                is_king: false,
                                is_alive: false,

                            },
                            Coordinates: {
                                fieldOrder: ["raw", "col"],
                                raw: 0,
                                col: 0,
                            },
                            Piece: {
                                player: account.address,
                                coordinates: {
                                    fieldOrder: ["raw", "col"],
                                    raw: 0,
                                    col: 0,
                                },
                                is_king: false,
                                is_alive: true,
                            },
                        },
                    },
                };
            }
        })

        try {
            (await setupWorld).actions.spawn(account);
            await state.waitForEntityChange(entityId, (entity) => {
                return (
                    entity?.models?.dojo_starter?.Piece?.position ===
                    Position.None
                );
            });
        } catch (error) {
            state.revertOptimisticUpdate(transactionId);
            console.error("Error executing spawn:", error);
            throw new Error(`Spawn failed: ${error}`);
        } finally {
            state.confirmTransaction(transactionId);
        }
    };

    return {
        spawn,
    };
};