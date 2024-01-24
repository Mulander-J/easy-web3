use starknet::ContractAddress;

// *************************************************************************
//                                     MODEL
// *************************************************************************

#[derive(Model, Copy, Drop, Serde)]
struct Position {
    #[key]
    player: ContractAddress,
    vec: Vec2,
}

#[derive(Copy, Drop, Serde, Introspect)]
struct Vec2 {
    x: VecInt,
    y: VecInt,
}

#[derive(Copy, Drop, Serde, Introspect)]
struct VecInt {
    value: u256,
    negative: bool
}

// *************************************************************************
//                              Implementation
// *************************************************************************

#[generate_trait]
impl Vec2IntImpl of Vec2IntTrait {
    fn safe_sub(ref self: VecInt, _v: u256) -> VecInt {
        if _v == 0 {
            return self;
        } else if self.value == 0 {
            self.value = _v;
            self.negative = true;
        } else if self.negative {
            self.value += _v
        } else {
            if self.value > _v {
                self.value -= _v;
                self.negative = false;
            } else if self.value < _v {
                self.value = _v - self.value;
                self.negative = true;
            } else {
                self.value = 0;
                self.negative = false;
            }
        }
        self
    }

    fn safe_add(ref self: VecInt, _v: u256) -> VecInt {
        if _v == 0 {
            return self;
        } else if (self.value == 0) {
            self.value = _v;
            self.negative = false;
        } else if !self.negative {
            self.value += _v
        } else {
            if self.value > _v {
                self.value -= _v;
                self.negative = true;
            } else if self.value < _v {
                self.value = _v - self.value;
                self.negative = false;
            } else {
                self.value = 0;
                self.negative = false;
            }
        }
        self
    }
}

// *************************************************************************
//                              Test
// *************************************************************************

#[cfg(test)]
mod tests {
    use super::{Vec2, VecInt, Vec2IntTrait};

    #[test]
    #[available_gas(100000_0)]
    fn test_vec_int_calc() {
        let mut test_vec = Vec2 {
            x: VecInt { value: 2, negative: false }, y: VecInt { value: 0, negative: false }
        };
        test_vec.x.safe_sub(3);
        assert(test_vec.x.value == 1 && test_vec.x.negative, '2 - 3 = -1');
        test_vec.x.safe_sub(2);
        assert(test_vec.x.value == 3 && test_vec.x.negative, '-1 - 2 = -3');
        test_vec.x.safe_add(1);
        assert(test_vec.x.value == 2 && test_vec.x.negative, '-3 + 1 = -2');
        test_vec.x.safe_add(4);
        assert(test_vec.x.value == 2 && !test_vec.x.negative, '-2 + 4 = 2');
    }
}
