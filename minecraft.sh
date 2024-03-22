#!/bin/bash

output(){
    echo -e '\e[36m'$1'\e[0m';
}

server_jar_size_check(){

minimumsize=50
actualsize=$(du -k "$JAR" | cut -f 1)
if [ $actualsize -ge $minimumsize ]; then
    echo -e "hi" 2> /dev/null > /dev/null
else
    exit
fi

}

jar_startup(){

if [ -e "server.jar" ]
then
    jabba_java
    java ${JAVA_ARGUMENT} -Xms256M -Xmx"$SERVER_MEMORY"M -Dterminal.jline=false -Dfile.encoding=UTF-8 -Dterminal.ansi=true -jar "$JAR"
fi 

}

go_env(){
  # Goenv
  
if [ -d "temp-folder" ]
then 
    echo -e "HI" 2> /dev/null > /dev/null
else
    mkdir -p temp-folder
fi
  
if [ -z "$GOLANG_VERSION" ] ; then
    echo -e "==============================="
    echo -e "Golang version can be 1.12.1 , 1.13.1 , 1.14.1 , 1.15.1 , custom"
    read -p "Golang: " GOLANG_VERSION_SELECT
    echo -e "==============================="
case $GOLANG_VERSION_SELECT in
1.12.1)
  echo -e "==============================="
  echo -e "Golang 1.12.1"
  GOLANG_VERSION="1.12.1"
  echo -e "==============================="
;;
1.13.1)
  echo -e "==============================="
  echo -e "Golang 1.13.1"
  GOLANG_VERSION="1.13.1"
  echo -e "==============================="
;;
1.14.1)
  echo -e "==============================="
  echo -e "Golang 1.14.1"
  GOLANG_VERSION="1.14.1"
  echo -e "==============================="
;;
1.15.1)
  echo -e "==============================="
  echo -e "Golang 3.8.7"
  GOLANG_VERSION="3.8.7"
  echo -e "==============================="  
;;
custom)
  echo -e "==============================="
  echo -e "Custom Golang version"
  read -p "Golang version: " GOLANG_VERSION
  echo -e "Using Golang $GOLANG_VERSION"
  echo -e "==============================="
;;
*)
  echo -e "hi" 2> /dev/null > /dev/null
;;
esac
fi

git clone https://github.com/syndbg/goenv.git ~/.goenv 2> /dev/null > /dev/null
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
export PATH="$GOROOT/bin:$PATH"
export PATH="$PATH:$GOPATH/bin"
eval "$(goenv init -)" 
export GOPATH="$HOME/go" >> ~/.bash_profile
export TMPDIR="$HOME/temp-folder"
     echo -e "Using Golang ${GOLANG_VERSION}"
     goenv install "${GOLANG_VERSION}" -s
     goenv global "${GOLANG_VERSION}"
     rm -rf temp-folder/go-build*
     clear
}

py_env(){
  # Pyenv

if [ -d "temp-folder" ]
then 
    echo -e "HI" 2> /dev/null > /dev/null
else
    mkdir -p temp-folder
fi

if [ -z "$PYTHON_VERSION" ] ; then
    echo -e "==============================="
    echo -e "Python version can be 3.5.10 , 3.6.12 , 3.7.9 , 3.8.7 , 3.9.1 , custom"
    read -p "Python: " PYTHON_VERSION_SELECT
    echo -e "==============================="
case $PYTHON_VERSION_SELECT in
3.5.10)
  echo -e "==============================="
  echo -e "Python 3.5.10"
  PYTHON_VERSION="3.5.10"
  echo -e "==============================="
;;
3.6.12)
  echo -e "==============================="
  echo -e "Python 3.6.12"
  PYTHON_VERSION="3.6.12"
  echo -e "==============================="
;;
3.7.9)
  echo -e "==============================="
  echo -e "Python 3.7.9"
  PYTHON_VERSION="3.7.9"
  echo -e "==============================="
;;
3.8.7)
  echo -e "==============================="
  echo -e "Python 3.8.7"
  PYTHON_VERSION="3.8.7"
  echo -e "==============================="  
;;
3.9.1)
  echo -e "==============================="
  echo -e "Python 3.9.1"
  PYTHON_VERSION="3.9.1"
  echo -e "==============================="
;;
custom)
  echo -e "==============================="
  echo -e "Custom python version"
  read -p "Python version: " PYTHON_VERSION
  echo -e "Using python $PYTHON_VERSION"
  echo -e "==============================="
;;
*)
  echo -e "hi" 2> /dev/null > /dev/null
;;
esac
fi

git clone https://github.com/pyenv/pyenv.git ~/.pyenv 2> /dev/null > /dev/null
export PYENV_ROOT="$HOME/.pyenv"
PATH="/home/container/.pyenv/bin:$PATH"
eval "$(pyenv init -)" 2> /dev/null > /dev/null
git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv 2> /dev/null > /dev/null
eval "$(pyenv virtualenv-init -)" 2> /dev/null > /dev/null
export TMPDIR="$HOME/temp-folder"
     echo -e "Using Python ${PYTHON_VERSION}"
     pyenv install "${PYTHON_VERSION}" -s
     pyenv global "${PYTHON_VERSION}"
     rm -rf temp-folder/python-build*
     clear
}

jabba_java(){
# Jabba

if [ -d "temp-folder" ]
then 
    echo -e "HI" 2> /dev/null > /dev/null
else
    mkdir -p temp-folder
fi

if [ -z "$JAVA_VERSION" ] ; then
    echo -e "==============================="
    echo -e "Java version can be java8 , java11 , latest , custom , default"
    read -p "Java: " JAVA_VERSION_SELECT
    echo -e "==============================="
case $JAVA_VERSION_SELECT in
java8)
  echo -e "==============================="
  echo -e "Java 8"
  JAVA_VERSION="adopt@1.8-0"
  echo -e "==============================="
;;
java11)
  echo -e "==============================="
  echo -e "Java 11"
  JAVA_VERSION="adopt@1.11-0"
  echo -e "==============================="
;;
latest)
  echo -e "==============================="
  echo -e "Java 15"
  JAVA_VERSION="adopt@1.15-0"
  echo -e "==============================="
;;
custom)
  echo -e "==============================="
  echo -e "Custom java version"
  read -p "Java version: " JAVA_VERSION
  echo -e "Using java $JAVA_VERSION"
  echo -e "==============================="
;;
default)
  echo -e "==============================="
  echo -e "Default java version"
  JAVA_VERSION="ignore-this"
  echo -e "==============================="
;;
*)
  echo -e "hi" 2> /dev/null > /dev/null
;;
esac
fi

curl -sL https://github.com/shyiko/jabba/raw/master/install.sh | JABBA_VERSION=0.11.2 bash && . ~/.jabba/jabba.sh 2> /dev/null > /dev/null
[ -s "$JABBA_HOME/jabba.sh" ] && source "$JABBA_HOME/jabba.sh" 2> /dev/null > /dev/null
export TMPDIR="$HOME/temp-folder"
     jabba install "${JAVA_VERSION}"
     jabba use "${JAVA_VERSION}"
     jabba alias default "${JAVA_VERSION}"
     echo -e "==============================="
     java -version
     echo -e "==============================="
}

nvm_nodejs(){
# NVM

if [ -e ".nvmrc" ]
then 
    echo -e "HI" 2> /dev/null > /dev/null
else
    touch .nvmrc
fi

if [ -d ".nvm" ]
then 
    echo -e "HI" 2> /dev/null > /dev/null
else
    mkdir -p .nvm
fi

if [ -d ".npm-global" ]
then 
    echo -e "HI" 2> /dev/null > /dev/null
else
    mkdir -p .npm-global
fi

if [ -d ".npm-global/lib" ]
then 
    echo -e "HI" 2> /dev/null > /dev/null
else
    mkdir -p .npm-global/lib
fi

if [ -d "temp-folder" ]
then 
    echo -e "HI" 2> /dev/null > /dev/null
else
    mkdir -p temp-folder
fi

if [ -z "$NODEJS_VERSION" ] ; then
    echo -e "==============================="
    echo -e "NodeJS version can be nodejs8 , nodejs10 , nodejs12 , nodejs14 , nodejs15 , custom"
    read -p "NodeJS: " NODEJS_VERSION_SELECT
    echo -e "==============================="
case $NODEJS_VERSION_SELECT in
nodejs8)
  echo -e "==============================="
  echo -e "NodeJS 8"
  NODEJS_VERSION="8"
  echo -e "==============================="
;;
nodejs10)
  echo -e "==============================="
  echo -e "NodeJS 10"
  NODEJS_VERSION="10"
  echo -e "==============================="
;;
nodejs12)
  echo -e "==============================="
  echo -e "NodeJS 12"
  NODEJS_VERSION="12"
  echo -e "==============================="
;;
nodejs14)
  echo -e "==============================="
  echo -e "NodeJS 14"
  NODEJS_VERSION="14"
  echo -e "==============================="  
;;
nodejs15)
  echo -e "==============================="
  echo -e "NodeJS 15"
  NODEJS_VERSION="15"
  echo -e "==============================="
;;
custom)
  echo -e "==============================="
  echo -e "Custom NodeJS version"
  read -p "NodeJS version: " NODEJS_VERSION
  echo -e "Using NodeJS $NODEJS_VERSION"
  echo -e "==============================="
;;
*)
  echo -e "hi" 2> /dev/null > /dev/null
;;
esac
fi

curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | NVM_DIR=/home/container/.nvm bash 2> /dev/null > /dev/null
NODE_PATH=$NVM_DIR/v$NODE_VERSION/lib/node_modules 
export NVM_DIR="/home/container/.nvm" 2> /dev/null > /dev/null
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm 2> /dev/null > /dev/null
     echo -e "==============================="
     echo -e "Installing NodeJS ${NODEJS_VERSION}" 
     nvm install "${NODEJS_VERSION}"
     nvm alias default "${NODEJS_VERSION}"
     echo -e "==============================="
     echo -e "==============================="
     echo -e "Upgrading NPM to latest version"
     npm install -g npm@latest --log-level warn
     echo -e "==============================="
     clear
 
}

case $GITHUB_ACTION in
pull)
  echo -e "==============================="
  echo -e "Setting git Variables"
  git config user.name "$GITHUB_USER"
  git config user.email "$GITHUB_EMAIL"
  echo -e "==============================="
  sleep 2s
  echo -e "==============================="
  echo -e "Pulling ${GITHUB_REPO}"
  git init
  git remote add origin $GITHUB_REPO
  git pull https://$GITHUB_USER:$GITHUB_OAUTH_TOKEN@$GITHUB_REPO
  echo -e "==============================="
;;
clone)
  echo -e "==============================="
  echo -e "Setting git Variables"
  git config user.name "$GITHUB_USER"
  git config user.email "$GITHUB_EMAIL"
  echo -e "==============================="
  sleep 2s
  echo -e "==============================="
  echo -e "Cloning ${GITHUB_REPO}"
  git clone https://$GITHUB_USER:$GITHUB_OAUTH_TOKEN@$GITHUB_REPO
  echo -e "==============================="
;;
*)
  echo -e "hi" 2> /dev/null > /dev/null
;;
esac

