#[cfg(test)]
mod tests {
    use dojo::model::{ModelStorage, ModelValueStorage, ModelStorageTest};
    use dojo::world::WorldStorageTrait;
    use dojo_cairo_test::{spawn_test_world, NamespaceDef, TestResource, ContractDef, ContractDefTrait, WorldStorageTestTrait};

    use dojo_starter::systems::actions::{actions, IActionsDispatcher, IActionsDispatcherTrait};
    use dojo_starter::models::{
        Piece, m_Piece, Coordinates, Position, Session, m_Session, Player, m_Player
    };

    fn namespace_def() -> NamespaceDef {
        let ndef = NamespaceDef {
            namespace: "checkers_marq", resources: [
                TestResource::Model(m_Piece::TEST_CLASS_HASH),
                TestResource::Model(m_Session::TEST_CLASS_HASH),
                TestResource::Model(m_Player::TEST_CLASS_HASH),
                TestResource::Event(actions::e_Moved::TEST_CLASS_HASH),
                TestResource::Event(actions::e_Killed::TEST_CLASS_HASH),
                TestResource::Event(actions::e_Winner::TEST_CLASS_HASH),
                TestResource::Contract(actions::TEST_CLASS_HASH)
            ].span()
        };

        ndef
    }

    fn contract_defs() -> Span<ContractDef> {
        [
            ContractDefTrait::new(@"checkers_marq", @"actions")
                .with_writer_of([dojo::utils::bytearray_hash(@"checkers_marq")].span())
        ].span()
    }

    #[test]
    fn test_world_test_set() {
        // Initialize test environment
        let caller = starknet::contract_address_const::<0x0>();
        let session_id = 0;
        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());
        world.sync_perms_and_inits(contract_defs());

        // Test initial piece
        let piece_position_77 = Coordinates { row: 7, col: 7 };
        let piece: Piece = world.read_model((session_id, piece_position_77));
        assert(piece.position == Position::None && piece.is_alive == false, 'initial piece wrong');

        // Test write_model_test
        let row = 1;
        let col = 1;
        let piece = Piece {
            session_id: session_id,
            player: caller,
            row: row,
            col: col,
            position: Position::Down,
            is_king: true,
            is_alive: true
        };

        world.write_model_test(@piece);

