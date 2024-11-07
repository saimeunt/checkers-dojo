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

if square.piece.is_alive 
piece_row = square.coordinates.row;
piece_col = square.coordinates.col;

new_square.piece = current_square.piece
current_square.piece = None


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
    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct Killed {
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
            let coord_01 = Coordinates { row: 0, col: 1 };
            let piece_01 = Piece {
                player,
                coordinates: coord_01,
                position: Position::Up,
                is_king: false,
                is_alive: true
            };
            let coord_03 = Coordinates { row: 0, col: 3 };
            let piece_03 = Piece {
                player,
                coordinates: coord_03,
                position: Position::Up,
                is_king: false,
                is_alive: true
            };
            let coord_05 = Coordinates { row: 0, col: 5 };
            let piece_05 = Piece {
                player,
                coordinates: coord_05,
                position: Position::Up,
                is_king: false,
                is_alive: true
            };
            let coord_07 = Coordinates { row: 0, col: 7 };
            let piece_07 = Piece {
                player,
                coordinates: coord_07,
                position: Position::Up,
                is_king: false,
                is_alive: true
            };
            let coord_10 = Coordinates { row: 1, col: 0 };
            let piece_10 = Piece {
                player,
                coordinates: coord_10,
                position: Position::Up,
                is_king: false,
                is_alive: true
            };
            let coord_12 = Coordinates { row: 1, col: 2 };
            let piece_12 = Piece {
                player,
                coordinates: coord_12,
                position: Position::Up,
                is_king: false,
                is_alive: true
            };
            let coord_14 = Coordinates { row: 1, col: 4 };
            let piece_14 = Piece {
                player,
                coordinates: coord_14,
                position: Position::Up,
                is_king: false,
                is_alive: true
            };
            let coord_16 = Coordinates { row: 1, col: 6 };
            let piece_16 = Piece {
                player,
                coordinates: coord_16,
                position: Position::Up,
                is_king: false,
                is_alive: true
            };
            let coord_21 = Coordinates { row: 2, col: 1 };
            let piece_21 = Piece {
                player,
                coordinates: coord_21,
                position: Position::Up,
                is_king: false,
                is_alive: true
            };
            let coord_23 = Coordinates { row: 2, col: 3 };
            let piece_23 = Piece {
                player,
                coordinates: coord_23,
                position: Position::Up,
                is_king: false,
                is_alive: true
            };
            let coord_25 = Coordinates { row: 2, col: 5 };
            let piece_25 = Piece {
                player,
                coordinates: coord_25,
                position: Position::Up,
                is_king: false,
                is_alive: true
            };
            let coord_27 = Coordinates { row: 2, col: 7 };
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
            let coord_50 = Coordinates { row: 5, col: 0 };
            let piece_50 = Piece {
                player,
                coordinates: coord_50,
                position: Position::Down,
                is_king: false,
                is_alive: true
            };
            let coord_52 = Coordinates { row: 5, col: 2 };
            let piece_52 = Piece {
                player,
                coordinates: coord_52,
                position: Position::Down,
                is_king: false,
                is_alive: true
            };
            let coord_54 = Coordinates { row: 5, col: 4 };
            let piece_54 = Piece {
                player,
                coordinates: coord_54,
                position: Position::Down,
                is_king: false,
                is_alive: true
            };
            let coord_56 = Coordinates { row: 5, col: 6 };
            let piece_56 = Piece {
                player,
                coordinates: coord_56,
                position: Position::Down,
                is_king: false,
                is_alive: true
            };
            let coord_61 = Coordinates { row: 6, col: 1 };
            let piece_61 = Piece {
                player,
                coordinates: coord_61,
                position: Position::Down,
                is_king: false,
                is_alive: true
            };
            let coord_63 = Coordinates { row: 6, col: 3 };
            let piece_63 = Piece {
                player,
                coordinates: coord_63,
                position: Position::Down,
                is_king: false,
                is_alive: true
            };
            let coord_65 = Coordinates { row: 6, col: 5 };
            let piece_65 = Piece {
                player,
                coordinates: coord_65,
                position: Position::Down,
                is_king: false,
                is_alive: true
            };
            let coord_67 = Coordinates { row: 6, col: 7 };
            let piece_67 = Piece {
                player,
                coordinates: coord_67,
                position: Position::Down,
                is_king: false,
                is_alive: true
            };
            let coord_70 = Coordinates { row: 7, col: 0 };
            let piece_70 = Piece {
                player,
                coordinates: coord_70,
                position: Position::Down,
                is_king: false,
                is_alive: true
            };
            let coord_72 = Coordinates { row: 7, col: 2 };
            let piece_72 = Piece {
                player,
                coordinates: coord_72,
                position: Position::Down,
                is_king: false,
                is_alive: true
            };
            let coord_74 = Coordinates { row: 7, col: 4 };
            let piece_74 = Piece {
                player,
                coordinates: coord_74,
                position: Position::Down,
                is_king: false,
                is_alive: true
            };
            let coord_76 = Coordinates { row: 7, col: 6 };
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
            let piece: Piece = world.read_model((coordinates_position));

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

            // Update the piece's coordinates based on the new coordinates.
            let updated_piece = update_piece_position(current_piece, square);
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

        fn change_is_alive(self: @ContractState, current_piece: Piece, new_coordinates_position: Coordinates) {
            let mut world = self.world_default();
            let square: Piece = world.read_model((new_coordinates_position));

            // Update the piece attributes based on the new coordinates.
            square.is_alive = true;
            square.player = current_piece.player;
            square.position = current_piece.position;

            world.write_model(@square);

            // Update the current piece attributes.
            current_piece.is_alive = false;
            current_piece.player = 0x0;
            current_piece.position = Position::None;
            // Write the new coordinates to the world.
            world.write_model(@current_piece);
            // Emit an event about the move
            world.emit_event(@Moved { square.player, coordinates: square.coordinates });
        }

        fn check_has_valid_moves(self: @ContractState, piece: Piece) -> bool {
            let world = self.world_default();
            let piece_row = piece.coordinates.row;
            let piece_col = piece.coordinates.col;

            // Only handling non-king pieces for now
            if piece.is_king {
                return false;
            }

            match piece.position {
                Position::Up => {
                    // Check forward moves (down direction)
                    if piece_row + 1 >= 8 {
                        return false;
                    }

                    // Check down-left diagonal
                    if piece_col > 0 {
                        let target_down_left = Coordinates {
                            row: piece_row + 1, col: piece_col - 1
                        };
                        let target_square: Piece = world
                            .read_model((piece.player, target_down_left));

                    }

                    // Check down-right diagonal
                    if piece_col + 1 < 8 {
                        let target_down_right = Coordinates {
                            row: piece_row + 1, col: piece_col + 1
                        };
                        let target_square: Piece = world
                            .read_model((target_down_right));
                    }
                    false
                },
                Position::Down => {
                    // Check forward moves (up direction)
                    if piece_row == 0 {
                        return false;
                    }

                    // Check up-left diagonal
                    if piece_col > 0 {
                        let target_up_left = Coordinates { row: piece_row - 1, col: piece_col - 1 };
                        let target_square: Piece = world.read_model((target_up_left));
                        return !target_square.is_alive;
                    }

                    // Check up-right diagonal
                    if piece_col + 1 < 8 {
                        let target_up_right = Coordinates {
                            row: piece_row - 1, col: piece_col + 1
                        };
                        let target_square: Piece = world
                            .read_model((target_up_right));
                        return !target_square.is_alive;
                    }
                    false
                },
                _ => false
            }
        }
    }
}

