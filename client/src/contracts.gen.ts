import { DojoProvider } from "@dojoengine/core";
import { Account } from "starknet";
import * as models from "./bindings.ts";

export function setupWorld(provider: DojoProvider) {
	function actions() {
		const namespace = "dojo_starter";

		const worldDispatcher = async (account: Account) => {
			try {
				return await provider.execute(

					account,
					{
						contractName: "actions",
						entrypoint: "world_dispatcher",
						calldata: [],
					}, namespace
				);
			} catch (error) {
				console.error(error);
			}
		};

		const dojoName = async (account: Account) => {
			try {
				return await provider.execute(

					account,
					{
						contractName: "actions",
						entrypoint: "dojo_name",
						calldata: [],
					}, namespace
				);
			} catch (error) {
				console.error(error);
			}
		};

		const spawn = async (account: Account) => {
			try {
				return await provider.execute(

					account,
					{
						contractName: "actions",
						entrypoint: "spawn",
						calldata: [],
					}, namespace
				);
			} catch (error) {
				console.error(error);
			}
		};

		const canChoosePiece = async (account: Account, position: models.Position, coordinatesPosition: models.Coordinates) => {
			try {
				return await provider.execute(

					account,
					{
						contractName: "actions",
						entrypoint: "can_choose_piece",
						calldata: [position, coordinatesPosition],
					}, namespace
				);
			} catch (error) {
				console.error(error);
			}
		};

		const movePiece = async (account: Account, currentPiece: models.Piece, newCoordinatesPosition: models.Coordinates) => {
			try {
				return await provider.execute(

					account,
					{
						contractName: "actions",
						entrypoint: "move_piece",
						calldata: [currentPiece, newCoordinatesPosition],
					}, namespace
				);
			} catch (error) {
				console.error(error);
			}
		};

		return {
			worldDispatcher,
			dojoName,
			spawn,
			canChoosePiece,
			movePiece,
		};
	}

	return {
		actions: actions(),
	};
}