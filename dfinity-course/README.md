# DF-Course `S2`

> Start at `2022-02-20`

## ClassInfo

- No.103
- Class.2

## Catalog

- 1.使用 SDK 搭建一个网站
- 2.Motoko 语言入门（工具，语法，例子）
- 3.使用 SDK 搭建一个网站
- 4.使用 SDK 搭建一个网站
- 5.使用 SDK 搭建一个网站

## Reference Links

[Dfinity-Official](https://smartcontracts.org/)
[Candid UI](https://a4gq6-oaaaa-aaaab-qaa4q-cai.raw.ic0.app)
[Http-Apply](https://gist.github.com/ninegua/d2a1b4452833bc0d606556e7ac8713f1)

## Project Cid

- [mysite.local](http://ryjl3-tyaaa-aaaaa-aaaba-cai.localhost:8000/)
- [mysite.ic0](https://srgrl-nyaaa-aaaal-qahbq-cai.ic0.app/)
- [myCounter.ic0](https://4rl4k-uiaaa-aaaal-qaknq-cai.raw.ic0.app)

## Down

1.1.Downlaod SDK

```bash
sh -ci "$(curl -fsSL https://smartcontracts.org/install.sh)"
```

1.2.Export PATH

```bash
export PATH=/home/$USER$/bin:$PATH
```

1.3.Create with Cli

```bash
dfx new ProjectName
```

1.4.Dev

```bash
dfx start
# in backgaround
dfx start --background

#build with check
dfx build --check

#local
dfx deploy
#mainnet
dfx deploy --network=ic --with-cycles=400000000000
#ReInstall
dfx deploy --network=ic -m reinstall <canister>

#Stop
dfx canister --network=ic stop -all
#Delete
dfx canister --network=ic delete -all

#Cache
dfx cache show
#Path
export PATH=$(dfx cache show):$PATH
#Compiler Runtime
moc
#Compiler file
moc --package base $(dfx cache show)/base -r src/mysite/main.mo
#Call
dfx canister call mysite fibonaci '(10)'
dfx canister --network=ic  call {canisterId} get
```

2.1.Check Principal Id

```bash
dfx identity get-principal
```

2.2.Get Cycles Fauet

> Mystery Code `*****-*****-*****`

```bash
dfx canister --network=ic --no-wallet \
call fg7gi-vyaaa-aaaal-qadca-cai redeem '("*****-*****-*****")'
```

```bash
# Return
(principal "*****-*****-*****-*****-cai")
```

2.3.Combine DFX & Cycles

```bash
dfx identity --network=ic set-wallet CANISTER_ID
```

2.4.Check Balance

```bash
dfx wallet --network=ic balance
```
