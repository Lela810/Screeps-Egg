chown -R root:root /mnt
cd /mnt/server

echo "Creating config.yml"
cat > config.yml << EOF
mods:
  - screepsmod-auth
  - screepsmod-admin-utils
bots:
  simplebot: screepsbot-zeswarm
serverOptions:
  logConsole: true
serverConfig:
  welcomeText: |
    <h1 style="text-align: center;">LKlaus Hosting Server</h1>
  tickRate: 1000
EOF

echo "Creating mods.json"
cat > mods.json << EOF
{
  "mods": [
    "node_modules/screepsmod-auth/index.js",
    "node_modules/screepsmod-admin-utils/index.js",
    "mods/screeps-launcher-cli.js"
  ],
  "bots": {
    "simplebot": "node_modules/screepsbot-zeswarm/src"
  }
}
EOF

echo "Creating init.sh"
cat > init.sh << EOF

if [ ! -f .screepsrc ]; then

echo "Installing Screeps server"
npm --silent i screeps

echo "Initializing Screeps server"
cp -a ./node_modules/@screeps/launcher/init_dist/.screepsrc ./
cp -a ./node_modules/@screeps/launcher/init_dist/db.json ./
cp -a ./node_modules/@screeps/launcher/init_dist/assets/ ./

echo "Adjusting configuration"
sed -i "s/{{STEAM_KEY}}/\$STEAM_KEY/g" .screepsrc
sed -i "s/21025/\$SERVER_PORT/g" .screepsrc

fi


# Extract and install screepsmod modules
cat mods.json | grep -o 'screepsmod-[^/]*' | while read -r mod; do
    echo "Installing \$mod"
    npm --silent install "\$mod"
done

# Extract and install screepsbot modules
cat mods.json | grep -o 'screepsbot-[^/]*' | while read -r bot; do
    echo "Installing \$bot"
    npm --silent install "\$bot"
done
EOF

echo "Adjusting permissions"
chmod +x init.sh
mkdir /mnt/server/.screen && chmod 700 /mnt/server/.screen