fn is_jump_possible(self: @ContractState, piece: Piece, square: Piece) -> bool {
    let world = self.world_default();
    if piece.coordinates.col > square.coordinates.col {
        // Move left
        match piece.position => {
            Position::Up => {
                let jump_coordinates = Coordinates {
                    row: piece.coordinates.row + 2,
                    col: piece.coordinates.col - 2
                };
                let jump_square: Piece = world.read_model((jump_coordinates));
                return !jump_square.is_alive;
            },
            Position::Down => {
                let jump_coordinates = Coordinates {
                    row: piece.coordinates.row - 2,
                    col: piece.coordinates.col - 2
                };
                let jump_square: Piece = world.read_model((jump_coordinates));
                return !jump_square.is_alive;
            }
        }
    } else {
        // Move right
        match piece.position => {
            Position::Up => {
                let jump_coordinates = Coordinates {
                    row: piece.coordinates.row + 2,
                    col: piece.coordinates.col + 2
                };
                let jump_square: Piece = world.read_model((jump_coordinates));
                return !jump_square.is_alive;
            },
            Position::Down => {
                let jump_coordinates = Coordinates {
                    row: piece.coordinates.row - 2,
                    col: piece.coordinates.col + 2
                };
                let jump_square: Piece = world.read_model((jump_coordinates));
                return !jump_square.is_alive;
            }
        }
    }
}

fn update_alive_position(self: @ContractState, mut piece: Piece, mut square: Piece) {
    let can_jump = is_jump_possible(piece, square);
    if can_jump {
        // Kill the piece
        let mut world = self.world_default();
        square.is_alive = false;
        square.player = 0x0;
        square.position = Position::None;

        world.write_model(@square)

        // TODO: Update the player model saying -1 piece
        let player = piece.player;
        let coordinates = square.coordinates;
        world.emit_event(@Killed { player, coordinates });
        // Make the jump
        if piece.coordinates.col > square.coordinates.col {
            // Move left
            match piece.position {
                Position::Up => {
                    let new_coordinates = Coordinates {
                        row: piece.coordinates.row + 2,
                        col: piece.coordinates.col - 2
                    };
                    change_is_alive(piece, new_coordinates);
                },
                Position::Down => {
                    let new_coordinates = Coordinates {
                        row: piece.coordinates.row - 2,
                        col: piece.coordinates.col - 2
                    };
                    change_is_alive(piece, new_coordinates);
                }
            }
        } else {
            // Move right
            match piece.position {
                Position::Up => {
                    let new_coordinates = Coordinates {
                        row: piece.coordinates.row + 2,
                        col: piece.coordinates.col + 2
                    };
                    change_is_alive(piece, new_coordinates);
                },
                Position::Down => {
                    let new_coordinates = Coordinates {
                        row: piece.coordinates.row - 2,
                        col: piece.coordinates.col + 2
                    };
                    change_is_alive(piece, new_coordinates);
                }
            }
        }        
    }
   
}
// Todo: Improve this function to check if the new coordinates is valid.
fn update_piece_position(mut piece: Piece, square: Piece) {
    // Check if there is a piece in the square
    if square.is_alive {
       update_alive_position(piece, square);
    } else {
        // Get the coordinates of the square and do the swap
        let coordinates = square.coordinates;
        change_is_alive(piece, coordinates);
    }
}

fn check_is_valid_position(coordinates: Coordinates) -> bool {
    let row = coordinates.row;
    let col = coordinates.col;
    // Check if the coordinates is out of bounds
    if row < 8 && col < 8 {
        // Check if the coordinates is valid on the board setup
        match row {
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
