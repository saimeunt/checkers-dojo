import type { SchemaType } from "@dojoengine/sdk";

// Type definition for `dojo_starter::models::PieceValue` struct
export interface PieceValue {
	fieldOrder: string[];
	player: string;
	position: Position;
	is_king: boolean;
	is_alive: boolean;
}

// Type definition for `dojo_starter::models::Piece` struct
export interface Piece {
	fieldOrder: string[];
	row: number;
	col: number;
	player: string;
	position: Position;
	is_king: boolean;
	is_alive: boolean;
}

// Type definition for `dojo_starter::models::Position` enum
export enum Position {
	None,
	Up,
	Down,
}

export interface DojoStarterSchemaType extends SchemaType {
	dojo_starter: {
		PieceValue: PieceValue,
		Piece: Piece,
		ERC__Balance: ERC__Balance,
		ERC__Token: ERC__Token,
		ERC__Transfer: ERC__Transfer,
	},
}
export const schema: DojoStarterSchemaType = {
	dojo_starter: {
		PieceValue: {
			fieldOrder: ['player', 'position', 'is_king', 'is_alive'],
			player: "",
			position: Position.None,
			is_king: false,
			is_alive: false,
		},
		Piece: {
			fieldOrder: ['row', 'col', 'player', 'position', 'is_king', 'is_alive'],
			row: 0,
			col: 0,
			player: "",
			position: Position.None,
			is_king: false,
			is_alive: false,
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