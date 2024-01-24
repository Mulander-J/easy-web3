use starknet::ContractAddress;

// *************************************************************************
//                                     MODEL
// *************************************************************************

#[derive(Model, Copy, Drop, Serde)]
struct Personality {
    #[key]
    player: ContractAddress,
    no: u256,
    last_choice: PersonClass,
    score: MbtiScore,
    group: MbtiGroup,
// group: (PersonClass, PersonClass, PersonClass, PersonClass),
}

#[derive(Copy, Drop, Serde, Introspect)]
struct MbtiScore {
    _e: u256,
    _i: u256,
    _s: u256,
    _n: u256,
    _t: u256,
    _f: u256,
    _p: u256,
    _j: u256,
}

#[derive(Copy, Drop, Serde, Introspect)]
struct MbtiGroup {
    EI: PersonClass,
    SN: PersonClass,
    TF: PersonClass,
    JP: PersonClass
}

#[derive(Serde, Copy, Drop, Introspect, PartialEq)]
enum PersonClass {
    X, // None
    E,
    I,
    S,
    N,
    T,
    F,
    J,
    P,
}

#[derive(Serde, Copy, Drop, Introspect)]
enum PersonSubClass {
    EI,
    SN,
    TF,
    JP,
}

#[derive(Serde, Copy, Drop, Introspect)]
enum Direction {
    None,
    North,
    South,
    East,
    West,
    NorthEast,
    SouthWest,
    NorthWest,
    SouthEast,
}

// *************************************************************************
//                               Type Into
// *************************************************************************

impl PersonClassIntoFelt252 of Into<PersonClass, felt252> {
    fn into(self: PersonClass) -> felt252 {
        match self {
            PersonClass::X => 0,
            PersonClass::E => 1,
            PersonClass::I => 2,
            PersonClass::S => 3,
            PersonClass::N => 4,
            PersonClass::T => 5,
            PersonClass::F => 6,
            PersonClass::J => 7,
            PersonClass::P => 8,
        }
    }
}

// *************************************************************************
//                              Implementation
// *************************************************************************

#[generate_trait]
impl PersonalityImpl of PersonalityTrait {
    /// new a Personality struct with player address
    fn new(creator: ContractAddress) -> Personality {
        Personality {
            player: creator,
            no: 0_u256,
            last_choice: PersonClass::X,
            score: MbtiScore { _e: 0, _i: 0, _s: 0, _n: 0, _t: 0, _f: 0, _j: 0, _p: 0, },
            group: MbtiGroup {
                EI: PersonClass::X, SN: PersonClass::X, TF: PersonClass::X, JP: PersonClass::X,
            }
        }
    }
    /// `calc` decide class by comparing 2 factor values
    /// return ClassX while factor values equal.
    fn calc(self: Personality, sub_class: PersonSubClass) -> PersonClass {
        match sub_class {
            PersonSubClass::EI => {
                if self.score._e > self.score._i {
                    PersonClass::E
                } else if self.score._e < self.score._i {
                    PersonClass::I
                } else {
                    PersonClass::X
                }
            },
            PersonSubClass::SN => {
                if self.score._s > self.score._n {
                    PersonClass::S
                } else if self.score._s < self.score._n {
                    PersonClass::N
                } else {
                    PersonClass::X
                }
            },
            PersonSubClass::TF => {
                if self.score._t > self.score._f {
                    PersonClass::T
                } else if self.score._t < self.score._f {
                    PersonClass::F
                } else {
                    PersonClass::X
                }
            },
            PersonSubClass::JP => {
                if self.score._j > self.score._p {
                    PersonClass::J
                } else if self.score._j < self.score._p {
                    PersonClass::P
                } else {
                    PersonClass::X
                }
            },
        }
    }
    /// unused
    fn calc_group(ref self: Personality) -> MbtiGroup {
        MbtiGroup {
            EI: self.calc(PersonSubClass::EI),
            SN: self.calc(PersonSubClass::SN),
            TF: self.calc(PersonSubClass::TF),
            JP: self.calc(PersonSubClass::JP),
        }
    }
    /// add_score with choice
    fn add_score(ref self: Personality, choice: PersonClass) -> (Personality, Direction) {
        // update counter
        self.no += 1;
        // update palyer's last choice
        self.last_choice = choice;
        //  update mbti state
        match choice {
            PersonClass::X => { (self, Direction::None) },
            PersonClass::E => {
                self.score._e += 1;
                self.group.EI = self.calc(PersonSubClass::EI);
                (self, Direction::North)
            },
            PersonClass::I => {
                self.score._i += 1;
                self.group.EI = self.calc(PersonSubClass::EI);
                (self, Direction::South)
            },
            PersonClass::S => {
                self.score._s += 1;
                self.group.SN = self.calc(PersonSubClass::SN);
                (self, Direction::East)
            },
            PersonClass::N => {
                self.score._n += 1;
                self.group.SN = self.calc(PersonSubClass::SN);
                (self, Direction::West)
            },
            PersonClass::T => {
                self.score._t += 1;
                self.group.TF = self.calc(PersonSubClass::TF);
                (self, Direction::NorthEast)
            },
            PersonClass::F => {
                self.score._f += 1;
                self.group.TF = self.calc(PersonSubClass::TF);
                (self, Direction::SouthWest)
            },
            PersonClass::J => {
                self.score._j += 1;
                self.group.JP = self.calc(PersonSubClass::JP);
                (self, Direction::NorthWest)
            },
            PersonClass::P => {
                self.score._p += 1;
                self.group.JP = self.calc(PersonSubClass::JP);
                (self, Direction::SouthEast)
            },
        }
    }
}
// *************************************************************************
//                           Schema Introspections
//   Refs: https://github.com/akhercha/werewolves-of-cairo/blob/4fccb04a0977e444743677236a7f99549bf82eae/contracts/src/models/game.cairo
// *************************************************************************

