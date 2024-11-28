#[cfg(test)]
mod tests {
    use dojo::model::{ModelStorage, ModelValueStorage, ModelStorageTest};
    use dojo::world::WorldStorageTrait;
    use dojo_cairo_test::{
        spawn_test_world, NamespaceDef, TestResource, ContractDef, ContractDefTrait,
        WorldStorageTestTrait
    };

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

        let pieces_keys: Array<(u64, Coordinates)> = array![
            (session_id, Coordinates { row: 7, col: 7 }),
            (session_id, Coordinates { row: 1, col: 1 }),
        ];
        let pieces: Array<Piece> = world.read_models(pieces_keys.span());
        assert(pieces.len() == 2, 'read_models failed');

        // Test initial piece
        assert(
            *pieces[0].position == Position::None && *pieces[0].is_alive == false,
            'initial piece wrong'
        );

        // Test write_model_test
        assert(
            *pieces[1].position == Position::Down && piece.is_king == true && piece.session_id == 0,
            'write_value_from_id failed'
        );
        assert(*pieces[1].is_alive == true, 'write_value_from_id failed');

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
        world.sync_perms_and_inits(contract_defs());

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

        // Mock change turn. update the session's turn
        let mut session: Session = world.read_model((session_id));
        session.turn = (session.turn + 1) % 2;
        world.write_model(@session);

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
        world.sync_perms_and_inits(contract_defs());

        let (contract_address, _) = world.dns(@"actions").unwrap();
        let actions_system = IActionsDispatcher { contract_address };
        let session_id = actions_system.create_lobby();
        actions_system.join_lobby(session_id);

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
    // //Test can choose piece but can not move
    #[test]
    #[should_panic(expected: ('Invalid coordinates', 'ENTRYPOINT_FAILED'))]
    fn test_move_piece31_forward_straight_fails() {
        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());
        world.sync_perms_and_inits(contract_defs());

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
        world.sync_perms_and_inits(contract_defs());

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
        world.sync_perms_and_inits(contract_defs());

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

        let new_coordinates_position = Coordinates { row: 3, col: 0 };
        actions_system.move_piece(initial_piece_position, new_coordinates_position);

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
        world.sync_perms_and_inits(contract_defs());

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

        let new_coordinates_position = Coordinates { row: 3, col: 2 };
        actions_system.move_piece(initial_piece_position, new_coordinates_position);

        let new_position: Piece = world.read_model((session_id, new_coordinates_position));

