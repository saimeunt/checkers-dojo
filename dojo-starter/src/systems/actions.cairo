use dojo_starter::models::Piece;
use dojo_starter::models::Coordinates;
use dojo_starter::models::Position;

// define the interface
#[starknet::interface]
trait IActions<T> {
    fn spawn(ref self: T) -> Span<Coordinates>;
    fn can_choose_piece(ref self: T, position: Position, coordinates_position: Coordinates) -> bool;
    fn move_piece(ref self: T, current_piece: Piece, new_coordinates_position: Coordinates);
}

// dojo decorator
#[dojo::contract]
pub mod actions {
    use super::{IActions, update_piece_position, check_is_valid_position};
    use starknet::{ContractAddress, get_caller_address};
    use dojo_starter::models::{Piece, Coordinates, Position};

    use dojo::model::{ModelStorage, ModelValueStorage};
    use dojo::event::EventStorage;

    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct Moved {
        #[key]
        pub player: ContractAddress,
        pub coordinates: Coordinates,
    }

    #[abi(embed_v0)]
    impl ActionsImpl of IActions<ContractState> {
        fn spawn(ref self: ContractState) -> Span<Coordinates> {
            // Get the default world.
            let mut world = self.world_default();

            // Get the address of the current caller, possibly the player's address.
            let player = get_caller_address();

            // Update the world state with the new data.

            // Create the pieces for the player. Upper side of the board.
            let coord_01 = Coordinates { raw: 0, col: 1 };
            let piece_01 = Piece {
                player,
                coordinates: coord_01,
                position: Position::Up,
                is_king: false,
                is_alive: true
            };
            let coord_03 = Coordinates { raw: 0, col: 3 };
            let piece_03 = Piece {
                player,
                coordinates: coord_03,
                position: Position::Up,
                is_king: false,
                is_alive: true
            };
            let coord_05 = Coordinates { raw: 0, col: 5 };
            let piece_05 = Piece {
                player,
                coordinates: coord_05,
                position: Position::Up,
                is_king: false,
                is_alive: true
            };
            let coord_07 = Coordinates { raw: 0, col: 7 };
            let piece_07 = Piece {
                player,
                coordinates: coord_07,
                position: Position::Up,
                is_king: false,
                is_alive: true
            };
            let coord_10 = Coordinates { raw: 1, col: 0 };
            let piece_10 = Piece {
                player,
                coordinates: coord_10,
                position: Position::Up,
                is_king: false,
                is_alive: true
            };
            let coord_12 = Coordinates { raw: 1, col: 2 };
            let piece_12 = Piece {
                player,
                coordinates: coord_12,
                position: Position::Up,
                is_king: false,
                is_alive: true
            };
            let coord_14 = Coordinates { raw: 1, col: 4 };
            let piece_14 = Piece {
                player,
                coordinates: coord_14,
                position: Position::Up,
                is_king: false,
                is_alive: true
            };
            let coord_16 = Coordinates { raw: 1, col: 6 };
            let piece_16 = Piece {
                player,
                coordinates: coord_16,
                position: Position::Up,
                is_king: false,
                is_alive: true
            };
            let coord_21 = Coordinates { raw: 2, col: 1 };
            let piece_21 = Piece {
                player,
                coordinates: coord_21,
                position: Position::Up,
                is_king: false,
                is_alive: true
            };
            let coord_23 = Coordinates { raw: 2, col: 3 };
            let piece_23 = Piece {
                player,
                coordinates: coord_23,
                position: Position::Up,
                is_king: false,
                is_alive: true
            };
            let coord_25 = Coordinates { raw: 2, col: 5 };
            let piece_25 = Piece {
                player,
                coordinates: coord_25,
                position: Position::Up,
                is_king: false,
                is_alive: true
            };
            let coord_27 = Coordinates { raw: 2, col: 7 };
            let piece_27 = Piece {
                player,
                coordinates: coord_27,
                position: Position::Up,
                is_king: false,
                is_alive: true
            };

            // Write the upper pieces to the world.
            world.write_model(@piece_01);
            world.write_model(@piece_03);
            world.write_model(@piece_05);
            world.write_model(@piece_07);
            world.write_model(@piece_10);
            world.write_model(@piece_12);
            world.write_model(@piece_14);
            world.write_model(@piece_16);
            world.write_model(@piece_21);
            world.write_model(@piece_23);
            world.write_model(@piece_25);
            world.write_model(@piece_27);

            // Important: For now we will use the same player for all the pieces.

            // Create the pieces for the player. Lower side of the board.
            let coord_50 = Coordinates { raw: 5, col: 0 };
            let piece_50 = Piece {
                player,
                coordinates: coord_50,
                position: Position::Down,
                is_king: false,
                is_alive: true
            };
            let coord_52 = Coordinates { raw: 5, col: 2 };
            let piece_52 = Piece {
                player,
                coordinates: coord_52,
                position: Position::Down,
                is_king: false,
                is_alive: true
            };
            let coord_54 = Coordinates { raw: 5, col: 4 };
            let piece_54 = Piece {
                player,
                coordinates: coord_54,
                position: Position::Down,
                is_king: false,
                is_alive: true
            };
            let coord_56 = Coordinates { raw: 5, col: 6 };
            let piece_56 = Piece {
                player,
                coordinates: coord_56,
                position: Position::Down,
                is_king: false,
                is_alive: true
            };
            let coord_61 = Coordinates { raw: 6, col: 1 };
            let piece_61 = Piece {
                player,
                coordinates: coord_61,
                position: Position::Down,
                is_king: false,
                is_alive: true
            };
            let coord_63 = Coordinates { raw: 6, col: 3 };
            let piece_63 = Piece {
                player,
                coordinates: coord_63,
                position: Position::Down,
                is_king: false,
                is_alive: true
            };
            let coord_65 = Coordinates { raw: 6, col: 5 };
            let piece_65 = Piece {
                player,
                coordinates: coord_65,
                position: Position::Down,
                is_king: false,
                is_alive: true
            };
            let coord_67 = Coordinates { raw: 6, col: 7 };
            let piece_67 = Piece {
                player,
                coordinates: coord_67,
                position: Position::Down,
                is_king: false,
                is_alive: true
            };
            let coord_70 = Coordinates { raw: 7, col: 0 };
            let piece_70 = Piece {
                player,
                coordinates: coord_70,
                position: Position::Down,
                is_king: false,
                is_alive: true
            };
            let coord_72 = Coordinates { raw: 7, col: 2 };
            let piece_72 = Piece {
                player,
                coordinates: coord_72,
                position: Position::Down,
                is_king: false,
                is_alive: true
            };
            let coord_74 = Coordinates { raw: 7, col: 4 };
            let piece_74 = Piece {
                player,
                coordinates: coord_74,
                position: Position::Down,
                is_king: false,
                is_alive: true
            };
            let coord_76 = Coordinates { raw: 7, col: 6 };
            let piece_76 = Piece {
                player,
                coordinates: coord_76,
                position: Position::Down,
                is_king: false,
                is_alive: true
            };

            // Write the lower pieces to the world.
            world.write_model(@piece_50);
            world.write_model(@piece_52);
            world.write_model(@piece_54);
            world.write_model(@piece_56);
            world.write_model(@piece_61);
            world.write_model(@piece_63);
            world.write_model(@piece_65);
            world.write_model(@piece_67);
            world.write_model(@piece_70);
            world.write_model(@piece_72);
            world.write_model(@piece_74);
            world.write_model(@piece_76);

            // Return the positions of the pieces
            [
                coord_01,
                coord_03,
                coord_05,
                coord_07,
                coord_10,
                coord_12,
                coord_14,
                coord_16,
                coord_21,
                coord_23,
                coord_25,
                coord_27,
                coord_50,
                coord_52,
                coord_54,
                coord_56,
                coord_61,
                coord_63,
                coord_65,
                coord_67,
                coord_70,
                coord_72,
                coord_74,
                coord_76,
            ].span()
        }
        //

