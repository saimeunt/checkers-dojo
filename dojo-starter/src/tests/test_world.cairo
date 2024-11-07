#[cfg(test)]
mod tests {
    use dojo::model::{ModelStorage, ModelValueStorage, ModelStorageTest};
    use dojo::world::WorldStorageTrait;
    use dojo_cairo_test::{spawn_test_world, NamespaceDef, TestResource, ContractDefTrait};

    use dojo_starter::systems::actions::{actions, IActionsDispatcher, IActionsDispatcherTrait};
    use dojo_starter::models::{Piece, m_Piece, Coordinates, Position};

    fn namespace_def() -> NamespaceDef {
        let ndef = NamespaceDef {
            namespace: "dojo_starter", resources: [
                TestResource::Model(m_Piece::TEST_CLASS_HASH.try_into().unwrap()),
                //TestResource::Model(m_Moves::TEST_CLASS_HASH.try_into().unwrap()),
                TestResource::Event(actions::e_Moved::TEST_CLASS_HASH.try_into().unwrap()),
                TestResource::Contract(
                    ContractDefTrait::new(actions::TEST_CLASS_HASH, "actions")
                        .with_writer_of([dojo::utils::bytearray_hash(@"dojo_starter")].span())
                )
            ].span()
        };

        ndef
    }

    #[test]
    fn test_world_test_set() {
        // Initialize test environment
        let caller = starknet::contract_address_const::<0x0>();
        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());

        // Test initial piece
        let piece_position_77 = Coordinates { row: 7, col: 7 };
        let piece: Piece = world.read_model((piece_position_77));
        assert(piece.position == Position::None && piece.is_alive == false, 'initial piece wrong');

        // Test write_model_test
        let row = 1;
        let col = 1;
        let piece = Piece {
            player: caller,
            row: row,
            col: col,
            position: Position::Down,
            is_king: true,
            is_alive: true
        };

        world.write_model_test(@piece);

