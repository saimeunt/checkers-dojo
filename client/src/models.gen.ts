import type { SchemaType } from "@dojoengine/sdk";

// Type definition for `dojo_starter::models::Counter` struct
export interface Counter {
	fieldOrder: string[];
	next_id: number;
	game_id: number;
}

// Type definition for `dojo_starter::models::CounterValue` struct
export interface CounterValue {
	fieldOrder: string[];
	game_id: number;
}

// Type definition for `dojo_starter::models::Piece` struct
export interface Piece {
	fieldOrder: string[];
	session_id: number;
	row: number;
	col: number;
	player: string;
	position: Position;
	is_king: boolean;
	is_alive: boolean;
}

// Type definition for `dojo_starter::models::PieceValue` struct
export interface PieceValue {
	fieldOrder: string[];
	player: string;
	position: Position;
	is_king: boolean;
	is_alive: boolean;
}

// Type definition for `dojo_starter::models::PlayerValue` struct
export interface PlayerValue {
	fieldOrder: string[];
	remaining_pieces: number;
}

// Type definition for `dojo_starter::models::Player` struct
export interface Player {
	fieldOrder: string[];
	player: string;
	remaining_pieces: number;
}

// Type definition for `dojo_starter::models::Session` struct
export interface Session {
	fieldOrder: string[];
	session_id: number;
	player_1: string;
	player_2: string;
	turn: number;
	winner: string;
	state: number;
}

// Type definition for `dojo_starter::models::SessionValue` struct
export interface SessionValue {
	fieldOrder: string[];
	player_1: string;
	player_2: string;
	turn: number;
	winner: string;
	state: number;
}

// Type definition for `dojo_starter::models::Position` enum
export enum Position {
	None,
	Up,
	Down,
}

export interface DojoStarterSchemaType extends SchemaType {
	dojo_starter: {
		Counter: Counter,
		CounterValue: CounterValue,
		Piece: Piece,
		PieceValue: PieceValue,
		PlayerValue: PlayerValue,
		Player: Player,
		Session: Session,
		SessionValue: SessionValue,
		ERC__Balance: ERC__Balance,
		ERC__Token: ERC__Token,
		ERC__Transfer: ERC__Transfer,
	},
}
export const schema: DojoStarterSchemaType = {
	dojo_starter: {
		Counter: {
			fieldOrder: ['next_id', 'game_id'],
			next_id: 0,
			game_id: 0,
		},
		CounterValue: {
			fieldOrder: ['game_id'],
			game_id: 0,
		},
		Piece: {
			fieldOrder: ['session_id', 'row', 'col', 'player', 'position', 'is_king', 'is_alive'],
			session_id: 0,
			row: 0,
			col: 0,
			player: "",
			position: Position.None,
			is_king: false,
			is_alive: false,
		},
		PieceValue: {
			fieldOrder: ['player', 'position', 'is_king', 'is_alive'],
			player: "",
			position: Position.None,
			is_king: false,
			is_alive: false,
		},
		PlayerValue: {
			fieldOrder: ['remaining_pieces'],
			remaining_pieces: 0,
		},
		Player: {
			fieldOrder: ['player', 'remaining_pieces'],
			player: "",
			remaining_pieces: 0,
		},
		Session: {
			fieldOrder: ['session_id', 'player_1', 'player_2', 'turn', 'winner', 'state'],
			session_id: 0,
			player_1: "",
			player_2: "",
			turn: 0,
			winner: "",
			state: 0,
		},
		SessionValue: {
			fieldOrder: ['player_1', 'player_2', 'turn', 'winner', 'state'],
			player_1: "",
			player_2: "",
			turn: 0,
			winner: "",
			state: 0,
		},
		ERC__Balance: {
			fieldOrder: ['balance', 'type', 'tokenmetadata'],
			balance: '',
			type: 'ERC20',
			tokenMetadata: {
				fieldOrder: ['name', 'symbol', 'tokenId', 'decimals', 'contractAddress'],
				name: '',
				symbol: '',
				tokenId: '',
				decimals: '',
				contractAddress: '',
			},
		},
		ERC__Token: {
			fieldOrder: ['name', 'symbol', 'tokenId', 'decimals', 'contractAddress'],
			name: '',
			symbol: '',
			tokenId: '',
			decimals: '',
			contractAddress: '',
		},
		ERC__Transfer: {
			fieldOrder: ['from', 'to', 'amount', 'type', 'executed', 'tokenMetadata'],
			from: '',
			to: '',
			amount: '',
			type: 'ERC20',
			executedAt: '',
			tokenMetadata: {
				fieldOrder: ['name', 'symbol', 'tokenId', 'decimals', 'contractAddress'],
				name: '',
				symbol: '',
				tokenId: '',
				decimals: '',
				contractAddress: '',
			},
			transactionHash: '',
		},

	},
};
// Type definition for ERC__Balance struct
export type ERC__Type = 'ERC20' | 'ERC721';
export interface ERC__Balance {
    fieldOrder: string[];
    balance: string;
    type: string;
    tokenMetadata: ERC__Token;
}
export interface ERC__Token {
    fieldOrder: string[];
    name: string;
    symbol: string;
    tokenId: string;
    decimals: string;
    contractAddress: string;
}
export interface ERC__Transfer {
    fieldOrder: string[];
    from: string;
    to: string;
    amount: string;
    type: string;
    executedAt: string;
    tokenMetadata: ERC__Token;
    transactionHash: string;
}