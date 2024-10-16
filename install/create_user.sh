#!/bin/env bash

##################################################################################
# This is the entry point for configuring the system.                            #
# Source https://mailinabox.email/ https://github.com/mail-in-a-box/mailinabox   #
# Updated by Afiniel for yiimpool use...                                         #
##################################################################################

source /etc/yiimpoolversion.conf
source /etc/functions.sh
cd ~/Yiimpoolv1/install
clear

# Welcome
message_box "Yiimpool Installer $VERSION" \
"Hello and thanks for using the Yiimpool Yiimp Installer!
\n\nInstallation for the most part is fully automated. In most cases any user responses that are needed are asked prior to the installation.
\n\nNOTE: You should only install this on a brand new Ubuntu 20.04 , Ubuntu 18.04 or Ubuntu 16.04 installation."

# Root warning message box
message_box "Yiimpool Installer $VERSION" \
"WARNING: You are about to run this script as root!
\n\n The program will create a new user account with sudo privileges. 
\n\nThe next step, you will be asked to create a new user account, you can name it whatever you want."

# Ask if SSH key or password user
dialog --title "Create New User With SSH Key" \
--yesno "Do you want to create new user with SSH key login?
Selecting no will create user with password login only." 7 60
response=$?
case $response in
0) UsingSSH=yes ;;
1) UsingSSH=no ;;
255) echo "[ESC] key pressed." ;;
esac

