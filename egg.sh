#!/bin/bash

aqua_color="\e[36m"
reset_color="\e[0m"
red_color="\e[31m"
aquaa_color="\033[38;5;14m"



install_counter-strike(){
wget https://github.com/AdemErsln/csbase/archive/refs/heads/master.zip
unzip master.zip
mv csbase-master/* /home/container
rm -rf csbase-master
rm master.zip
exit 0
}
#Installers
install_vanilla_bedrock(){
# Minecraft CDN Akamai blocks script user-agents
RANDVERSION=$(echo $((1 + $RANDOM % 4000)))

if [ -z "${BEDROCK_VERSION}" ] || [ "${BEDROCK_VERSION}" == "latest" ]; then
    echo -e "\n Downloading latest Bedrock server"
    curl -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.$RANDVERSION.212 Safari/537.36" -H "Accept-Language: en" -H "Accept-Encoding: gzip, deflate" -o versions.html.gz https://www.minecraft.net/en-us/download/server/bedrock
    DOWNLOAD_URL=$(zgrep -o 'https://minecraft.azureedge.net/bin-linux/[^"]*' versions.html.gz)
else 
    echo -e "\n Downloading ${BEDROCK_VERSION} Bedrock server"
    DOWNLOAD_URL=https://minecraft.azureedge.net/bin-linux/bedrock-server-$BEDROCK_VERSION.zip
fi

DOWNLOAD_FILE=$(echo ${DOWNLOAD_URL} | cut -d"/" -f5) # Retrieve archive name

echo -e "backing up config files"
rm *.bak versions.html.gz
cp server.properties server.properties.bak
cp permissions.json permissions.json.bak
cp allowlist.json allowlist.json.bak

echo -e "Downloading files from: $DOWNLOAD_URL"

curl -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.$RANDVERSION.212 Safari/537.36" -H "Accept-Language: en" -o $DOWNLOAD_FILE $DOWNLOAD_URL

echo -e "Unpacking server files"
unzip -o $DOWNLOAD_FILE

echo -e "Cleaning up after installing"
rm $DOWNLOAD_FILE

echo 'emit-server-telemetry=true' >> server.properties

echo -e "restoring backup config files - on first install there will be file not found errors which you can ignore."
cp -rf server.properties.bak server.properties
cp -rf permissions.json.bak permissions.json
cp -rf allowlist.json.bak allowlist.json

chmod +x bedrock_server

echo -e "Install Completed"
}
install_vanilla(){
echo -e "What build type you want to use?"
read -p  "Enter version:" version
echo -e "${red_color}You must accept the EULA to run the server. Do you agree? (T/F)${reset_color}"
read -p "Eula (T/F): " eula
lowercase_eula=$(echo "$eula" | tr '[:upper:]' '[:lower:]')

if [[ "$lowercase_eula" == "t" ]]; then
    echo "eula=true" > eula.txt
    # Eğer eula "t" ise yapılacak işlemleri burada belirtebilirsiniz.
else
        echo "eula=false" > eula.txt

fi
VANILLA_VERSION="$version"
LATEST_VERSION=`curl https://launchermeta.mojang.com/mc/game/version_manifest.json | jq -r '.latest.release'`
LATEST_SNAPSHOT_VERSION=`curl https://launchermeta.mojang.com/mc/game/version_manifest.json | jq -r '.latest.snapshot'`

MANIFEST_URL=$(curl -sSL https://launchermeta.mojang.com/mc/game/version_manifest.json | jq --arg VERSION $VANILLA_VERSION -r '.versions | .[] | select(.id== $VERSION )|.url')

DOWNLOAD_URL=$(curl ${MANIFEST_URL} | jq .downloads.server | jq -r '. | .url')

curl -o "/home/container/server.jar" $DOWNLOAD_URL

echo -e "Install Complete"
if [ -f $jar_file ]; then
echo "server-ip: 0.0.0.0" > server.properties
echo "server-port: $SERVER_PORT" >> server.properties
echo "query.port: $SERVER_PORT" >> server.properties
  echo "Success"
else
  echo "Error"
fi

}
install_fabric(){
echo -e "What version would you like to install?:"
echo -e "Visit https://maven.fabricmc.net/net/fabricmc/intermediary/ for version"
read -p  "Version:" version
echo -e "${red_color}You must accept the EULA to run the server. Do you agree? (T/F)${reset_color}"
read -p "Eula (T/F): " eula
lowercase_eula=$(echo "$eula" | tr '[:upper:]' '[:lower:]')

if [[ "$lowercase_eula" == "t" ]]; then
    echo "eula=true" > eula.txt
    # Eğer eula "t" ise yapılacak işlemleri burada belirtebilirsiniz.
else
        echo "eula=false" > eula.txt

fi
MC_VERSION="$version"
# Enable snapshots
if [ -z "$MC_VERSION" ] || [ "$MC_VERSION" == "latest" ]; then
  MC_VERSION=$(curl -sSL https://meta.fabricmc.net/v2/versions/game | jq -r '.[] | select(.stable== true )|.version' | head -n1)
elif [ "$MC_VERSION" == "snapshot" ]; then
  MC_VERSION=$(curl -sSL https://meta.fabricmc.net/v2/versions/game | jq -r '.[] | select(.stable== false )|.version' | head -n1)
fi

if [ -z "$FABRIC_VERSION" ] || [ "$FABRIC_VERSION" == "latest" ]; then
  FABRIC_VERSION=$(curl -sSL https://meta.fabricmc.net/v2/versions/installer | jq -r '.[0].version')
fi

if [ -z "$LOADER_VERSION" ] || [ "$LOADER_VERSION" == "latest" ]; then
  LOADER_VERSION=$(curl -sSL https://meta.fabricmc.net/v2/versions/loader | jq -r '.[] | select(.stable== true )|.version' | head -n1)
elif [ "$LOADER_VERSION" == "snapshot" ]; then
  LOADER_VERSION=$(curl -sSL https://meta.fabricmc.net/v2/versions/loader | jq -r '.[] | select(.stable== false )|.version' | head -n1)
fi

wget -O fabric-installer.jar https://maven.fabricmc.net/net/fabricmc/fabric-installer/$FABRIC_VERSION/fabric-installer-$FABRIC_VERSION.jar
java -jar fabric-installer.jar server -mcversion $MC_VERSION -loader $LOADER_VERSION -downloadMinecraft
mv server.jar minecraft-server.jar
mv fabric-server-launch.jar server.jar
echo "serverJar=minecraft-server.jar" > fabric-server-launcher.properties
echo -e "Install Complete"


}
install_magma(){
jar_file="/home/container/server.jar"
echo -e "What version would you like to install?"
echo -e "Supported versions: 1.12.2 1.16.5 1.18.2 1.19.3 "
read -p  "Version:" version

DOWNLOAD_URL="https://api.magmafoundation.org/api/v2/$version/latest/download"

wget -O $jar_file $DOWNLOAD_URL

if [ -f $jar_file ]; then
echo "server-ip: 0.0.0.0" > server.properties
echo "server-port: $SERVER_PORT" >> server.properties
echo "query.port: $SERVER_PORT" >> server.properties
echo "Accept eula? (T/F)"
read -p "Eula (E/H): " eula
lowercase_eula=$(echo "$eula" | tr '[:upper:]' '[:lower:]')

if [[ "$lowercase_eula" == "t" ]]; then
    echo "eula=true" > eula.txt
    # Eğer eula "t" ise yapılacak işlemleri burada belirtebilirsiniz.
else
        echo "eula=false" > eula.txt

    # Eğer eula "t" değilse yapılacak işlemleri burada belirtebilirsiniz.
fi
  echo "Success"
else
  echo "Error"
fi

}
install_paper(){
echo -e "What version would you like to install?"
versions=$(curl -s https://api.papermc.io/v2/projects/paper | jq -r '.versions[]')
versions_combined=""
for version in $versions; do
    versions_combined="$versions_combined $version"
done
echo "Supported versions:$versions_combined"
read -p  "Version:" version


MINECRAFT_VERSION="$version"
PROJECT="paper"

# PaperMC jar dosyasının indirme bağlantısı
JAR_NAME=${PROJECT}-${MINECRAFT_VERSION}-${BUILD_NUMBER}.jar

	BUILD_EXISTS=`curl -s https://api.papermc.io/v2/projects/${PROJECT}/versions/${MINECRAFT_VERSION} | jq -r --arg BUILD ${BUILD_NUMBER} '.builds[] | tostring | contains($BUILD)' | grep -m1 true`
	LATEST_BUILD=`curl -s https://api.papermc.io/v2/projects/${PROJECT}/versions/${MINECRAFT_VERSION} | jq -r '.builds' | jq -r '.[-1]'`
    BUILD_NUMBER=${LATEST_BUILD}

    JAR_NAME=${PROJECT}-${MINECRAFT_VERSION}-${BUILD_NUMBER}.jar

	DOWNLOAD_URL=https://api.papermc.io/v2/projects/${PROJECT}/versions/${MINECRAFT_VERSION}/builds/${BUILD_NUMBER}/downloads/${JAR_NAME}

# PaperMC jar dosyasının indirileceği konum
jar_file="/home/container/server.jar"

# PaperMC jar dosyasını indirme
wget -O $jar_file $DOWNLOAD_URL

# PaperMC sürümünü kontrol et
if [ -f $jar_file ]; then
echo "server-ip: 0.0.0.0" > server.properties
echo "server-port: $SERVER_PORT" >> server.properties
echo "query.port: $SERVER_PORT" >> server.properties
echo "Accept eula? (T/F)"
read -p "Eula (E/H): " eula
lowercase_eula=$(echo "$eula" | tr '[:upper:]' '[:lower:]')

if [[ "$lowercase_eula" == "t" ]]; then
    echo "eula=true" > eula.txt
    # Eğer eula "t" ise yapılacak işlemleri burada belirtebilirsiniz.
else
        echo "eula=false" > eula.txt

    # Eğer eula "t" değilse yapılacak işlemleri burada belirtebilirsiniz.
fi
  echo "Success"
else
  echo "Error"
fi
}
install_forge(){
echo -e "What build type you want to use?"
echo -e "Accepted values is recommended/latest"
read -p "Build Type:" build_type
BUILD_TYPE="$build_type"
echo -e "You choose Forge! What version would you like to install?"
read -p "Minecraft version:" mc_version
MC_VERSION="$mc_version"

FORGE_VERSION="$(echo "$FORGE_VERSION" | tr -d ' ')"


if [[ ! -z ${FORGE_VERSION} ]]; then
  DOWNLOAD_LINK=https://maven.minecraftforge.net/net/minecraftforge/forge/${FORGE_VERSION}/forge-${FORGE_VERSION}
  FORGE_JAR=forge-${FORGE_VERSION}*.jar
else
  JSON_DATA=$(curl -sSL https://files.minecraftforge.net/maven/net/minecraftforge/forge/promotions_slim.json)

  if [[ "${MC_VERSION}" == "latest" ]] || [[ "${MC_VERSION}" == "" ]]; then
    echo -e "getting latest version of forge."
    MC_VERSION=$(echo -e ${JSON_DATA} | jq -r '.promos | del(."latest-1.7.10") | del(."1.7.10-latest-1.7.10") | to_entries[] | .key | select(contains("latest")) | split("-")[0]' | sort -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n | tail -1)
    BUILD_TYPE=latest
  fi

  if [[ "${BUILD_TYPE}" != "recommended" ]] && [[ "${BUILD_TYPE}" != "latest" ]]; then
    BUILD_TYPE=recommended
  fi

  echo -e "minecraft version: ${MC_VERSION}"
  echo -e "build type: ${BUILD_TYPE}"

  ## some variables for getting versions and things
  FILE_SITE=https://maven.minecraftforge.net/net/minecraftforge/forge/
  VERSION_KEY=$(echo -e ${JSON_DATA} | jq -r --arg MC_VERSION "${MC_VERSION}" --arg BUILD_TYPE "${BUILD_TYPE}" '.promos | del(."latest-1.7.10") | del(."1.7.10-latest-1.7.10") | to_entries[] | .key | select(contains($MC_VERSION)) | select(contains($BUILD_TYPE))')

  ## locating the forge version
  if [[ "${VERSION_KEY}" == "" ]] && [[ "${BUILD_TYPE}" == "recommended" ]]; then
    echo -e "dropping back to latest from recommended due to there not being a recommended version of forge for the mc version requested."
    VERSION_KEY=$(echo -e ${JSON_DATA} | jq -r --arg MC_VERSION "${MC_VERSION}" '.promos | del(."latest-1.7.10") | del(."1.7.10-latest-1.7.10") | to_entries[] | .key | select(contains($MC_VERSION)) | select(contains("latest"))')
  fi

  ## Error if the mc version set wasn't valid.
  if [ "${VERSION_KEY}" == "" ] || [ "${VERSION_KEY}" == "null" ]; then
    echo -e "The install failed because there is no valid version of forge for the version of minecraft selected."
    exit 1
  fi

  FORGE_VERSION=$(echo -e ${JSON_DATA} | jq -r --arg VERSION_KEY "$VERSION_KEY" '.promos | .[$VERSION_KEY]')

  if [[ "${MC_VERSION}" == "1.7.10" ]] || [[ "${MC_VERSION}" == "1.8.9" ]]; then
    DOWNLOAD_LINK=${FILE_SITE}${MC_VERSION}-${FORGE_VERSION}-${MC_VERSION}/forge-${MC_VERSION}-${FORGE_VERSION}-${MC_VERSION}
    FORGE_JAR=forge-${MC_VERSION}-${FORGE_VERSION}-${MC_VERSION}.jar
    if [[ "${MC_VERSION}" == "1.7.10" ]]; then
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

if [[ ! -z "${DOWNLOAD_LINK}" ]]; then
  if curl --output /dev/null --silent --head --fail ${DOWNLOAD_LINK}-installer.jar; then
    echo -e "installer jar download link is valid."
  else
    echo -e "link is invalid. Exiting now"
    exit 2
  fi
else
  echo -e "no download link provided. Exiting now"
  exit 3
fi

curl -s -o installer.jar -sS ${DOWNLOAD_LINK}-installer.jar

#Checking if downloaded jars exist
if [[ ! -f ./installer.jar ]]; then
  echo "!!! Error downloading forge version ${FORGE_VERSION} !!!"
  exit
fi

function  unix_args {
  echo -e "Detected Forge 1.17 or newer version. Setting up forge unix args."
  ln -sf libraries/net/minecraftforge/forge/*/unix_args.txt unix_args.txt
}

