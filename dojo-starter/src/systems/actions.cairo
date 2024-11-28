use dojo_starter::models::Piece;
use dojo_starter::models::Coordinates;
use dojo_starter::models::Position;
use starknet::ContractAddress;

// define the interface
#[starknet::interface]
trait IActions<T> {
    fn create_lobby(ref self: T) -> u64;
    fn join_lobby(ref self: T, session_id: u64);
    fn can_choose_piece(
        ref self: T, position: Position, coordinates_position: Coordinates, session_id: u64
    ) -> bool;
    fn move_piece(ref self: T, current_piece: Piece, new_coordinates_position: Coordinates);
    fn move_piece_multiple(
        ref self: T, current_piece: Piece, new_coordinates_positions: Array<Coordinates>
    );

    //getter function
    fn get_session_id(self: @T) -> u64;
}

// dojo decorator
#[dojo::contract]
pub mod actions {
    use super::IActions;
    use starknet::{ContractAddress, get_caller_address};
    use dojo_starter::models::{
        Piece, Coordinates, Position, Session, Player, Counter, CounterTrait
    };

    use dojo::model::{ModelStorage, ModelValueStorage};
    use dojo::event::EventStorage;

    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct Moved {
        #[key]
        pub session_id: u64,
        #[key]
        pub player: ContractAddress,
        pub row: u8,
        pub col: u8,
    }
    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct Killed {
        #[key]
        pub session_id: u64,
        #[key]
        pub player: ContractAddress,
        pub row: u8,
        pub col: u8,
    }

    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct Winner {
        #[key]
        pub session_id: u64,
        #[key]
        pub player: ContractAddress,
        pub position: Position,
    }

    #[abi(embed_v0)]
    impl ActionsImpl of IActions<ContractState> {
        fn create_lobby(ref self: ContractState) -> u64 {
            let mut world = self.world_default();
            let player = get_caller_address();
            // let mut counter: Counter = world.read_model(0);

            // TODO: Fix counter for production
            // let _id = counter.uuid();
            // world.write_model(@counter);
            // TODO: Refactor the session_id for production
            let session = Session {
                session_id: 0,
                player_1: player,
                player_2: starknet::contract_address_const::<0x0>(),
                turn: 0,
                winner: starknet::contract_address_const::<0x0>(),
                state: 0,
            };
            world.write_model(@session);
            // Initialize the pieces for the session
            self.initialize_pieces_session_id(session.session_id);
            // Spawn the pieces for the player
            self.spawn(player, Position::Up, session.session_id);

            0
        }

        fn join_lobby(ref self: ContractState, session_id: u64) {
            let mut world = self.world_default();
            let player = get_caller_address();
            let mut session: Session = world.read_model((session_id));
            session.player_2 = player;
            session.state = 1;
            world.write_model(@session);
            // Spawn the pieces for the player
            self.spawn(player, Position::Down, session_id);
        }

        fn can_choose_piece(
            ref self: ContractState,
            position: Position,
            coordinates_position: Coordinates,
            session_id: u64
        ) -> bool {
            let mut world = self.world_default();

            // Get the address of the current caller, possibly the player's address.
            let session: Session = world.read_model((session_id));
            let turn = session.turn;

            // Check if it is the player's turn
            if position == Position::Up && turn == 1 {
                panic!("Not your turn");
            } else if position == Position::Down && turn == 0 {
                panic!("Not your turn");
            }

            // Check is current coordinates is valid
            let is_valid_position = self.check_is_valid_position(coordinates_position);
            if !is_valid_position {
                return false;
            }

            // Get the player's piece from the world by its coordinates.
            let piece: Piece = world.read_model((session_id, coordinates_position));

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
            let session_id = current_piece.session_id;

            // Get the piece from the world by its coordinates.
            let square: Piece = world.read_model((session_id, row, col));

            // Update the piece's coordinates based on the new coordinates.
            self.update_piece_position(current_piece, square);

            // Update the session's turn
            let mut session: Session = world.read_model((session_id));
            session.turn = (session.turn + 1) % 2;
            world.write_model(@session);
        }

        fn move_piece_multiple(
            ref self: ContractState,
            current_piece: Piece,
            new_coordinates_positions: Array<Coordinates>
        ) {
            for new_coordinates_position in new_coordinates_positions {
                self.move_piece_single(current_piece, new_coordinates_position);
            };
            let mut world = self.world_default();
            // Update the session's turn
            let mut session: Session = world.read_model((current_piece.session_id));
            session.turn = (session.turn + 1) % 2;
            world.write_model(@session);
        }

