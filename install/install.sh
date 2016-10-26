#!/bin/sh
WHOAMI="$(whoami)"
#echo "${WHOAMI}"

UNAME="$(uname -a)"
echo "${UNAME}"

OS="UNKNOWN"

GCCVERSION="$(gcc --version)"
#echo "${GCCVERSION}"

echo "First we install NodeJS..."

if [[ $UNAME == *"Darwin"* ]]; then
    echo " for Mac";
    OS="MAC";

    #First we homebrew
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew install nodejs

    #First we Node...
    #curl "https://nodejs.org/dist/latest/node-${VERSION:-$(wget -qO- https://nodejs.org/dist/latest/ | sed -nE 's|.*>node-(.*)\.pkg</a>.*|\1|p')}.pkg" > "$HOME/Downloads/node-latest.pkg" && sudo installer -store -pkg "$HOME/Downloads/node-latest.pkg" -target "/"
    
    #TODO: Need to be able to reboot from within Node
    #?? sudo setcap CAP_SYS_BOOT=+ep /usr/local/bin/node
    sudo cat >> filename /etc/sudoers.d/pi "pi ALL=/sbin/shutdown"
    sudo cat >> filename /etc/sudoers.d/pi "pi ALL=NOPASSWD: /sbin/shutdown"
    sudo cat >> filename /etc/sudoers.d/pi "pi ALL=/etc/init.d/networking"
    sudo cat >> filename /etc/sudoers.d/pi "pi ALL=NOPASSWD: /etc/init.d/networking"

#http://askubuntu.com/questions/450298/how-to-get-ubuntu-distributions-full-code-name
elif [[ -r /etc/os-release ]]; then
#elif [[ $UNAME == *"Linux"* ]]; then
    OS="LINUX";
    echo " for Linux";

    . /etc/os-release

    if [[ $ID = ubuntu ]]; then
        read _ UBUNTU_VERSION_NAME <<< "$VERSION";
        echo "  on Ubuntu $UBUNTU_VERSION_NAME";
    else
        echo "Not running an Ubuntu distribution. ID=$ID, VERSION=$VERSION";
    fi

    LINUXVERSION="$(lsb_release -a)"
    echo "${LINUXVERSION}"

    if [[ $LINUXVERSION == *"wheezy"* ]] \
        || [[ $LINUXVERSION == *"precise"* ]]; then
        echo "Umm... yeah, we're not going to even try to support this. Please upgrade to a newer version..."
    fi

    #Need to be able to reboot from within Node
    echo "Modifying sudoers file /etc/sudoers.d/pi to allow commands to run from api."
    #sudo setcap CAP_SYS_BOOT=+ep /usr/local/bin/node
    sudo cat >> filename /etc/sudoers.d/pi "pi ALL=/sbin/shutdown"
    sudo cat >> filename /etc/sudoers.d/pi "pi ALL=NOPASSWD: /sbin/shutdown"
    sudo cat >> filename /etc/sudoers.d/pi "pi ALL=/etc/init.d/networking"
    sudo cat >> filename /etc/sudoers.d/pi "pi ALL=NOPASSWD: /etc/init.d/networking"

    apt-get update # To get the latest package lists
    apt-get upgrade

    apt-get install avahi-utils
    apt-get install libavahi-compat-libdnssd-dev -y

    CPUINFO="${cat /proc/cpuinfo}";

    #http://elinux.org/RPi_HardwareHistory
    
    #HARDWARE="PI"
    if [[ $CPUINFO == *"Hardware	: BCM2708"* ]] \
        || [[ $CPUINFO == *"Hardware	: BCM2708"* ]] \
        ; then

        echo "Hardware is ARM";
        # HARDWAREVERSION = "B256"; - 0002
        # HARDWAREVERSION = "A256"; - 0007
        # HARDWAREVERSION = "B512"; - 000d
        # HARDWAREVERSION = "BP512"; - 0010
        # HARDWAREVERSION = "CM512"; - 0011
        # HARDWAREVERSION = "AP512"; - 0012
        # HARDWAREVERSION = "BP512"; - 0013
        # HARDWAREVERSION = "CM512"; - 0014
        # HARDWAREVERSION = "CM256"; - 0015
        if
            [[ $CPUINFO == *"Revision	: 0002"* ]] \
            || [[ $CPUINFO == *"Revision	: 0003"* ]] \
            || [[ $CPUINFO == *"Revision	: 0004"* ]] \
            || [[ $CPUINFO == *"Revision	: 0005"* ]] \
            || [[ $CPUINFO == *"Revision	: 0006"* ]] \
            || [[ $CPUINFO == *"Revision	: 0007"* ]] \
            || [[ $CPUINFO == *"Revision	: 0008"* ]] \
            || [[ $CPUINFO == *"Revision	: 0009"* ]] \
            || [[ $CPUINFO == *"Revision	: 000d"* ]] \
            || [[ $CPUINFO == *"Revision	: 000e"* ]] \
            || [[ $CPUINFO == *"Revision	: 000f"* ]] \
            || [[ $CPUINFO == *"Revision	: 0010"* ]] \
            || [[ $CPUINFO == *"Revision	: 0011"* ]] \
            || [[ $CPUINFO == *"Revision	: 0012"* ]] \
            || [[ $CPUINFO == *"Revision	: 0013"* ]] \
            || [[ $CPUINFO == *"Revision	: 0014"* ]] \
            || [[ $CPUINFO == *"Revision	: 0015"* ]] \
            ; then
            echo "ARMv6 Found";
            echo "WARN: Support for this may terminate soon.";

            wget https://nodejs.org/dist/v4.2.1/node-v4.2.1-linux-armv6l.tar.gz;
            tar -xvf node-v4.2.1-linux-armv6l.tar.gz;
            cd node-v4.2.1-linux-armv6l;
            sudo cp -R * /usr/local/;

        # HARDWAREVERSION = "2B1024"; - a01040
        # HARDWAREVERSION = "Z512"; - 900092
        #  HARDWAREVERSION = "3B1024"; - a02082
        elif [[ $CPUINFO == *"Revision	: a01040"* ]] \
            || [[ $CPUINFO == *"Revision	: a01041"* ]] \
            || [[ $CPUINFO == *"Revision	: a21041"* ]] \
            || [[ $CPUINFO == *"Revision	: a22042"* ]] \
            || [[ $CPUINFO == *"Revision	: 900092"* ]] \
            || [[ $CPUINFO == *"Revision	: 900093"* ]] \
            || [[ $CPUINFO == *"Revision	: a02082"* ]] \
            || [[ $CPUINFO == *"Revision	: a22082"* ]] \
            ; then
           
            echo "ARMv7 Found";
            
            #wget https://nodejs.org/dist/v4.2.1/node-v4.2.1-linux-armv7l.tar.gz 
            #tar -xvf node-v4.2.1-linux-armv7l.tar.gz 
            #cd node-v4.2.1-linux-armv7l
            #sudo cp -R * /usr/local/

            sudo apt-get install curl;
            #curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
            #sudo apt-get install --yes nodejs

            curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -;
            sudo apt-get install -y nodejs;
        fi
    fi
fi

npm install -g homebridge --unsafe-perm

#start homebridge
#homebridge