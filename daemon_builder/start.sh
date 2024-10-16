#!/bin/env bash

##################################################################################
# This is the entry point for configuring the system.                            #
# Source https://mailinabox.email/ https://github.com/mail-in-a-box/mailinabox   #
# Updated by Afiniel for yiimpool use...                                         #
##################################################################################

source /etc/functions.sh
source /etc/yiimpool.conf

# Create DaemonBuilder directory
if [ ! -d $STORAGE_ROOT/daemon_builder ]; then
sudo mkdir -p $STORAGE_ROOT/daemon_builder
fi

# Start the DeamonBuilder installation.
cd $HOME/Yiimpoolv1/daemon_builder
source requirements.sh

cd $HOME/Yiimpoolv1/yiimp_single