software_startup(){

if [ -e "cryofall.server" ]
then 
    chmod +x Binaries/Server/CryoFall_Server.dll
    echo -e "==============================="
    echo -e "To stop server type:"
    echo -e "stop 10 stopping server"
    echo -e "==============================="
    sleep 2s
    echo -e "==============================="
    echo -e "Starting CryoFall Server"
    echo -e "==============================="
    dotnet Binaries/Server/CryoFall_Server.dll loadOrNew
    exit
fi     

if [ -e "sinusbot" ]
then 
    chmod +x sinusbot
    echo -e "==============================="
    export OVERRIDE_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    echo -e "Sinus Bot Admin Password: ${OVERRIDE_PASSWORD}"
    echo -e "==============================="
    sleep 5s
    echo -e "==============================="
    echo -e "Starting SinusBot Server"
    echo -e "==============================="
    sed -i "s|^ListenPort.*|ListenPort = "$SERVER_PORT"|g" config.ini
    sed -i "s|^ListenHost.*|ListenHost = \"0.0.0.0\"|g" config.ini
   ./sinusbot --override-password="${OVERRIDE_PASSWORD}"
    exit
fi 

if [ -e "Impostor.Server" ]
then 
    chmod +x Impostor.Server
    echo -e "==============================="
    echo -e "Starting Impostor Server"
    echo -e "==============================="
    sed -i 's/\"PublicIp\":.*/\"PublicIp\": "0.0.0.0",/g' "config.json"
    sed -i 's/\"PublicPort\":.*/\"PublicPort\": '$SERVER_PORT',/g' "config.json"
    sed -i 's/\"ListenIp\":.*/\"ListenIp\": "0.0.0.0",/g' "config.json"
    sed -i 's/\"ListenPort\":.*/\"ListenPort\": '$SERVER_PORT'/g' "config.json"
    ./Impostor.Server
    exit
fi 

if [ -e "start_ts3-manager" ]
then 
    chmod +x start_ts3-manager
    echo -e "==============================="
    echo -e "Starting TS3 Manager"
    echo -e "==============================="
    ./start_ts3-manager -p ${SERVER_PORT}
    exit
fi

if [ -e "TeaSpeakServer" ]
then 
    chmod +x TeaSpeakServer
    echo -e "==============================="
    echo -e "TeaSpeak Query port"
    read -p "TeaSpeak Query port: " TEA_QUERY_PORT
    echo -e "==============================="
    sleep 1s
    echo -e "==============================="
    echo -e "TeaSpeak File Transfer Port"
    read -p "TeaSpeak File Transfer Port: " TEA_FILE_PORT
    echo -e "==============================="
    sleep 1s
    echo -e "==============================="
    echo -e "To stop server type shutdown now"
    echo -e "==============================="
    sleep 2s
    echo -e "==============================="
    echo -e "Starting TeaSpeak server"
    echo -e "File Transfer Port: ${TEA_FILE_PORT}"
    echo -e "Query Port: ${TEA_QUERY_PORT}"
    echo -e "==============================="
    LD_LIBRARY_PATH="./libs/"
    LD_PRELOAD="./libs/libjemalloc.so.2"
    ./TeaSpeakServer --property:binding.query.port=${TEA_QUERY_PORT} --property:binding.file.port=${TEA_FILE_PORT} --property:voice.default_port=${SERVER_PORT}
    exit
fi 

if [ -e "rage-mp-server" ]
then
    chmod +x rage-mp-server
    echo -e "==============================="
    let SECOND_PORT=${SERVER_PORT}+1
    echo -e "This server requires 2 ports to be added for the server. the main port and the next (port+1) as ports for the server."
    echo -e "Make sure you have following ports allocated:"
    echo -e "Game: ${SERVER_PORT}"
    echo -e "http: ${SECOND_PORT}"
    echo -e "==============================="
    sleep 2s
    echo -e "==============================="
    echo -e "Server Name: ${SERVER_NAME}"
    echo -e "Max Players: ${MAX_PLAYERS}"
    echo -e "Announce: ${ANNOUNCE}"
    echo -e "==============================="
    sleep 5s
    echo -e "==============================="
    echo -e "Starting Rage.MP Server"
    echo -e "==============================="
    sed -i 's/\"name\":.*/\"name\": "'${SERVER_NAME}'",/g' "conf.json"
    sed -i 's/\"bind\":.*/\"bind\": "0.0.0.0",/g' "conf.json"
    sed -i 's/\"maxplayers\":.*/\"maxplayers\": '${MAX_PLAYERS}',/g' "conf.json"
    sed -i 's/\"announce\":.*/\"announce\": '${ANNOUNCE}',/g' "conf.json"
    sed -i 's/\"port\":.*/\"port\": '${SERVER_PORT}',/g' "conf.json"
   ./rage-mp-server
    exit
fi

if [ -e "./bin/minetestserver" ]
then 
    chmod +x bin/minetestserver
    echo -e "==============================="
    echo -e "Starting Minetest Server"
    echo -e "==============================="
    ./bin/minetestserver --port ${SERVER_PORT}
    exit
fi

if [ -e "fabric-server-launch.jar" ]
then
    FABRIC="fabric-server-launch.jar"
    echo -e "==============================="
    echo -e "Starting Fabric Server"
    echo -e "==============================="
    JAR="fabric-server-launch.jar"
    server_jar_size_check
    java -Xms256M -Xmx"$SERVER_MEMORY"M -Dterminal.jline=false -Dfile.encoding=UTF-8 -Dterminal.ansi=true -jar "$JAR"
   exit
fi

if [ -e "mindustry-server.jar" ]
then
    sleep 2s
    echo -e "============NOTE============"
    echo -e "| Java11 Required"
    echo -e "============NOTE============"
    sleep 1s
    echo -e "==============================="
    echo -e "Server Name:"
    read -p "Name: " MINDUSTRY_SERVER_NAME
    echo -e "==============================="
    sleep 1s
    echo -e "==============================="
    echo -e "Server Map: ${MAPNAME}"
    echo -e "Server Port: ${SERVER_PORT}"
    echo -e "Server Name: ${MINDUSTRY_SERVER_NAME}"
    echo -e "==============================="
    sleep 1s
    echo -e "==============================="
    echo -e "Starting Mindustry Server"
    echo -e "==============================="
    jabba_java
    JAR=mindustry-server.jar

java -Xms128M  -Xmx"$SERVER_MEMORY"M -jar "$JAR" config port ${SERVER_PORT},config name ${MINDUSTRY_SERVER_NAME},host ${MAPNAME}

    exit
fi

if [ -e "ts3server" ]
then

if [ -z "$FILE_TRANSFER" ] ; then
    echo -e "File transfer port variable can't be empty"
    exit
else
    echo -e "hi" 2> /dev/null > /dev/null
fi

     chmod +x ts3server
     echo -e "==============================="
     echo -e "File Transfer Port: ${FILE_TRANSFER}"
     echo -e "==============================="
     sleep 5s 
     echo -e "==============================="
     echo -e "Starting TeamSpeak3 Server"
     echo -e "==============================="
    ./ts3server default_voice_port=${SERVER_PORT} query_port=${SERVER_PORT} filetransfer_ip=0.0.0.0 filetransfer_port=${FILE_TRANSFER} license_accepted=1
    exit
fi

if [ -e "PocketMine-MP.phar" ]
then 
    chmod +x PocketMine-MP.phar
    chmod -R u+x bin
    echo -e "==============================="
    echo -e "Starting PocketMineMP Server"
    echo -e "==============================="
    ./bin/php7/bin/php ./PocketMine-MP.phar --no-wizard --disable-ansi
    exit
fi

if [ -e "minios3.server" ]
then 
    
if [ -e "minio.sh" ]
then
    wget -N https://github.com//parkervcp/eggs/raw/master/storage/minio/minio.sh 2> /dev/null > /dev/null
    chmod +x minio.sh
else
    wget -N https://github.com//parkervcp/eggs/raw/master/storage/minio/minio.sh 2> /dev/null > /dev/null
    chmod +x minio.sh 
fi

if [ -e "minio" ]
then
    wget -N https://dl.min.io/server/minio/release/linux-amd64/minio 2> /dev/null > /dev/null
    chmod +x minio 
else
    wget -N https://dl.min.io/server/minio/release/linux-amd64/minio 2> /dev/null > /dev/null
    chmod +x minio 
fi

    rm -rf .wget-hsts
    echo -e "Startup type can be normal,rotate,update"
    read -p "Startup type: " MINIO_STARTUP_TYPE
    sleep 2s
    echo -e "==============================="
    echo -e "Startup type: $MINIO_STARTUP_TYPE"
    echo -e "==============================="
    sleep 2s
    echo -e "==============================="
    echo -e "Starting Minio S3 Server"
    echo -e "==============================="
    ./minio.sh
    exit
fi

if [ -e "Altay.phar" ]
then 
    chmod +x Altay.phar
    chmod -R u+x bin
    echo -e "==============================="
    echo -e "Starting Altay Server"
    echo -e "==============================="
    ./bin/php7/bin/php ./Altay.phar --no-wizard --disable-ansi
    exit
fi

if [ -e "bedrock_server" ]
then 
    chmod +x bedrock_server
    echo -e "==============================="
    echo -e "Starting Vanilla Bedrock Server"
    echo -e "==============================="
    LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu ./bedrock_server
    exit
fi

if [ -e "tModLoaderServer" ]
then 
    chmod +x tModLoaderServer
    echo -e "==============================="
    echo -e "Starting tModLoaderServer(Terraria) server"
    echo -e "==============================="
    ./tModLoaderServer -ip 0.0.0.0 -port ${SERVER_PORT} -savedirectory ~/ -tmlsavedirectory ~/saves -modpath ~/mods
    exit
fi

if [ -e "TerrariaServer.exe" ]
then 
    chmod +x TerrariaServer.exe
    echo -e "==============================="
    echo -e "Starting tshock(Terraria) server"
    echo -e "==============================="
    mono-sgen TerrariaServer.exe -ip 0.0.0.0 -port ${SERVER_PORT}
    exit
fi

if [ -e "samp-server.exe" ]
then 
    chmod +x samp-server.exe
    echo -e "==============================="
    echo -e "Starting SA:MP(Wine) Server"
    echo -e "==============================="
    wine64 ./samp-server.exe
    exit
fi

if [ -e "samp03svr" ]
then 
    chmod +x samp03svr
    echo -e "==============================="
    echo -e "Starting SA:MP Server"
    echo -e "==============================="
    ./samp03svr
    exit
fi

if [ -e "mta-server64" ]
then 
    chmod +x mta-server64
    echo -e "==============================="
    let SECOND_PORT=${SERVER_PORT}+2
    let THREE_PORT=${SERVER_PORT}+123
    echo -e "Make sure you have following ports allocated:"
    echo -e "Game: ${SERVER_PORT}"
    echo -e "http: ${SECOND_PORT}"
    echo -e "ASE: ${THREE_PORT}"
    echo -e "==============================="
    sleep 2s 
    echo -e "HTTP port needs to be the ${SERVER_PORT} +3:"
    read -p "HTTP port: " HTTP_PORT
    echo -e "The ASE port is required to announce the server to the mta server list, this port is always the Game port ${SERVER_PORT} +123"
    echo -e "ASE port:"
    read -p "ASE port: " ASE_PORT
    sleep 5s
    echo -e "==============================="
    echo -e "HTTP Port: ${HTTP_PORT}"
    echo -e "ASE Port: ${ASE_PORT}"
    echo -e "==============================="
    sleep 5s
    echo -e "==============================="
    echo -e "Starting MTA:SA Server"
    echo -e "==============================="
    ./mta-server64 --port ${SERVER_PORT} --httpport ${HTTP_PORT} -n
    exit
fi

if [ -e "Unturned_Headless.x86_64" ]
then 
    echo -e "==============================="
    echo -e "Starting Unturned Server"
    echo -e "==============================="
    sleep 2s
    echo -e "==============================="
    let SECOND_PORT=${SERVER_PORT}+1
    let THREE_PORT=${SERVER_PORT}+2
    echo -e "Make sure you have following ports allocated:"
    echo -e "Game: ${SERVER_PORT}"
    echo -e "Game +1: ${SECOND_PORT}"
    echo -e "Game +2: ${THREE_PORT}"
    echo -e "==============================="
    sleep 2s 
    echo -e "==============================="
    echo -e "To stop server type shutdown"
    echo -e "==============================="
    LD_LIBRARY_PATH=./Unturned_Headless_Data/Plugins/x86_64/
    chmod +x Unturned_Headless.x86_64
    ./Unturned_Headless.x86_64 -batchmode -nographics -bind 0.0.0.0 -port ${SERVER_PORT}
    exit
fi

if [ -e "proxy-linux-amd64" ]
then 
    chmod +x proxy-linux-amd64
    echo -e "==============================="
    echo -e "Starting Lilypad Server"
    echo -e "==============================="
    ./proxy-linux-amd64
    exit
fi

if [ -e "gtac.server" ]
then 
    chmod +x Server
    echo -e "==============================="
    echo -e "Server Port: ${SERVER_PORT}"
    echo -e "HTTP Port: ${SERVER_PORT}"
    echo -e "==============================="
    sleep 1s
    echo -e "==============================="
    echo -e "To stop server type exit"
    echo -e "==============================="
    sleep 1s
    echo -e "==============================="
    echo -e "Starting Grand Theft Auto connected Server"
    echo -e "==============================="
    ./Server
    exit
fi

if [ -e "bombsquad_server" ]
then 
    chmod +x bombsquad_server
    py_env
    echo -e "==============================="
    echo -e "Starting BombSquad Server"
    echo -e "==============================="
    ./bombsquad_server
    exit
fi

if [ -e "Cuberite" ]
then 
    chmod +x Cuberite
    echo -e "==============================="
    echo -e "Starting Cuberite Server"
    echo -e "==============================="
    ./Cuberite
    exit
fi

if [ -e "oragono" ]
then 
    echo -e "==============================="
    echo -e "Starting Oragono Server"
    echo -e "==============================="
    chmod +x oragono
    sleep 1s
    echo -e "==============================="
    echo -e "Do you want to run oragono_genpasswd command?"
    echo -e "Type yes to execute"
    read -p "Oragono: " ORAGONO_GEN
    echo -e "==============================="

case "$ORAGONO_GEN" in
yes)
  oragono genpasswd
;;
*)
  echo -e "hi" 2> /dev/null > /dev/null
;;
esac

    ./oragono run --conf /home/container/ircd.yaml
    exit
fi

if [ -e "nginx.server" ]
then
    echo -e "==============================="
    echo -e "Updating PHP extensions"
    wget https://github.com/devil38/scripts/blob/master/nginx/debian-nginx.zip?raw=true 2> /dev/null > /dev/null
    unzip -o debian-nginx.zip?raw=true 'php/*' -d $HOME 2> /dev/null > /dev/null
    rm -rf debian-nginx.zip?raw=true .wget-hsts
    echo -e "==============================="
    sleep 1s
    echo -e "==============================="
    echo "Starting PHP-FPM..."
    /usr/sbin/php-fpm8.0 --fpm-config /home/container/php/8.0/fpm/php-fpm.conf
    echo -e "==============================="
    sleep 1s
    echo -e "==============================="
    echo -e "Starting Nginx webserver"
    sed -i "s|listen.*|listen "$SERVER_PORT";|g" "nginx/sites-available/default.conf"
    echo -e "If process has not crashed your webserver is online. [ Custom domains are NOT available ]"
    /usr/sbin/nginx -c /home/container/nginx/nginx.conf
    echo -e "==============================="
    exit
fi

if [ -e "backup.me" ]
then 
    echo -e "==============================="
    echo -e "Make sure you have enough Disk Storage"
    echo -e "==============================="
    sleep 5s
    zip -r "backup-$(date +"%Y-%m-%d %H-%M-%S").zip" *
    echo -e "==============================="
    echo -e "Backup Finished"
    echo -e "Download Backup Archive from File Manager or SFTP"
    echo -e "==============================="
    sleep 5s
    rm -rf backup.me
    exit
fi

if [ -e "hlds_run" ]
then
    output "Server map:"
  output "Default is de_dust2"
  read -p "Map: " SRCDS_MAP
  output "Max players:"
  output "Number must be from 2 to 32"
  read -p "Players: " CS_MAX_PLAYERS
  output "Pingboost:"
  output "Allowed values for pingboost is 1/2/3"
  read -p "Pingboost: " PING_BOOST
    if ((CS_MAX_PLAYERS >= 2 && CS_MAX_PLAYERS <= 32));
    then
    output "HI" 2> /dev/null > /dev/null
    else
    output "Number out of range"
    sleep 1h
    exit 
    fi
     if ((PING_BOOST >= 1 && PING_BOOST <= 3));
     then
      output "HI" 2> /dev/null > /dev/null
     else
       output "Number out of range"
     exit
     fi
        sleep 5s
        output "==============================="
        output "Server Map: ${SRCDS_MAP}"
        output "Max players: ${CS_MAX_PLAYERS}"
        output "Ping Boost: ${PING_BOOST}"
        output "==============================="
        sleep 5s
        output "==============================="
        output "Starting CS 1.6 Server"
        output "==============================="
        output "Would you like to add the -insecure parameter? This means the server will start without the technology of Valve Anti-Cheat:\nAccepted values is yes/no"
        read -p "VAC: " DISABLE_VAC
    if [[ "$DISABLE_VAC" == "yes" ]]
    then 
     output "Using -insecure parameter"
    ./hlds_run -console -game cstrike -port ${SERVER_PORT} -maxplayers ${CS_MAX_PLAYERS} +map ${SRCDS_MAP} +ip 0.0.0.0 -strictportbind -insecure -pingboost ${PING_BOOST} -norestart
    elif [[ "$DISABLE_VAC" == "no" ]]
    then
     output "Not using -insecure parameter"
     ./hlds_run -console -game cstrike -port ${SERVER_PORT} -maxplayers ${CS_MAX_PLAYERS} +map ${SRCDS_MAP} +ip 0.0.0.0 -strictportbind -pingboost ${PING_BOOST} -norestart
    else
     output "Invalid option"
     exit
    fi
  exit
fi

if [ -e "database.server" ]
then
    output "Select"
    PS3='Select: '
    options=("Redis" "MongoDB" "MariaDB" "RethinkDB" "Exit")
    select opt in "${options[@]}"
    do
        case $opt in            		
            "Redis")
                echo -e "==============================="
                export REDIS_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
                echo -e "Redis Admin Account Password: ${REDIS_PASSWORD}"
                echo -e "==============================="
                sleep 5s
                echo -e "==============================="
                echo -e "Starting Redis Server"
                echo -e "==============================="
                redis-server --bind 0.0.0.0 --port ${SERVER_PORT} --requirepass ${REDIS_PASSWORD} --maxmemory {$SERVER_MEMORY}mb --daemonize yes && redis-cli -p ${SERVER_PORT} -a ${REDIS_PASSWORD} && redis-cli -p ${SERVER_PORT} -a ${REDIS_PASSWORD} shutdown save
                exit
				break   
                ;;               		
            "MongoDB")
                echo -e "==============================="
                echo -e "To stop MongoDB server execute following commands:"
                echo -e "use admin"
                echo -e "db.shutdownServer()"
                echo -e "quit()"
                echo -e "==============================="
                sleep 5s
                echo -e "==============================="
                echo -e "Starting MongoDB Server"
                echo -e "==============================="
if [ -e "m" ]
then
    curl -s https://raw.githubusercontent.com/aheckmann/m/master/bin/m -o m && chmod +x ./m
else
    curl -s https://raw.githubusercontent.com/aheckmann/m/master/bin/m -o m && chmod +x ./m 