# Delete args to support downgrading/upgrading
rm -rf libraries/net/minecraftforge/forge
rm unix_args.txt

#Installing server
echo -e "Installing forge server.\n"
java -jar installer.jar --installServer || { echo -e "\nInstall failed using Forge version ${FORGE_VERSION} and Minecraft version ${MINECRAFT_VERSION}.\nShould you be using unlimited memory value of 0, make sure to increase the default install resource limits in the Wings config or specify exact allocated memory in the server Build Configuration instead of 0! \nOtherwise, the Forge installer will not have enough memory."; exit 4; }

# Check if we need a symlink for 1.17+ Forge JPMS args
if [[ $MC_VERSION =~ ^1\.(17|18|19|20|21|22|23) || $FORGE_VERSION =~ ^1\.(17|18|19|20|21|22|23) ]]; then
  unix_args

# Check if someone has set MC to latest but overwrote it with older Forge version, otherwise we would have false positives
elif [[ $MC_VERSION == "latest" && $FORGE_VERSION =~ ^1\.(17|18|19|20|21|22|23) ]]; then
  unix_args
else
  # For versions below 1.17 that ship with jar
  mv $FORGE_JAR $SERVER_JARFILE
fi

echo -e "Deleting installer.jar file.\n"
rm -rf installer.jar
echo -e "Installation process is completed"


}
install_mta_sa(){
rm -f multitheftauto_linux.tar.gz
wget https://linux.mtasa.com/dl/multitheftauto_linux.tar.gz
tar -xf multitheftauto_linux.tar.gz
rm -f baseconfig.tar.gz
wget https://linux.mtasa.com/dl/baseconfig.tar.gz
tar -xf baseconfig.tar.gz
mv baseconfig/* multitheftauto_linux/mods/deathmatch
cd multitheftauto_linux
mkdir mods/deathmatch/resources
cd mods/deathmatch/resources
rm -f mtasa-resources-latest.zip
wget https://mirror.mtasa.com/mtasa/resources/mtasa-resources-latest.zip
unzip mtasa-resources-latest.zip
rm -f mtasa-resources-latest.zip
cd /home/container
echo "Deleting Old files"
rm .wget-hsts
rm multitheftauto_linux.tar.gz
rm baseconfig.tar.gz
rm -rf baseconfig
mv  multitheftauto_linux/* ./
rm -rf multitheftauto_linux
echo "OK"
}
install_samp(){
wget http://files.sa-mp.com/samp037svr_R2-1.tar.gz
tar -zxvf samp037svr_R2-1.tar.gz
mv /home/container/samp03/* /home/container/
rm -rf samp037svr_R2-1.tar.gz
rm -rf  /home/container/samp03
sed -i 's/rcon_password .*/rcon_password newpassword/' server.cfg
sed -i 's/port .*/port ${SERVER_PORT}/' server.cfg
new_port="${SERVER_PORT}"
sed -i 's/^port .*/port '"$new_port"'/' server.cfg
exit 0
}


