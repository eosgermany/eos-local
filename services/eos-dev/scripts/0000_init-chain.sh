#!/usr/bin/env bash
EOSIO_PRIVATE_KEY="5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3"
EOSIO_PUBLIC_KEY="EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV"

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
sleep 2s
echo "Creating accounts and deploying wallets"

# start wallet
wallet_password=$(./cleos wallet create --to-console | awk 'FNR > 3 { print $1 }' | tr -d '"')
echo $wallet_password > "$CONFIG_DIR"/keys/default_wallet_password.txt

# open the wallet
sleep .5s
./cleos wallet open

# list wallet
sleep .5s
./cleos wallet list

#unlock wallet
sleep .5s
./cleos wallet unlock -n default --password $wallet_password

# list wallet
sleep .5s
./cleos wallet list

# import wallet keys
sleep .5s
./cleos wallet import -n default --private-key $EOSIO_PRIVATE_KEY

sleep .5s
./cleos -u http://eosiodev:8888 create account eosio bob $EOSIO_PUBLIC_KEY 
./cleos -u http://eosiodev:8888 create account eosio alice $EOSIO_PUBLIC_KEY