fi
                mkdir -p temp-folder && mkdir -p mongodb/data && mkdir -p mongodb/logs && mkdir -p mongodb/bin
                export M_PREFIX="/home/container/mongodb"
                export TMPDIR="$HOME/temp-folder"
                yes | ./m tools stable
                yes | ./m stable
                ./m use stable --fork --logpath mongodb/logs/mongodb.log --dbpath mongodb/data --bind_ip 0.0.0.0 --port ${SERVER_PORT}
                ./m shell stable --port ${SERVER_PORT} --norc
                exit
				break   
                ;;          		
            "MariaDB")
                echo -e "==============================="
                echo -e "Starting MariaDB Server"
                echo -e "To stop server" 
                echo -e "Type shutdown; exit;"
                echo -e "==============================="
                sed -i "s|^bind-address.*|bind-address=0.0.0.0|g" .my.cnf
                sed -i "s|^port.*|port = "$SERVER_PORT"|g" .my.cnf
                { /usr/sbin/mysqld & } && sleep 5 && mysql -u root
                exit
				break   
                ;;            		
            "RethinkDB")
                mkdir -p rethinkdb             
                echo -e "==============================="
                echo -e "Driver Port: ${SERVER_PORT}"
                echo -e "HTTP Port: ${HTTP_PORT}"
                echo -e "Cluster Port: ${CLUSTER_PORT}"
                export ADMIN_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
                echo -e "Admin Account Password: ${ADMIN_PASSWORD}"
                echo -e "==============================="
                sleep 5s
                echo -e "==============================="
                echo -e "Starting RethinkDB Server"
                echo -e "==============================="
                rethinkdb -d rethinkdb --bind 0.0.0.0 --bind-http 0.0.0.0 --bind-cluster 0.0.0.0 --bind-driver 0.0.0.0 --http-port ${HTTP_PORT} --driver-port ${SERVER_PORT} --initial-password ${ADMIN_PASSWORD} --cluster-port ${CLUSTER_PORT} --log-file rethink.log --cache-size auto
                exit
				break                 		           
                ;;                                                                                                                                                          
            "Exit")
                echo -e "You selected $REPLY) $opt"
				echo -e "Exit requested"
				exit
                ;;				
            *) echo -e "invalid option $REPLY";;            
        esac
    done
fi

if [ -e "discord.bot" ]
then
    PS3='Select: '
    options=("Start NodeJS Server via pm2" "Start NodeJS Server" "Start Python Server via pm2" "Start Python Server" "Compile TypeScript" "Install Python package" "Install NodeJS package" "Install Global NodeJS package" "Uninstall NodeJS package" "Install NodeJS packages from package.json" "Install Python packages from requirements.txt" "Install PHP Discord Dependency" "Start PHP Discord Bot" "Install Lua Discord Dependency" "Start Lua Discord Bot" "Start Lua Discord Bot via pm2" "Run npm start via pm2" "Run npm start" "Install Golang package" "Install Golang Discord Bot Dependency" "Start .NET DLL file/application" "Start .NET DLL file/application via pm2" "Start Golang Discord Bot" "Start Golang Discord Bot via pm2" "Start Raw TypeScript Discord Bot" "Start Raw CofeeScript Discord Bot" "Compile Raw CofeeScript Discord Bot" "Exit")
    select opt in "${options[@]}"
    do
        case $opt in            		
            "Start NodeJS Server via pm2")                
                echo -e "Path to main file"
                read -p "File: " GENERIC_BOT_FILE
                nvm_nodejs
                echo -e "==============================="
                echo -e "Installing CoffeeScript, PM2 and TypeScript"
                npm install -g coffeescript pm2 typescript --log-level warn
                echo -e "==============================="
                sleep 2s
                pm2-runtime start "${GENERIC_BOT_FILE}" --interpreter=node "${PM2_ARGUMENTS}"
                exit
				break   
                ;;               		
            "Start NodeJS Server")
                echo -e "Path to main file"
                read -p "File: " GENERIC_BOT_FILE
                nvm_nodejs
                echo -e "==============================="
                echo -e "Installing CoffeeScript, PM2 and TypeScript"
                npm install -g coffeescript pm2 typescript --log-level warn
                echo -e "==============================="
                sleep 2s                                
                node ${GENERIC_BOT_FILE}
                exit
				break   
                ;;          		
            "Start Python Server via pm2")
                echo -e "Path to main file:"
                read -p "File: " GENERIC_BOT_FILE
                py_env
                NODEJS_VERSION="10"
                nvm_nodejs
                echo -e "==============================="
                echo -e "Installing PM2"
                npm install -g pm2 --log-level warn
                echo -e "==============================="
                sleep 2s                
                pm2-runtime start "${GENERIC_BOT_FILE}" --interpreter=python "${PM2_ARGUMENTS}"
                exit
				break   
                ;;            		
            "Start Python Server")
                echo -e "Path to main file:"
                read -p "File: " GENERIC_BOT_FILE
                py_env
                python "${GENERIC_BOT_FILE}"
                exit
				break   
                ;;               		             
            "Compile TypeScript")
			    echo -e "Compile folder:"
                read -p "Folder: " COMPILE_FOLDER
                nvm_nodejs
                echo -e "==============================="
                echo -e "Installing TypeScript"
                npm install -g typescript --log-level warn
                echo -e "==============================="
                sleep 2s                
                tsc --outDir ${COMPILE_FOLDER} --strictPropertyInitialization false
                exit
				break   
                ;;     
            "Install Python package")
			    echo -e "Package:"
                read -p "Package: " GENERIC_PACKAGE
                py_env
                pyenv exec pip install ${GENERIC_PACKAGE} --user
                exit
				break   
                ;;                                                                                     
            "Install NodeJS package")
			    echo -e "Package:"
                read -p "Package: " GENERIC_PACKAGE
                nvm_nodejs
                npm install --unsafe-perm ${GENERIC_PACKAGE} --log-level warn
                exit
				break   
                ;;                                                                                   
            "Install Global NodeJS package")
			    echo -e "Package:"
                read -p "Package: " GENERIC_PACKAGE
                nvm_nodejs
                npm install -g ${GENERIC_PACKAGE} --log-level warn
                exit
				break   
                ;;                                                                                     
            "Uninstall NodeJS package")
			    echo -e "Package:"
                read -p "Package: " GENERIC_PACKAGE
                nvm_nodejs
                npm uninstall ${GENERIC_PACKAGE}
                exit
				break   
                ;;        
            "Install NodeJS packages from package.json")
                nvm_nodejs
	  	 	    npm install --unsafe-perm
                exit
				break   
                ;;
            "Install Python packages from requirements.txt")
                py_env
	  	 	 pyenv exec pip install -r requirements.txt --user
                exit
				break   
                ;;
            "Install PHP Discord Dependency")
	  	 	    composer require team-reflex/discord-php
                exit
				break 
                ;;
            "Start PHP Discord Bot")
	  	 	    echo -e "Path to main file"
                read -p "File: " GENERIC_BOT_FILE
                php ${GENERIC_BOT_FILE}
                exit
				break   
                ;;              
            "Install Lua Discord Dependency")
	  	 	    lit install SinisterRectus/discordia
                exit
				break 
                ;;
            "Start Lua Discord Bot")
	  	 	    echo -e "Path to main file"
                read -p "File: " GENERIC_BOT_FILE
                luvit ${GENERIC_BOT_FILE}
                exit
				break   
                ;;              
            "Start Lua Discord Bot via pm2")
	  	 	    echo -e "Path to main file"
                read -p "File: " GENERIC_BOT_FILE
                NODEJS_VERSION="10"
                nvm_nodejs
                echo -e "==============================="
                echo -e "Installing PM2"
                npm install -g pm2 --log-level warn
                echo -e "==============================="
                sleep 2s                
                pm2-runtime start "luvit "${GENERIC_BOT_FILE}""
                exit
				break   
                ;;
            "Run npm start via pm2")
	  	 	    nvm_nodejs
                echo -e "==============================="
                echo -e "Installing CoffeeScript, PM2 and TypeScript"
                npm install -g coffeescript pm2 typescript --log-level warn
                echo -e "==============================="
                sleep 2s                   
                pm2-runtime start npm -- start "${PM2_ARGUMENTS}"
                exit
				break   
                ;;               
            "Run npm start")
	  	        nvm_nodejs
                echo -e "==============================="
                echo -e "Installing CoffeeScript, PM2 and TypeScript"
                npm install -g coffeescript pm2 typescript --log-level warn
                echo -e "==============================="
                sleep 2s  
                npm start
                exit
				break   
                ;; 
            "Install Golang package")
                echo -e "Package"
                read -p "Package: " GENERIC_PACKAGE 
                go_env
                go get -u "${GENERIC_PACKAGE}"
                exit
				break   
                ;; 
            "Install Golang Discord Bot Dependency")
	  	 	    go_env
                go get github.com/bwmarrin/discordgo
                exit
				break   
                ;; 
            "Start .NET DLL file/application")
	  	      echo -e "Path to main file:"
                read -p "File: " GENERIC_BOT_FILE 
                dotnet "${GENERIC_BOT_FILE}"
                exit
				break   
                ;; 
            "Start .NET DLL file/application via pm2")
	  	 	    echo -e "Path to main file:"
                read -p "File: " GENERIC_BOT_FILE
                NODEJS_VERSION="10"
                nvm_nodejs
                echo -e "==============================="
                echo -e "Installing PM2"
                npm install -g pm2 --log-level warn
                echo -e "==============================="
                sleep 2s                
                pm2-runtime start "dotnet "${GENERIC_BOT_FILE}""
                exit
				break   
                ;; 
            "Start Golang Discord Bot")
	  	 	    echo -e "Path to main file:"
                read -p "File: " GENERIC_BOT_FILE
                go_env
                ./${GENERIC_BOT_FILE}
                exit
				break   
                ;; 
            "Start Golang Discord Bot via pm2")
	  	 	    echo -e "Path to main file:"
                read -p "File: " GENERIC_BOT_FILE   
                go_env
                NODEJS_VERSION="10"
                nvm_nodejs
                echo -e "==============================="
                echo -e "Installing PM2"
                npm install -g pm2 --log-level warn
                echo -e "==============================="
                sleep 2s                
                pm2-runtime start ./${GENERIC_BOT_FILE}  ${PM2_ARGUMENTS}
                exit
				break   
                ;;
            "Start Raw TypeScript Discord Bot")
	  	 	    echo -e "Path to main file:"
                read -p "File: " GENERIC_BOT_FILE   
                nvm_nodejs
                echo -e "==============================="
                echo -e "Installing ts-node, TypeScript"
                npm install -g typescript ts-node --log-level warn
                echo -e "==============================="
                sleep 2s                
                ts-node "${GENERIC_BOT_FILE}"
                exit
				break   
                ;;
            "Start Raw CofeeScript Discord Bot")
	  	 	    echo -e "Path to main file:"
                read -p "File: " GENERIC_BOT_FILE   
                nvm_nodejs
                echo -e "==============================="
                echo -e "Installing CoffeeScript"
                npm install -g coffeescript --log-level warn
                echo -e "==============================="
                sleep 2s               
                coffee "${GENERIC_BOT_FILE}"
                exit
				break   
                ;;
            "Compile Raw CofeeScript Discord Bot")
                echo -e "Path to main file:"
                read -p "File: " COFEESCRIPT_COMPILE_FILE
                nvm_nodejs
                echo -e "==============================="
                echo -e "Installing CoffeeScript"
                npm install -g coffeescript --log-level warn
                echo -e "==============================="
                sleep 2s               
                coffee -c "${COFEESCRIPT_COMPILE_FILE}"
                exit
				break   
                ;;                                                                                                                                                                                                            
            "Exit")
                echo -e "You selected $REPLY) $opt"
				echo -e "Exit requested"
				exit
                ;;				
            *) echo -e "invalid option $REPLY";;            
        esac
    done
fi

}   


warn(){
    echo -e '\e[31m'$1'\e[0m';
}

startup(){
    
    output "==========Hardware Information=========="
    free -m | awk 'NR==2{printf "Memory Usage: %s/%s MB (%.2f%%)\n", $3,$2,$3*100/$2 }'
    echo -e "SWAP Size: $(awk '/SwapTotal/ { printf "%.3f \n", $2/1024}' /proc/meminfo)MB"
    echo -e "CPU:$(cat /proc/cpuinfo | grep 'model name' | cut -d: -f2 | awk 'NR==1') $(getconf _NPROCESSORS_ONLN) Cores"
    top -bn1 | grep load | awk '{printf "CPU Load: %.2f\n", $(NF-2)}' 
    df -h | awk '$NF=="/"{printf "Disk Usage: %d/%dGB (%s)\n", $3,$2,$5}'
    output "==========Hardware Information=========="
    output ""
	
    output "==============================="
    output "| RAM: $SERVER_MEMORY MB"
    output "| IP: $SERVER_IP:$SERVER_PORT"
    output "| Server UUID: $(hostname)"
    output "==============================="
    output ""
    sleep 5s

    output "==========Changelog=========="
    output "| 14.03.2021 GeyserMC install fixed"
    output "| 01.04.2021 Impostor install fixed"
    output "=============================="
    output ""
    output "==============================="
    output "| Create backup.me file to backup server"
    output "| Don't forget to backup server regularly"
    output "==============================="
    output ""
    clear
    
    output "==============================="
    output "| https://multi-egg.nyasky.cf/egg.json"

cat << "EOF"
              _ _   _         __           
  /\/\  _   _| | |_(_)       /__\_ _  __ _ 
 /    \| | | | | __| |_____ /_\/ _` |/ _` |
/ /\/\ \ |_| | | |_| |_____//_| (_| | (_| |
\/    \/\__,_|_|\__|_|     \__/\__, |\__, |
                               |___/ |___/                                 
EOF

    output "| Starting...."
    output "==============================="
    output ""

}

#Execution
startup
software_startup

if [ -e "server.jar" ]
then
    JAR="server.jar"
    output "Found "$JAR
    server_jar_size_check

else
    JAR=""
    warn "Could not find server.jar"
fi

if [ "$JAR" = "" ]
then
    echo -e "Please choose the number and press enter or send, and it will download it for you"
    PS3='Select: '
    options=("Minecraft Java" "Minecraft Pocket/Bedrock" "GTA" "Voice" "Discord Bot Hosting" "Terraria" "Proxy" "Database" "Others" "Exit")
    select opt in "${options[@]}"
    do
        case $opt in
            "Minecraft Java")
                echo -e "You selected $REPLY) $opt"
                 PS3='Server type: '
    options=("PaperMC" "Purpur" "Akarin" "Fabric" "VanillaCord" "Mohist" "Uranium" "Vanilla" "Vanilla Snapshot" "Tuinity" "Magma" "Forge" "Cuberite" "SpongeVanilla" "SpongeForge" "Exit")
    select opt in "${options[@]}"
    do
        case $opt in            		
            "PaperMC")
                echo -e "You selected $REPLY) $opt"
                SERVER_JARFILE=server.jar
              