function installPythonPackage() {
    read -p "Enter package name" package_name
    echo "Installing package: $package_name"
    pip install "$package_name"
}

function installNodeJSPackage() {
    read -p "Yüklemek istediğiniz Node.js paketinin adını girin: " package_name
    echo "Node.js paketi yükleniyor: $package_name"
    npm install "$package_name"
}

function installNodeJSPackagesFromPackageJson() {
    echo "Node.js paketleri package.json dosyasından yükleniyor..."
    npm install
}


function installPythonPackagesFromRequirementsTxt() {
    echo "Python paketleri requirements.txt dosyasından yükleniyor..."
    pip install -r requirements.txt
}



print_aqua_ascii() {
  echo -e "${aqua_color}$1${reset_color}"
}

# ASCII sanatını değişkene atayın

bot_menu(){
echo "Please choose the number and press enter"
echo "1) Start NodeJS Server"
echo "2) Start Python Server"
echo "3) Install Python package"
echo "4) Install NodeJS package"
echo "5) Install NodeJS packages from package.json"
echo "6) Install Python packages from requirements.txt"
echo "7) Exit"

read -p "Select:" choice_bot
case $choice_bot in

1) echo "Starting NodeJs Server" 
run_server "node" ;;
2) echo "Starting Python Server"
run_server "py" ;;
3) echo "Enter python package name"
installPythonPackage 
;;
4) echo "Enter node package name"
installNodeJSPackage
;;
5) echo "Installing"
installNodeJSPackagesFromPackageJson
;;
6)echo "Installing"
installPythonPackagesFromRequirementsTxt
;;
7) exit 0
;;

