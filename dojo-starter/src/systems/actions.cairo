use dojo_starter::models::Piece;
use dojo_starter::models::Coordinates;
use dojo_starter::models::Position;

// define the interface
#[starknet::interface]
trait IActions<T> {
    fn spawn(ref self: T); //  ->  Span<Coordinates>
    fn can_choose_piece(ref self: T, position: Position, coordinates_position: Coordinates) -> bool;
    fn move_piece(ref self: T, current_piece: Piece, new_coordinates_position: Coordinates);
}

// dojo decorator
#[dojo::contract]
pub mod actions {
    use super::IActions;
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
        fn spawn(ref self: ContractState) {
            // Get the default world.
            let mut world = self.world_default();

            // Get the address of the current caller, possibly the player's address.
            let player = get_caller_address();

            //player 1 
            self.initialize_player_pieces(player, 0, 2, Position::Up);
            //player 2
            self.initialize_player_pieces(player, 5, 7, Position::Down);
        // Update the world state with the new data.

        // [
        //     coord_01,
        //     coord_03,
        //     coord_05,
        //     coord_07,
        //     coord_10,
        //     coord_12,
        //     coord_14,
        //     coord_16,
        //     coord_21,
        //     coord_23,
        //     coord_25,
        //     coord_27,
        //     coord_50,
        //     coord_52,
        //     coord_54,
        //     coord_56,
        //     coord_61,
        //     coord_63,
        //     coord_65,
        //     coord_67,
        //     coord_70,
        //     coord_72,
        //     coord_74,
        //     coord_76,
        // ].span()
        }
        //