        //Getter function
        fn get_session_id(self: @ContractState) -> u64 {
            let mut world = self.world_default();
            let counter: Counter = world.read_model((0));

            counter.nonce - 1
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        // Need a function since byte array can't be const.
        // We could have a self.world with an other function to init from hash, that can be
        // constant.
        fn world_default(self: @ContractState) -> dojo::world::WorldStorage {
            self.world(@"checkers_marq")
        }

        fn move_piece_single(
            ref self: ContractState, current_piece: Piece, new_coordinates_position: Coordinates
        ) {
            // Get the address of the current caller, possibly the player's address.
            let world = self.world_default();

            //let player = get_caller_address();

            // Check is new coordinates is valid
            let is_valid_position = self.check_is_valid_position(new_coordinates_position);
            assert(is_valid_position, 'Invalid coordinates');

            let row = new_coordinates_position.row;
            let col = new_coordinates_position.col;
            let session_id = current_piece.session_id;

            // Get the piece from the world by its coordinates.
            let square: Piece = world.read_model((session_id, row, col));

            // Update the piece's coordinates based on the new coordinates.
            self.update_piece_position(current_piece, square);
        }

        fn spawn(
            ref self: ContractState, player: ContractAddress, position: Position, session_id: u64
        ) {
            let mut world = self.world_default();
            if position == Position::Up {
                self.initialize_player_pieces(player, 0, 2, Position::Up, session_id);
            } else if position == Position::Down {
                self.initialize_player_pieces(player, 5, 7, Position::Down, session_id);
            }
            // Assign remaining pieces to player
            let player_model = Player { player: player, remaining_pieces: 12, };
            world.write_model(@player_model);
        }

        fn check_diagonal_path(
            self: @ContractState,
            start_row: u8,
            start_col: u8,
            row_step: u8,
            col_step: u8,
            session_id: u64
        ) -> bool {
            let mut row = start_row;
            let mut col = start_col;
            let world = self.world_default();
            let mut good_move = false;

            loop {
                row += row_step;
                col += col_step;

                let valid = self.check_is_valid_position(Coordinates { row, col });

                if valid {
                    let target_square: Piece = world.read_model((session_id, row, col));

                    if target_square.is_alive {
                        break;
                    }
                    good_move = true;
                };
                break;
            };
            good_move
        }

        fn initialize_player_pieces(
            ref self: ContractState,
            player: ContractAddress,
            start_row: u8,
            end_row: u8,
            position: Position,
            session_id: u64,
        ) {
            let mut world = self.world_default();
            let mut row = start_row;
            let mut pieces: Array<@Piece> = array![];
            while row <= end_row {
                let start_col = (row + 1) % 2; // Alternates between 0 and 1
                let mut col = start_col;
                while col < 8 {
                    let piece = Piece {
                        session_id, row, col, player, position, is_king: false, is_alive: true,
                    };
                    pieces.append(@piece);
                    col += 2;
                };
                row += 1;
            };
            world.write_models(pieces.span());
        }

        fn initialize_pieces_session_id(ref self: ContractState, session_id: u64) {
            let mut world = self.world_default();
            let mut row = 0;
            let mut pieces: Array<@Piece> = array![];
            while row < 8 {
                let start_col = (row + 1) % 2; // Alternates between 0 and 1
                let mut col = start_col;
                while col < 8 {
                    let piece = Piece {
                        session_id,
                        row,
                        col,
                        player: starknet::contract_address_const::<0x0>(),
                        position: Position::None,
                        is_king: false,
                        is_alive: false,
                    };
                    pieces.append(@piece);
                    col += 2;
                };
                row += 1;
            };
            world.write_models(pieces.span());
        }

        fn change_is_alive(
            self: @ContractState, mut current_piece: Piece, new_coordinates_position: Coordinates
        ) {
            let mut world = self.world_default();
            let session_id = current_piece.session_id;
            let mut square: Piece = world.read_model((session_id, new_coordinates_position));

            // Check if the piece can be promoted to a king
            if current_piece.position == Position::Up && new_coordinates_position.row == 7 {
                current_piece.is_king = true;
            } else if current_piece.position == Position::Down
                && new_coordinates_position.row == 0 {
                current_piece.is_king = true;
            }
            // Update the piece attributes based on the new coordinates.
            square.is_alive = true;
            square.player = current_piece.player;
            square.position = current_piece.position;
            square.is_king = current_piece.is_king;

            // Update the current piece attributes.
            current_piece.is_alive = false;
            current_piece.player = starknet::contract_address_const::<0x0>();
            current_piece.position = Position::None;
            current_piece.is_king = false;

            // Write the new coordinates to the world.
            let pieces: Array<@Piece> = array![@square, @current_piece];
            world.write_models(pieces.span());

            // Emit an event about the move
            let row = new_coordinates_position.row;
            let col = new_coordinates_position.col;
            world.emit_event(@Moved { session_id, player: square.player, row, col });
        }

        fn check_has_valid_moves(self: @ContractState, piece: Piece) -> bool {
            let world = self.world_default();
            let piece_row = piece.row;
            let piece_col = piece.col;
            let session_id = piece.session_id;
            // Only handling non-king pieces for now
            if piece.is_king == true {
                // For kings, check all four directions using only unsigned integers
                // Moving up (subtract) is only possible if we're not at row 0
                let can_move_up = piece_row > 0;
                let can_move_left = piece_col > 0;

                let mut has_valid_move = false;

                // Down-right (both increment)
                if piece_row != 7 {
                    has_valid_move = has_valid_move
                        || self.check_diagonal_path(piece_row, piece_col, 1, 1, session_id);
                }

                // Down-left (row increment, col decrement but only if col > 0)
                if can_move_left {
                    has_valid_move = has_valid_move
                        || self.check_diagonal_path(piece_row, piece_col, 1, 0, session_id);
                }

                // Up-right (row decrement but only if row > 0, col increment)
                if can_move_up {
                    has_valid_move = has_valid_move
                        || self.check_diagonal_path(piece_row - 1, piece_col, 0, 1, session_id);
                }

                // Up-left (both decrement but only if both > 0)
                if can_move_up && can_move_left {
                    has_valid_move = has_valid_move
                        || self.check_diagonal_path(piece_row - 1, piece_col - 1, 0, 0, session_id);
                }

                return has_valid_move;
            }

            if piece.position == Position::None {
                return false;
            } else {
                if (piece.position == Position::Up && piece_row + 1 >= 8)
                    || (piece.position == Position::Down && piece_row == 0) {
                    return false;
                }
                let row = if piece.position == Position::Up {
                    piece_row + 1
                } else {
                    piece_row - 1
                };
                let mut target_coordinates_keys = array![];
                // Check left diagonal
                if piece_col > 0 {
                    let target_left = Coordinates { row, col: piece_col - 1 };
                    target_coordinates_keys.append((session_id, target_left));
                }
                // Check right diagonal
                if piece_col + 1 < 8 {
                    let target_right = Coordinates { row, col: piece_col + 1 };
                    target_coordinates_keys.append((session_id, target_right));
                }
                let target_squares: Array<Piece> = world
                    .read_models(target_coordinates_keys.span());
                let mut alive_squares: u32 = 0;
                for target_square in target_squares
                    .clone() {
                        alive_squares += if target_square.is_alive {
                            1
                        } else {
                            0
                        };
                    };
                return alive_squares < target_squares.len();
            }
        }

        fn is_jump_possible(self: @ContractState, piece: Piece, square: Piece) -> bool {
            let world = self.world_default();
            let session_id = piece.session_id;
            if piece.col > square.col {
                // Move left
                match piece.position {
                    Position::Up => {
                        let jump_coordinates = Coordinates {
                            row: piece.row + 2, col: piece.col - 2
                        };
                        let jump_square: Piece = world.read_model((session_id, jump_coordinates));
                        return !jump_square.is_alive;
                    },
                    Position::Down => {
                        let jump_coordinates = Coordinates {
                            row: piece.row - 2, col: piece.col - 2
                        };
                        let jump_square: Piece = world.read_model((session_id, jump_coordinates));
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
                        let jump_square: Piece = world.read_model((session_id, jump_coordinates));
                        return !jump_square.is_alive;
                    },
                    Position::Down => {
                        let jump_coordinates = Coordinates {
                            row: piece.row - 2, col: piece.col + 2
                        };
                        let jump_square: Piece = world.read_model((session_id, jump_coordinates));
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
                let killed_player = square.player;
                let session_id = piece.session_id;
                square.is_alive = false;
                square.player = starknet::contract_address_const::<0x0>();
                square.position = Position::None;

                world.write_model(@square);

                let player = piece.player;
                world.emit_event(@Killed { session_id, player, row: square.row, col: square.col });

                // Update the enemy player remaining pieces
                let mut killed_player_world: Player = world.read_model((killed_player));
                killed_player_world.remaining_pieces -= 1;
                world.write_model(@killed_player_world);

                // Check if the player won the game
                if killed_player_world.remaining_pieces == 0 {
                    let mut session: Session = world.read_model((session_id));
                    session.winner = piece.player;
                    session.state = 2;
                    world.write_model(@session);
                    let position = piece.position;
                    world.emit_event(@Winner { session_id, player: piece.player, position });
                }

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
            if square.is_alive && piece.position != square.position {
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