        fn can_choose_piece(
            ref self: ContractState, position: Position, coordinates_position: Coordinates
        ) -> bool {
            let mut world = self.world_default();

            // Get the address of the current caller, possibly the player's address.
            let player = get_caller_address();

            // Check is current coordinates is valid
            let is_valid_position = check_is_valid_position(coordinates_position);
            if !is_valid_position {
                return false;
            }

            // Get the player's piece from the world by its coordinates.
            let piece: Piece = world.read_model((player, coordinates_position));

            // Check if the piece belongs to the position and is alive.
            // TODO: Fow now we only support one player. later we will add support for multiple
            // players.
            let is_valid_piece = piece.position == position && piece.is_alive == true;

            // Only check for valid moves if the piece is valid
            if is_valid_piece {
                self.check_has_valid_moves(piece)
            } else {
                false
            }
        }

        // Implementation of the move function for the ContractState struct.
        fn move_piece(
            ref self: ContractState, current_piece: Piece, new_coordinates_position: Coordinates
        ) {
            // Get the address of the current caller, possibly the player's address.

            let mut world = self.world_default();
            let player = get_caller_address();

            // Check is new coordinates is valid
            let is_valid_position = check_is_valid_position(new_coordinates_position);
            assert(is_valid_position, 'Invalid coordinates');

            // Retrieve the player's piece from the world by its coordinates.
            let square: Piece = world.read_model((player, new_coordinates_position));

            // Update the piece's coordinates based on the new coordinates.
            let updated_piece = update_piece_position(current_piece, square);

            // Write the new coordinates to the world.
            world.write_model(@updated_piece);
            // Emit an event to the world to notify about the player's move.
            world.emit_event(@Moved { player, coordinates: new_coordinates_position });
        }
    }
    #[generate_trait]
    impl InternalImpl of InternalTrait {
        // Need a function since byte array can't be const.
        // We could have a self.world with an other function to init from hash, that can be
        // constant.
        fn world_default(self: @ContractState) -> dojo::world::WorldStorage {
            self.world(@"dojo_starter")
        }

