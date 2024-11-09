import { DojoProvider } from "@dojoengine/core";
import { Account } from "starknet";
import { Position, Piece } from "./models.gen.ts";


export function setupWorld(provider: DojoProvider) {


	async function actions() {
		const namespace = "checkers_marq";

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

		const createLobby = async (account: Account) => {
			try {
				return await provider.execute(
					account,
					{
						contractName: "actions",
						entrypoint: "create_lobby",
						calldata: [],
					}, namespace
				);
			} catch (error) {
				console.error(error,'Error in create lobby');
			}
		};

		const joinLobby = async (account: Account, sessionId: number) => {
			try {
				return await provider.execute(
					account,
					{
						contractName: "actions",
						entrypoint: "join_lobby",
						calldata: [sessionId],
					}, namespace
				);
			} catch (error) {
				console.error(error);
			}
		};


		const spawn = async (account: Account, player: string, position: Position, sessionId: number) => {
			try {
				return await provider.execute(

					account,
					{
						contractName: "actions",
						entrypoint: "spawn",
						calldata: [player, position, sessionId],
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

		const canChoosePiece = async (account: Account, position: Position,  coordinatesPosition: Coordinates, sessionId: number) => {
			try {
				return await provider.execute(
					account,
					{
						contractName: "actions",
						entrypoint: "can_choose_piece",
						calldata: [position, coordinatesPosition, sessionId],
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
							//sessionId=>0										//TODO:refactor this
						calldata: [0,currentPiece.row, currentPiece.col, currentPiece.player, currentPiece.position, currentPiece.is_king, currentPiece.is_alive, currentPiece.row, currentPiece.col],
					}, namespace
				);
			} catch (error) {
				console.error(error);
			}
		};

			const getSessionId = async (account: Account) => {
				console.log(account,'account')
				console.log(provider,'provider')
				//TODO:FIX THIS CALL
        try {
          return await provider.execute(account, {
            contractName: "actions",
            entrypoint: "get_session_id",
            calldata: [],
          },namespace);
        } catch (error) {
          console.error(error);
        }
      };

		return {
      worldDispatcher,
      dojoName,
      createLobby,
      joinLobby,
      spawn,
      canChoosePiece,
      movePiece,
      getSessionId,
    };
	}

	return {
		actions: actions(),
	};
}