# If Using SSH Key Login
if [[ ("$UsingSSH" == "yes") ]]; then
    clear
    if [ -z "${yiimpadmin:-}" ]; then
        DEFAULT_yiimpadmin=yiimpadmin
        input_box "New username" \
            "Please enter your new  username.
      \n\nUser Name:" \
            ${DEFAULT_yiimpadmin} \
            yiimpadmin

        if [ -z "${yiimpadmin}" ]; then
            # user hit ESC/cancel
            exit
        fi
    fi

    if [ -z "${ssh_key:-}" ]; then
        DEFAULT_ssh_key=PublicKey
        input_box "Please open PuTTY Key Generator on your local machine and generate a new public key." \
            "To paste your Public key use ctrl shift right click.
      \n\nPublic Key:" \
            ${DEFAULT_ssh_key} \
            ssh_key

        if [ -z "${ssh_key}" ]; then
            # user hit ESC/cancel
            exit
        fi
    fi

    # create random user password
    RootPassword=$(openssl rand -base64 8 | tr -d "=+/")
    clear

    # Add user
    echo -e "$YELLOW => Adding new user and setting SSH key... <= ${NC}"
    sudo adduser ${yiimpadmin} --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
    echo -e "${RootPassword}\n${RootPassword}" | passwd ${yiimpadmin}
    sudo usermod -aG sudo ${yiimpadmin}
    
    # Create SSH Key structure
    mkdir -p /home/${yiimpadmin}/.ssh
    touch /home/${yiimpadmin}/.ssh/authorized_keys
    chown -R ${yiimpadmin}:${yiimpadmin} /home/${yiimpadmin}/.ssh
    chmod 700 /home/${yiimpadmin}/.ssh
    chmod 644 /home/${yiimpadmin}/.ssh/authorized_keys
    authkeys=/home/${yiimpadmin}/.ssh/authorized_keys
    echo "$ssh_key" >"$authkeys"

    # enabling yiimpool command
    echo '# yiimp
  # It needs passwordless sudo functionality.
  '""''"${yiimpadmin}"''""' ALL=(ALL) NOPASSWD:ALL
  ' | sudo -E tee /etc/sudoers.d/${yiimpadmin} >/dev/null 2>&1

    echo '
  cd ~/Yiimpoolv1/install
  bash start.sh
  ' | sudo -E tee /usr/bin/yiimpool >/dev/null 2>&1
    sudo chmod +x /usr/bin/yiimpool

    # Check required files and set global variables
    cd $HOME/Yiimpoolv1/install
    source pre_setup.sh

    # Create the STORAGE_USER and STORAGE_ROOT directory if they don't already exist.
    if ! id -u $STORAGE_USER >/dev/null 2>&1; then
        sudo useradd -m $STORAGE_USER
    fi
    if [ ! -d $STORAGE_ROOT ]; then
        sudo mkdir -p $STORAGE_ROOT
    fi
    sudo usermod -aG $STORAGE_ROOT $yiimpadmin

    # Save the global options in /etc/yiimpool.conf so that standalone
    # tools know where to look for data.
    echo 'STORAGE_USER='"${STORAGE_USER}"'
    STORAGE_ROOT='"${STORAGE_ROOT}"'
    PUBLIC_IP='"${PUBLIC_IP}"'
    PUBLIC_IPV6='"${PUBLIC_IPV6}"'
    DISTRO='"${DISTRO}"'
    PRIVATE_IP='"${PRIVATE_IP}"'' | sudo -E tee /etc/yiimpool.conf >/dev/null 2>&1

    # Set Donor Addresses
    echo 'BTCDON="bc1q582gdvyp09038hp9n5sfdtp0plkx5x3yrhq05y"
    LTCDON="ltc1qqw7cv4snx9ctmpcf25x26lphqluly4w6m073qw"
    ETHDON="0x50C7d0BF9714dBEcDc1aa6Ab0E72af8e6Ce3b0aB"
    BCHDON="qzz0aff2k0xnwyzg7k9fcxlndtaj4wa65uxteqe84m"
    DOGEDON="DSzcmyCRi7JeN4XUiV2qYhRQAydNv7A1Yb"' | sudo -E tee /etc/yiimpooldonate.conf >/dev/null 2>&1

    sudo cp -r ~/Yiimpoolv1 /home/${yiimpadmin}/
    cd ~
    sudo setfacl -m u:${yiimpadmin}:rwx /home/${yiimpadmin}/Yiimpoolv1
    sudo rm -r $HOME/yiimpool
    clear
    term_art
    echo
    echo -e "${YELLOW}Setup information:$NC"
    echo
    echo -e "${MAGENTA}USERNAME: ${GREEN}${yiimpadmin}$NC"
    echo -e "${MAGENTA}STORAGE_USER: ${GREEN}${STORAGE_USER}$NC"
    echo -e "${MAGENTA}STORAGE_ROOT: ${GREEN}${STORAGE_ROOT}$NC"
    echo -e "${MAGENTA}PUBLIC_IPV6: ${GREEN}${PUBLIC_IPV6}$NC"
    echo -e "${MAGENTA}DISTRO: ${GREEN}${DISTRO}$NC"
    echo -e "${MAGENTA}FIRST_TIME_SETUP: ${GREEN}${FIRST_TIME_SETUP}$NC"
    echo
    echo -e "$YELLOW New User:$MAGENTA ${yiimpadmin} $GREEN created!$YELLOW Make sure you save your$RED private key!${NC}"
    echo
    echo -e "$RED Please reboot the system and log in as$GREEN ${yiimpadmin} $YELLOW and type$GREEN yiimpool$YELLOW to$GREEN continu$YELLOW setup...$NC"
    exit 0
fi

# New User Password Login Creation
if [ -z "${yiimpadmin:-}" ]; then
    DEFAULT_yiimpadmin=yiimpadmin
    input_box "Creaete new username" \
        "Please enter your new username.
  \n\nUser Name:" \
        ${DEFAULT_yiimpadmin} \
        yiimpadmin

    if [ -z "${yiimpadmin}" ]; then
        # user hit ESC/cancel
        exit
    fi
fi

if [ -z "${RootPassword:-}" ]; then
    DEFAULT_RootPassword=$(openssl rand -base64 8 | tr -d "=+/")
    input_box "User Password" \
        "Enter your new user password or use this randomly system generated one.
  \n\nUnfortunatley dialog doesnt let you copy. So you have to write it down.
  \n\nUser password:" \
        ${DEFAULT_RootPassword} \
        RootPassword

    if [ -z "${RootPassword}" ]; then
        # user hit ESC/cancel
        exit
    fi
fi

clear

dialog --title "Verify Your input" \
    --yesno "Please verify your answers before you continue:
New User Name : ${yiimpadmin}
New User Pass : ${RootPassword}" 8 60

# Get exit status
# 0 means user hit [yes] button.
# 1 means user hit [no] button.
# 255 means user hit [Esc] key.
response=$?
case $response in

