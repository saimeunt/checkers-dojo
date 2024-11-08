import { DojoProvider } from "@dojoengine/core";
import { Account } from "starknet";
import { Position, Piece } from "./models.gen.ts";


export function setupWorld(provider: DojoProvider) {


	async function actions() {
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


			interface Coordinates {
        row: number;
        col: number;
      }

		const canChoosePiece = async (account: Account, position: Position, coordinatesPosition: Coordinates) => {
			try {
				return await provider.execute(
					account,
					{
						contractName: "actions",
						entrypoint: "can_choose_piece",
						calldata: [position, coordinatesPosition.row,coordinatesPosition.col],
					}, namespace
				);
			} catch (error) {
				console.error(error);
			}
		};

		const movePiece = async (account: Account, currentPiece: Piece) => {
			try {
				return await provider.execute(
					account,
					{
						contractName: "actions",
						entrypoint: "move_piece",
					//TODO:refactor this
						calldata: [currentPiece.row,currentPiece.col,currentPiece.player,currentPiece.position,currentPiece.is_king,currentPiece.is_alive, currentPiece.row,currentPiece.col],
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