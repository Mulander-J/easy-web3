use starknet::ContractAddress;

#[starknet::interface]
trait IERC20<TContractState> {
    fn name(self: @TContractState) -> felt252;
    fn symbol(self: @TContractState) -> felt252;
    fn decimals(self: @TContractState) -> u8;
    fn totalSupply(self: @TContractState) -> u256;
    fn balanceOf(self: @TContractState, account: ContractAddress) -> u256;
    fn allowance(self: @TContractState, owner: ContractAddress, spender: ContractAddress) -> u256;
    fn approve(ref self: TContractState, spender: ContractAddress, amount: u256) -> bool;
    fn mint(ref self: TContractState, amount: u256);
    fn transfer(ref self: TContractState, to: ContractAddress, amount: u256) -> bool;
    fn transferFrom(
        ref self: TContractState, from: ContractAddress, to: ContractAddress, amount: u256
    ) -> bool;
}

#[starknet::contract]
mod ERC20 {
    use starknet::{ContractAddress, event::EventEmitter};
    use starknet::get_caller_address;
    use core::integer::BoundedInt;

    #[derive(Drop, Hash, starknet::Store)]
    struct test {
        name: felt252,
        symbol: felt252,
    }
    #[storage]
    struct Storage {
        _name: felt252,
        _symbol: felt252,
        _decimals: u8,
        _total_supply: u256,
        _balances: LegacyMap::<ContractAddress, u256>,
        _allowance: LegacyMap::<(ContractAddress, ContractAddress), u256>,
        _test: LegacyMap::<test, test>
    }

    #[event]
    #[derive(Drop, PartialEq, starknet::Event)]
    enum Event {
        Transfer: Transfer,
        Approval: Approval,
    }

    #[derive(Drop, PartialEq, starknet::Event)]
    struct Transfer {
        #[key] // indexd 
        from: ContractAddress,
        #[key]
        to: ContractAddress,
        value: u256,
    }

    #[derive(Drop, PartialEq, starknet::Event)]
    struct Approval {
        #[key]
        owner: ContractAddress,
        #[key]
        spender: ContractAddress,
        value: u256
    }

    #[constructor]
    fn constructor(ref self: ContractState, name: felt252, symbol: felt252, decimals: u8) {
        self._name.write(name);
        self._symbol.write(symbol);
        self._decimals.write(decimals);
    }

    #[external(v0)]
    impl ERC20Impl of super::IERC20<ContractState> {
        fn name(self: @ContractState) -> felt252 {
            self._name.read()
        }
        fn symbol(self: @ContractState) -> felt252 {
            self._symbol.read()
        }
        fn decimals(self: @ContractState) -> u8 {
            self._decimals.read()
        }
        fn totalSupply(self: @ContractState) -> u256 {
            self._total_supply.read()
        }
        fn balanceOf(self: @ContractState, account: ContractAddress) -> u256 {
            self._balances.read(account)
        }
        fn allowance(
            self: @ContractState, owner: ContractAddress, spender: ContractAddress
        ) -> u256 {
            self._allowance.read((owner, spender))
        }
        fn approve(ref self: ContractState, spender: ContractAddress, amount: u256) -> bool {
            let owner = get_caller_address();
            self._allowance.write((owner, spender), amount);
            self.emit(Event::Approval(Approval { owner, spender, value: amount }));

            true
        }
        fn mint(ref self: ContractState, amount: u256) {
            let sender = get_caller_address();

            self._total_supply.write(self._total_supply.read() + amount);
            self._balances.write(sender, self._balances.read(sender) + amount);

            self
                .emit(
                    Event::Transfer(
                        Transfer { from: core::Zeroable::zero(), to: sender, value: amount }
                    )
                )
        }
        fn transfer(ref self: ContractState, to: ContractAddress, amount: u256) -> bool {
            let from = get_caller_address();

            self.transfer_helper(from, to, amount);

            true
        }
        fn transferFrom(
            ref self: ContractState, from: ContractAddress, to: ContractAddress, amount: u256
        ) -> bool {
            let caller = get_caller_address();
            let allowed = self._allowance.read((from, caller));

            if (allowed != BoundedInt::max()) {
                self._allowance.write((from, caller), allowed - amount);
                self
                    .emit(
                        Event::Approval(
                            Approval { owner: from, spender: caller, value: allowed - amount }
                        )
                    );
            }

            self.transfer_helper(from, to, amount);

            true
        }
    }

    #[generate_trait]
    impl StrogeImpl of StrogeTrait {
        fn transfer_helper(
            ref self: ContractState,
            sender: ContractAddress,
            recipient: ContractAddress,
            amount: u256
        ) {
            self._balances.write(sender, self._balances.read(sender) - amount);
            self._balances.write(recipient, self._balances.read(recipient) + amount);

            self.emit(Event::Transfer(Transfer { from: sender, to: recipient, value: amount }));
        }
    }
}