BUILD_NUMBER=latest
echo -e "What version would you like to install?"
echo -e Supported versions: $(curl  --silent https://papermc.io/api/v1/paper | jq  -r '{"versions"} | .versions | .[]')
read -p "Version: " MINECRAFT_VERSION

curl -o ${SERVER_JARFILE} https://papermc.io/api/v1/paper/${MINECRAFT_VERSION}/${BUILD_NUMBER}/download

if [ ! -f server.properties ]; then
    echo -e "Downloading MC server.properties"
    curl -o server.properties https://raw.githubusercontent.com/flaxeneel2/pterodactyl-optimized-paper-egg/main/server.properties
fi

if [ ! -f paper.yml ]; then
    echo -e "Downloading MC paper.yml"
    curl -o paper.yml https://raw.githubusercontent.com/flaxeneel2/pterodactyl-optimized-paper-egg/main/paper.yml
fi

if [ ! -f spigot.yml ]; then
    echo -e "Downloading MC spigot.yml"
    curl -o spigot.yml https://raw.githubusercontent.com/flaxeneel2/pterodactyl-optimized-paper-egg/main/spigot.yml
fi

if [ ! -f bukkit.yml ]; then
    echo -e "Downloading MC bukkit.yml"
    curl -o bukkit.yml https://raw.githubusercontent.com/flaxeneel2/pterodactyl-optimized-paper-egg/main/bukkit.yml
fi

				break 
                ;;                                                                    
            "Purpur")
                echo -e "You selected $REPLY) $opt"
                jabba_java     
                    echo -e "You choose Purpur! What version would you like to install?"
                 PS3='Purpur: '
    options=("1.14.x" "1.15" "1.15.1" "1.15.2" "1.16.1" "1.16.2" "Exit")
    select opt in "${options[@]}"
    do
        case $opt in            		
            "1.14.x")
                echo -e "You selected $REPLY) $opt"
                curl --silent https://ci.pl3x.net/job/Purpur/337/artifact/final/purpurclip-337.jar -o server.jar  
				break   
                ;;                         
            "1.15")
                echo -e "You selected $REPLY) $opt"
		    	curl --silent https://ci.pl3x.net/job/Purpur/346/artifact/target/purpur-346.jar -o server.jar  
				break   
                ;;                             
            "1.15.1")
                echo -e "You selected $REPLY) $opt"
			curl --https://ci.pl3x.net/job/Purpur/397/artifact/target/purpur-397.jar -o server.jar  
				break   
                ;;                                             
            "1.15.2")
                echo -e "You selected $REPLY) $opt"
			curl --silent https://ci.pl3x.net/job/Purpur/606/artifact/final/purpurclip-606.jar -o server.jar  
				break   
                ;;        
            "1.16.1")
                echo -e "You selected $REPLY) $opt"
			 curl --silent https://ci.pl3x.net/job/Purpur/710/artifact/final/purpurclip-710.jar -o server.jar  
				break   
                ;;                         
            "1.16.2")
                echo -e "You selected $REPLY) $opt"
                JAR_ENDPOINT=$(curl https://ci.pl3x.net/job/Purpur/lastStableBuild/artifact/final/ | grep -Eo 'href="[^\"]+"' | grep -vE "view|fingerprint" | grep "purpurclip.jar" | sed -n 's/.*href="\([^"]*\).*/\1/p')

JAR_LINK=https://ci.pl3x.net/job/Purpur/lastStableBuild/artifact/final/${JAR_ENDPOINT}
                    curl ${JAR_LINK} -o server.jar
                #curl --silent https://ci.pl3x.net/job/Purpur/lastStableBuild/artifact/final/purpurclip.jar -o server.jar
				break
                ;;        
            "Exit")
                echo -e "You selected $REPLY) $opt"
				echo -e "Exit requested"
				exit
                ;;				
            *) echo -e "invalid option $REPLY";;            
        esac
    done

if [ ! -f server.properties ]; then
    echo -e "Downloading MC server.properties"
    curl -o server.properties https://raw.githubusercontent.com/flaxeneel2/pterodactyl-optimized-paper-egg/main/server.properties
fi

if [ ! -f paper.yml ]; then
    echo -e "Downloading MC paper.yml"
    curl -o paper.yml https://raw.githubusercontent.com/flaxeneel2/pterodactyl-optimized-paper-egg/main/paper.yml
fi

if [ ! -f spigot.yml ]; then
    echo -e "Downloading MC spigot.yml"
    curl -o spigot.yml https://raw.githubusercontent.com/flaxeneel2/pterodactyl-optimized-paper-egg/main/spigot.yml
fi

if [ ! -f bukkit.yml ]; then
    echo -e "Downloading MC bukkit.yml"
    curl -o bukkit.yml https://raw.githubusercontent.com/flaxeneel2/pterodactyl-optimized-paper-egg/main/bukkit.yml
fi

				break   
                ;;                       		
            "Akarin")
                echo -e "You selected $REPLY) $opt"     
                    echo -e "You choose Akarin! What version would you like to install?"
                 PS3='Akarin: '
    options=("1.12.2" "1.13.2" "1.14.4" "1.15.2" "1.16.1" "1.16.2" "Exit")
    select opt in "${options[@]}"
    do
        case $opt in            		
            "1.12.2")
                echo -e "You selected $REPLY) $opt"
                echo -e "Soon"        
				break   
                ;;                         
            "1.13.2")
                echo -e "You selected $REPLY) $opt"
			JAR_ENDPOINT=$(curl http://josephworks.ddns.net:8080/job/Akarin/job/1.13.2/lastSuccessfulBuild/artifact/ | grep -Eo 'href="[^\"]+"' | grep -vE "view|fingerprint" | grep "akarin-1.13.2.jar" | sed -n 's/.*href="\([^"]*\).*/\1/p')

JAR_LINK=http://josephworks.ddns.net:8080/job/Akarin/job/1.13.2/lastSuccessfulBuild/artifact/${JAR_ENDPOINT}
                    curl ${JAR_LINK} -o server.jar
				break   
                ;;                             
            "1.14.4")
                echo -e "You selected $REPLY) $opt"
			JAR_ENDPOINT=$(curl http://josephworks.ddns.net:8080/job/Akarin/job/1.14.4/lastSuccessfulBuild/artifact/ | grep -Eo 'href="[^\"]+"' | grep -vE "view|fingerprint" | grep "akarin-1.14.4.jar" | sed -n 's/.*href="\([^"]*\).*/\1/p')

JAR_LINK=http://josephworks.ddns.net:8080/job/Akarin/job/1.14.4/lastSuccessfulBuild/artifact/${JAR_ENDPOINT}
                    curl ${JAR_LINK} -o server.jar
				break   
                ;;                                             
            "1.15.2")
                echo -e "You selected $REPLY) $opt"
			JAR_ENDPOINT=$(curl http://josephworks.ddns.net:8080/job/Akarin/job/1.15.2/lastSuccessfulBuild/artifact/target/ | grep -Eo 'href="[^\"]+"' | grep -vE "view|fingerprint" | grep "launcher.jar" | sed -n 's/.*href="\([^"]*\).*/\1/p')

JAR_LINK=http://josephworks.ddns.net:8080/job/Akarin/job/1.15.2/lastSuccessfulBuild/artifact/target/${JAR_ENDPOINT}
                    curl ${JAR_LINK} -o server.jar
				break   
                ;;        
            "1.16.1")
                echo -e "You selected $REPLY) $opt"
			 JAR_ENDPOINT=$(curl http://josephworks.ddns.net:8080/job/Akarin/job/1.16.1/lastSuccessfulBuild/artifact/target/ | grep -Eo 'href="[^\"]+"' | grep -vE "view|fingerprint" | grep "launcher.jar" | sed -n 's/.*href="\([^"]*\).*/\1/p')

JAR_LINK=http://josephworks.ddns.net:8080/job/Akarin/job/1.16.1/lastSuccessfulBuild/artifact/target/${JAR_ENDPOINT}
                    curl ${JAR_LINK} -o server.jar
				break   
                ;;                         
            "1.16.2")
                echo -e "You selected $REPLY) $opt"
			JAR_ENDPOINT=$(curl http://josephworks.ddns.net:8080/job/Akarin/job/1.16.2/lastSuccessfulBuild/artifact/target/ | grep -Eo 'href="[^\"]+"' | grep -vE "view|fingerprint" | grep "launcher.jar" | sed -n 's/.*href="\([^"]*\).*/\1/p')

JAR_LINK=http://josephworks.ddns.net:8080/job/Akarin/job/1.16.2/lastSuccessfulBuild/artifact/target/${JAR_ENDPOINT}
                    curl ${JAR_LINK} -o server.jar
				break
                ;;        
            "Exit")
                echo -e "You selected $REPLY) $opt"
				echo -e "Exit requested"
				exit
                ;;				
            *) echo -e "invalid option $REPLY";;            
        esac
    done
				break   
                ;;                       		                                            			                   
            "Fabric")
                echo -e "You selected $REPLY) $opt"

echo -e "The version of Minecraft to install. Use "latest" to install the latest version, or use "snapshot" to install the latest snapshot."
read -p 'Version: ' MC_VERSION

echo -e "The version of Fabric to install. Use "latest" to install the latest version"
read -p 'Fabric Version: ' FABRIC_VERSION

# Enable snapshots
if [ -z "$MC_VERSION" ] || [ "$MC_VERSION" == "latest" ]; then
  MC_VERSION=$(curl -sSL https://meta.fabricmc.net/v2/versions/game | jq -r '.[] | select(.stable== true )|.version' | head -n1)
elif [ "$MC_VERSION" == "snapshot" ]; then
  MC_VERSION=$(curl -sSL https://meta.fabricmc.net/v2/versions/game | jq -r '.[] | select(.stable== false )|.version' | head -n1)
fi

if [ -z "$FABRIC_VERSION" ] || [ "$FABRIC_VERSION" == "latest" ]; then
  FABRIC_VERSION=$(curl -sSL https://meta.fabricmc.net/v2/versions/installer | jq -r '.[0].version')
fi
wget -O fabric-installer.jar https://maven.fabricmc.net/net/fabricmc/fabric-installer/$FABRIC_VERSION/fabric-installer-$FABRIC_VERSION.jar
java -jar fabric-installer.jar server -mcversion $MC_VERSION -downloadMinecraft
				break 			
                ;;                                      
            "VanillaCord")
                echo -e "You selected $REPLY) $opt"
                    echo -e "VanillaCord Version:"
                    echo -e "1.7.10 for Minecraft 1.7.10, 1.8.x, 1.9.x, 1.10.x, and 1.11.x"
                    echo -e "1.12 for Minecraft 1.12.x, 1.13.x, 1.14.x, 1.15.x, and possible future versions"
                    read -p "Version: " VANILLA_VERSION
                    SERVER_JARFILE=server.jar
                    echo $VANILLA_VERSION

LATEST_VERSION=`curl https://launchermeta.mojang.com/mc/game/version_manifest.json | jq -r '.latest.release'`

if { [ -z "$VANILLA_VERSION" ] || [ "$VANILLA_VERSION" == "latest" ]; } then
  INSTALLING_VERSION=$LATEST_VERSION
else
  INSTALLING_VERSION=$VANILLA_VERSION
fi

MAJOR_VERSION=$(echo $INSTALLING_VERSION | sed -En 's/^([0-9]*)\.[0-9]*\.[0-9]*$/\1/p')
MINOR_VERSION=$(echo $INSTALLING_VERSION | sed -En 's/^[0-9]*\.([0-9]*)\.[0-9]*$/\1/p')
PATCH_VERSION=$(echo $INSTALLING_VERSION | sed -En 's/^[0-9]*\.[0-9]*\.([0-9]*)$/\1/p')

VANILLACORD_URL=https://src.me1312.net/jenkins/job/VanillaCord/job/1.12/lastSuccessfulBuild/artifact/artifacts/VanillaCord.jar
if [ $MAJOR_VERSION -eq 1 ] && [ $MINOR_VERSION -lt 12 ]; then
  VANILLACORD_URL=https://src.me1312.net/jenkins/job/VanillaCord/job/1.7.10/lastSuccessfulBuild/artifact/artifacts/VanillaCord.jar
fi

if { [ $MAJOR_VERSION -eq 1 ] && [ $MINOR_VERSION -eq 7 ] && [ $PATCH_VERSION -lt 10 ]; } || { [ $MAJOR_VERSION -eq 1 ] && [ $MINOR_VERSION -lt 7 ]; } then
  echo "VanillaCord is only supported on Minecraft 1.7.10 or higher! You cannot use it with $INSTALLING_VERSION."
  exit 1
fi

curl -o vanillacord.jar $VANILLACORD_URL
jabba_java
java -jar vanillacord.jar $INSTALLING_VERSION

rm -f vanillacord.jar
rm -rf in
mv out/*.jar $SERVER_JARFILE
rm -rf out
				break  
                ;;                    
            "Mohist")
                echo -e "You selected $REPLY) $opt"
echo -e "Available versions: 1.12.2, 1.7.10"
read -p "Version: " MOHIST_VERSION

case $MOHIST_VERSION in
1.12.2)
  echo -e "https://mohistmc.com"
  JAR_ENDPOINT=$(curl https://ci.codemc.io/job/Mohist-Community/job/Mohist-1.12.2/lastSuccessfulBuild/artifact/projects/mohist/build/libs/ | grep -Eo 'href="[^\"]+"' | grep -vE "view|fingerprint" | grep "server.jar" | sed -n 's/.*href="\([^"]*\).*/\1/p')
  JAR_LINK=https://ci.codemc.io/job/Mohist-Community/job/Mohist-1.12.2/lastSuccessfulBuild/artifact/projects/mohist/build/libs/${JAR_ENDPOINT}
  curl ${JAR_LINK} -o server.jar
;;
1.7.10)
  echo -e "https://mohistmc.com"
  JAR_ENDPOINT=$(curl https://ci.codemc.io/job/Mohist-Community/job/Mohist-1.7.10/lastSuccessfulBuild/artifact/build/distributions/ | grep -Eo 'href="[^\"]+"' | grep -vE "view|fingerprint" | grep "server.jar" | sed -n 's/.*href="\([^"]*\).*/\1/p')
  JAR_LINK=https://ci.codemc.io/job/Mohist-Community/job/Mohist-1.7.10/lastSuccessfulBuild/artifact/build/distributions/${JAR_ENDPOINT}
  curl ${JAR_LINK} -o server.jar
;;
*)
  echo -e "hi" 2> /dev/null > /dev/null
;;
esac   
				break   
                ;;            
            "Uranium")
                echo -e "You selected $REPLY) $opt"
                echo -e "https://www.uraniummc.cc"
                echo -e "1.7.10 Version"
