const ONE_MINUTE_IN_SECONDS: u64 = 60;

#[derive(Drop)]
struct Rectangle<T> {
    width: T,
    height: T,
}

trait RectangleTrait<T> {
    fn area(self: @Rectangle<T>) -> T;
}

// impl RectangleDisplay of core::fmt::Display::<Rectangle> {
//     fn fmt(self: @Rectangle, ref f: core::fmt::Formatter) -> Result<(), core::fmt::Error> {
//         write!(f, "width: ")?;
//         core::fmt::Display::fmt(self.width, ref f)?;
//         write!(f, "height: ")?;
//         core::fmt::Display::fmt(self.height, ref f)
//     }
// }
impl RectangleImpl<T, +Mul<T>, +Copy<T>> of RectangleTrait<T> {
    fn area(self: @Rectangle<T>) -> T {
        *self.width * * self.height
    }
}

fn main() {
    /// define const
    println!("SECONDS_OF_MINUTE is {}", ONE_MINUTE_IN_SECONDS);

    /// mutable var
    // let mut x = 5;
    // println!("x is {}", x);
    // x = 6;
    // println!("x is {}", x);

    /// type transfer
    // let x = 5_u8;
    // let y = 6_u16;    
    // println!("y / x = {}", y / x.into());
    // println!("x / y = {}", x / y.try_into().unwrap());

    /// string - short -> ascii
    // let x = 'Hello World';
    // println!("{}, Cairo", x);
    
    /// string - format
    // let x = 25_u16;
    // println!("{}", format!("https://example.com/{}", x));

    /// string Byte
    // let x: ByteArray = "Long String";
    // println!("{}", x);

    /// custom function & test
    println!("sum_tripe:1+3+4 = {}", sum_tripe(1, 3, 4));

    /// control flow
    println!("min {}", min(3,6));
    println!("min_tripe {}", min_tripe(3,6,2));
    println!("fib {}", fib(3,6,3));

    /// array
    let mut a = array![1,3,4];
    // println!("sum_array {}", sum_array(a));
    // println!("len_a_2 {}", a.len()); // error: Variable was previously moved.
    println!("sum_ref {}", sum_ref(ref a));
    println!("len_a {}", return_arr_len(@a));
    println!("len_a_2 {}", return_span_len(a.span()));
    println!("len_a_3 {}", a.len());
    
    /// struct
    let rect = Rectangle { width:30_u32, height: 40, };
    let _area = area(@rect);
    // println!("Rectangle is {}", rect);
    println!("Rectangle area {}", _area);
    println!("Rectangle area2 {}", rect.area());
    println!("Width is {}", rect.width);
}

fn sum_tripe(a: u32, b: u32, c: u32) -> u32 {
    a + b + c
}

fn min(a:u32, b:u32) -> u32 {
    if a <= b {
        a
    } else {
        b
    }
}
fn min_tripe(a:u32, b:u32, c:u32) -> u32 {
    if (a <= b) & ( a <= c) {
        a
    } else if (b <= a) & (b <= c) {
        b
    } else {
        c
    }
}

fn fib(mut a: felt252, mut b: felt252, mut n: felt252) -> felt252{
    loop {
        if n==0 {
            break a;
        }

        n -= 1;
        let temp = b;
        b = a + b;
        a = temp;
    }
}

fn sum_array(mut arr: Array<u32>) -> u32 {
    let mut sum = 0_u32;
    loop {
        match arr.pop_front() {
            Option::Some(current) => {
                sum += current;
            },
            Option::None => {
                break;
            },
        }
    };
    sum
}
fn sum_span(mut arr: Span<u32>) -> u32 {
    let mut sum = 0_u32;
    loop {
        match arr.pop_front() {
            Option::Some(current) => {
                sum += *current;
            },
            Option::None => {
                break;
            },
        }
    };
    sum
}
fn sum_ref(ref arr: Array<u32>) -> u32 {
    let mut sum = 0_u32;
    loop {
        match arr.pop_front() {
            Option::Some(current) => {
                sum += current;
            },
            Option::None => {
                break;
            },
        }
    };
    sum
}

fn return_arr_len(arr: @Array<u32>) -> u32 {
    arr.len()
}
fn return_span_len(arr: Span<u32>) -> u32 {
    arr.len()
}
fn area(rect: @Rectangle<u32>) -> u32 {
    *rect.width * *rect.height
}

#[cfg(test)]
mod tests {
    use super::sum_tripe;
    #[test]
    fn it_works() {
        assert(sum_tripe(1,3,4) == 8, 'Sum Fail');
    }
}