        fn can_choose_piece(
            ref self: ContractState, position: Position, coordinates_position: Coordinates
        ) -> bool {
            let mut world = self.world_default();

            // Get the address of the current caller, possibly the player's address.
            //let player = get_caller_address();

            // Check is current coordinates is valid
            let is_valid_position = self.check_is_valid_position(coordinates_position);
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
            //let player = get_caller_address();

            // Check is new coordinates is valid
            let is_valid_position = self.check_is_valid_position(new_coordinates_position);
            assert(is_valid_position, 'Invalid coordinates');

            let row = new_coordinates_position.row;
            let col = new_coordinates_position.col;

            // Get the piece from the world by its coordinates.
            let square: Piece = world.read_model((row, col));

            // Update the piece's coordinates based on the new coordinates.
            self.update_piece_position(current_piece, square);
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

        fn initialize_player_pieces(
            ref self: ContractState,
            player: ContractAddress,
            start_row: u8,
            end_row: u8,
            position: Position
        ) {
            let mut world = self.world_default();
            let mut row = start_row;
            while row <= end_row {
                let start_col = (row + 1) % 2; // Alternates between 0 and 1
                let mut col = start_col;
                while col < 8 {
                    let piece = Piece {
                        row, col, player, position, is_king: false, is_alive: true,
                    };
                    world.write_model(@piece);
                    col += 2;
                };
                row += 1;
            }
        }

        fn change_is_alive(
            self: @ContractState, mut current_piece: Piece, new_coordinates_position: Coordinates
        ) {
            let mut world = self.world_default();
            let mut square: Piece = world.read_model((new_coordinates_position));

            // Update the piece attributes based on the new coordinates.
            square.is_alive = true;
            square.player = current_piece.player;
            square.position = current_piece.position;

            world.write_model(@square);

            // Update the current piece attributes.
            current_piece.is_alive = false;
            current_piece.player = starknet::contract_address_const::<0x0>();
            current_piece.position = Position::None;
            // Write the new coordinates to the world.
            world.write_model(@current_piece);
            let coordinates = Coordinates { row: square.row, col: square.col };
            // Emit an event about the move
            world.emit_event(@Moved { player: square.player, coordinates });
        }

        fn check_has_valid_moves(self: @ContractState, piece: Piece) -> bool {
            let world = self.world_default();
            let piece_row = piece.row;
            let piece_col = piece.col;

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
                        let _target_square: Piece = world
                            .read_model((piece.player, target_down_left));
                    }

                    // Check down-right diagonal
                    if piece_col + 1 < 8 {
                        let target_down_right = Coordinates {
                            row: piece_row + 1, col: piece_col + 1
                        };
                        let _target_square: Piece = world.read_model((target_down_right));
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
                        let target_square: Piece = world.read_model((target_up_right));
                        return !target_square.is_alive;
                    }
                    false
                },
                _ => false
            }
        }

        fn is_jump_possible(self: @ContractState, piece: Piece, square: Piece) -> bool {
            let world = self.world_default();
            if piece.col > square.col {
                // Move left
                match piece.position {
                    Position::Up => {
                        let jump_coordinates = Coordinates {
                            row: piece.row + 2, col: piece.col - 2
                        };
                        let jump_square: Piece = world.read_model((jump_coordinates));
                        return !jump_square.is_alive;
                    },
                    Position::Down => {
                        let jump_coordinates = Coordinates {
                            row: piece.row - 2, col: piece.col - 2
                        };
                        let jump_square: Piece = world.read_model((jump_coordinates));
                        return !jump_square.is_alive;
                    },
                    _ => false
                }
            } else {
                // Move right
                match piece.position {
                    Position::Up => {
                        let jump_coordinates = Coordinates {
                            row: piece.row + 2, col: piece.col + 2
                        };
                        let jump_square: Piece = world.read_model((jump_coordinates));
                        return !jump_square.is_alive;
                    },
                    Position::Down => {
                        let jump_coordinates = Coordinates {
                            row: piece.row - 2, col: piece.col + 2
                        };
                        let jump_square: Piece = world.read_model((jump_coordinates));
                        return !jump_square.is_alive;
                    },
                    _ => false
                }
            }
        }

        fn update_alive_position(ref self: ContractState, mut piece: Piece, mut square: Piece) {
            let can_jump = self.is_jump_possible(piece, square);
            if can_jump {
                // Kill the piece
                let mut world = self.world_default();
                square.is_alive = false;
                square.player = starknet::contract_address_const::<0x0>();
                square.position = Position::None;

                world.write_model(@square);

                // TODO: Update the player model saying -1 piece
                let player = piece.player;
                let coordinates = Coordinates { row: square.row, col: square.col };
                world.emit_event(@Killed { player, coordinates });
                // Make the jump
                if piece.col > square.col {
                    // Move left
                    match piece.position {
                        Position::Up => {
                            let new_coordinates = Coordinates {
                                row: piece.row + 2, col: piece.col - 2
                            };
                            self.change_is_alive(piece, new_coordinates);
                        },
                        Position::Down => {
                            let new_coordinates = Coordinates {
                                row: piece.row - 2, col: piece.col - 2
                            };
                            self.change_is_alive(piece, new_coordinates);
                        },
                        _ => {}
                    }
                } else {
                    // Move right
                    match piece.position {
                        Position::Up => {
                            let new_coordinates = Coordinates {
                                row: piece.row + 2, col: piece.col + 2
                            };
                            self.change_is_alive(piece, new_coordinates);
                        },
                        Position::Down => {
                            let new_coordinates = Coordinates {
                                row: piece.row - 2, col: piece.col + 2
                            };
                            self.change_is_alive(piece, new_coordinates);
                        },
                        _ => {}
                    }
                }
            }
        }

        // Todo: Improve this function to check if the new coordinates is valid.
        fn update_piece_position(ref self: ContractState, mut piece: Piece, square: Piece) {
            // Check if there is a piece in the square
            if square.is_alive {
                self.update_alive_position(piece, square);
            } else {
                // Get the coordinates of the square and do the swap
                let coordinates = Coordinates { row: square.row, col: square.col };
                self.change_is_alive(piece, coordinates);
            }
        }

        fn check_is_valid_position(self: @ContractState, coordinates: Coordinates) -> bool {
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
    }
}