esac

}

menu(){



  echo "Please choose the number and press enter or send, and it will download it for you"
  echo "1) Minecraft Java              4) Voice                      7) Proxy                     10) Exit"
  echo "2) Minecraft Pocket/Bedrock    5) Discord Bot Hosting        8) Database"
  echo "3) GTA                         6) Terraria                   9) Others"
  echo -n "Select: "


read -p "Please choose an option (1-10): " choice

case $choice in
    1)
        echo "1) PaperMC 2) Magma  3) Fabric 4) Vanilla 5) Forge 6) Exit"
        read -p "Enter your choice (1-6): " choice_mcjava
        case "$choice_mcjava" in
            1)
                install_paper
                ;;
            2)
                install_magma
                ;;
            3)
                install_fabric
                ;;
            4)
                install_vanilla
                ;;
            5)
                echo -e "${color_red}This feature is temporarily disabled"
                ;;
            6)
                exit 3
                ;;
            *)
                echo "Invalid choice. Please enter 1, 2, 3, 4, 5, or 6."
                exit 1
                ;;
        esac
        ;;
    2)
        echo "1) Cloudburst               4) PMMP                     7) Altay"
		echo "2) JSPrismarine             5) PMMP Zekkou Cake         8) Vanilla Bedrock"
		echo "3) PowerNukkit              6) Altay Development Build  9) Exit"
        read -p "Enter your choice (1-6): " choice_mcbedrock
    
        ;;
    3)
        echo "You selected 3) GTA"
      echo '1) SA:MP'
	   echo '2) MTA:SA'
      read -p "Select:" choice_gta
      case "$choice_gta" in
      1)
        install_samp
        ;;
      2)
    	install_mta_sa
      ;;
      esac
       ;;
    4)
        echo "Downloading Voice server..."
        sleep 2
        echo "Download complete!"
        ;;
    5)
    	echo bot > bot
        ;;
    6)
        echo "Downloading Terraria server..."
        sleep 2
        echo "Download complete!"
        ;;
    7)
        echo "Downloading Proxy server..."
        sleep 2
        echo "Download complete!"
        ;;
    8)
        echo "Downloading Database files..."
        sleep 2
        echo "Download complete!"
        ;;
    9)
        echo "1) Nginx  2) Counter-Strike"
        read -p "Enter your choice (1-2): " choice_other
        case "$choice_other" in
            1)
                install_nginx
                ;;
            2)
                install_counter-strike
                ;;
            *)
                echo "Invalid choice. Please enter 1 or 2."
                exit 1
                ;;
        esac
        ;;
    10)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid choice! Please choose a valid option (1-10)."
        sleep 2
        ;;
