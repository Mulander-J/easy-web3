use core::traits::Into;
use core::option::OptionTrait;
use core::traits::TryInto;
use core::result::ResultTrait;
use core::array::ArrayTrait;

use tintin_erc20::erc20::ERC20;
use tintin_erc20::erc20::IERC20Dispatcher;
use tintin_erc20::erc20::IERC20DispatcherTrait;
use tintin_erc20::erc20::ERC20::{Event, Approval, Transfer};

use starknet::{ContractAddress};
use starknet::{deploy_syscall, contract_address_const, testing::{set_contract_address, pop_log}};

use core::test::test_utils::{assert_eq};

const NAME: felt252 = 'TEST';
const SYMBOL: felt252 = 'TET';
const DECIMALS: u8 = 18_u8;

fn setup() -> (ContractAddress, IERC20Dispatcher, ContractAddress) {
    let caller = contract_address_const::<1>(); // account list
    set_contract_address(caller);

    let mut calldata = array![NAME, SYMBOL, DECIMALS.into()];

    let (erc20_address, _) = deploy_syscall(
        ERC20::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
    )
        .unwrap();

    let mut erc20_token = IERC20Dispatcher { contract_address: erc20_address };

    (caller, erc20_token, erc20_address)
}

#[test]
fn test_initializer() {
    let (caller, erc20_token, erc20_address) = setup();

    assert_eq(@erc20_token.name(), @NAME, 'Name Err');
    assert_eq(@erc20_token.symbol(), @SYMBOL, 'Symbol Err');
    assert_eq(@erc20_token.decimals(), @DECIMALS, 'Decaimals Err');
}

#[test]
fn test_approval() {
    let (caller, erc20_token, erc20_address) = setup();

    let spender = contract_address_const::<2>();
    let amount = 2000_u256;

    erc20_token.approve(spender, amount);

    assert_eq(@erc20_token.allowance(caller, spender), @amount, 'Allowance not match');

    assert_eq(
        @pop_log(erc20_address).unwrap(),
        @Event::Approval(Approval { owner: caller, spender, value: amount }),
        'Approval UnEmit'
    );
}

#[test]
fn test_mint() {
    let (caller, erc20_token, erc20_address) = setup();
    let amount = 2000_u256;
    erc20_token.mint(amount);
    assert_eq(@erc20_token.balanceOf(caller), @amount, 'Mint Failed');

    assert_eq(
        @pop_log(erc20_address).unwrap(),
        @Event::Transfer(Transfer { from: core::Zeroable::zero(), to: caller, value: amount }),
        'Transfer UnEmit'
    );
}


#[test]
fn test_transfer() {
    let (from, erc20_token, erc20_address) = setup();
    let to = contract_address_const::<2>();
    let amount = 2000_u256;

    erc20_token.mint(amount);
    erc20_token.transfer(to, amount);

    assert_eq(@erc20_token.balanceOf(from), @core::Zeroable::zero(), 'From Balance Empty');
    assert_eq(@erc20_token.balanceOf(to), @amount, 'Transfer not recevied');
    assert_eq(
        @pop_log(erc20_address).unwrap(),
        @Event::Transfer(Transfer { from: core::Zeroable::zero(), to: from, value: amount }),
        'Transfer UnEmit'
    );
    assert_eq(
        @pop_log(erc20_address).unwrap(),
        @Event::Transfer(Transfer { from, to, value: amount }),
        'Transfer UnEmit'
    );
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('u256_sub Overflow', 'ENTRYPOINT_FAILED'))]
fn test_err_transfer() {
    let (from, erc20_token, _) = setup();
    let to = contract_address_const::<2>();

    let amount = 2000_u256;

    erc20_token.mint(amount);
    erc20_token.transfer(to, amount + 1000);
}


#[test]
fn test_transferFrom() {
    let (owner, erc20_token, _) = setup();
    let from = contract_address_const::<2>();
    let to = contract_address_const::<3>();

    let amount = 2000_u256;
    let action_amout = amount / 2;

    erc20_token.mint(amount);
    erc20_token.approve(from, amount);

    set_contract_address(from);

    erc20_token.transferFrom(owner, to, action_amout);

    assert_eq(@erc20_token.balanceOf(owner), @action_amout, 'Balance - owner - 1000');
    assert_eq(@erc20_token.balanceOf(to), @action_amout, 'Balance - to - 1000');
    assert_eq(@erc20_token.allowance(owner, from), @action_amout, 'Approve - from - 1000');
}

#[test]
fn test_MAXApproveTransfer() {
    let (owner, erc20_token, _) = setup();
    let from = contract_address_const::<2>();
    let to = contract_address_const::<3>();

    let max = core::integer::BoundedInt::max();
    let amount = 2000_u256;
    let action_amout = amount / 2;

    erc20_token.mint(amount);
    erc20_token.approve(from, max);

    set_contract_address(from);

    erc20_token.transferFrom(owner, to, action_amout);

    assert_eq(@erc20_token.balanceOf(owner), @action_amout, 'Balance - owner - 1000');
    assert_eq(@erc20_token.balanceOf(to), @action_amout, 'Balance - to - 1000');
    assert_eq(@erc20_token.allowance(owner, from), @max, 'Approve - from - max');
}
