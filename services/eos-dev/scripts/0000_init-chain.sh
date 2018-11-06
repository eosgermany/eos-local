#!/usr/bin/env bash

RIVATE_KEY="5JB2p6ApneND4LcQri8M9rEUXt1vfMf7PSMZDSgYLh8YKdHyabK"
PUBLIC_KEY="EOS6gzmYfUEXpR2TyA6nuyBmtoKwW6JTp7xBJw1AYTRAJqi72Q5FP"

ROOT_DIR="/opt/eosio/bin"
CLEOS_PATH="$ROOT_DIR/cleos"
SCRIPTS_DIR="/opt/application/scripts"
CONFIG_DIR="/opt/application/config"
CONTRACTS_DIR="/opt/application/contracts"

# move into the executable directory
cd $ROOT_DIR

# Only create contract if wallet doesn't exist
mkdir "$CONFIG_DIR"/keys

sleep 1s

until curl eosiodev:8888/v1/chain/get_info
do
    sleep 1s
done

# Sleep for 2 secs to allow time to 4 blocks to be
# created so we have blocks to reference when
# sending transactions
echo "Creating accounts and deploying wallets"

# start wallet
wallet_password=$(cleos wallet create --to-console | awk 'FNR > 3 { print $1 }' | tr -d '"')
echo $wallet_password > "$CONFIG_DIR"/keys/default_wallet_password.txt

# open the wallet

cleos -u http://eosiodev:8888 wallet open

# list wallet

cleos -u http://eosiodev:8888 wallet list

#unlock wallet

cleos -u http://eosiodev:8888 wallet unlock -n default --password $wallet_password

# list wallet

cleos -u http://eosiodev:8888 wallet list

# import wallet keys
cleos -u http://eosiodev:8888 wallet import --private-key 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3

cleos -u http://eosiodev:8888 create account eosio bob EOS6gzmYfUEXpR2TyA6nuyBmtoKwW6JTp7xBJw1AYTRAJqi72Q5FP 
cleos -u http://eosiodev:8888 create account eosio alice EOS6gzmYfUEXpR2TyA6nuyBmtoKwW6JTp7xBJw1AYTRAJqi72Q5FP
cleos -u http://eosiodev:8888 create account eosio hello EOS6gzmYfUEXpR2TyA6nuyBmtoKwW6JTp7xBJw1AYTRAJqi72Q5FP -p eosio@active

cleos -u http://eosiodev:8888 wallet unlock -n default --password $wallet_password
cleos -u http://eosiodev:8888 set contract hello $CONTRACTS_DIR/hello -p hello@active