esac

}

run_server(){
echo ")! For help, type "
clear
 case $1 in
        "cs")
		./hlds_run  +maxplayers 32 -game cstrike +map fy_iceworld16 -port 1026 +sv_lan 0 +sys_ticrate 1000 +fps_max 0 -pingboost 2 -noipx -tos -insecure
            ;;
        "mc")""
		java -Xms128M -XX:MaxRAMPercentage=95.0 -Dterminal.jline=false -Dterminal.ansi=true -jar server.jar
		;;
        "mta")
            ./mta-server --port ${SERVER_PORT} --httpport 27019 --aseport 27199  -n
            ;;
        "samp")
           ./samp03svr
           ;;
        "node")
           node ${BOT_FILE}
           ;;   
         "py")
           python3 ${BOT_FILE}
           ;; 
        *)
            echo "Geçersiz argüman: $1"
            ;;
    esac
}
destination_folder="/home/container/temp"
root_dir="/home/container"

check_file(){

if [ -f "$root_dir/hlds_run" ]; then
  file="cs"
elif [ -f  "$root_dir/server.jar" ]; then
  file="server.jar"
elif [ -f  "$root_dir/mta-server" ]; then
  file="mta"
elif [ -f  "$root_dir/samp03svr" ]; then
  file="samp"
elif [ -f  "$root_dir/bot" ]; then
  file="bot"
else
  file=""
fi



case $file in
  cs) echo "Counter-Strike Starting.."
  run_server "cs"
  ;;
  server.jar) echo "Minecraft Starting..."
  run_server "mc" ;;
  mta) run_server "mta" ;;
  samp) echo "Samp bulundu" 
  run_server "samp"  ;;
  bot) bot_menu
  ;;
  *)  menu ;;
