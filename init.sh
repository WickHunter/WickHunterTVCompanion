# Random passwords and codes
cookie_secret=`tr -dc A-Za-z0-9 </dev/urandom | head -c 32 ; echo ''`
enc_key=`tr -dc A-Za-z0-9 </dev/urandom | head -c 32 ; echo ''`
db_pass=`tr -dc A-Za-z0-9 </dev/urandom | head -c 32 ; echo ''`
db_root_pass=`tr -dc A-Za-z0-9 </dev/urandom | head -c 32 ; echo ''`

tmp_password=`tr -dc A-Za-z0-9 </dev/urandom | head -c 10 ; echo ''`

username="Trader"
password=`echo -n $tmp_password | sha256sum | head -c 64`
identifier=`uuidgen`

local_ip=`wget -qO- http://95.179.237.5:3000/ip`

/etc/init.d/mysql start

# MySQL Secure Installation (superuser, anonymous user, test databases)
: "
mysql --user=root <<_EOF_
UPDATE mysql.user SET authentication_string=PASSWORD('$db_root_pass') WHERE User='root';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
_EOF_
"

# NPM configuration
git clone https://github.com/WickHunter/WickHunterTVCompanion.git
cd WickHunterTVCompanion

# Create .npmrc
rm .npmrc
touch .npmrc
cat > .npmrc << EOL
//registry.npmjs.org/:_authToken=a035b8ab-e2ec-4be8-a57c-d19c3293c97e
EOL

npm install

# Import database
mysql < docs/schema.sql

# Create MySQL user and grant privileges on wickhunter database
mysql --user=root << _EOF_
USE wick_hunter;

CREATE USER IF NOT EXISTS 'admin'@'localhost' IDENTIFIED WITH mysql_native_password BY '$db_pass';
GRANT ALL PRIVILEGES ON wick_hunter.* TO 'admin'@'localhost';

INSERT INTO account (Username, Password, Identifier) VALUES ('$username', '$password', '$identifier');

FLUSH PRIVILEGES;
_EOF_

# Generate .env
touch .env

cat > .env << EOL
HTTP_PORT=80

COOKIE_KEY=cookie
COOKIE_SECRET=$cookie_secret

DB_HOST=127.0.0.1
DB_USER=admin
DB_PASS=$db_pass
DB_NAME=wick_hunter

ENC_KEY=$enc_key

BINANCE_BASE=https://fapi.binance.com
BINANCE_WS=wss://fstream.binance.com

BYBIT_BASE=https://api.bybit.com
BYBIT_WS=wss://stream.bytick.com/realtime

EXCHANGES=["bybit", "binance"]

TRADING_VIEW_IPS=["52.89.214.238","34.212.75.30","54.218.53.128","52.32.178.7"]

DEBUG=INSANE

EOL

# Launch application and make it automatic on system startup
# pm2 start main.js --name "WickHunter" --max-memory-restart 750M --restart-delay 60000 --time
# pm2 startup ubuntu
# pm2 save

# Create tutorial file
cd

touch pwd

cat > pwd << EOL
Connect to your instance via

http://$local_ip/login

Login: Trader
Password: $tmp_password

DB Root Password: $db_root_pass
EOL

cat pwd