LIBRARIES_ENDPOINT=$(curl https://ci.uraniummc.cc/job/Uranium-dev/271/artifact/build/distributions/ | grep -Eo 'href="[^\"]+"' | grep -vE "view|fingerprint" | grep "libraries.zip" | sed -n 's/.*href="\([^"]*\).*/\1/p')
JAR_ENDPOINT=$(curl https://ci.uraniummc.cc/job/Uranium-dev/lastSuccessfulBuild/artifact/build/distributions/ | grep -Eo 'href="[^\"]+"' | grep -vE "view|fingerprint" | grep "server.jar" | sed -n 's/.*href="\([^"]*\).*/\1/p')
 LIBRARIES_LINK=https://ci.uraniummc.cc/job/Uranium-dev/271/artifact/build/distributions/${LIBRARIES_ENDPOINT}
JAR_LINK=https://ci.uraniummc.cc/job/Uranium-dev/lastSuccessfulBuild/artifact/build/distributions/${JAR_ENDPOINT}
                    curl ${LIBRARIES_LINK} -o libraries.zip
                    curl ${JAR_LINK} -o server.jar
                    unzip -o libraries.zip
                    rm -rf kBootstrapX.reposList libraries.zip
				break 
                ;;        
            "Vanilla")
                echo -e "You selected $REPLY) $opt"
				SERVER_JARFILE=server.jar
echo -e "You choose Vanilla! What version would you like to install?"
read -p "Version: " VANILLA_VERSION

LATEST_VERSION=`curl https://launchermeta.mojang.com/mc/game/version_manifest.json | jq -r '.latest.release'`
if [ -z "$VANILLA_VERSION" ] || [ "$VANILLA_VERSION" == "latest" ]; then
MANIFEST_URL=$(curl https://launchermeta.mojang.com/mc/game/version_manifest.json | jq .versions | jq -r '.[] | select(.id == "'$LATEST_VERSION'") | .url')
else
MANIFEST_URL=$(curl https://launchermeta.mojang.com/mc/game/version_manifest.json | jq .versions | jq -r '.[] | select(.id == "'$VANILLA_VERSION'") | .url')
fi
DOWNLOAD_URL=`curl $MANIFEST_URL | jq .downloads.server | jq -r '. | .url'`
curl -o ${SERVER_JARFILE} $DOWNLOAD_URL
				break
                ;; 
            "Vanilla Snapshot")
                echo -e "You selected $REPLY) $opt"
				SERVER_JARFILE=server.jar
                    VANILLA_VERSION=latest

LATEST_VERSION=`curl https://launchermeta.mojang.com/mc/game/version_manifest.json | jq -r '.latest.snapshot'`
if [ -z "$VANILLA_VERSION" ] || [ "$VANILLA_VERSION" == "latest" ]; then
MANIFEST_URL=$(curl https://launchermeta.mojang.com/mc/game/version_manifest.json | jq .versions | jq -r '.[] | select(.id == "'$LATEST_VERSION'") | .url')
else
MANIFEST_URL=$(curl https://launchermeta.mojang.com/mc/game/version_manifest.json | jq .versions | jq -r '.[] | select(.id == "'$VANILLA_VERSION'") | .url')
fi
DOWNLOAD_URL=`curl $MANIFEST_URL | jq .downloads.server | jq -r '. | .url'`
curl -o ${SERVER_JARFILE} $DOWNLOAD_URL
				break
                ;; 
            "Tuinity")
                echo -e "You selected $REPLY) $opt"
                JAR_ENDPOINT=$(curl https://ci.codemc.io/job/Spottedleaf/job/Tuinity/lastSuccessfulBuild/artifact/ | grep -Eo 'href="[^\"]+"' | grep -vE "view|fingerprint" | grep "tuinity-paperclip.jar" | sed -n 's/.*href="\([^"]*\).*/\1/p')
 
JAR_LINK=https://ci.codemc.io/job/Spottedleaf/job/Tuinity/lastSuccessfulBuild/artifact/${JAR_ENDPOINT}
                    curl ${JAR_LINK} -o server.jar

if [ ! -f server.properties ]; then
    echo -e "Downloading MC server.properties"
    curl -o server.properties https://raw.githubusercontent.com/flaxeneel2/pterodactyl-optimized-paper-egg/main/server.properties
fi

if [ ! -f paper.yml ]; then
    echo -e "Downloading MC paper.yml"
    curl -o paper.yml https://raw.githubusercontent.com/flaxeneel2/pterodactyl-optimized-paper-egg/main/paper.yml
fi

if [ ! -f spigot.yml ]; then
    echo -e "Downloading MC spigot.yml"
    curl -o spigot.yml https://raw.githubusercontent.com/flaxeneel2/pterodactyl-optimized-paper-egg/main/spigot.yml
fi

if [ ! -f bukkit.yml ]; then
    echo -e "Downloading MC bukkit.yml"
    curl -o bukkit.yml https://raw.githubusercontent.com/flaxeneel2/pterodactyl-optimized-paper-egg/main/bukkit.yml
fi

				break         
                ;;     
            "Magma")
                echo -e "You selected $REPLY) $opt"
	 	     echo -e "1.12.2 Version"
                JAR_ENDPOINT=$(curl https://ci.hexeption.dev/job/Magma%20Foundation/job/Magma/job/master/lastSuccessfulBuild/artifact/build/distributions/ | grep -Eo 'href="[^\"]+"' | grep -vE "view|fingerprint" | grep "server.jar" | sed -n 's/.*href="\([^"]*\).*/\1/p')

JAR_LINK=https://ci.hexeption.dev/job/Magma%20Foundation/job/Magma/job/master/lastSuccessfulBuild/artifact/build/distributions/${JAR_ENDPOINT}
                    curl ${JAR_LINK} -o server.jar
				break 
                ;;   
            "Forge")
                echo -e "You selected $REPLY) $opt"

echo -e "What build type you want to use?"
echo -e "Accepted values is recommended/latest"
read -p "Build type: " BUILD_TYPE
SERVER_JARFILE=server.jar
echo -e "You choose Forge! What version would you like to install?"
read -p "Minecraft version: " MC_VERSION

if [ ! -z ${FORGE_VERSION} ]; then
    DOWNLOAD_LINK=https://maven.minecraftforge.net/net/minecraftforge/forge/${FORGE_VERSION}/forge-${FORGE_VERSION}
    FORGE_JAR=forge-${FORGE_VERSION}*.jar
else
    JSON_DATA=$(curl -sSL https://files.minecraftforge.net/maven/net/minecraftforge/forge/promotions_slim.json)

    if [ "${MC_VERSION}" == "latest" ] || [ "${MC_VERSION}" == "" ] ; then
        echo -e "getting latest recommended version of forge."
        MC_VERSION=$(echo -e ${JSON_DATA} | jq -r '.promos | del(."latest-1.7.10") | del(."1.7.10-latest-1.7.10") | to_entries[] | .key | select(contains("recommended")) | split("-")[0]' | sort -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n | tail -1)
    	BUILD_TYPE=recommended
    fi

    if [ "${BUILD_TYPE}" != "recommended" ] && [ "${BUILD_TYPE}" != "latest" ]; then
        BUILD_TYPE=recommended
    fi

    echo -e "minecraft version: ${MC_VERSION}"
    echo -e "build type: ${BUILD_TYPE}"

    ## some variables for getting versions and things
	FILE_SITE=https://maven.minecraftforge.net/net/minecraftforge/forge/
    VERSION_KEY=$(echo -e ${JSON_DATA} | jq -r --arg MC_VERSION "${MC_VERSION}" --arg BUILD_TYPE "${BUILD_TYPE}" '.promos | del(."latest-1.7.10") | del(."1.7.10-latest-1.7.10") | to_entries[] | .key | select(contains($MC_VERSION)) | select(contains($BUILD_TYPE))')

    ## locating the forge version
    if [ "${VERSION_KEY}" == "" ] && [ "${BUILD_TYPE}" == "recommended" ]; then
        echo -e "dropping back to latest from recommended due to there not being a recommended version of forge for the mc version requested."
        VERSION_KEY=$(echo -e ${JSON_DATA} | jq -r --arg MC_VERSION "${MC_VERSION}" '.promos | del(."latest-1.7.10") | del(."1.7.10-latest-1.7.10") | to_entries[] | .key | select(contains($MC_VERSION)) | select(contains("recommended"))')
    fi

    ## Error if the mc version set wasn't valid.
    if [ "${VERSION_KEY}" == "" ] || [ "${VERSION_KEY}" == "null" ]; then
    	echo -e "The install failed because there is no valid version of forge for the version on minecraft selected."
    	exit 1
    fi

    FORGE_VERSION=$(echo -e ${JSON_DATA} | jq -r --arg VERSION_KEY "$VERSION_KEY" '.promos | .[$VERSION_KEY]')

    if [ "${MC_VERSION}" == "1.7.10" ] || [ "${MC_VERSION}" == "1.8.9" ]; then
        DOWNLOAD_LINK=${FILE_SITE}${MC_VERSION}-${FORGE_VERSION}-${MC_VERSION}/forge-${MC_VERSION}-${FORGE_VERSION}-${MC_VERSION}
        FORGE_JAR=forge-${MC_VERSION}-${FORGE_VERSION}-${MC_VERSION}.jar
        if [ "${MC_VERSION}" == "1.7.10" ]; then
            FORGE_JAR=forge-${MC_VERSION}-${FORGE_VERSION}-${MC_VERSION}-universal.jar
        fi
    else
        DOWNLOAD_LINK=${FILE_SITE}${MC_VERSION}-${FORGE_VERSION}/forge-${MC_VERSION}-${FORGE_VERSION}
        FORGE_JAR=forge-${MC_VERSION}-${FORGE_VERSION}.jar
    fi
fi


#Adding .jar when not eding by SERVER_JARFILE
if [[ ! $SERVER_JARFILE = *\.jar ]]; then
  SERVER_JARFILE="$SERVER_JARFILE.jar"
fi

#Downloading jars
echo -e "Downloading forge version ${FORGE_VERSION}"
echo -e "Download link is ${DOWNLOAD_LINK}"
if [ ! -z "${DOWNLOAD_LINK}" ]; then 
    if curl --output /dev/null --silent --head --fail ${DOWNLOAD_LINK}-installer.jar; then
        echo -e "installer jar download link is valid."
    else
        echo -e "link is invalid closing out"
        exit 2
    fi
else
    echo -e "no download link closing out"
    exit 3
fi

curl -s -o installer.jar -sS ${DOWNLOAD_LINK}-installer.jar

#Checking if downloaded jars exist
if [ ! -f ./installer.jar ]; then
    echo "!!! Error by downloading forge version ${FORGE_VERSION} !!!"
    exit
fi

#Installing server
echo -e "Installing forge server.\n"
jabba_java
java -jar installer.jar --installServer || { echo -e "install failed"; exit 4; }

mv $FORGE_JAR $SERVER_JARFILE

#Deleting installer.jar
echo -e "Deleting installer.jar file.\n"
rm -rf installer.jar
				break                                                                                                                                        
                ;; 
            "Cuberite")
                echo -e "You selected $REPLY) $opt"
                DOWNLOADURL="https://download.cuberite.org/linux-x86_64/Cuberite.tar.gz"
                curl -Ls $DOWNLOADURL | tar -xzf -
                sed -i "s|"25565"|"$SERVER_PORT"|g" settings.ini
				break                                                                                                                                        
                ;; 
            "SpongeVanilla")
                echo -e "You selected $REPLY) $opt"             
                echo -e "SpongeVanilla Version:"
    read -p "Version: " SV_VERSION
SERVER_JARFILE=server.jar
#Adding .jar when not eding by SERVER_JARFILE
if [[ ! ${SERVER_JARFILE} = *\.jar ]]; then
  SERVER_JARFILE="${SERVER_JARFILE}.jar"
fi

## check spongevanilla version and default to recommended if it's invalid
if [ -z ${SV_VERSION} ] || [ "$(curl -s https://dl-api.spongepowered.org/v1/org.spongepowered/spongevanilla/downloads/${SV_VERSION})" == "Unknown version" ]; then
    echo -e "defaulting to recommended"
    SV_VERSION="recommended"
fi

## handle getting download linsk for sponge
if [ "${SV_VERSION}" == "recommended" ]; then
    echo -e "using recommended spongevanilla version"
    SV_VERSION=$(curl -s https://dl-api.spongepowered.org/v1/org.spongepowered/spongevanilla/downloads/recommended | jq -r '.version')
    echo -e "found spongevanilla Version ${SV_VERSION}"
    SV_DL_LINK=$(curl -s https://dl-api.spongepowered.org/v1/org.spongepowered/spongevanilla/downloads/recommended | jq -r '.artifacts."".url')
elif [ "${SV_VERSION}" == "latest" ]; then
    echo -e "using latest SpongForge version"
    SV_VERSION=$(curl -s https://dl-api.spongepowered.org/v1/org.spongepowered/spongevanilla | jq -r '.buildTypes.stable.latest.version')
    echo -e "found spongevanilla Version ${SV_VERSION}"
else
    echo -e "found spongevanilla Version ${SV_VERSION}"
    SV_DL_LINK=$(curl -s https://dl-api.spongepowered.org/v1/org.spongepowered/spongevanilla/downloads/${SV_VERSION} | jq -r '.artifacts."".url')
fi

if [ -f ${SERVER_JARFILE} ] && [ $(sha1sum server.jar | awk '{ print $1 }') == $(curl -s https://dl-api.spongepowered.org/v1/org.spongepowered/spongevanilla/downloads/recommended | jq -r '.artifacts."".sha1') ]; then
    echo -e "Already have the correct spongevanilla version"
else
    echo -e "Downloading spongevanilla version ${SV_VERSION}"
    curl -s ${SV_DL_LINK} -o ${SERVER_JARFILE}
fi
				break   
                ;;  
            "SpongeForge")
                echo -e "You selected $REPLY) $opt"                  
                echo -e "SpongeForge Version:"
                read -p "Version: " SF_VERSION
                SERVER_JARFILE=server.jar
#Adding .jar when not eding by SERVER_JARFILE
if [[ ! ${SERVER_JARFILE} = *\.jar ]]; then
  SERVER_JARFILE="${SERVER_JARFILE}.jar"
fi

if [ -z ${SF_VERSION} ] || [ "$(curl -s https://dl-api.spongepowered.org/v1/org.spongepowered/spongeforge/downloads/${SF_VERSION})" == "Unknown version" ]; then
    echo -e "defaulting to recommended"
    SF_VERSION="recommended"
fi

if [ "${SF_VERSION}" == "recommended" ]; then
    echo -e "using recommended SpongeForge version"
    SF_VERSION=$(curl -s https://dl-api.spongepowered.org/v1/org.spongepowered/spongeforge/downloads/recommended | jq -r '.version')
    echo -e "found SpongeForge Version ${SF_VERSION}"
    SF_DL_LINK=$(curl -s https://dl-api.spongepowered.org/v1/org.spongepowered/spongeforge/downloads/recommended | jq -r '.artifacts."".url')
    FORGE_DOWNLOAD_VERSION=$(curl -s https://dl-api.spongepowered.org/v1/org.spongepowered/spongeforge/downloads/recommended | jq -r '.dependencies.forge')
    echo -e "found Forge Version ${FORGE_DOWNLOAD_VERSION}"
    MC_VERSION=$(curl -s https://dl-api.spongepowered.org/v1/org.spongepowered/spongeforge/downloads/${SF_VERSION} | jq -r '.dependencies.minecraft')
elif [ "${SF_VERSION}" == "latest" ]; then
    echo -e "using latest SpongForge version"
    SF_VERSION=$(curl -s https://dl-api.spongepowered.org/v1/org.spongepowered/spongeforge | jq -r '.buildTypes.stable.latest.version')
    echo -e "found SpongeForge Version ${SF_VERSION}"
    SF_DL_LINK=$(curl -s https://dl-api.spongepowered.org/v1/org.spongepowered/spongeforge/downloads/${SF_VERSION} | jq -r '.artifacts."".url')
    FORGE_DOWNLOAD_VERSION=$(curl -s https://dl-api.spongepowered.org/v1/org.spongepowered/spongeforge/downloads/${SF_VERSION} | jq -r '.dependencies.forge')
    MC_VERSION=$(curl -s https://dl-api.spongepowered.org/v1/org.spongepowered/spongeforge/downloads/${SF_VERSION} | jq -r '.dependencies.minecraft')
else
    echo -e "found SpongeForge Version ${SF_VERSION}"
    SF_DL_LINK=$(curl -s https://dl-api.spongepowered.org/v1/org.spongepowered/spongeforge/downloads/${SF_VERSION} | jq -r '.artifacts."".url')
    FORGE_DOWNLOAD_VERSION=$(curl -s https://dl-api.spongepowered.org/v1/org.spongepowered/spongeforge/downloads/${SF_VERSION} | jq -r '.dependencies.forge')
    echo -e "found Forge Version ${FORGE_DOWNLOAD_VERSION}"
    MC_VERSION=$(curl -s https://dl-api.spongepowered.org/v1/org.spongepowered/spongeforge/downloads/${SF_VERSION} | jq -r '.dependencies.minecraft')
fi

FORGE_DL_LINK=https://files.minecraftforge.net/maven/net/minecraftforge/forge/${MC_VERSION}-${FORGE_DOWNLOAD_VERSION}/forge-${MC_VERSION}-${FORGE_DOWNLOAD_VERSION}

if [ -f server.jar ] && [ $(sha1sum server.jar | awk '{ print $1 }') == $(curl -s ${FORGE_DL_LINK}-universal.jar.sha1) ]; then
    echo -e "Already have the correct forge version"
else
    echo -e "Downloading forge version ${FORGE_VERSION}"
    echo -e "running: curl -s -o installer.jar -o ${FORGE_DL_LINK}-installer.jar"
    curl -s -o installer.jar ${FORGE_DL_LINK}-installer.jar
    echo -e "running: curl -s -o ${SERVER_JARFILE} -o ${FORGE_DL_LINK}-universal.jar"
    curl -s -o ${SERVER_JARFILE} ${FORGE_DL_LINK}-universal.jar
    jabba_java
    java -jar installer.jar --installServer
    rm installer.jar forge-${MC_VERSION}-${FORGE_DOWNLOAD_VERSION}-universal.jar
fi

if [ ! -d mods ]; then
    echo -e "making mods directory"
    mkdir -p mods
fi

if [ -f mods/spongeforge*.jar ]; then
    mkdir -p mods/old
    mv -f mods/spongeforge*.jar mods/old/spongeforge*.jar
fi 

curl -s ${SF_DL_LINK} -o mods/spongeforge-${SF_VERSION}.jar
rm -rf installer.jar.log
				break  
                ;;                    
            "Exit")
                echo -e "You selected $REPLY) $opt"
				echo -e "Exit requested"
				exit
                ;;				
            *) echo -e "invalid option $REPLY";;            
        esac
    done
				break
                ;;   
            "Minecraft Pocket/Bedrock")
                echo -e "You selected $REPLY) $opt"
                 PS3='Server type: '
    options=("Cloudburst" "PowerNukkit" "PMMP" "Altay Development Build" "Altay" "Vanilla Bedrock" "Exit")
    select opt in "${options[@]}"
    do
        case $opt in            		
            "Cloudburst")
                echo -e "You selected $REPLY) $opt"
                JAR_ENDPOINT=$(curl https://ci.opencollab.dev/job/NukkitX/job/Nukkit/job/master/lastSuccessfulBuild/artifact/target/ | grep -Eo 'href="[^\"]+"' | grep -vE "view|fingerprint" | grep ".jar" | sed -n 's/.*href="\([^"]*\).*/\1/p')

JAR_LINK=https://ci.opencollab.dev/job/NukkitX/job/Nukkit/job/master/lastSuccessfulBuild/artifact/target/${JAR_ENDPOINT}
                    curl ${JAR_LINK} -o server.jar

if [ ! -f server.properties ]; then
    wget https://raw.githubusercontent.com/parkervcp/eggs/master/minecraft/bedrock/nukkit/server.properties
fi
                    sed -i "s|"19132"|"$SERVER_PORT"|g" server.properties
				break      
                ;;                                                          
            "PowerNukkit")
                echo -e "You selected $REPLY) $opt"
			    wget --quiet $(curl --silent "https://api.github.com/repos/PowerNukkit/PowerNukkit/releases/latest" | jq .assets | jq -r .[].browser_download_url) 
                mv powernukkit-*.jar server.jar
if [ ! -f server.properties ]; then
    wget https://raw.githubusercontent.com/parkervcp/eggs/master/minecraft/bedrock/nukkit/server.properties
fi
                    sed -i "s|"19132"|"$SERVER_PORT"|g" server.properties
				break      
                ;;                         
            "PMMP")
                echo -e "You selected $REPLY) $opt"
                PMMP_ENDPOINT=$(curl https://jenkins.pmmp.io/job/PocketMine-MP/lastSuccessfulBuild/artifact/ | grep -Eo 'href="[^\"]+"' | grep -vE "view|fingerprint" | grep "PocketMine-MP.phar" | sed -n 's/.*href="\([^"]*\).*/\1/p')
 
PMMP_LINK=https://jenkins.pmmp.io/job/PocketMine-MP/lastSuccessfulBuild/artifact//${PMMP_ENDPOINT}
                curl ${PMMP_LINK} -o PocketMine-MP.phar
                curl -sSL -o php.binary.tar.gz https://jenkins.pmmp.io/job/PHP-7.4-Linux-x86_64/lastSuccessfulBuild/artifact/PHP_Linux-x86_64.tar.gz
                tar -xzvf php.binary.tar.gz
                rm -rf php.binary.tar.gz
                curl -sSL https://raw.githubusercontent.com/parkervcp/eggs/master/minecraft/bedrock/pocketmine_mp/server.properties > server.properties
                sed -i "s|"25573"|"$SERVER_PORT"|g" server.properties
                EXTENSION_DIR=$(find "$HOME/bin" -name *debug-zts*)
                grep -q '^extension_dir' bin/php7/bin/php.ini && sed -i'bak' "s{^extension_dir=.*{extension_dir=\"$EXTENSION_DIR\"{" bin/php7/bin/php.ini || echo "extension_dir=\"$EXTENSION_DIR\"" >> bin/php7/bin/php.ini
				break 
                ;;                                                        
            "Altay Development Build")
                echo -e "You selected $REPLY) $opt"
                 ALTAY_ENDPOINT=$(curl https://altay.minehub.de/job/Altay/lastSuccessfulBuild/artifact/ | grep -Eo 'href="[^\"]+"' | grep -vE "view|fingerprint" | grep "Altay.phar" | sed -n 's/.*href="\([^"]*\).*/\1/p')
ALTAY_LINK=https://altay.minehub.de/job/Altay/lastSuccessfulBuild/artifact/${ALTAY_ENDPOINT}
                  curl ${ALTAY_LINK} -o Altay.phar
                  curl -sSL -o php.binary.tar.gz https://jenkins.pmmp.io/PHP-7.4-Linux-x86_64/lastSuccessfulBuild/artifact/PHP_Linux-x86_64.tar.gz
                tar -xzvf php.binary.tar.gz
                rm -rf php.binary.tar.gz
                curl -sSL https://raw.githubusercontent.com/parkervcp/eggs/master/minecraft/bedrock/pocketmine_mp/server.properties > server.properties
                sed -i "s|"25573"|"$SERVER_PORT"|g" server.properties
                EXTENSION_DIR=$(find "$HOME/bin" -name *debug-zts*)
                grep -q '^extension_dir' bin/php7/bin/php.ini && sed -i'bak' "s{^extension_dir=.*{extension_dir=\"$EXTENSION_DIR\"{" bin/php7/bin/php.ini || echo "extension_dir=\"$EXTENSION_DIR\"" >> bin/php7/bin/php.ini
				break 
                ;;                       
            "Altay")
                echo -e "You selected $REPLY) $opt"
                 wget --quiet $(curl --silent "https://api.github.com/repos/TuranicTeam/Altay/releases/latest" | jq .assets | jq -r .[].browser_download_url)
                mv Altay*.phar Altay.phar
                curl -sSL -o php.binary.tar.gz https://jenkins.pmmp.io/job/PHP-7.4-Linux-x86_64/lastSuccessfulBuild/artifact/PHP_Linux-x86_64.tar.gz
                tar -xzvf php.binary.tar.gz
                rm -rf php.binary.tar.gz
                curl -sSL https://raw.githubusercontent.com/parkervcp/eggs/master/minecraft/bedrock/pocketmine_mp/server.properties > server.properties
                sed -i "s|"25573"|"$SERVER_PORT"|g" server.properties
                EXTENSION_DIR=$(find "$HOME/bin" -name *debug-zts*)
                grep -q '^extension_dir' bin/php7/bin/php.ini && sed -i'bak' "s{^extension_dir=.*{extension_dir=\"$EXTENSION_DIR\"{" bin/php7/bin/php.ini || echo "extension_dir=\"$EXTENSION_DIR\"" >> bin/php7/bin/php.ini
				break 
                ;; 
            "Vanilla Bedrock")
                echo -e "You selected $REPLY) $opt"
				BEDROCK_VERSION=latest
				if [ -z "${BEDROCK_VERSION}" ] || [ "${BEDROCK_VERSION}" == "latest" ]; then
    echo -e "\n Downloading latest Bedrock server"
    DOWNLOAD_URL=$(curl -sSL https://www.minecraft.net/en-us/download/server/bedrock/ | grep azureedge | grep linux | grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*")
else 
    echo -e "\n Downloading ${BEDROCK_VERSION} Bedrock server"
    DOWNLOAD_URL=https://minecraft.azureedge.net/bin-linux/bedrock-server-$BEDROCK_VERSION.zip
fi

echo -e "Downloading files from https://minecraft.azureedge.net/bin-linux/bedrock-server-$BEDROCK_VERSION.zip"

wget ${DOWNLOAD_URL}

echo -e "Unpacking server files"
unzip -o $(echo ${DOWNLOAD_URL} | cut -d"/" -f5)

echo -e "Cleaning up after installing"
rm -rf $(echo ${DOWNLOAD_URL} | cut -d"/" -f5)
				break 
                ;;        
            "Exit")
                echo -e "You selected $REPLY) $opt"
				echo -e "Exit requested"
				exit
                ;;				
            *) echo -e "invalid option $REPLY";;            
        esac
    done
				break     
                ;;        
            "GTA")
                echo -e "You selected $REPLY) $opt"
                 PS3='Server type: '
    options=("SA:MP" "MTA:SA" "Rage.MP" "Grand Theft Auto connected" "Exit")
    select opt in "${options[@]}"
    do
        case $opt in            		
            "SA:MP")
                echo -e "You selected $REPLY) $opt"
                PS3='Server type: '
    options=("Windows" "Linux" "Exit")
    select opt in "${options[@]}"
    do
        case $opt in            		
            "Windows")
                echo -e "You selected $REPLY) $opt"
                echo -e "Downloading Windows Version"
                curl -SL -o samp.zip http://files.sa-mp.com/samp037_svr_R2-1-1_win32.zip
                unzip -o samp.zip
			    sed -i "s|"7777"|"$SERVER_PORT"|g" server.cfg
                rm -rf samp.zip
				break   
                ;;                         
            "Linux")
                echo -e "You selected $REPLY) $opt"			
                echo -e "Downloading Linux Version"
                curl -sSL -o samp.tar.gz http://files.sa-mp.com/samp037svr_R2-1.tar.gz
                tar -xzvf samp.tar.gz
                mv samp03/* .
                rm -rf samp03
                sed -i '3d' server.cfg
			    sed -i "s|"7777"|"$SERVER_PORT"|g" server.cfg
                echo "rcon_password changemeplease" >> server.cfg
                rm -rf samp.tar.gz
				break   
                ;;        		
            "Exit")
                echo -e "You selected $REPLY) $opt"
				echo -e "Exit requested"
				exit
                ;;				
            *) echo -e "invalid option $REPLY";;            
        esac
    done    
				break        
                ;;     
            "MTA:SA")
                echo -e "You selected $REPLY) $opt" 
               curl -sSL -o multitheftauto_linux_x64.tar.gz https://linux.mtasa.com/dl/multitheftauto_linux_x64.tar.gz
curl -sSL -o mta-baseconfig.tar.gz https://linux.mtasa.com/dl/baseconfig.tar.gz
curl -sSL -o mtasa-resources-latest.zip http://mirror.mtasa.com/mtasa/resources/mtasa-resources-latest.zip

tar --strip-components=1 -xzvf multitheftauto_linux_x64.tar.gz

mkdir -p mods/deathmatch/resources
unzip -o -d mods/deathmatch/resources mtasa-resources-latest.zip

tar --strip-components=1 -xzvf mta-baseconfig.tar.gz -C mods/deathmatch
rm -rf mtasa-resources-latest.zip multitheftauto_linux_x64.tar.gz mta-baseconfig.tar.gz
				break  
                ;;     
            "Rage.MP")
                echo -e "You selected $REPLY) $opt" 
curl -sSL -o ragemp-srv-037.tar.gz https://cdn.rage.mp/lin/ragemp-srv-037.tar.gz
curl -sSL -o bridge-linux-037.tar.gz https://cdn.rage.mp/lin/bridge-linux-037.tar.gz

tar --strip-components=1 -xzvf  ragemp-srv-037.tar.gz
tar --strip-components=1 -xzvf  bridge-linux-037.tar.gz 

rm ragemp-srv-037.tar.gz
rm bridge-linux-037.tar.gz
mv server rage-mp-server
chmod +x ./rage-mp-server
rm -rf conf.json
if [ -e conf.json ]; then
    echo "server config file exists"
else
    echo "Downloading default rage.mp config"
    curl https://raw.githubusercontent.com/parkervcp/eggs/master/gta/ragemp/conf.json >> conf.json
fi
				break  
                ;;     
            "Grand Theft Auto connected")
                echo -e "You selected $REPLY) $opt"
                curl -SL -o gtac.tar.gz https://gtaconnected.com/downloads/server/latest/linux
                tar -xzvf gtac.tar.gz
                rm -rf gtac.tar.gz
                sed -i "s|<port>22000</port>|<port>$SERVER_PORT</port>|g" server.xml
                sed -i "s|<httpport>22000</httpport>|<httpport>$SERVER_PORT</httpport>|g" server.xml
                touch gtac.server
				break  
                ;;                                               
            "Exit")
                echo -e "You selected $REPLY) $opt"
				echo -e "Exit requested"
				exit
                ;;				
            *) echo -e "invalid option $REPLY";;            
        esac
    done
				break     
                ;;        
            "Voice")
                echo -e "You selected $REPLY) $opt"
				PS3='Server type: '
    options=("TeamSpeak3" "TS3 Manager" "Lavalink" "TeaSpeak" "Exit")
    select opt in "${options[@]}"
    do
        case $opt in            		
            "TeamSpeak3")
                echo -e "You selected $REPLY) $opt"
                TS_VERSION=latest
			    if [ -z ${TS_VERSION} ] || [ ${TS_VERSION} == latest ]; then
    TS_VERSION=$(wget https://teamspeak.com/versions/server.json -qO - | jq -r '.linux.x86_64.version')
fi

echo -e "getting files from http://files.teamspeak-services.com/releases/server/${TS_VERSION}/teamspeak3-server_linux_amd64-${TS_VERSION}.tar.bz2"
curl http://files.teamspeak-services.com/releases/server/${TS_VERSION}/teamspeak3-server_linux_amd64-${TS_VERSION}.tar.bz2 | tar xj --strip-components=1
				break     
                ;;
            "TS3 Manager")
                echo -e "You selected $REPLY) $opt"
                MATCH=ts3-manager-linux-x64
                VERSION=latest
                GITHUB_PACKAGE=joni1802/ts3-manager
## get release info and download links
LATEST_RELEASE=$(curl -L -s -H 'Accept: application/json' https://github.com/${GITHUB_PACKAGE}/releases/latest)
LATEST_VERSION=$(echo $LATEST_RELEASE | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')

if [ -z "${VERSION}" ] || [ "${VERSION}" == "latest" ]; then
    DOWNLOAD_LINK="https://github.com/${GITHUB_PACKAGE}/releases/download/$LATEST_VERSION/$MATCH-$LATEST_VERSION"
else 
    DOWNLOAD_LINK="https://github.com/${GITHUB_PACKAGE}/releases/download/v$VERSION/$MATCH-$VERSION-v$VERSION"
fi

echo $DOWNLOAD_LINK
wget $DOWNLOAD_LINK

if [ -z "${VERSION}" ] || [ "${VERSION}" == "latest" ]; then
    mv -f $MATCH-$LATEST_VERSION $HOME/start_ts3-manager
    chmod +x start_ts3-manager
else
    mv -f $MATCH-v$VERSION $HOME/start_ts3-manager
    chmod start_ts3-manager
fi			   
				break     
                ;;
            "Lavalink")
                echo -e "You selected $REPLY) $opt"
                wget --quiet $(curl --silent "https://api.github.com/repos/Frederikam/Lavalink/releases/latest" | jq .assets | jq -r .[].browser_download_url | grep -i Lavalink.jar) 
                mv Lavalink.jar server.jar
                curl --silent https://raw.githubusercontent.com/Frederikam/Lavalink/master/LavalinkServer/application.yml.example -o application.yml
				break                                                                                                      
                ;;
            "TeaSpeak")
                echo -e "You selected $REPLY) $opt"
                echo -e "What version of TeaSpeak to install: latest = latest stable ; nightly = latest nightly"
                read -p "TeaSpeak Version: " VERSION             
                
## get download link
if [ "${VERSION}" == "" ] || [ "${VERSION}" == "latest" ]; then
    DOWNLOAD_URL=$(echo "https://repo.teaspeak.de/server/linux/amd64/TeaSpeak-$(curl -sSLk https://repo.teaspeak.de/server/linux/amd64/latest).tar.gz")
elif [ "${VERSION}" == "" ] || [ "${VERSION}" == "nightly" ]; then
    DOWNLOAD_URL=$(echo "https://repo.teaspeak.de/server/linux/amd64_nightly/TeaSpeak-$(curl -sSLk https://repo.teaspeak.de/server/linux/amd64_nightly/latest).tar.gz")
else
    DOWNLOAD_URL=$(echo "https://repo.teaspeak.de/server/linux/amd64/TeaSpeak-${VERSION}.tar.gz")
fi

if [ ! -z "${DOWNLOAD_URL}" ]; then 
    if curl --output /dev/null --silent --head --fail ${DOWNLOAD_URL}; then
        echo -e "link is valid. setting download link to ${DOWNLOAD_URL}"
        DOWNLOAD_LINK=${DOWNLOAD_URL}
    else        
        echo -e "link is invalid closing out"
        exit 2
    fi
fi

## download files
echo -e "running: curl -sSL -o teaspeak.tar.gz ${DOWNLOAD_LINK}"
curl -sSL -o teaspeak.tar.gz ${DOWNLOAD_LINK}

## unpack files
echo -e "unpacking files"
tar xzvf teaspeak.tar.gz

echo -e "install complete"

## Cleanup
rm -rf teaspeak.tar.gz                
				break                                                                                                      
                ;;                                                 				
            "Exit")
                echo -e "You selected $REPLY) $opt"
				echo -e "Exit requested"
				exit
                ;;				
            *) echo -e "invalid option $REPLY";;            
        esac
    done
				break     
                ;;        
            "Discord Bot Hosting")
                echo -e "You selected $REPLY) $opt"
                 PS3='Server type: '
    options=("Discord" "SinusBot" "Exit")
    select opt in "${options[@]}"
    do
        case $opt in            		
            "Discord")
                echo -e "You selected $REPLY) $opt"  
                 touch discord.bot
                 exit
				break  
                ;;        
            "SinusBot")
                echo -e "You selected $REPLY) $opt"
                mkdir -p TeamSpeak3-Client-linux_amd64/plugins
                mkdir youtube-dl
                wget -qO - https://www.sinusbot.com/dl/sinusbot.current.tar.bz2 | tar xj
                TS_VERSION=$(curl https://teamspeak.com/versions/client.json | jq -r '.linux.x86_64.version')
                TS_DL_LINK=$(curl https://teamspeak.com/versions/client.json | jq -r '.linux.x86_64.mirrors."teamspeak.com"')
                wget ${TS_DL_LINK}
                chmod 0755 TeamSpeak3-Client-linux_amd64*.run
                ./TeamSpeak3-Client-linux_amd64*.run --tar xfv -C TeamSpeak3-Client-linux_amd64
                rm TeamSpeak3-Client-linux_amd64*.run
                rm TeamSpeak3-Client-linux_amd64/xcbglintegrations/libqxcb-glx-integration.so
                chmod +x sinusbot
                cp config.ini.dist config.ini
                sed -i "s|^TS3Path.*|TS3Path = \"TeamSpeak3-Client-linux_amd64/ts3client_linux_amd64\"|g" config.ini
                echo 'YoutubeDLPath = "youtube-dl/youtube-dl"' >> config.ini
                sed -i "s|^ListenPort.*|ListenPort = "$SERVER_PORT"|g" config.ini
                sed -i "s|^ListenHost.*|ListenHost = \"0.0.0.0\"|g" config.ini
                cp plugin/libsoundbot_plugin.so TeamSpeak3-Client-linux_amd64/plugins
                cd youtube-dl
                wget -q https://yt-dl.org/downloads/latest/youtube-dl
                chmod a+rx youtube-dl
				break   
                ;;            
            "Exit")
                echo -e "You selected $REPLY) $opt"
				echo -e "Exit requested"
				exit
                ;;				
            *) echo -e "invalid option $REPLY";;            
        esac
    done
				break     
                ;;        
            "Terraria")
                echo -e "You selected $REPLY) $opt"
                 PS3='Server type: '
    options=("tModLoader" "tshock" "Exit")
    select opt in "${options[@]}"
    do
        case $opt in            		
            "tModLoader")
                echo -e "You selected $REPLY) $opt"
                VERSION=latest
                GITHUB_PACKAGE=tModLoader/tModLoader
## get release info and download links
LATEST_JSON=$(curl --silent "https://api.github.com/repos/$GITHUB_PACKAGE/releases/latest")
RELEASES=$(curl --silent "https://api.github.com/repos/$GITHUB_PACKAGE/releases")

if [ -z "$VERSION" ] || [ "$VERSION" == "latest" ]; then
    echo -e "defaulting to latest release"
    DOWNLOAD_LINK=$(echo $LATEST_JSON | jq .assets | jq -r .[].browser_download_url | grep -i linux | grep -i zip)
else
    VERSION_CHECK=$(echo $RELEASES | jq -r --arg VERSION "$VERSION" '.[] | select(.tag_name==$VERSION) | .tag_name')
    if [ "$VERSION" == "$VERSION_CHECK" ]; then
        DOWNLOAD_LINK=$(echo $RELEASES | jq -r --arg VERSION "$VERSION" '.[] | select(.tag_name==$VERSION) | .assets[].browser_download_url' | grep -i linux)
    else
        echo -e "defaulting to latest release"
        DOWNLOAD_LINK=$(echo $LATEST_JSON | jq .assets | jq -r .[].browser_download_url | grep -i linux | grep -i zip)
    fi
fi

## download release
echo -e "running: curl -sSL ${DOWNLOAD_LINK} -o ${DOWNLOAD_LINK##*/}"
curl -sSL ${DOWNLOAD_LINK} -o ${DOWNLOAD_LINK##*/}

FILETYPE=$(file -F ',' ${DOWNLOAD_LINK##*/} | cut -d',' -f2 | cut -d' ' -f2)
if [ "$FILETYPE" == "gzip" ]; then
    tar xzvf ${DOWNLOAD_LINK##*/}
elif [ "$FILETYPE" == "Zip" ]; then
    unzip -o ${DOWNLOAD_LINK##*/}
else
    echo -e "unknown filetype. Exiting"
    exit 2 
fi

chmod +x tModLoaderServer.bin.x86_64
chmod +x tModLoaderServer

echo -e "Cleaning up extra files."
rm -rf terraria-server-${CLEAN_VERSION}.zip rm ${DOWNLOAD_LINK##*/}
				break   
                ;;     
            "tshock")
                echo -e "You selected $REPLY) $opt"
                TSHOCK_VERSION=latest
                GITHUB_PACKAGE=Pryaxis/TShock
## get release info and download links
LATEST_JSON=$(curl --silent "https://api.github.com/repos/$GITHUB_PACKAGE/releases/latest")
RELEASES=$(curl --silent "https://api.github.com/repos/$GITHUB_PACKAGE/releases")

if [ -z "$TSHOCK_VERSION" ] || [ "$TSHOCK_VERSION" == "latest" ]; then
    DOWNLOAD_LINK=$(echo $LATEST_JSON | jq .assets | jq -r .[].browser_download_url)
else
    VERSION_CHECK=$(echo $RELEASES | jq -r --arg VERSION "$TSHOCK_VERSION" '.[] | select(.tag_name==$VERSION) | .tag_name')
    if [ "$TSHOCK_VERSION" == "$VERSION_CHECK" ]; then
        DOWNLOAD_LINK=$(echo $RELEASES | jq -r --arg VERSION "$TSHOCK_VERSION" '.[] | select(.tag_name==$VERSION) | .assets[].browser_download_url')
    else
        echo -e "defaulting to latest release"
        DOWNLOAD_LINK=$(echo $LATEST_JSON | jq .assets | jq -r .[].browser_download_url)
    fi
fi

## download release
echo -e "running: wget $DOWNLOAD_LINK"
wget $DOWNLOAD_LINK

FILETYPE=$(file -F ',' ${DOWNLOAD_LINK##*/} | cut -d',' -f2 | cut -d' ' -f2)
if [ "$FILETYPE" == "gzip" ]; then
    tar xzvf ${DOWNLOAD_LINK##*/}
elif [ "$FILETYPE" == "Zip" ]; then
    unzip -o ${DOWNLOAD_LINK##*/}
else
    echo -e "unknown filetype. Exeting"
    exit 2 
fi
rm -rf tshock*
				break   
                ;;        
            "Exit")
                echo -e "You selected $REPLY) $opt"
				echo -e "Exit requested"
				exit
                ;;				
            *) echo -e "invalid option $REPLY";;            
        esac
    done
				break     
                ;;   
            "Proxy")
                echo -e "You selected $REPLY) $opt"
                 PS3='Server type: '
    options=("Waterfall" "HexaCord" "Lilypad" "Travertine" "Velocity" "BungeeCord" "Waterdog" "GeyserMC" "Exit")
    select opt in "${options[@]}"
    do
        case $opt in            		
            "Waterfall")
                echo -e "You selected $REPLY) $opt"
                echo -e "Supported Versions: 1.16, 1.15, 1.14 ,1.13 ,1.12, 1.11"
                echo -e "Minecraft Version:" 
                read -p 'Version: ' MINECRAFT_VERSION
                SERVER_JARFILE=server.jar
                BUILD_NUMBER=latest

if [ -n "${DL_PATH}" ]; then
    echo -e "using supplied download url"
    DOWNLOAD_URL=`eval echo $(echo ${DL_PATH} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
else
    if [ -z "$VANILLA_VERSION" ] || [ "${MINECRAFT_VERSION}" == "latest" ]; then
        echo -e "getting latest supported mc version and latest paper build"
        MINECRAFT_VERSION=$(curl -s https://papermc.io/api/v1/waterfall | jq -r '.versions[0]')
        BUILD_NUMBER=$(curl -sSL https://papermc.io/api/v1/waterfall/${MINECRAFT_VERSION} | jq -r '.builds.latest')
        VER_EXISTS=true
    else
        echo -e "checking if version ${MINECRAFT_VERSION} exists"
        VER_EXISTS=$(curl -s https://papermc.io/api/v1/waterfall | jq -r --arg VERSION ${MINECRAFT_VERSION} '.versions[] | contains($VERSION)' | grep true)
    fi
    
    if [ "${VER_EXISTS}" == "true" ]; then
        echo -e "Version is valid. Using version ${MINECRAFT_VERSION}"
    else
        echo -e "Using the latest waterfall version"
        MINECRAFT_VERSION=${LATEST_WATERFALL_VERSION}
    fi
    
    BUILD_EXISTS=$(curl -sSL https://papermc.io/api/v1/waterfall/${MINECRAFT_VERSION} | jq -r --arg BUILD ${BUILD_NUMBER} '.builds.all[] | contains($BUILD)' | grep true)
    
    if [ "${BUILD_EXISTS}" == "true" ] || [ ${BUILD_NUMBER} == "latest" ]; then
        echo -e "Build is valid. Using version ${BUILD_NUMBER}"
    else
        echo -e "Using the latest paper build for version ${MINECRAFT_VERSION}"
        BUILD_NUMBER=$(curl -sSL https://papermc.io/api/v1/waterfall/${MINECRAFT_VERSION} | jq -r '.builds.latest')
    fi
    
    echo "Version being downloaded"
    echo -e "MC Version: ${MINECRAFT_VERSION}"
    echo -e "Build: ${BUILD_NUMBER}"
    DOWNLOAD_URL=https://papermc.io/api/v1/waterfall/${MINECRAFT_VERSION}/${BUILD_NUMBER}/download 
fi

if [ -z ${SERVER_JARFILE} ]; then
    SERVER_JARFILE=server.jar
fi

if [[ ! $SERVER_JARFILE = *\.jar ]]; then
  SERVER_JARFILE="$SERVER_JARFILE.jar"
fi

echo -e "running curl -o ${SERVER_JARFILE} ${DOWNLOAD_URL}"

curl -o ${SERVER_JARFILE} ${DOWNLOAD_URL}
				break   
                ;;                          
            "HexaCord")
                echo -e "You selected $REPLY) $opt"
			    wget --quiet $(curl --silent "https://api.github.com/repos/HexagonMC/BungeeCord/releases/latest" | jq .assets | jq -r .[].browser_download_url | grep -i BungeeCord.jar) 
                mv Bungee*.jar server.jar
				break   
                ;;                          
            "Lilypad")
                echo -e "You selected $REPLY) $opt"
			    LILY_ENDPOINT=$(curl https://ci.lilypadmc.org/job/Go-Server-Proxy/lastSuccessfulBuild/artifact/target/ | grep -Eo 'href="[^\"]+"' | grep -vE "view|fingerprint" | grep "proxy-linux-amd64" | sed -n 's/.*href="\([^"]*\).*/\1/p')
                LILY_LINK=https://ci.lilypadmc.org/job/Go-Server-Proxy/lastSuccessfulBuild/artifact/target/${LILY_ENDPOINT}
                curl ${LILY_LINK} -o proxy-linux-amd64
                chmod u+x proxy-linux-amd64
				break 
                ;; 								
            "Travertine")
                echo -e "You selected $REPLY) $opt"
                JAR_ENDPOINT=$(curl https://papermc.io/ci/job/Travertine/lastSuccessfulBuild/artifact/Travertine-Proxy/bootstrap/target/ | grep -Eo 'href="[^\"]+"' | grep -vE "view|fingerprint" | grep "Travertine.jar" | sed -n 's/.*href="\([^"]*\).*/\1/p')
 
JAR_LINK=https://papermc.io/ci/job/Travertine/lastSuccessfulBuild/artifact/Travertine-Proxy/bootstrap/target/${JAR_ENDPOINT}
                    curl ${JAR_LINK} -o server.jar
				break   
                ;;        
            "Velocity")
                echo -e "You selected $REPLY) $opt"
			 if [ -z ${VELOCITY_VERSION} ] || [ ${VELOCITY_VERSION} == "latest" ]; then
                VELOCITY_VERSION=/lastStableBuild
             fi

                DOWNLOAD_ENDPOINT=$(curl https://ci.velocitypowered.com/job/velocity/${VELOCITY_VERSION}/ | grep -Eo 'href="[^\"]+"' | grep -vE "view|fingerprint" | grep ".jar" | sed -n 's/.*href="\([^"]*\).*/\1/p')
                DOWNLOAD_LINK=https://ci.velocitypowered.com/job/velocity/lastStableBuild/${DOWNLOAD_ENDPOINT}
                curl ${DOWNLOAD_LINK} -o server.jar
				break 
                ;;                         
            "BungeeCord")
                echo -e "You selected $REPLY) $opt"
                JAR_ENDPOINT=$(curl https://ci.md-5.net/job/BungeeCord/lastStableBuild/artifact/bootstrap/target/ | grep -Eo 'href="[^\"]+"' | grep -vE "view|fingerprint" | grep "BungeeCord.jar" | sed -n 's/.*href="\([^"]*\).*/\1/p')
 
JAR_LINK=https://ci.md-5.net/job/BungeeCord/lastStableBuild/artifact/bootstrap/target/${JAR_ENDPOINT}
                    curl ${JAR_LINK} -o server.jar
				break   
               ;;                         
            "Waterdog")
                echo -e "You selected $REPLY) $opt"
                curl -o server.jar https://jenkins.waterdog.dev/job/Waterdog/job/WaterdogPE/job/master/lastSuccessfulBuild/artifact/target/waterdog-1.0.0-SNAPSHOT.jar 2> /dev/null > /dev/null
				break   
               ;;                                        
            "GeyserMC")
                echo -e "You selected $REPLY) $opt"
                JAR_ENDPOINT=$(curl -s https://ci.opencollab.dev//job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/bootstrap/standalone/target/ | grep -Eo 'href="[^\"]+"' | grep -vE "view|fingerprint" | grep "Geyser.jar" | sed -n 's/.*href="\([^"]*\).*/\1/p') 
  JAR_LINK=https://ci.opencollab.dev//job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/bootstrap/standalone/target/${JAR_ENDPOINT}
  curl -s ${JAR_LINK} -o server.jar
				break   
                ;;        
            "Exit")
                echo -e "You selected $REPLY) $opt"
				echo -e "Exit requested"
				exit
                ;;				
            *) echo -e "invalid option $REPLY";;            
        esac
    done
				break     
                ;;        
            "Database")
                echo -e "You selected $REPLY) $opt"
                 PS3='Server type: '
    options=("MongoDB" "RethinkDB" "Redis" "MariaDB" "Exit")
    select opt in "${options[@]}"
    do
        case $opt in            		
            "MongoDB")
                echo -e "You selected $REPLY) $opt"
                touch database.server
				break   
                ;;                         
            "RethinkDB")
                echo -e "You selected $REPLY) $opt"
                touch database.server
				break   
                ;;        
            "Redis")
                echo -e "You selected $REPLY) $opt"    
                touch database.server
				break 
                ;;                   
            "MariaDB")
                echo -e "You selected $REPLY) $opt"
                mkdir -p run/mysqld && mkdir -p log/mysql && mkdir -p mysql
curl --silent https://raw.githubusercontent.com/devil38/scripts/master/mariadb/my.cnf > .my.cnf
mysql_install_db --defaults-file=/home/container/.my.cnf
                echo -e "=======================" 
                echo -e "install complete"   
                touch database.server
                echo -e "=======================" 
				break 
                ;;  		
            "Exit")
                echo -e "You selected $REPLY) $opt"
				echo -e "Exit requested"
				exit
                ;;				
            *) echo -e "invalid option $REPLY";;            
        esac
    done
				break                                                                                                                                        
                ;;        
            "Others")
                echo -e "You selected $REPLY) $opt"
                 PS3='Server type: '
    options=("BombSquad" "Counter-Strike 1.6" "Mindustry" "Minetest" "Unturned" "Oragono" "Impostor" "Minio S3" "Nginx" "CryoFall" "Exit")
    select opt in "${options[@]}"
    do
        case $opt in            		
            "BombSquad")
                echo -e "You selected $REPLY) $opt"
                echo -e "BombSquad version:"
                echo -e "Type latest for latest version"
                read -p "Version: " BOMBSQUAD_VERSION
                if [ -z "${BOMBSQUAD_VERSION}" ] || [ "${BOMBSQUAD_VERSION}" == "latest" ]; then
    echo -e "Downloading latest BombSquad server"
    TAR_ENDPOINT=$(curl https://files.ballistica.net/bombsquad/builds/ | grep -Eo 'href="[^\"]+"' | grep -vE "view|fingerprint" | grep "BombSquad_Server_Linux" | sed -n 's/.*href="\([^"]*\).*/\1/p')
TAR_LINK=https://files.ballistica.net/bombsquad/builds/${TAR_ENDPOINT}
                    curl ${TAR_LINK} -o bombsquad.tar.gz
                    tar --strip-components=1 -xzvf bombsquad.tar.gz
                    rm -rf bombsquad.tar.gz
else 
    echo -e "Downloading ${BOMBSQUAD_VERSION} BombSquad server"
    TAR_ENDPOINT=$(curl https://files.ballistica.net/bombsquad/builds/old/ | grep -Eo 'href="[^\"]+"' | grep -vE "view|fingerprint" | grep "Server_Linux_64bit_${BOMBSQUAD_VERSION}" | sed -n 's/.*href="\([^"]*\).*/\1/p')
TAR_LINK=https://files.ballistica.net/bombsquad/builds/old/${TAR_ENDPOINT}
                    curl ${TAR_LINK} -o bombsquad.tar.gz
                    tar --strip-components=1 -xzvf bombsquad.tar.gz
                    rm -rf bombsquad.tar.gz
                    fi
				break   
                ;;        
            "Counter-Strike 1.6")
                echo -e "You selected $REPLY) $opt"
                echo -e "====================\nThanks to Drakunovu#9424\n===================="
wget https://github.com/Drakunovu/csbase/archive/master.zip 
unzip -o master.zip
cd csbase* && cp -r * /home/container
cd /home/container
mkdir -p .steam/sdk32
cp -r steamclient.so .steam/sdk32
rm -rf master.zip csbase* .wget*
				break 
                ;;            
            "Mindustry")
                echo -e "You selected $REPLY) $opt"
                wget --quiet $(curl --silent "https://api.github.com/repos/Anuken/Mindustry/releases/latest" | jq .assets | jq -r .[].browser_download_url | grep -i server-release.jar) 
                 mv server-release.jar mindustry-server.jar
				break                       
                ;;            
            "Minetest")
                echo -e "You selected $REPLY) $opt"              
echo -e "The version of Minetest to install. Releases only"
read -p "Version: "  MTVERSION

# Download, compile and prepare the engine
wget -O src.zip https://github.com/minetest/minetest/archive/"${MTVERSION}".zip && unzip ./src.zip && rm ./src.zip
cd ./minetest-"${MTVERSION}" &&
cmake . -DRUN_IN_PLACE=TRUE -DBUILD_CLIENT=FALSE -DBUILD_SERVER=TRUE -DENABLE_GLES=OFF -DENABLE_POSTGRESQL=OFF -DENABLE_REDIS=OFF -DENABLE_SOUND=OFF -DENABLE_LEVELDB=OFF -DENABLE_SPATIAL=OFF && make -j$(nproc) && make package && mv ./minetest-"${MTVERSION}"-linux.tar.gz ../ && cd .. && rm -rf ./minetest-"${MTVERSION}" && tar xfz ./minetest-"${MTVERSION}"-linux.tar.gz &&
rm minetest-"${MTVERSION}"-linux.tar.gz && mv ./minetest-"${MTVERSION}"-linux/* ./ && rm -rf minetest-"${MTVERSION}"-linux && touch ./minetest.conf

# Download and prepare the game
cd ./games && wget -O minetest_game.zip https://github.com/minetest/minetest_game/archive/"${MTVERSION}".zip && unzip minetest_game.zip && rm minetest_game.zip && mv minetest_game-"${MTVERSION}" minetest_game && cd ..

# Clean up a bit
rm -rf clientmods unix doc client fonts textures
				break                                           
                ;;                       
            "Unturned")
                echo -e "You selected $REPLY) $opt"  
LD_LIBRARY_PATH=./Unturned_Headless_Data/Plugins/x86_64/
SRCDS_APPID=1110390
## just in case someone removed the defaults.
if [ "${STEAM_USER}" == "" ]; then
    echo -e "steam user is not set.\n"
    echo -e "Using anonymous user.\n"
    STEAM_USER=anonymous
    STEAM_PASS=""
    STEAM_AUTH=""
else
    echo -e "user set to ${STEAM_USER}"
fi

## download and install steamcmd

mkdir -p /home/container/steamcmd
curl -sSL -o steamcmd.tar.gz https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
tar -xzvf steamcmd.tar.gz -C /home/container/steamcmd
rm -rf steamcmd.tar.gz
cd /home/container/steamcmd

# SteamCMD fails otherwise for some reason, even running as root.
# This is changed at the end of the install process anyways.
export HOME=/home/container

## install game using steamcmd
./steamcmd.sh +login ${STEAM_USER} ${STEAM_PASS} ${STEAM_AUTH} +force_install_dir /home/container +app_update ${SRCDS_APPID} ${EXTRA_FLAGS} validate +quit ## other flags may be needed depending on install. looking at you cs 1.6

## set up 32 bit libraries
mkdir -p /home/container/.steam/sdk32
cp -v linux32/steamclient.so /home/container/.steam/sdk32/steamclient.so

## set up 64 bit libraries
mkdir -p /home/container/.steam/sdk64
cp -v linux64/steamclient.so /home/container/.steam/sdk64/steamclient.so

## Specific to Unturned
cd /home/container/

mkdir -p /home/container/Unturned_Headless_Data/Plugins/x86_64
redist_steamclient=linux64/steamclient.so
steamcmd_steamclient=/home/container/linux64/steamclient.so
unturned_steamclient=/home/container/Unturned_Headless_Data/Plugins/x86_64/steamclient.so
if [[ -f $steamcmd_steamclient ]]
then
    cp -f $steamcmd_steamclient $unturned_steamclient
else
    cp -f $redist_steamclient $unturned_steamclient
fi

ln -s /home/container/Extras/Rocket.Unturned/ /Modules/
				break                                                                      
                ;;			
            "Oragono")
                echo -e "You selected $REPLY) $opt"    
                wget --quiet $(curl --silent "https://api.github.com/repos/oragono/oragono/releases/latest" | jq .assets | jq -r .[].browser_download_url | grep -i linux-x86_64.tar.gz) 
                tar --strip-components=1 -xzvf *linux-x86_64.tar.gz
                rm -rf *linux-x86_64.tar.gz
                chmod u+x oragono
                cp default.yaml ircd.yaml
                sed -i "s|"127.0.0.1:6667"|0.0.0.0:"$SERVER_PORT"|g" ircd.yaml
                ./oragono mkcerts
				break                                             
                ;;
            "Impostor")
                echo -e "You selected $REPLY) $opt"             
                wget --quiet $(curl --silent "https://api.github.com/repos/Impostor/Impostor/releases/latest" | jq .assets | jq -r .[].browser_download_url | grep -i linux-x64.tar.gz)
                rm -rf Impostor-Patcher*
                tar -xzvf Impostor-Server*
                rm -rf Impostor-Server* .wget-hsts
                chmod +x Impostor.Server
				break                                             
                ;;
            "Minio S3")
                echo -e "You selected $REPLY) $opt"             
                wget https://dl.min.io/server/minio/release/linux-amd64/minio
                chmod +x minio
                mkdir -p data && mkdir -p keys
                wget https://github.com//parkervcp/eggs/raw/master/storage/minio/minio.sh
                chmod +x minio.sh
                export MINIO_ACCESS_KEY=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
                echo $MINIO_ACCESS_KEY > keys/key.txt
                export MINIO_SECRET_KEY=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
                echo $MINIO_SECRET_KEY > keys/secret.txt
                echo done
                touch minios3.server
				break                                             
                ;;
            "Nginx")
                echo -e "You selected $REPLY) $opt"             
                wget https://github.com/devil38/scripts/blob/master/nginx/debian-nginx.zip?raw=true
                unzip -o debian-nginx.zip?raw=true
                rm -rf debian-nginx.zip?raw=true
                touch nginx.server
				break                                             
                ;;
            "CryoFall")
                echo -e "You selected $REPLY) $opt"  
                VERSION="latest"          
                
if [ "${VERSION}" == "latest" ] || [ "${VERSION}" == "" ]; then
    DOWNLOAD_URL=$(curl -sSL https://wiki.atomictorch.com/CryoFall/Server/Setup | grep 'SERVER DOWNLOAD' | grep -Eoi '<a [^>]+>' | grep -Eo 'href=\"[^\\\"]+\"' | grep -Eo '(http|https):\/\/[^\"]+' | tail -1 | cut -d'?' -f1)
else
    DOWNLOAD_URL=https://atomictorch.com/Files/CryoFall_Server_v${VERSION}_NetCore.zip
fi

if [ ! -z "${DOWNLOAD_URL}" ]; then 
    if curl --output /dev/null --silent --head --fail ${DOWNLOAD_URL}; then
        echo -e "link is valid. setting download link to ${DOWNLOAD_URL}"
        DOWNLOAD_LINK=${DOWNLOAD_URL}
    else        
        echo -e "link is invalid closing out"
        exit 2
    fi
fi

curl -L -o cryofall_server.zip ${DOWNLOAD_LINK}
unzip cryofall_server.zip
cp -rf CryoFall_Server*NetCore/. /home/container
rm -rf cryofall_server.zip CryoFall_Server*NetCore/
                sed -i "s|<port>6000</port>|<port>$SERVER_PORT</port>|g" /home/container/Data/SettingsServer.xml                
                touch cryofall.server
				break                                             
                ;;                                                                       		
            "Exit")
                echo -e "You selected $REPLY) $opt"
				echo -e "Exit requested"
				exit
                ;;				
            *) echo -e "invalid option $REPLY";;            
        esac
    done
				break                                                                                                                                        
                ;; 											
            "Exit")
                echo -e "You selected $REPLY) $opt"
				echo -e "Exit requested"
				exit
                ;;				
            *) echo -e "invalid option $REPLY";;            
        esac
    done
	JAR="server.jar"
fi

if grep -r "eula=false" eula.txt  2> /dev/null > /dev/null; then
        echo -e "By typing yes you are indicating your agreement to Mojang EULA (https://account.mojang.com/documents/minecraft_eula)"
        echo -e "Type yes to accept Minecraft EULA"
        read -p "EULA: " MOJANG_EULA

case $MOJANG_EULA in
yes)
     echo -e "==============================="
     echo -e "You Accepted Minecraft EULA"
     sed -i "s|"eula=false"|eula=true|g" eula.txt
     echo -e "==============================="
;;
no)
     echo -e "==============================="
     echo -e "You didn't Accepted Minecraft EULA"
     echo -e "==============================="
     exit
;;
*)
  echo -e "hi" 2> /dev/null > /dev/null
;;
esac      
fi

jar_startup
