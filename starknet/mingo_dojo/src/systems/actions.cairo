// define the interface
#[starknet::interface]
trait IActions<TContractState> {
    fn spawn(self: @TContractState);
    fn move(self: @TContractState, choice: mingo_choice::models::personality::PersonClass);
}

// dojo decorator
#[dojo::contract]
mod actions {
    use super::IActions;

    use starknet::{ContractAddress, get_caller_address};
    use mingo_choice::models::{
        position::{Position, Vec2, VecInt, Vec2IntTrait},
        personality::{Personality, PersonClass, MbtiScore, Direction, PersonalityTrait},
    };

    // declaring custom event struct
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Moved: Moved,
    }

    // declaring custom event struct
    #[derive(Drop, starknet::Event)]
    struct Moved {
        player: ContractAddress,
        direction: Direction
    }

    fn next_position(mut position: Position, direction: Direction) -> Position {
        match direction {
            Direction::None => {},
            Direction::North => { position.vec.y.safe_add(1); },
            Direction::South => { position.vec.y.safe_sub(1); },
            Direction::East => { position.vec.x.safe_add(1); },
            Direction::West => { position.vec.x.safe_sub(1); },
            Direction::NorthEast => {
                position.vec.y.safe_add(1);
                position.vec.x.safe_add(1);
            },
            Direction::SouthWest => {
                position.vec.y.safe_sub(1);
                position.vec.x.safe_sub(1);
            },
            Direction::NorthWest => {
                position.vec.y.safe_add(1);
                position.vec.x.safe_sub(1);
            },
            Direction::SouthEast => {
                position.vec.y.safe_sub(1);
                position.vec.x.safe_add(1);
            },
        }

        position
    }


    // impl: implement functions specified in trait
    #[abi(embed_v0)]
    impl ActionsImpl of IActions<ContractState> {
        // ContractState is defined by system decorator expansion
        fn spawn(self: @ContractState) {
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();

            // Get the address of the current caller, possibly the player's address.
            let player = get_caller_address();

            // Retrieve the player's current position from the world.
            let position = get!(world, player, (Position));

            // Retrieve the player's personality data.
            let personality = get!(world, player, (Personality));

            // new person
            let freshman = PersonalityTrait::new(player);

            // Update the world state with the new data.
            // 1. Set new player
            // 2. Move the player's position 100 units in both the x and y.
            set!(
                world,
                (
                    freshman,
                    Position {
                        player,
                        vec: Vec2 {
                            x: VecInt { value: 0, negative: false },
                            y: VecInt { value: 0, negative: false }
                        }
                    }
                )
            );
        }

        // Implementation of the move function for the ContractState struct.
        fn move(self: @ContractState, choice: PersonClass) {
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();

            // Get the address of the current caller, possibly the player's address.
            let player = get_caller_address();

            // Retrieve the player's current position and moves data from the world.
            let (mut personality, mut position) = get!(world, player, (Personality, Position));

            // Update score and get direction.
            let (freshman, direction) = personality.add_score(choice);

            // Calculate the player's next position based on the provided choice.
            let next = next_position(position, direction);

            // Update the world state with the new personality data and position.
            set!(world, (freshman, next));

            // Emit an event to the world to notify about the player's choice.
            emit!(world, Moved { player, direction });
        }
    }
}