esac
}


install_nginx() {
    echo "Nginx sunucusu yükleniyor..."
    # Burada Nginx'in yüklendiği komutları yazabilirsiniz
    echo "Nginx başarıyla yüklendi."
}



install_others() {
    echo "Seçilen sunucu türü desteklenmiyor veya listede yok."
    echo "Lütfen geçerli bir sunucu türü seçin."
}



main(){
 clear
 machine_id=$P_SERVER_UUID
  echo -e "${aqua_color}==============================="
  echo -e "${aqua_color}| RAM:  ${SERVER_MEMORY} MB"
  echo -e "${aqua_color}| IP: ${SERVER_IP}"
  echo -e "${aqua_color}| Server UUID: ${machine_id}"
  echo -e "${aqua_color}==============================="
  echo "              _ _   _         __           "
  echo "  /\/\\  _   _| | |_(_)       /__\\_ _  __ _ "
  echo " /    \| | | | | __| |_____ /_\/ _\` |/ _\` |"
  echo "/ /\/\\ \\ |_| | | |_| |_____//_| (_| | (_| |"
  echo "\\/    \\/\__,_|_|\\__|_|     \\__/\__, |\\__, |"
  echo "                               |___/ |___/ "

  echo -e "${aqua_color}==============================="
  echo -e "${aqua_color}| Starting...."
  echo -e "${aqua_color}===============================${reset_color}"

check_file
}
#bot_menu
main