        assert!(new_position.session_id == 0, "wrong session");
        assert!(new_position.row == 3, "piece x is wrong");
        assert!(new_position.col == 2, "piece y is wrong");
        assert!(new_position.is_alive == true, "piece is not alive");
        assert!(new_position.is_king == false, "piece is king");
    }
    #[test]
    fn test_move_piece25_down_left() {
        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());
        world.sync_perms_and_inits(contract_defs());

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

        let new_coordinates_position = Coordinates { row: 3, col: 4 };
        actions_system.move_piece(initial_piece_position, new_coordinates_position);

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
        world.sync_perms_and_inits(contract_defs());

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

        let new_coordinates_position = Coordinates { row: 3, col: 6 };
        actions_system.move_piece(initial_piece_position, new_coordinates_position);

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
        world.sync_perms_and_inits(contract_defs());

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

        let new_coordinates_position = Coordinates { row: 3, col: 2 };
        actions_system.move_piece(initial_piece_position, new_coordinates_position);

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
        world.sync_perms_and_inits(contract_defs());

        let (contract_address, _) = world.dns(@"actions").unwrap();
        let actions_system = IActionsDispatcher { contract_address };
        let session_id = actions_system.create_lobby();
        actions_system.join_lobby(session_id);

        // Test initial position 21 & 56
        let valid_piece_position21 = Coordinates { row: 2, col: 1 };
        let valid_piece_position56 = Coordinates { row: 5, col: 6 };
        let initial_pieces_keys: Array<(u64, Coordinates)> = array![
            (session_id, valid_piece_position21), (session_id, valid_piece_position56),
        ];
        let initial_pieces: Array<Piece> = world.read_models(initial_pieces_keys.span());
        assert(initial_pieces.len() == 2, 'read_models failed');

        assert(
            *initial_pieces[0].row == 2 && *initial_pieces[0].col == 1, 'wrong initial piece 21'
        );
        assert(
            *initial_pieces[1].row == 5 && *initial_pieces[1].col == 6, 'wrong initial piece 56'
        );
        for piece in initial_pieces
            .clone() {
                assert(piece.session_id == 0, 'wrong session');
                assert(piece.is_king == false, 'wrong initial piece');
                assert(piece.is_alive == true, 'wrong initial piece');
            };

        // Test move to positions 32 & 45
        let can_choose_piece21 = actions_system
            .can_choose_piece(Position::Up, valid_piece_position21, session_id);
        assert(can_choose_piece21, 'can_choose_piece 21 failed');
        let new_coordinates_position32 = Coordinates { row: 3, col: 2 };
        actions_system.move_piece(*initial_pieces[0], new_coordinates_position32);

        let can_choose_piece56 = actions_system
            .can_choose_piece(Position::Down, valid_piece_position56, session_id);
        assert(can_choose_piece56, 'can_choose_piece 56 failed');
        let new_coordinates_position45 = Coordinates { row: 4, col: 5 };
        actions_system.move_piece(*initial_pieces[1], new_coordinates_position45);

        let new_coordinates_keys: Array<(u64, Coordinates)> = array![
            (session_id, new_coordinates_position32), (session_id, new_coordinates_position45),
        ];
        let new_positions: Array<Piece> = world.read_models(new_coordinates_keys.span());
        assert(new_positions.len() == 2, 'read_models failed');

        assert!(*new_positions[0].row == 3, "piece x is wrong");
        assert!(*new_positions[0].col == 2, "piece y is wrong");
        assert!(*new_positions[1].row == 4, "piece x is wrong");
        assert!(*new_positions[1].col == 5, "piece y is wrong");
        for new_position in new_positions {
            assert!(new_position.session_id == 0, "wrong session");
            assert!(new_position.is_alive == true, "piece is not alive");
            assert!(new_position.is_king == false, "piece is king");
        };
    }
    #[test]
    fn test_piece21_eat_piece54() {
        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());
        world.sync_perms_and_inits(contract_defs());

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

        // Test initial position 21 & 54
        let valid_piece_position21 = Coordinates { row: 2, col: 1 };
        let valid_piece_position54 = Coordinates { row: 5, col: 4 };
        let initial_pieces_keys: Array<(u64, Coordinates)> = array![
            (session_id, valid_piece_position21), (session_id, valid_piece_position54),
        ];
        let initial_pieces: Array<Piece> = world.read_models(initial_pieces_keys.span());
        assert(initial_pieces.len() == 2, 'read_models failed');

        assert(
            *initial_pieces[0].row == 2 && *initial_pieces[0].col == 1, 'wrong initial piece 21'
        );
        assert(
            *initial_pieces[1].row == 5 && *initial_pieces[1].col == 4, 'wrong initial piece 54'
        );
        for piece in initial_pieces
            .clone() {
                assert(piece.session_id == 0, 'wrong session');
                assert(piece.is_king == false, 'wrong initial piece');
                assert(piece.is_alive == true, 'wrong initial piece');
            };

        // Test move to position 32 & 43
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, valid_piece_position21, session_id);
        assert(can_choose_piece, 'can_choose_piece 21 failed');
        let new_coordinates_position32 = Coordinates { row: 3, col: 2 };
        actions_system.move_piece(*initial_pieces[0], new_coordinates_position32);

        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, valid_piece_position54, session_id);
        assert(can_choose_piece, 'can_choose_piece 54 failed');
        let new_coordinates_position43 = Coordinates { row: 4, col: 3 };
        actions_system.move_piece(*initial_pieces[1], new_coordinates_position43);

        let new_coordinates_keys: Array<(u64, Coordinates)> = array![
            (session_id, new_coordinates_position32), (session_id, new_coordinates_position43),
        ];
        let new_positions: Array<Piece> = world.read_models(new_coordinates_keys.span());
        assert(new_positions.len() == 2, 'read_models failed');

        assert!(*new_positions[0].row == 3, "piece x is wrong");
        assert!(*new_positions[0].col == 2, "piece y is wrong");
        assert!(*new_positions[1].row == 4, "piece x is wrong");
        assert!(*new_positions[1].col == 3, "piece y is wrong");
        for new_position in new_positions
            .clone() {
                assert!(new_position.session_id == 0, "wrong session");
                assert!(new_position.is_alive == true, "piece is not alive");
                assert!(new_position.is_king == false, "piece is king");
            };

        // Test position 32 moves to eat 43 then jump to 54
        let eat_position = Coordinates { row: 4, col: 3 };
        let jump_position = Coordinates { row: 5, col: 4 };
        actions_system.move_piece(*new_positions[0], eat_position);

        let updated_pieces_keys: Array<(u64, Coordinates)> = array![
            (session_id, jump_position), (session_id, eat_position),
        ];
        let updated_pieces: Array<Piece> = world.read_models(updated_pieces_keys.span());
        assert(updated_pieces.len() == 2, 'read_models failed');

        assert!(*updated_pieces[0].row == 5, "piece x is wrong");
        assert!(*updated_pieces[0].col == 4, "piece y is wrong");
        assert!(*updated_pieces[1].row == 4, "piece x is wrong");
        assert!(*updated_pieces[1].col == 3, "piece y is wrong");

        assert!(*updated_pieces[0].is_alive == true, "piece is not alive");
        assert!(*updated_pieces[0].position == Position::Up, "piece is not right team");
        assert!(*updated_pieces[0].is_king == false, "piece is king");

        assert!(*updated_pieces[1].is_alive == false, "piece is alive");
        assert!(*updated_pieces[1].is_king == false, "piece is king");

        // Check the remaining pieces got reduced
        let player_model: Player = world.read_model(player2);
        assert!(player_model.remaining_pieces == 11, "wrong remaining pieces");
    }
    #[test]
    fn test_move_king_piece() {
        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());
        world.sync_perms_and_inits(contract_defs());

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

        // Get all initial piecs
        let initial_position_25 = Coordinates { row: 2, col: 5 };
        let cheat_piece_52 = Coordinates { row: 5, col: 2 };
        let cheat_piece_61 = Coordinates { row: 6, col: 1 };
        let actual_piece_70 = Coordinates { row: 7, col: 0 };
        let initial_pieces_keys: Array<(u64, Coordinates)> = array![
            (session_id, initial_position_25),
            (session_id, cheat_piece_52),
            (session_id, cheat_piece_61),
            (session_id, actual_piece_70),
        ];
        let initial_pieces: Array<Piece> = world.read_models(initial_pieces_keys.span());
        assert(initial_pieces.len() == 4, 'read_models failed');

        assert(
            *initial_pieces[0].row == 2 && *initial_pieces[0].col == 5, 'wrong initial piece 25'
        );
        assert(
            *initial_pieces[1].row == 5 && *initial_pieces[1].col == 2, 'wrong initial piece 52'
        );
        assert(
            *initial_pieces[2].row == 6 && *initial_pieces[2].col == 1, 'wrong initial piece 61'
        );
        assert(
            *initial_pieces[3].row == 7 && *initial_pieces[3].col == 0, 'wrong initial piece 70'
        );
        for piece in initial_pieces
            .clone() {
                assert(piece.session_id == 0, 'wrong session');
                assert(piece.is_king == false, 'wrong initial piece');
                assert(piece.is_alive == true, 'wrong initial piece');
            };

        // Test move pieces 25->34, 52->30, 61->41, 70->61
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, initial_position_25, session_id);
        assert(can_choose_piece, 'can_choose_piece failed');

        let new_position_34 = Coordinates { row: 3, col: 4 };
        let new_position_30 = Coordinates { row: 3, col: 0 };
        let new_position_41 = Coordinates { row: 4, col: 1 };
        let new_position_61 = Coordinates { row: 6, col: 1 };
        actions_system.move_piece(*initial_pieces[0], new_position_34);
        actions_system.move_piece(*initial_pieces[1], new_position_30);
        actions_system.move_piece(*initial_pieces[2], new_position_41);
        actions_system.move_piece(*initial_pieces[3], new_position_61);

        let new_positions_keys: Array<(u64, Coordinates)> = array![
            (session_id, new_position_34),
            (session_id, new_position_30),
            (session_id, new_position_41),
            (session_id, new_position_61),
        ];
        let new_positions: Array<Piece> = world.read_models(new_positions_keys.span());
        assert(new_positions.len() == 4, 'read_models failed');

        assert(*new_positions[0].row == 3 && *new_positions[0].col == 4, 'wrong updated piece 34');
        assert(*new_positions[1].row == 3 && *new_positions[1].col == 0, 'wrong updated piece 30');
        assert(*new_positions[2].row == 4 && *new_positions[2].col == 1, 'wrong updated piece 41');
        assert(*new_positions[3].row == 6 && *new_positions[3].col == 1, 'wrong updated piece 61');
        assert!(*new_positions[0].position == Position::Up, "piece 34 is not right team");
        assert!(*new_positions[1].position == Position::Down, "piece 30 is not right team");
        assert!(*new_positions[2].position == Position::Down, "piece 41 is not right team");
        assert!(*new_positions[3].position == Position::Down, "piece 61 is not right team");
        for new_position in new_positions
            .clone() {
                assert(new_position.session_id == 0, 'wrong session');
                assert(new_position.is_king == false, 'wrong initial piece');
                assert(new_position.is_alive == true, 'wrong initial piece');
            };

        // Test move 34 -> 43 -> 52 eat 61 becomes king (70) & move to 34
        let next_position = Coordinates { row: 4, col: 3 };
        actions_system.move_piece(*new_positions[0], next_position);
        let current_position: Piece = world.read_model((session_id, next_position));

        assert!(current_position.session_id == 0, "wrong session");
        assert!(current_position.row == 4, "piece 43 x is wrong");
        assert!(current_position.col == 3, "piece 43 y is wrong");
        assert!(current_position.is_alive == true, "piece 43 is not alive");
        assert!(current_position.is_king == false, "piece 43 is king");
        assert!(current_position.position == Position::Up, "piece 43 is not right team");

        let next_position = Coordinates { row: 5, col: 2 };
        actions_system.move_piece(current_position, next_position);
        let current_position: Piece = world.read_model((session_id, next_position));

        assert!(current_position.session_id == 0, "wrong session");
        assert!(current_position.row == 5, "piece 52 x is wrong");
        assert!(current_position.col == 2, "piece 52 y is wrong");
        assert!(current_position.is_alive == true, "piece 52 is not alive");
        assert!(current_position.is_king == false, "piece 52 is king");
        assert!(current_position.position == Position::Up, "piece 52 is not right team");

        let next_position = Coordinates { row: 6, col: 1 };
        actions_system.move_piece(current_position, next_position);

        // Now position is 70
        let king_position = Coordinates { row: 7, col: 0 };
        let current_position: Piece = world.read_model((session_id, king_position));

        assert!(current_position.session_id == 0, "wrong session");
        assert!(current_position.row == 7, "piece 70 x is wrong");
        assert!(current_position.col == 0, "piece 70 y is wrong");
        assert!(current_position.is_alive == true, "piece 70 is not alive");
        assert!(current_position.is_king == true, "piece 70 is king");
        assert!(current_position.position == Position::Up, "piece 70 is not right team");

        let next_position = Coordinates { row: 3, col: 4 };
        actions_system.move_piece(current_position, next_position);
        let current_position: Piece = world.read_model((session_id, next_position));

        assert!(current_position.session_id == 0, "wrong session");
        assert!(current_position.row == 3, "piece 34 x is wrong");
        assert!(current_position.col == 4, "piece 34 y is wrong");
        assert!(current_position.is_alive == true, "piece 34 is not alive");
        assert!(current_position.is_king == true, "piece 34 is king");
        assert!(current_position.position == Position::Up, "piece 34 is not right team");
    }
    #[test]
    fn test_session_creation() {
        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());
        world.sync_perms_and_inits(contract_defs());

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
        world.sync_perms_and_inits(contract_defs());

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

        // Test initial position 21 & 56
        let valid_piece_position21 = Coordinates { row: 2, col: 1 };
        let valid_piece_position56 = Coordinates { row: 5, col: 6 };
        let initial_pieces_keys: Array<(u64, Coordinates)> = array![
            (session_id, valid_piece_position21), (session_id, valid_piece_position56),
        ];
        let initial_pieces: Array<Piece> = world.read_models(initial_pieces_keys.span());
        assert(initial_pieces.len() == 2, 'read_models failed');

        assert(
            *initial_pieces[0].row == 2 && *initial_pieces[0].col == 1, 'wrong initial piece 21'
        );
        assert(
            *initial_pieces[1].row == 5 && *initial_pieces[1].col == 6, 'wrong initial piece 56'
        );
        for piece in initial_pieces
            .clone() {
                assert(piece.session_id == 0, 'wrong session');
                assert(piece.is_king == false, 'piece is king');
                assert(piece.is_alive == true, 'piece is not alive');
            };

        // Test move to positions 32 & 45
        let can_choose_piece21 = actions_system
            .can_choose_piece(Position::Up, valid_piece_position21, session_id);
        assert(can_choose_piece21, 'can_choose_piece 21 failed');
        let new_coordinates_position32 = Coordinates { row: 3, col: 2 };
        actions_system.move_piece(*initial_pieces[0], new_coordinates_position32);

        // Check if turn changed for player 2
        let session: Session = world.read_model((session_id));
        assert!(session.turn == 1, "wrong turn");

        let can_choose_piece56 = actions_system
            .can_choose_piece(Position::Down, valid_piece_position56, session_id);
        assert(can_choose_piece56, 'can_choose_piece 56 failed');
        let new_coordinates_position45 = Coordinates { row: 4, col: 5 };
        actions_system.move_piece(*initial_pieces[1], new_coordinates_position45);

        // Check if turn changed back to player 1
        let session: Session = world.read_model((session_id));
        assert!(session.turn == 0, "wrong turn");

        let new_coordinates_keys: Array<(u64, Coordinates)> = array![
            (session_id, new_coordinates_position32), (session_id, new_coordinates_position45),
        ];
        let new_positions: Array<Piece> = world.read_models(new_coordinates_keys.span());
        assert(new_positions.len() == 2, 'read_models failed');

        assert!(*new_positions[0].row == 3, "piece x is wrong");
        assert!(*new_positions[0].col == 2, "piece y is wrong");
        assert!(*new_positions[1].row == 4, "piece x is wrong");
        assert!(*new_positions[1].col == 5, "piece y is wrong");
        for new_position in new_positions {
            assert!(new_position.session_id == 0, "wrong session");
            assert!(new_position.is_alive == true, "piece is not alive");
            assert!(new_position.is_king == false, "piece is king");
        };
    }

    fn dump_piece(piece: @Piece) -> ByteArray {
        if *piece.is_alive {
            if *piece.position == Position::Up {
                "v"
            } else {
                "^"
            }
        } else {
            "X"
        }
    }

    fn dump_plate(world: @dojo::world::WorldStorage) {
        let initial_pieces_keys: Array<(u64, Coordinates)> = array![
            (0, Coordinates { row: 0, col: 1 }),
            (0, Coordinates { row: 0, col: 3 }),
            (0, Coordinates { row: 0, col: 5 }),
            (0, Coordinates { row: 0, col: 7 }),
            (0, Coordinates { row: 1, col: 0 }),
            (0, Coordinates { row: 1, col: 2 }),
            (0, Coordinates { row: 1, col: 4 }),
            (0, Coordinates { row: 1, col: 6 }),
            (0, Coordinates { row: 2, col: 1 }),
            (0, Coordinates { row: 2, col: 3 }),
            (0, Coordinates { row: 2, col: 5 }),
            (0, Coordinates { row: 2, col: 7 }),
            (0, Coordinates { row: 3, col: 0 }),
            (0, Coordinates { row: 3, col: 2 }),
            (0, Coordinates { row: 3, col: 4 }),
            (0, Coordinates { row: 3, col: 6 }),
            (0, Coordinates { row: 4, col: 1 }),
            (0, Coordinates { row: 4, col: 3 }),
            (0, Coordinates { row: 4, col: 5 }),
            (0, Coordinates { row: 4, col: 7 }),
            (0, Coordinates { row: 5, col: 0 }),
            (0, Coordinates { row: 5, col: 2 }),
            (0, Coordinates { row: 5, col: 4 }),
            (0, Coordinates { row: 5, col: 6 }),
            (0, Coordinates { row: 6, col: 1 }),
            (0, Coordinates { row: 6, col: 3 }),
            (0, Coordinates { row: 6, col: 5 }),
            (0, Coordinates { row: 6, col: 7 }),
            (0, Coordinates { row: 7, col: 0 }),
            (0, Coordinates { row: 7, col: 2 }),
            (0, Coordinates { row: 7, col: 4 }),
            (0, Coordinates { row: 7, col: 6 }),
        ];
        let initial_pieces: Array<Piece> = world.read_models(initial_pieces_keys.span());
        println!("----------");
        println!(
            "| {} {} {} {}|",
            dump_piece(initial_pieces[0]),
            dump_piece(initial_pieces[1]),
            dump_piece(initial_pieces[2]),
            dump_piece(initial_pieces[3]),
        );
        println!(
            "|{} {} {} {} |",
            dump_piece(initial_pieces[4]),
            dump_piece(initial_pieces[5]),
            dump_piece(initial_pieces[6]),
            dump_piece(initial_pieces[7]),
        );
        println!(
            "| {} {} {} {}|",
            dump_piece(initial_pieces[8]),
            dump_piece(initial_pieces[9]),
            dump_piece(initial_pieces[10]),
            dump_piece(initial_pieces[11]),
        );
        println!(
            "|{} {} {} {} |",
            dump_piece(initial_pieces[12]),
            dump_piece(initial_pieces[13]),
            dump_piece(initial_pieces[14]),
            dump_piece(initial_pieces[15]),
        );
        println!(
            "| {} {} {} {}|",
            dump_piece(initial_pieces[16]),
            dump_piece(initial_pieces[17]),
            dump_piece(initial_pieces[18]),
            dump_piece(initial_pieces[19]),
        );
        println!(
            "|{} {} {} {} |",
            dump_piece(initial_pieces[20]),
            dump_piece(initial_pieces[21]),
            dump_piece(initial_pieces[22]),
            dump_piece(initial_pieces[23]),
        );
        println!(
            "| {} {} {} {}|",
            dump_piece(initial_pieces[24]),
            dump_piece(initial_pieces[25]),
            dump_piece(initial_pieces[26]),
            dump_piece(initial_pieces[27]),
        );
        println!(
            "|{} {} {} {} |",
            dump_piece(initial_pieces[28]),
            dump_piece(initial_pieces[29]),
            dump_piece(initial_pieces[30]),
            dump_piece(initial_pieces[31]),
        );
        println!("----------");
    }

    #[test]
    fn test_piece21_eat_piece54_and_piece65() {
        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());
        world.sync_perms_and_inits(contract_defs());

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

        // Test initial position 07, 16, 21, 27, 54 & 65
        let valid_piece_position07 = Coordinates { row: 0, col: 7 };
        let valid_piece_position16 = Coordinates { row: 1, col: 6 };
        let valid_piece_position21 = Coordinates { row: 2, col: 1 };
        let valid_piece_position27 = Coordinates { row: 2, col: 7 };
        let valid_piece_position54 = Coordinates { row: 5, col: 4 };
        let valid_piece_position65 = Coordinates { row: 6, col: 5 };
        let initial_pieces_keys: Array<(u64, Coordinates)> = array![
            (session_id, valid_piece_position07),
            (session_id, valid_piece_position16),
            (session_id, valid_piece_position21),
            (session_id, valid_piece_position27),
            (session_id, valid_piece_position54),
            (session_id, valid_piece_position65),
        ];
        dump_plate(@world);
        let initial_pieces: Array<Piece> = world.read_models(initial_pieces_keys.span());
        assert(initial_pieces.len() == 6, 'read_models failed');

        assert(
            *initial_pieces[0].row == 0 && *initial_pieces[0].col == 7, 'wrong initial piece 07'
        );
        assert(
            *initial_pieces[1].row == 1 && *initial_pieces[1].col == 6, 'wrong initial piece 16'
        );
        assert(
            *initial_pieces[2].row == 2 && *initial_pieces[2].col == 1, 'wrong initial piece 21'
        );
        assert(
            *initial_pieces[3].row == 2 && *initial_pieces[3].col == 7, 'wrong initial piece 27'
        );
        assert(
            *initial_pieces[4].row == 5 && *initial_pieces[4].col == 4, 'wrong initial piece 54'
        );
        assert(
            *initial_pieces[5].row == 6 && *initial_pieces[5].col == 5, 'wrong initial piece 65'
        );
        for piece in initial_pieces
            .clone() {
                assert(piece.session_id == 0, 'wrong session');
                assert(piece.is_king == false, 'wrong initial piece');
                assert(piece.is_alive == true, 'wrong initial piece');
            };

        // Test move to position 36 & 43
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, valid_piece_position27, session_id);
        assert(can_choose_piece, 'can_choose_piece 27 failed');
        let new_coordinates_position36 = Coordinates { row: 3, col: 6 };
        actions_system.move_piece(*initial_pieces[3], new_coordinates_position36);

        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, valid_piece_position54, session_id);
        assert(can_choose_piece, 'can_choose_piece 54 failed');
        let new_coordinates_position43 = Coordinates { row: 4, col: 3 };
        actions_system.move_piece(*initial_pieces[4], new_coordinates_position43);

        let new_coordinates_keys: Array<(u64, Coordinates)> = array![
            (session_id, new_coordinates_position36), (session_id, new_coordinates_position43),
        ];
        let new_positions_first_turn: Array<Piece> = world.read_models(new_coordinates_keys.span());
        assert(new_positions_first_turn.len() == 2, 'read_models failed');

        assert!(*new_positions_first_turn[0].row == 3, "piece x is wrong");
        assert!(*new_positions_first_turn[0].col == 6, "piece y is wrong");
        assert!(*new_positions_first_turn[1].row == 4, "piece x is wrong");
        assert!(*new_positions_first_turn[1].col == 3, "piece y is wrong");
        for new_position in new_positions_first_turn
            .clone() {
                assert!(new_position.session_id == 0, "wrong session");
                assert!(new_position.is_alive == true, "piece is not alive");
                assert!(new_position.is_king == false, "piece is king");
            };
        dump_plate(@world);

        // Test move to position 27 & 54
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, valid_piece_position16, session_id);
        assert(can_choose_piece, 'can_choose_piece 16 failed');
        let new_coordinates_position27 = Coordinates { row: 2, col: 7 };
        actions_system.move_piece(*initial_pieces[1], new_coordinates_position27);

        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, valid_piece_position65, session_id);
        assert(can_choose_piece, 'can_choose_piece 65 failed');
        let new_coordinates_position54 = Coordinates { row: 5, col: 4 };
        actions_system.move_piece(*initial_pieces[5], new_coordinates_position54);

        let new_coordinates_keys: Array<(u64, Coordinates)> = array![
            (session_id, new_coordinates_position27), (session_id, new_coordinates_position54),
        ];
        let new_positions_second_turn: Array<Piece> = world
            .read_models(new_coordinates_keys.span());
        assert(new_positions_second_turn.len() == 2, 'read_models failed');

        assert!(*new_positions_second_turn[0].row == 2, "piece x is wrong");
        assert!(*new_positions_second_turn[0].col == 7, "piece y is wrong");
        assert!(*new_positions_second_turn[1].row == 5, "piece x is wrong");
        assert!(*new_positions_second_turn[1].col == 4, "piece y is wrong");
        for new_position in new_positions_second_turn
            .clone() {
                assert!(new_position.session_id == 0, "wrong session");
                assert!(new_position.is_alive == true, "piece is not alive");
                assert!(new_position.is_king == false, "piece is king");
            };
        dump_plate(@world);

        // Test move to position 16 & 32
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, valid_piece_position07, session_id);
        assert(can_choose_piece, 'can_choose_piece 07 failed');
        let new_coordinates_position16 = Coordinates { row: 1, col: 6 };
        actions_system.move_piece(*initial_pieces[0], new_coordinates_position16);

        let valid_piece_position43 = Coordinates { row: 4, col: 3 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, valid_piece_position43, session_id);
        assert(can_choose_piece, 'can_choose_piece 43 failed');
        let new_coordinates_position32 = Coordinates { row: 3, col: 2 };
        actions_system.move_piece(*new_positions_first_turn[1], new_coordinates_position32);

        let new_coordinates_keys: Array<(u64, Coordinates)> = array![
            (session_id, new_coordinates_position16), (session_id, new_coordinates_position32),
        ];
        let new_positions_third_turn: Array<Piece> = world.read_models(new_coordinates_keys.span());
        assert(new_positions_third_turn.len() == 2, 'read_models failed');

        assert!(*new_positions_third_turn[0].row == 1, "piece x is wrong");
        assert!(*new_positions_third_turn[0].col == 6, "piece y is wrong");
        assert!(*new_positions_third_turn[1].row == 3, "piece x is wrong");
        assert!(*new_positions_third_turn[1].col == 2, "piece y is wrong");
        for new_position in new_positions_third_turn
            .clone() {
                assert!(new_position.session_id == 0, "wrong session");
                assert!(new_position.is_alive == true, "piece is not alive");
                assert!(new_position.is_king == false, "piece is king");
            };
        dump_plate(@world);

        // Test position 21 moves to 32 then jumps to 43, moves to 54 then jumps 65, eating both 32
        // and 54
        let new_coordinates_positions = array![
            Coordinates { row: 3, col: 2 }, Coordinates { row: 5, col: 4 },
        ];
        actions_system.move_piece_multiple(*initial_pieces[2], new_coordinates_positions);
        // println!("{} {}", *initial_pieces[2].row, *initial_pieces[2].col);
        // actions_system.move_piece(*initial_pieces[2], *new_coordinates_positions[0]);
        // let updated_piece: Piece = world.read_model((session_id, Coordinates { row: 4, col: 3
        // }));
        // println!("{} {}", updated_piece.row, updated_piece.col);
        // let eaten_piece: Piece = world.read_model((session_id, Coordinates { row: 3, col: 2 }));
        // println!("eaten_piece.is_alive {}", eaten_piece.is_alive);
        // dump_plate(@world);

        // actions_system.move_piece(updated_piece, *new_coordinates_positions[1]);
        // let updated_piece: Piece = world.read_model((session_id, Coordinates { row: 6, col: 5
        // }));
        // println!("{} {}", updated_piece.row, updated_piece.col);
        // let eaten_piece: Piece = world.read_model((session_id, Coordinates { row: 5, col: 4 }));
        // println!("eaten_piece.is_alive {}", eaten_piece.is_alive);
        // dump_plate(@world);

        let updated_pieces_keys = array![
            (session_id, Coordinates { row: 3, col: 2 }),
            (session_id, Coordinates { row: 5, col: 4 }),
            (session_id, Coordinates { row: 6, col: 5 }),
        ];
        let updated_pieces: Array<Piece> = world.read_models(updated_pieces_keys.span());
        assert(updated_pieces.len() == 3, 'read_models failed');

        assert!(*updated_pieces[0].row == 3, "piece x is wrong");
        assert!(*updated_pieces[0].col == 2, "piece y is wrong");
        assert!(*updated_pieces[1].row == 5, "piece x is wrong");
        assert!(*updated_pieces[1].col == 4, "piece y is wrong");
        assert!(*updated_pieces[2].row == 6, "piece x is wrong");
        assert!(*updated_pieces[2].col == 5, "piece y is wrong");

        println!("{}", *updated_pieces[0].is_alive);
        println!("{}", *updated_pieces[1].is_alive);
        println!("{}", *updated_pieces[2].is_alive);
        assert!(*updated_pieces[0].is_alive == false, "piece is alive");
        assert!(*updated_pieces[0].is_king == false, "piece is king");
        assert!(*updated_pieces[1].is_alive == false, "piece is alive");
        assert!(*updated_pieces[1].is_king == false, "piece is king");
        assert!(*updated_pieces[2].is_alive == true, "piece is not alive");
        assert!(*updated_pieces[2].position == Position::Up, "piece is not right team");
        assert!(*updated_pieces[2].is_king == false, "piece is king");

        // Check the remaining pieces got reduced
        let player_model: Player = world.read_model(player2);
        assert!(player_model.remaining_pieces == 10, "wrong remaining pieces");
    }
}
