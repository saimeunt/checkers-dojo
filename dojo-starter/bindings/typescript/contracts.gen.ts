import { DojoProvider } from "@dojoengine/core";
import { Account } from "starknet";
import * as models from "./models.gen";

export async function setupWorld(provider: DojoProvider) {

	const actions_spawn = async (account: Account) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "actions",
					entryPoint: "spawn",
					calldata: [],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const actions_canChoosePiece = async (account: Account, position: models.Position, coordinatesPosition: Coordinates) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "actions",
					entryPoint: "can_choose_piece",
					calldata: [position, coordinatesPosition],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const actions_movePiece = async (account: Account, currentPiece: Piece, newCoordinatesPosition: Coordinates) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "actions",
					entryPoint: "move_piece",
					calldata: [currentPiece, newCoordinatesPosition],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	return {
		actions: {
			spawn: actions_spawn,
			canChoosePiece: actions_canChoosePiece,
			movePiece: actions_movePiece,
		},
	};
}