        let piece: Piece = world.read_model((session_id, row, col));
        assert(
            piece.position == Position::Down && piece.is_king == true && piece.session_id == 0,
            'write_value_from_id failed'
        );
        assert(piece.is_alive == true, 'write_value_from_id failed');
        // Test model deletion
        world.erase_model(@piece);
        let piece: Piece = world.read_model((session_id, row, col));
        assert(piece.position == Position::None && piece.is_king == false, 'erase_model failed');
        assert(piece.is_alive == false, 'erase_model failed');
    }
    #[test]
    fn test_can_not_choose_piece() {
        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());

        let (contract_address, _) = world.dns(@"actions").unwrap();
        let actions_system = IActionsDispatcher { contract_address };
        let session_id = 0;

        // test zero row
        let invalid_piece_position00 = Coordinates { row: 0, col: 0 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position00, session_id);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position01 = Coordinates { row: 0, col: 1 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position01, session_id);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position02 = Coordinates { row: 0, col: 2 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position02, session_id);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position03 = Coordinates { row: 0, col: 3 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position03, session_id);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position04 = Coordinates { row: 0, col: 4 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position04, session_id);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position05 = Coordinates { row: 0, col: 5 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position05, session_id);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position06 = Coordinates { row: 0, col: 6 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position06, session_id);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position07 = Coordinates { row: 0, col: 7 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position07, session_id);
        assert(!can_choose_piece, 'should be false');

        // test first row
        let invalid_piece_position10 = Coordinates { row: 1, col: 0 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position10, session_id);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position11 = Coordinates { row: 1, col: 1 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position11, session_id);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position12 = Coordinates { row: 1, col: 2 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position12, session_id);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position13 = Coordinates { row: 1, col: 3 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position13, session_id);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position14 = Coordinates { row: 1, col: 4 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position14, session_id);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position15 = Coordinates { row: 1, col: 5 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position15, session_id);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position16 = Coordinates { row: 1, col: 6 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position16, session_id);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position17 = Coordinates { row: 1, col: 7 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position17, session_id);
        assert(!can_choose_piece, 'should be false');

        // test second row
        let invalid_piece_position20 = Coordinates { row: 2, col: 0 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position20, session_id);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position22 = Coordinates { row: 2, col: 2 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position22, session_id);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position24 = Coordinates { row: 2, col: 4 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position24, session_id);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position26 = Coordinates { row: 2, col: 6 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position26, session_id);
        assert(!can_choose_piece, 'should be false');

        // test fifth row
        let invalid_piece_position51 = Coordinates { row: 5, col: 1 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position51, session_id);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position53 = Coordinates { row: 5, col: 3 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position53, session_id);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position55 = Coordinates { row: 5, col: 5 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position55, session_id);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position57 = Coordinates { row: 5, col: 7 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position57, session_id);
        assert(!can_choose_piece, 'should be false');

        // test sixth row
        let invalid_piece_position60 = Coordinates { row: 6, col: 0 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, invalid_piece_position60, session_id);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position61 = Coordinates { row: 6, col: 1 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, invalid_piece_position61, session_id);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position62 = Coordinates { row: 6, col: 2 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, invalid_piece_position62, session_id);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position63 = Coordinates { row: 6, col: 3 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, invalid_piece_position63, session_id);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position64 = Coordinates { row: 6, col: 4 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, invalid_piece_position64, session_id);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position65 = Coordinates { row: 6, col: 5 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, invalid_piece_position65, session_id);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position66 = Coordinates { row: 6, col: 6 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, invalid_piece_position66, session_id);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position67 = Coordinates { row: 6, col: 7 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, invalid_piece_position67, session_id);
        assert(!can_choose_piece, 'should be false');

        // test seventh row
        let invalid_piece_position70 = Coordinates { row: 7, col: 0 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, invalid_piece_position70, session_id);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position71 = Coordinates { row: 7, col: 1 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, invalid_piece_position71, session_id);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position72 = Coordinates { row: 7, col: 2 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, invalid_piece_position72, session_id);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position73 = Coordinates { row: 7, col: 3 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, invalid_piece_position73, session_id);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position74 = Coordinates { row: 7, col: 4 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, invalid_piece_position74, session_id);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position75 = Coordinates { row: 7, col: 5 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, invalid_piece_position75, session_id);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position76 = Coordinates { row: 7, col: 6 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, invalid_piece_position76, session_id);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position77 = Coordinates { row: 7, col: 7 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, invalid_piece_position77, session_id);
        assert(!can_choose_piece, 'should be false');
    }

    #[test]
    fn test_can_choose_piece() {
        //let caller = starknet::contract_address_const::<0x0>();

        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());

        let (contract_address, _) = world.dns(@"actions").unwrap();
        let actions_system = IActionsDispatcher { contract_address };

        let session_id = actions_system.create_lobby();
        actions_system.join_lobby(session_id);

        // test third row
        let valid_piece_position21 = Coordinates { row: 2, col: 1 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, valid_piece_position21, session_id);
        assert(can_choose_piece, 'should be true');
        let valid_piece_position23 = Coordinates { row: 2, col: 3 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, valid_piece_position23, session_id);
        assert(can_choose_piece, 'should be true');

        let valid_piece_position25 = Coordinates { row: 2, col: 5 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, valid_piece_position25, session_id);
        assert(can_choose_piece, 'should be true');

        let valid_piece_position27 = Coordinates { row: 2, col: 7 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, valid_piece_position27, session_id);
        assert(can_choose_piece, 'should be true');
        // test fifth row
        let valid_piece_position50 = Coordinates { row: 5, col: 0 };

        // Change turn 
        let mut game: Session = world.read_model((session_id));
        game.turn = 1;
        world.write_model(@game);

        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, valid_piece_position50, session_id);
        assert(can_choose_piece, 'should be true');

        let valid_piece_position52 = Coordinates { row: 5, col: 2 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, valid_piece_position52, session_id);
        assert(can_choose_piece, 'should be true');

        let valid_piece_position54 = Coordinates { row: 5, col: 4 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, valid_piece_position54, session_id);
        assert(can_choose_piece, 'should be true');

        let valid_piece_position56 = Coordinates { row: 5, col: 6 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, valid_piece_position56, session_id);
        assert(can_choose_piece, 'should be true');
    }

    //Test can choose piece but can not move
    #[test]
    #[should_panic(expected: ('Invalid coordinates', 'ENTRYPOINT_FAILED'))]
    fn test_move_piece31_forward_straight_fails() {
        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());

        let (contract_address, _) = world.dns(@"actions").unwrap();
        let actions_system = IActionsDispatcher { contract_address };
        let session_id = actions_system.create_lobby();
        actions_system.join_lobby(session_id);

        let valid_piece_position = Coordinates { row: 2, col: 1 };

        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, valid_piece_position, session_id);
        assert(can_choose_piece, 'can_choose_piece failed');

        let current_piece = world.read_model((session_id, valid_piece_position));
        let new_coordinates_position = Coordinates { row: 3, col: 1 };
        actions_system.move_piece(current_piece, new_coordinates_position);
    }

    #[test]
    #[should_panic(expected: ('Invalid coordinates', 'ENTRYPOINT_FAILED'))]
    fn test_move_piece37_forward_right_fails() {
        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());

        let (contract_address, _) = world.dns(@"actions").unwrap();
        let actions_system = IActionsDispatcher { contract_address };
        let session_id = actions_system.create_lobby();
        actions_system.join_lobby(session_id);

        let valid_piece_position = Coordinates { row: 2, col: 7 };

        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, valid_piece_position, session_id);
        assert(can_choose_piece, 'can_choose_piece failed');

        let current_piece = world.read_model((session_id, valid_piece_position));
        let new_coordinates_position = Coordinates { row: 3, col: 8 };
        actions_system.move_piece(current_piece, new_coordinates_position);
    }

    #[test]
    fn test_move_piece21_down_left() {
        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());

        let (contract_address, _) = world.dns(@"actions").unwrap();
        let actions_system = IActionsDispatcher { contract_address };
        let session_id = actions_system.create_lobby();
        actions_system.join_lobby(session_id);

        let valid_piece_position = Coordinates { row: 2, col: 1 };
        let initial_piece_position: Piece = world.read_model((session_id, valid_piece_position));

        assert(
            initial_piece_position.row == 2 && initial_piece_position.col == 1,
            'wrong initial piece'
        );
        assert(initial_piece_position.session_id == 0, 'wrong session');
        assert(initial_piece_position.is_king == false, 'wrong initial piece');
        assert(initial_piece_position.is_alive == true, 'wrong initial piece');

        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, valid_piece_position, session_id);
        assert(can_choose_piece, 'can_choose_piece failed');
        let current_piece: Piece = world.read_model((session_id, valid_piece_position));
        let new_coordinates_position = Coordinates { row: 3, col: 0 };
        actions_system.move_piece(current_piece, new_coordinates_position);

        let new_position: Piece = world.read_model((session_id, new_coordinates_position));

        assert!(new_position.session_id == 0, "wrong session");
        assert!(new_position.row == 3, "piece x is wrong");
        assert!(new_position.col == 0, "piece y is wrong");
        assert!(new_position.is_alive == true, "piece is not alive");
        assert!(new_position.is_king == false, "piece is king");
    }

    #[test]
    fn test_move_piece23_down_left() {
        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());

        let (contract_address, _) = world.dns(@"actions").unwrap();
        let actions_system = IActionsDispatcher { contract_address };
        let session_id = actions_system.create_lobby();
        actions_system.join_lobby(session_id);

        let valid_piece_position = Coordinates { row: 2, col: 3 };
        let initial_piece_position: Piece = world.read_model((session_id, valid_piece_position));
        assert(
            initial_piece_position.row == 2 && initial_piece_position.col == 3,
            'wrong initial piece cords'
        );
        assert(initial_piece_position.session_id == 0, 'wrong session');
        assert(initial_piece_position.is_king == false, 'wrong initial piece king');
        assert(initial_piece_position.is_alive == true, 'wrong initial piece alive');

        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, valid_piece_position, session_id);
        assert(can_choose_piece, 'can_choose_piece failed');
        let current_piece: Piece = world.read_model((session_id, valid_piece_position));
        let new_coordinates_position = Coordinates { row: 3, col: 2 };
        actions_system.move_piece(current_piece, new_coordinates_position);

        let new_position: Piece = world.read_model((session_id, new_coordinates_position));

        assert!(new_position.session_id == 0, "wrong session");
        assert!(new_position.row == 3, "piece x is wrong");
        assert!(new_position.col == 2, "piece y is wrong");
        assert!(new_position.is_alive == true, "piece is not alive");
        assert!(new_position.is_king == false, "piece is king");
    }

    #[test]
    fn test_move_piece23_down_left_choose() {
        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());

        let (contract_address, _) = world.dns(@"actions").unwrap();
        let actions_system = IActionsDispatcher { contract_address };

        actions_system.spawn();
        let valid_piece_position = Coordinates { row: 2, col: 3 };
        let initial_piece_position: Piece = world.read_model((valid_piece_position));
        assert(
            initial_piece_position.row == 2
                && initial_piece_position.col == 3,
            'wrong initial piece cords'
        );
        assert(initial_piece_position.is_king == false, 'wrong initial piece king');
        assert(initial_piece_position.is_alive == true, 'wrong initial piece alive');

        let can_choose_piece = actions_system.can_choose_piece(Position::Up, valid_piece_position);
        assert(can_choose_piece, 'can_choose_piece failed');
        let current_piece: Piece = world.read_model((valid_piece_position));
        let new_coordinates_position = Coordinates { row: 3, col: 2 };
        actions_system.move_piece(current_piece, new_coordinates_position);

        let new_position: Piece = world.read_model((new_coordinates_position));

        assert!(new_position.row == 3, "piece x is wrong");
        assert!(new_position.col == 2, "piece y is wrong");
        assert!(new_position.is_alive == true, "piece is not alive");
        assert!(new_position.is_king == false, "piece is king");

        let can_choose_piece = actions_system.can_choose_piece(Position::Up, new_coordinates_position);
        assert(can_choose_piece, 'can_choose_piece failed 32');
    }    

    #[test]
    fn test_move_piece25_down_left() {
        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());

        let (contract_address, _) = world.dns(@"actions").unwrap();
        let actions_system = IActionsDispatcher { contract_address };
        let session_id = actions_system.create_lobby();
        actions_system.join_lobby(session_id);

        let valid_piece_position = Coordinates { row: 2, col: 5 };
        let initial_piece_position: Piece = world.read_model((session_id, valid_piece_position));

        assert(
            initial_piece_position.row == 2 && initial_piece_position.col == 5,
            'wrong initial piece'
        );
        assert(initial_piece_position.session_id == 0, 'wrong session');
        assert(initial_piece_position.is_king == false, 'wrong initial piece');
        assert(initial_piece_position.is_alive == true, 'wrong initial piece');

        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, valid_piece_position, session_id);
        assert(can_choose_piece, 'can_choose_piece failed');
        let current_piece: Piece = world.read_model((session_id, valid_piece_position));
        let new_coordinates_position = Coordinates { row: 3, col: 4 };
        actions_system.move_piece(current_piece, new_coordinates_position);

        let new_position: Piece = world.read_model((session_id, new_coordinates_position));

        assert!(new_position.session_id == 0, "wrong session");
        assert!(new_position.row == 3, "piece x is wrong");
        assert!(new_position.col == 4, "piece y is wrong");
        assert!(new_position.is_alive == true, "piece is not alive");
        assert!(new_position.is_king == false, "piece is king");
    }

    #[test]
    fn test_move_piece27_down_left() {
        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());

        let (contract_address, _) = world.dns(@"actions").unwrap();
        let actions_system = IActionsDispatcher { contract_address };
        let session_id = actions_system.create_lobby();
        actions_system.join_lobby(session_id);

        let valid_piece_position = Coordinates { row: 2, col: 7 };
        let initial_piece_position: Piece = world.read_model((session_id, valid_piece_position));

        assert(
            initial_piece_position.row == 2 && initial_piece_position.col == 7,
            'wrong initial piece'
        );
        assert(initial_piece_position.session_id == 0, 'wrong session');
        assert(initial_piece_position.is_king == false, 'wrong initial piece');
        assert(initial_piece_position.is_alive == true, 'wrong initial piece');

        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, valid_piece_position, session_id);
        assert(can_choose_piece, 'can_choose_piece failed');
        let current_piece: Piece = world.read_model((session_id, valid_piece_position));
        let new_coordinates_position = Coordinates { row: 3, col: 6 };
        actions_system.move_piece(current_piece, new_coordinates_position);

        let new_position: Piece = world.read_model((session_id, new_coordinates_position));

        assert!(new_position.session_id == 0, "wrong session");
        assert!(new_position.row == 3, "piece x is wrong");
        assert!(new_position.col == 6, "piece y is wrong");
        assert!(new_position.is_alive == true, "piece is not alive");
        assert!(new_position.is_king == false, "piece is king");
    }

    #[test]
    fn test_move_piece21_down_right() {
        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());

        let (contract_address, _) = world.dns(@"actions").unwrap();
        let actions_system = IActionsDispatcher { contract_address };
        let session_id = actions_system.create_lobby();
        actions_system.join_lobby(session_id);

        let valid_piece_position = Coordinates { row: 2, col: 1 };
        let initial_piece_position: Piece = world.read_model((session_id, valid_piece_position));

        assert(
            initial_piece_position.row == 2 && initial_piece_position.col == 1,
            'wrong initial piece'
        );
        assert(initial_piece_position.session_id == 0, 'wrong session');
        assert(initial_piece_position.is_king == false, 'wrong initial piece');
        assert(initial_piece_position.is_alive == true, 'wrong initial piece');

        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, valid_piece_position, session_id);
        assert(can_choose_piece, 'can_choose_piece failed');
        let current_piece: Piece = world.read_model((session_id, valid_piece_position));
        let new_coordinates_position = Coordinates { row: 3, col: 2 };
        actions_system.move_piece(current_piece, new_coordinates_position);

        let new_position: Piece = world.read_model((session_id, new_coordinates_position));

        assert!(new_position.session_id == 0, "wrong session");
        assert!(new_position.row == 3, "piece x is wrong");
        assert!(new_position.col == 2, "piece y is wrong");
        assert!(new_position.is_alive == true, "piece is not alive");
        assert!(new_position.is_king == false, "piece is king");
    }

    #[test]
    fn test_move_piece21_down_right_move_piece56_up_left() {
        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());

        let (contract_address, _) = world.dns(@"actions").unwrap();
        let actions_system = IActionsDispatcher { contract_address };
        let session_id = actions_system.create_lobby();
        actions_system.join_lobby(session_id);

        let valid_piece_position = Coordinates { row: 2, col: 1 };
        let initial_piece_position: Piece = world.read_model((session_id, valid_piece_position));

        assert(
            initial_piece_position.row == 2 && initial_piece_position.col == 1,
            'wrong initial piece'
        );
        assert(initial_piece_position.session_id == 0, 'wrong session');
        assert(initial_piece_position.is_king == false, 'wrong initial piece');
        assert(initial_piece_position.is_alive == true, 'wrong initial piece');

        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, valid_piece_position, session_id);
        assert(can_choose_piece, 'can_choose_piece failed');
        let current_piece: Piece = world.read_model((session_id, valid_piece_position));
        let new_coordinates_position = Coordinates { row: 3, col: 2 };
        actions_system.move_piece(current_piece, new_coordinates_position);

        let new_position: Piece = world.read_model((session_id, new_coordinates_position));

        assert!(new_position.session_id == 0, "wrong session");
        assert!(new_position.row == 3, "piece x is wrong");
        assert!(new_position.col == 2, "piece y is wrong");
        assert!(new_position.is_alive == true, "piece is not alive");
        assert!(new_position.is_king == false, "piece is king");

        let valid_piece_position56 = Coordinates { row: 5, col: 6 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, valid_piece_position56, session_id);
        assert(can_choose_piece, 'can_choose_piece failed');
        let current_piece: Piece = world.read_model((session_id, valid_piece_position56));
        let new_coordinates_position = Coordinates { row: 4, col: 5 };
        actions_system.move_piece(current_piece, new_coordinates_position);

        let new_position: Piece = world.read_model((session_id, new_coordinates_position));

        assert!(new_position.session_id == 0, "wrong session");
        assert!(new_position.row == 4, "piece x is wrong");
        assert!(new_position.col == 5, "piece y is wrong");
        assert!(new_position.is_alive == true, "piece is not alive");
        assert!(new_position.is_king == false, "piece is king");
    }

    #[test]
    fn test_piece21_eat_piece54() {
        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());

        let (contract_address, _) = world.dns(@"actions").unwrap();
        let actions_system = IActionsDispatcher { contract_address };
        let session_id = actions_system.create_lobby();
        // Cheat call the second player
        let player2 = starknet::contract_address_const::<0x1>();
        starknet::testing::set_contract_address(player2);
        actions_system.join_lobby(session_id);

        let session: Session = world.read_model((session_id));
        assert(session.player_2 == player2, 'wrong player');
        // Reset player to default operation
        starknet::testing::set_contract_address(starknet::contract_address_const::<0x0>());

        let valid_piece_position = Coordinates { row: 2, col: 1 };
        let initial_piece_position: Piece = world.read_model((session_id, valid_piece_position));

        assert(
            initial_piece_position.row == 2 && initial_piece_position.col == 1,
            'wrong initial piece'
        );
        assert(initial_piece_position.session_id == 0, 'wrong session');
        assert(initial_piece_position.is_king == false, 'wrong initial piece');
        assert(initial_piece_position.is_alive == true, 'wrong initial piece');

        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, valid_piece_position, session_id);
        assert(can_choose_piece, 'can_choose_piece failed');
        let current_piece: Piece = world.read_model((session_id, valid_piece_position));
        let new_coordinates_position = Coordinates { row: 3, col: 2 };
        actions_system.move_piece(current_piece, new_coordinates_position);

        let new_position: Piece = world.read_model((session_id, new_coordinates_position));

        assert!(new_position.session_id == 0, "wrong session");
        assert!(new_position.row == 3, "piece x is wrong");
        assert!(new_position.col == 2, "piece y is wrong");
        assert!(new_position.is_alive == true, "piece is not alive");
        assert!(new_position.is_king == false, "piece is king");

        let valid_piece_position54 = Coordinates { row: 5, col: 4 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, valid_piece_position54, session_id);
        assert(can_choose_piece, 'can_choose_piece failed');
        let current_piece: Piece = world.read_model((session_id, valid_piece_position54));
        let new_coordinates_position = Coordinates { row: 4, col: 3 };
        actions_system.move_piece(current_piece, new_coordinates_position);

        let new_position: Piece = world.read_model((session_id, new_coordinates_position));

        assert!(new_position.row == 4, "piece x is wrong");
        assert!(new_position.col == 3, "piece y is wrong");
        assert!(new_position.is_alive == true, "piece is not alive");
        assert!(new_position.is_king == false, "piece is king");

        let eat_position = Coordinates { row: 4, col: 3 };
        let killing_position = Coordinates { row: 3, col: 2 };
        let killing_piece: Piece = world.read_model((session_id, killing_position));
        actions_system.move_piece(killing_piece, eat_position);

        let killed_piece: Piece = world.read_model((session_id, eat_position));
        assert!(killed_piece.row == 4, "piece x is wrong");
        assert!(killed_piece.col == 3, "piece y is wrong");
        assert!(killed_piece.is_alive == false, "piece is alive");
        assert!(killed_piece.is_king == false, "piece is king");

        // Check the remaining pieces got reduced
        let player_model: Player = world.read_model(player2);
        assert!(player_model.remaining_pieces == 11, "wrong remaining pieces");

        let jump_position = Coordinates { row: 5, col: 4 };
        let moved_piece: Piece = world.read_model((session_id, jump_position));
        assert!(moved_piece.row == 5, "piece x is wrong");
        assert!(moved_piece.col == 4, "piece y is wrong");
        assert!(moved_piece.is_alive == true, "piece is not alive");
        assert!(moved_piece.position == Position::Up, "piece is not right team");
        assert!(moved_piece.is_king == false, "piece is king");
    }

    #[test]
    fn test_move_king_piece() {
        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());

        let (contract_address, _) = world.dns(@"actions").unwrap();
        let actions_system = IActionsDispatcher { contract_address };
        let session_id = actions_system.create_lobby();
        // Cheat call the second player
        let player2 = starknet::contract_address_const::<0x1>();
        starknet::testing::set_contract_address(player2);
        actions_system.join_lobby(session_id);

        let session: Session = world.read_model((session_id));
        assert(session.player_2 == player2, 'wrong player');
        // Reset player to default operation
        starknet::testing::set_contract_address(starknet::contract_address_const::<0x0>());

        let valid_piece_position = Coordinates { row: 2, col: 5 };
        let initial_piece_position: Piece = world.read_model((session_id, valid_piece_position));

        assert(
            initial_piece_position.row == 2 && initial_piece_position.col == 5,
            'wrong initial piece'
        );
        assert(initial_piece_position.session_id == 0, 'wrong session');
        assert(initial_piece_position.is_king == false, 'wrong initial piece');
        assert(initial_piece_position.is_alive == true, 'wrong initial piece');
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, valid_piece_position, session_id);
        assert(can_choose_piece, 'can_choose_piece failed');
        let current_piece: Piece = world.read_model((session_id, valid_piece_position));
        let new_coordinates_position = Coordinates { row: 3, col: 4 };
        actions_system.move_piece(current_piece, new_coordinates_position);

        let new_position: Piece = world.read_model((session_id, new_coordinates_position));

        assert!(new_position.session_id == 0, "wrong session");
        assert!(new_position.row == 3, "piece x is wrong");
        assert!(new_position.col == 4, "piece y is wrong");
        assert!(new_position.is_alive == true, "piece is not alive");
        assert!(new_position.is_king == false, "piece is king");

        let new_coordinates_position = Coordinates { row: 4, col: 3 };
        let current_cords = Coordinates { row: 3, col: 4 };
        let current_piece: Piece = world.read_model((session_id, current_cords));
        actions_system.move_piece(current_piece, new_coordinates_position);
        let new_piece: Piece = world.read_model((session_id, new_coordinates_position));

        assert!(new_piece.session_id == 0, "wrong session");
        assert!(new_piece.row == 4, "piece x is wrong");
        assert!(new_piece.col == 3, "piece y is wrong");
        assert!(new_piece.is_alive == true, "piece is not alive");
        assert!(new_piece.is_king == false, "piece is king");

        // Cheat pieces to make way for the king
        let cheat_cords = Coordinates { row: 3, col: 0 };
        let moving_cords = Coordinates { row: 5, col: 2 };
        let moving_piece: Piece = world.read_model((session_id, moving_cords));
        actions_system.move_piece(moving_piece, cheat_cords);

        let cheat_piece: Piece = world.read_model((session_id, cheat_cords));
        assert!(cheat_piece.row == 3, "piece x is wrong");
        assert!(cheat_piece.col == 0, "piece y is wrong");
        assert!(cheat_piece.is_alive == true, "piece is not alive");
        assert!(cheat_piece.is_king == false, "piece is king");
        assert!(cheat_piece.position == Position::Down, "piece is not right team");

        let cheat_cords = Coordinates { row: 4, col: 1 };
        let moving_cords = Coordinates { row: 6, col: 1 };
        let moving_piece: Piece = world.read_model((session_id, moving_cords));
        actions_system.move_piece(moving_piece, cheat_cords);

        let cheat_piece: Piece = world.read_model((session_id, cheat_cords));
        assert!(cheat_piece.session_id == 0, "wrong session");
        assert!(cheat_piece.row == 4, "piece x is wrong");
        assert!(cheat_piece.col == 1, "piece y is wrong");
        assert!(cheat_piece.is_alive == true, "piece is not alive");
        assert!(cheat_piece.is_king == false, "piece is king");
        assert!(cheat_piece.position == Position::Down, "piece is not right team");

        // Move actual piece
        let moving_cords = Coordinates { row: 6, col: 1 };
        let actual_cords = Coordinates { row: 7, col: 0 };
        let moving_piece: Piece = world.read_model((session_id, actual_cords));
        actions_system.move_piece(moving_piece, moving_cords);
        let actual_piece: Piece = world.read_model((session_id, moving_cords));

        assert!(actual_piece.session_id == 0, "wrong session");
        assert!(actual_piece.row == 6, "piece x is wrong");
        assert!(actual_piece.col == 1, "piece y is wrong");
        assert!(actual_piece.is_alive == true, "piece is not alive");
        assert!(actual_piece.is_king == false, "piece is king");
        assert!(actual_piece.position == Position::Down, "piece is not right team");

        // Move enemy piece to become king
        let new_coordinates_position = Coordinates { row: 5, col: 2 };
        let current_cords = Coordinates { row: 4, col: 3 };
        let current_piece: Piece = world.read_model((session_id, current_cords));
        actions_system.move_piece(current_piece, new_coordinates_position);
        let new_piece: Piece = world.read_model((session_id, new_coordinates_position));

        assert!(new_piece.session_id == 0, "wrong session");
        assert!(new_piece.row == 5, "piece x is wrong");
        assert!(new_piece.col == 2, "piece y is wrong");
        assert!(new_piece.is_alive == true, "piece is not alive");
        assert!(new_piece.is_king == false, "piece is king");
        assert!(new_piece.position == Position::Up, "piece is not right team");

        let actual_cords = Coordinates { row: 5, col: 2 };
        let moving_cords = Coordinates { row: 6, col: 1 };
        let moving_piece: Piece = world.read_model((session_id, actual_cords));
        actions_system.move_piece(moving_piece, moving_cords);
        let new_cords = Coordinates { row: 7, col: 0 };
        let actual_piece: Piece = world.read_model((session_id, new_cords));

        assert!(actual_piece.session_id == 0, "wrong session");
        assert!(actual_piece.row == 7, "piece x is wrong");
        assert!(actual_piece.col == 0, "piece y is wrong");
        assert!(actual_piece.is_alive == true, "piece is not alive");
        assert!(actual_piece.is_king == true, "piece is king");
        assert!(actual_piece.position == Position::Up, "piece is not right team");

        let new_coordinates_position = Coordinates { row: 3, col: 4 };
        let current_cords = Coordinates { row: 7, col: 0 };
        let current_piece: Piece = world.read_model((session_id, current_cords));
        actions_system.move_piece(current_piece, new_coordinates_position);
        let new_piece: Piece = world.read_model((session_id, new_coordinates_position));

        assert!(new_piece.session_id == 0, "wrong session");
        assert!(new_piece.row == 3, "piece x is wrong");
        assert!(new_piece.col == 4, "piece y is wrong");
        assert!(new_piece.is_alive == true, "piece is not alive");
        assert!(new_piece.is_king == true, "piece is king");
        assert!(new_piece.position == Position::Up, "piece is not right team");
    }

    #[test]
    fn test_session_creation() {
        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());

        let player1 = starknet::contract_address_const::<0x0>();
        let (contract_address, _) = world.dns(@"actions").unwrap();
        let actions_system = IActionsDispatcher { contract_address };
        let session_id = actions_system.create_lobby();
        let session: Session = world.read_model((session_id));
        assert!(session.state == 0, "wrong session state");
        // Cheat call the second player
        let player2 = starknet::contract_address_const::<0x1>();
        starknet::testing::set_contract_address(player2);
        actions_system.join_lobby(session_id);
        // Re read the model once the second player joins
        let session: Session = world.read_model((session_id));

        assert!(session.player_1 == player1, "wrong player");
        assert!(session.player_2 == player2, "wrong player");
        assert!(session.turn == 0, "wrong turn");
        assert!(session.state == 1, "wrong session state");
    }

    #[test]
    fn test_turn_switch() {
        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());

        let player1 = starknet::contract_address_const::<0x0>();
        let (contract_address, _) = world.dns(@"actions").unwrap();
        let actions_system = IActionsDispatcher { contract_address };
        let session_id = actions_system.create_lobby();
        // Cheat call the second player
        let player2 = starknet::contract_address_const::<0x1>();
        starknet::testing::set_contract_address(player2);
        actions_system.join_lobby(session_id);
        // Read session model
        let session: Session = world.read_model((session_id));

        assert!(session.player_1 == player1, "wrong player");
        assert!(session.player_2 == player2, "wrong player");
        assert!(session.turn == 0, "wrong turn");
        assert!(session.state == 1, "wrong session state");

        let valid_piece_position = Coordinates { row: 2, col: 1 };
        let initial_piece_position: Piece = world.read_model((session_id, valid_piece_position));

        assert(
            initial_piece_position.row == 2 && initial_piece_position.col == 1,
            'wrong initial piece'
        );
        assert(initial_piece_position.session_id == 0, 'wrong session');
        assert(initial_piece_position.is_king == false, 'wrong initial piece');
        assert(initial_piece_position.is_alive == true, 'wrong initial piece');

        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, valid_piece_position, session_id);
        assert(can_choose_piece, 'can_choose_piece failed');
        let current_piece: Piece = world.read_model((session_id, valid_piece_position));
        let new_coordinates_position = Coordinates { row: 3, col: 2 };
        actions_system.move_piece(current_piece, new_coordinates_position);

        // Check if turn changed for player 2
        let session: Session = world.read_model((session_id));
        assert!(session.turn == 1, "wrong turn");

        let new_position: Piece = world.read_model((session_id, new_coordinates_position));

        assert!(new_position.session_id == 0, "wrong session");
        assert!(new_position.row == 3, "piece x is wrong");
        assert!(new_position.col == 2, "piece y is wrong");
        assert!(new_position.is_alive == true, "piece is not alive");
        assert!(new_position.is_king == false, "piece is king");

        let valid_piece_position56 = Coordinates { row: 5, col: 6 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, valid_piece_position56, session_id);
        assert(can_choose_piece, 'can_choose_piece failed');
        let current_piece: Piece = world.read_model((session_id, valid_piece_position56));
        let new_coordinates_position = Coordinates { row: 4, col: 5 };
        actions_system.move_piece(current_piece, new_coordinates_position);

        // Check if turn changed back to player 1
        let session: Session = world.read_model((session_id));
        assert!(session.turn == 0, "wrong turn");

        let new_position: Piece = world.read_model((session_id, new_coordinates_position));

        assert!(new_position.session_id == 0, "wrong session");
        assert!(new_position.row == 4, "piece x is wrong");
        assert!(new_position.col == 5, "piece y is wrong");
        assert!(new_position.is_alive == true, "piece is not alive");
        assert!(new_position.is_king == false, "piece is king");
    }
}