// impl GroupIntrospectionImpl of Introspect<(PersonClass, PersonClass, PersonClass, PersonClass)> {
//     #[inline(always)]
//     fn size() -> usize {
//         1
//     }

//     #[inline(always)]
//     fn layout(ref layout: Array<u8>) {
//         layout.append(8);
//     }

//     #[inline(always)]
//     fn ty() -> Ty {
//         Ty::Enum(
//             Enum {
//                 name: 'Group',
//                 attrs: array![].span(),
//                 children: array![('Group', serialize_member_type(@Ty::Tuple(array![].span()))),]
//                     .span()
//             }
//         )
//     }
// }

// *************************************************************************
//                              Unit Test
// *************************************************************************

#[cfg(test)]
mod tests {
    use super::{Personality, PersonClass, PersonalityTrait};
    use starknet::contract_address_const;

    #[test]
    #[available_gas(100000_0)]
    fn test_person_add_score_EI() {
        let mut person = PersonalityTrait::new(contract_address_const::<0>());
        person.add_score(PersonClass::E);
        assert(person.group.EI == PersonClass::E, 'group EI - E');
        person.add_score(PersonClass::I);
        assert(person.group.EI == PersonClass::X, 'group EI - X');
        person.add_score(PersonClass::I);
        assert(person.group.EI == PersonClass::I, 'group EI - I');
        person.add_score(PersonClass::E);
        person.add_score(PersonClass::E);
        assert(person.group.EI == PersonClass::E, 'group EI - E');
        assert(person.last_choice == PersonClass::E, 'last choice - E');
        assert(person.no == 5, 'No - 5');
    }

    #[test]
    #[available_gas(100000_0)]
    fn test_person_add_score_SN() {
        let mut person = PersonalityTrait::new(contract_address_const::<0>());
        person.add_score(PersonClass::N);
        assert(person.group.SN == PersonClass::N, 'group SN - N');
        person.add_score(PersonClass::S);
        assert(person.group.SN == PersonClass::X, 'group SN - X');
        person.add_score(PersonClass::S);
        assert(person.group.SN == PersonClass::S, 'group SN - S');
        person.add_score(PersonClass::N);
        person.add_score(PersonClass::N);
        assert(person.group.SN == PersonClass::N, 'group SN - N');
    }

    #[test]
    #[available_gas(100000_0)]
    fn test_person_add_score_TF() {
        let mut person = PersonalityTrait::new(contract_address_const::<0>());
        person.add_score(PersonClass::F);
        assert(person.group.TF == PersonClass::F, 'group TF - F');
        person.add_score(PersonClass::T);
        assert(person.group.TF == PersonClass::X, 'group TF - X');
        person.add_score(PersonClass::T);
        assert(person.group.TF == PersonClass::T, 'group TF - T');
        person.add_score(PersonClass::F);
        person.add_score(PersonClass::F);
        assert(person.group.TF == PersonClass::F, 'group TF - F');
    }

    #[test]
    #[available_gas(100000_0)]
    fn test_person_add_score_JP() {
        let mut person = PersonalityTrait::new(contract_address_const::<0>());
        person.add_score(PersonClass::J);
        assert(person.group.JP == PersonClass::J, 'group JP - J');
        person.add_score(PersonClass::P);
        assert(person.group.JP == PersonClass::X, 'group JP - X');
        person.add_score(PersonClass::P);
        assert(person.group.JP == PersonClass::P, 'group JP - P');
        person.add_score(PersonClass::J);
        person.add_score(PersonClass::J);
        assert(person.group.JP == PersonClass::J, 'group JP - J');
    }
}