        fn check_has_valid_moves(self: @ContractState, piece: Piece) -> bool {
            let world = self.world_default();
            let piece_raw = piece.coordinates.raw;
            let piece_col = piece.coordinates.col;

            // Only handling non-king pieces for now
            if piece.is_king {
                return false;
            }

            match piece.position {
                Position::Up => {
                    // Check forward moves (down direction)
                    if piece_raw + 1 >= 8 {
                        return false;
                    }

                    // Check down-left diagonal
                    if piece_col > 0 {
                        let target_down_left = Coordinates {
                            raw: piece_raw + 1, col: piece_col - 1
                        };
                        let target_square: Piece = world
                            .read_model((piece.player, target_down_left));
                        return !target_square.is_alive;
                    }

                    // Check down-right diagonal
                    if piece_col + 1 < 8 {
                        let target_down_right = Coordinates {
                            raw: piece_raw + 1, col: piece_col + 1
                        };
                        let target_square: Piece = world
                            .read_model((piece.player, target_down_right));
                        return !target_square.is_alive;
                    }
                    false
                },
                Position::Down => {
                    // Check forward moves (up direction)
                    if piece_raw == 0 {
                        return false;
                    }

                    // Check up-left diagonal
                    if piece_col > 0 {
                        let target_up_left = Coordinates { raw: piece_raw - 1, col: piece_col - 1 };
                        let target_square: Piece = world.read_model((piece.player, target_up_left));
                        return !target_square.is_alive;
                    }

                    // Check up-right diagonal
                    if piece_col + 1 < 8 {
                        let target_up_right = Coordinates {
                            raw: piece_raw - 1, col: piece_col + 1
                        };
                        let target_square: Piece = world
                            .read_model((piece.player, target_up_right));
                        return !target_square.is_alive;
                    }
                    false
                },
                _ => false
            }
        }
    }
}

// Todo: Improve this function to check if the new coordinates is valid.
fn update_piece_position(mut piece: Piece, square: Piece) -> Piece {
    piece.coordinates.raw = square.coordinates.raw;
    piece.coordinates.col = square.coordinates.col;
    piece
}

fn check_is_valid_position(coordinates: Coordinates) -> bool {
    let raw = coordinates.raw;
    let col = coordinates.col;
    // Check if the coordinates is out of bounds
    if raw < 8 && col < 8 {
        // Check if the coordinates is valid on the board setup
        match raw {
            0 => col == 1 || col == 3 || col == 5 || col == 7,
            1 => col == 0 || col == 2 || col == 4 || col == 6,
            2 => col == 1 || col == 3 || col == 5 || col == 7,
            3 => col == 0 || col == 2 || col == 4 || col == 6,
            4 => col == 1 || col == 3 || col == 5 || col == 7,
            5 => col == 0 || col == 2 || col == 4 || col == 6,
            6 => col == 1 || col == 3 || col == 5 || col == 7,
            7 => col == 0 || col == 2 || col == 4 || col == 6,
            _ => false,
        }
    } else {
        false
    }
}
