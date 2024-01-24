#[cfg(test)]
mod tests {
    use starknet::class_hash::Felt252TryIntoClassHash;
    // import world dispatcher
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

    // import test utils
    use dojo::test_utils::{spawn_test_world, deploy_contract};

    // import test utils
    use mingo_choice::{
        systems::{actions::{actions, IActionsDispatcher, IActionsDispatcherTrait}},
        models::{
            position::{Position, position}, personality::{Personality, PersonClass, personality}
        }
    };


    #[test]
    #[available_gas(30000000_0)]
    fn test_move() {
        // caller
        let caller = starknet::contract_address_const::<0x0>();

        // models
        let mut models = array![personality::TEST_CLASS_HASH, position::TEST_CLASS_HASH];

        // deploy world with models
        let world = spawn_test_world(models);

        // deploy systems contract
        let contract_address = world
            .deploy_contract('salt', actions::TEST_CLASS_HASH.try_into().unwrap());
        let actions_system = IActionsDispatcher { contract_address };

        // call spawn()
        actions_system.spawn();

        // call move with direction right
        actions_system.move(PersonClass::I); // {x:0,y:-1}
        actions_system.move(PersonClass::E); // {x:0,y:0}
        actions_system.move(PersonClass::E); // {x:0,y:1}
        actions_system.move(PersonClass::N); // {x:-1,y:1}
        actions_system.move(PersonClass::F); // {x:-2,y:0}
        actions_system.move(PersonClass::P); // {x:-1,y:-1}

        // Check world state
        let personality = get!(world, caller, Personality);

        // casting right direction
        let p_class_felt: felt252 = PersonClass::P.into();

        // check moves
        assert(personality.no == 6, 'count is wrong');

        // check last direction
        assert(personality.last_choice.into() == p_class_felt, 'last choice is wrong');

        assert(personality.group.EI == PersonClass::E, 'EI is wrong');
        assert(personality.group.SN == PersonClass::N, 'SN is wrong');
        assert(personality.group.TF == PersonClass::F, 'TF is wrong');
        assert(personality.group.JP == PersonClass::P, 'JP is wrong');
        // get new_position
        let new_position = get!(world, caller, Position);

        // check new position x
        assert(new_position.vec.x.value == 1 && new_position.vec.x.negative, 'position x is wrong');

        // check new position y
        assert(new_position.vec.y.value == 1 && new_position.vec.y.negative, 'position y is wrong');
    }
}