        let piece: Piece = world.read_model((row, col));
        assert(
            piece.position == Position::Down && piece.is_king == true, 'write_value_from_id failed'
        );
        assert(piece.is_alive == true, 'write_value_from_id failed');
        // Test model deletion
        world.erase_model(@piece);
        let piece: Piece = world.read_model((row, col));
        assert(piece.position == Position::None && piece.is_king == false, 'erase_model failed');
        assert(piece.is_alive == false, 'erase_model failed');
    }
    #[test]
    fn test_can_not_choose_piece() {
        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());

        let (contract_address, _) = world.dns(@"actions").unwrap();
        let actions_system = IActionsDispatcher { contract_address };

        // test zero row
        let invalid_piece_position00 = Coordinates { row: 0, col: 0 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position00);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position01 = Coordinates { row: 0, col: 1 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position01);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position02 = Coordinates { row: 0, col: 2 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position02);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position03 = Coordinates { row: 0, col: 3 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position03);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position04 = Coordinates { row: 0, col: 4 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position04);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position05 = Coordinates { row: 0, col: 5 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position05);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position06 = Coordinates { row: 0, col: 6 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position06);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position07 = Coordinates { row: 0, col: 7 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position07);
        assert(!can_choose_piece, 'should be false');

        // test first row
        let invalid_piece_position10 = Coordinates { row: 1, col: 0 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position10);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position11 = Coordinates { row: 1, col: 1 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position11);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position12 = Coordinates { row: 1, col: 2 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position12);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position13 = Coordinates { row: 1, col: 3 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position13);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position14 = Coordinates { row: 1, col: 4 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position14);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position15 = Coordinates { row: 1, col: 5 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position15);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position16 = Coordinates { row: 1, col: 6 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position16);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position17 = Coordinates { row: 1, col: 7 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position17);
        assert(!can_choose_piece, 'should be false');

        // test second row
        let invalid_piece_position20 = Coordinates { row: 2, col: 0 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position20);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position22 = Coordinates { row: 2, col: 2 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position22);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position24 = Coordinates { row: 2, col: 4 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position24);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position26 = Coordinates { row: 2, col: 6 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position26);
        assert(!can_choose_piece, 'should be false');

        // test fifth row
        let invalid_piece_position51 = Coordinates { row: 5, col: 1 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position51);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position53 = Coordinates { row: 5, col: 3 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position53);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position55 = Coordinates { row: 5, col: 5 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position55);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position57 = Coordinates { row: 5, col: 7 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, invalid_piece_position57);
        assert(!can_choose_piece, 'should be false');

        // test sixth row
        let invalid_piece_position60 = Coordinates { row: 6, col: 0 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, invalid_piece_position60);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position61 = Coordinates { row: 6, col: 1 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, invalid_piece_position61);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position62 = Coordinates { row: 6, col: 2 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, invalid_piece_position62);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position63 = Coordinates { row: 6, col: 3 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, invalid_piece_position63);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position64 = Coordinates { row: 6, col: 4 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, invalid_piece_position64);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position65 = Coordinates { row: 6, col: 5 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, invalid_piece_position65);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position66 = Coordinates { row: 6, col: 6 }; // Empty square
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, invalid_piece_position66);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position67 = Coordinates { row: 6, col: 7 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, invalid_piece_position67);
        assert(!can_choose_piece, 'should be false');

        // test seventh row
        let invalid_piece_position70 = Coordinates { row: 7, col: 0 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, invalid_piece_position70);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position71 = Coordinates { row: 7, col: 1 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, invalid_piece_position71);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position72 = Coordinates { row: 7, col: 2 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, invalid_piece_position72);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position73 = Coordinates { row: 7, col: 3 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, invalid_piece_position73);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position74 = Coordinates { row: 7, col: 4 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, invalid_piece_position74);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position75 = Coordinates { row: 7, col: 5 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, invalid_piece_position75);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position76 = Coordinates { row: 7, col: 6 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, invalid_piece_position76);
        assert(!can_choose_piece, 'should be false');

        let invalid_piece_position77 = Coordinates { row: 7, col: 7 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, invalid_piece_position77);
        assert(!can_choose_piece, 'should be false');
    }
    #[test]
    fn test_can_choose_piece() {
        //let caller = starknet::contract_address_const::<0x0>();

        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());

        let (contract_address, _) = world.dns(@"actions").unwrap();
        let actions_system = IActionsDispatcher { contract_address };

        actions_system.spawn();

        // test third row
        let valid_piece_position21 = Coordinates { row: 2, col: 1 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, valid_piece_position21);
        assert(can_choose_piece, 'should be true');
        let valid_piece_position23 = Coordinates { row: 2, col: 3 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, valid_piece_position23);
        assert(can_choose_piece, 'should be true');

        let valid_piece_position25 = Coordinates { row: 2, col: 5 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, valid_piece_position25);
        assert(can_choose_piece, 'should be true');

        let valid_piece_position27 = Coordinates { row: 2, col: 7 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Up, valid_piece_position27);
        assert(can_choose_piece, 'should be true');
        // test fifth row
        let valid_piece_position50 = Coordinates { row: 5, col: 0 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, valid_piece_position50);
        assert(can_choose_piece, 'should be true');

        let valid_piece_position52 = Coordinates { row: 5, col: 2 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, valid_piece_position52);
        assert(can_choose_piece, 'should be true');

        let valid_piece_position54 = Coordinates { row: 5, col: 4 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, valid_piece_position54);
        assert(can_choose_piece, 'should be true');

        let valid_piece_position56 = Coordinates { row: 5, col: 6 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, valid_piece_position56);
        assert(can_choose_piece, 'should be true');
    }
    // Test can choose piece but can not move
    #[test]
    #[should_panic(expected: ('Invalid coordinates', 'ENTRYPOINT_FAILED'))]
    fn test_move_piece31_forward_straight_fails() {
        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());

        let (contract_address, _) = world.dns(@"actions").unwrap();
        let actions_system = IActionsDispatcher { contract_address };

        actions_system.spawn();
        let valid_piece_position = Coordinates { row: 2, col: 1 };

        let can_choose_piece = actions_system.can_choose_piece(Position::Up, valid_piece_position);
        assert(can_choose_piece, 'can_choose_piece failed');

        let current_piece = world.read_model((valid_piece_position));
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

        actions_system.spawn();
        let valid_piece_position = Coordinates { row: 2, col: 7 };

        let can_choose_piece = actions_system.can_choose_piece(Position::Up, valid_piece_position);
        assert(can_choose_piece, 'can_choose_piece failed');

        let current_piece = world.read_model((valid_piece_position));
        let new_coordinates_position = Coordinates { row: 3, col: 8 };
        actions_system.move_piece(current_piece, new_coordinates_position);
    }

    #[test]
    fn test_move_piece21_down_left() {
        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());

        let (contract_address, _) = world.dns(@"actions").unwrap();
        let actions_system = IActionsDispatcher { contract_address };

        actions_system.spawn();
        let valid_piece_position = Coordinates { row: 2, col: 1 };
        let initial_piece_position: Piece = world.read_model((valid_piece_position));

        assert(
            initial_piece_position.row == 2
                && initial_piece_position.col == 1,
            'wrong initial piece'
        );
        assert(initial_piece_position.is_king == false, 'wrong initial piece');
        assert(initial_piece_position.is_alive == true, 'wrong initial piece');

        let can_choose_piece = actions_system.can_choose_piece(Position::Up, valid_piece_position);
        assert(can_choose_piece, 'can_choose_piece failed');
        let current_piece: Piece = world.read_model((valid_piece_position));
        let new_coordinates_position = Coordinates { row: 3, col: 0 };
        actions_system.move_piece(current_piece, new_coordinates_position);

        let new_position: Piece = world.read_model((new_coordinates_position));

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
    }

    #[test]
    fn test_move_piece25_down_left() {
        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());

        let (contract_address, _) = world.dns(@"actions").unwrap();
        let actions_system = IActionsDispatcher { contract_address };

        actions_system.spawn();
        let valid_piece_position = Coordinates { row: 2, col: 5 };
        let initial_piece_position: Piece = world.read_model((valid_piece_position));

        assert(
            initial_piece_position.row == 2
                && initial_piece_position.col == 5,
            'wrong initial piece'
        );
        assert(initial_piece_position.is_king == false, 'wrong initial piece');
        assert(initial_piece_position.is_alive == true, 'wrong initial piece');

        let can_choose_piece = actions_system.can_choose_piece(Position::Up, valid_piece_position);
        assert(can_choose_piece, 'can_choose_piece failed');
        let current_piece: Piece = world.read_model((valid_piece_position));
        let new_coordinates_position = Coordinates { row: 3, col: 4 };
        actions_system.move_piece(current_piece, new_coordinates_position);

        let new_position: Piece = world.read_model((new_coordinates_position));

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

        actions_system.spawn();
        let valid_piece_position = Coordinates { row: 2, col: 7 };
        let initial_piece_position: Piece = world.read_model((valid_piece_position));

        assert(
            initial_piece_position.row == 2
                && initial_piece_position.col == 7,
            'wrong initial piece'
        );
        assert(initial_piece_position.is_king == false, 'wrong initial piece');
        assert(initial_piece_position.is_alive == true, 'wrong initial piece');

        let can_choose_piece = actions_system.can_choose_piece(Position::Up, valid_piece_position);
        assert(can_choose_piece, 'can_choose_piece failed');
        let current_piece: Piece = world.read_model((valid_piece_position));
        let new_coordinates_position = Coordinates { row: 3, col: 6 };
        actions_system.move_piece(current_piece, new_coordinates_position);

        let new_position: Piece = world.read_model((new_coordinates_position));

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

        actions_system.spawn();
        let valid_piece_position = Coordinates { row: 2, col: 1 };
        let initial_piece_position: Piece = world.read_model((valid_piece_position));

        assert(
            initial_piece_position.row == 2
                && initial_piece_position.col == 1,
            'wrong initial piece'
        );
        assert(initial_piece_position.is_king == false, 'wrong initial piece');
        assert(initial_piece_position.is_alive == true, 'wrong initial piece');

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
    }

    #[test]
    fn test_move_piece21_down_right_move_piece56_up_left() {
        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());

        let (contract_address, _) = world.dns(@"actions").unwrap();
        let actions_system = IActionsDispatcher { contract_address };

        actions_system.spawn();
        let valid_piece_position = Coordinates { row: 2, col: 1 };
        let initial_piece_position: Piece = world.read_model((valid_piece_position));

        assert(
            initial_piece_position.row == 2
                && initial_piece_position.col == 1,
            'wrong initial piece'
        );
        assert(initial_piece_position.is_king == false, 'wrong initial piece');
        assert(initial_piece_position.is_alive == true, 'wrong initial piece');

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

        let valid_piece_position56 = Coordinates { row: 5, col: 6 };
        let can_choose_piece = actions_system
            .can_choose_piece(Position::Down, valid_piece_position56);
        assert(can_choose_piece, 'can_choose_piece failed');
        let current_piece: Piece = world.read_model((valid_piece_position56));
        let new_coordinates_position = Coordinates { row: 4, col: 5 };
        actions_system.move_piece(current_piece, new_coordinates_position);

        let new_position: Piece = world.read_model((new_coordinates_position));

        assert!(new_position.row == 4, "piece x is wrong");
        assert!(new_position.col == 5, "piece y is wrong");
        assert!(new_position.is_alive == true, "piece is not alive");
        assert!(new_position.is_king == false, "piece is king");
    }
}