0)
    clear
    echo -e "$YELLOW => Adding new user and password... <= ${NC}"

    sudo adduser ${yiimpadmin} --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
    echo -e ""${RootPassword}"\n"${RootPassword}"" | passwd ${yiimpadmin}
    sudo usermod -aG sudo ${yiimpadmin}

    # enabling yiimpool command
    echo '# yiimp
    # It needs passwordless sudo functionality.
    '""''"${yiimpadmin}"''""' ALL=(ALL) NOPASSWD:ALL
    ' | sudo -E tee /etc/sudoers.d/${yiimpadmin} >/dev/null 2>&1

    echo '
    cd ~/Yiimpoolv1/install
    bash start.sh
    ' | sudo -E tee /usr/bin/yiimpool >/dev/null 2>&1
    sudo chmod +x /usr/bin/yiimpool

    # Check required files and set global variables
    cd $HOME/Yiimpoolv1/install
    source pre_setup.sh

    # Create the STORAGE_USER and STORAGE_ROOT directory if they don't already exist.
    if ! id -u $STORAGE_USER >/dev/null 2>&1; then
        sudo useradd -m $STORAGE_USER
    fi
    if [ ! -d $STORAGE_ROOT ]; then
        sudo mkdir -p $STORAGE_ROOT
    fi

    # Save the global options in /etc/yiimpool.conf so that standalone
    # tools know where to look for data.
    echo 'STORAGE_USER='"${STORAGE_USER}"'
    STORAGE_ROOT='"${STORAGE_ROOT}"'
    PUBLIC_IP='"${PUBLIC_IP}"'
    PUBLIC_IPV6='"${PUBLIC_IPV6}"'
    DISTRO='"${DISTRO}"'

    PRIVATE_IP='"${PRIVATE_IP}"'' | sudo -E tee /etc/yiimpool.conf >/dev/null 2>&1

    # Set Donor Addresses
    echo 'BTCDON="bc1q582gdvyp09038hp9n5sfdtp0plkx5x3yrhq05y"
    LTCDON="ltc1qqw7cv4snx9ctmpcf25x26lphqluly4w6m073qw"
    ETHDON="0x50C7d0BF9714dBEcDc1aa6Ab0E72af8e6Ce3b0aB"
    BCHDON="qzz0aff2k0xnwyzg7k9fcxlndtaj4wa65uxteqe84m"
    DOGEDON="DSzcmyCRi7JeN4XUiV2qYhRQAydNv7A1Yb"' | sudo -E tee /etc/yiimpooldonate.conf >/dev/null 2>&1

    sudo cp -r ~/Yiimpoolv1 /home/${yiimpadmin}/
    cd ~
    sudo setfacl -m u:${yiimpadmin}:rwx /home/${yiimpadmin}/Yiimpoolv1
    sudo rm -r $HOME/Yiimpoolv1
    clear
    term_art
    echo
    echo -e "${YELLOW}Setup information:$NC"
    echo
    echo -e "${MAGENTA}USERNAME: ${GREEN}${yiimpadmin}$NC"
    echo -e "${MAGENTA}STORAGE_USER: ${GREEN}${STORAGE_USER}$NC"
    echo -e "${MAGENTA}STORAGE_ROOT: ${GREEN}${STORAGE_ROOT}$NC"
    echo -e "${MAGENTA}PUBLIC_IPV6: ${GREEN}${PUBLIC_IPV6}$NC"
    echo -e "${MAGENTA}DISTRO: ${GREEN}${DISTRO}$NC"
    echo -e "${MAGENTA}FIRST_TIME_SETUP: ${GREEN}${FIRST_TIME_SETUP}$NC"
    echo -e "${MAGENTA}PRIVATE_IP: ${GREEN}${PRIVATE_IP}$NC"
    echo -e "$YELLOW New User:$MAGENTA ${yiimpadmin} $GREEN created$RED $NC"
    echo
    echo -e "$RED Please reboot the system and log in as$GREEN ${yiimpadmin} $YELLOW and type$GREEN yiimpool$YELLOW to$GREEN continu$YELLOW setup...$NC"
    exit 0
    ;;

1)

    clear
    bash $(basename $0) && exit
    ;;

255) ;;

esac
