#!/bin/bash

RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${BLUE}[Wings Builder]:${NC} ${RED}Do you want to download the code from (https://github.com/pterodactyl/wings/) (Y/N)${NC}"
read -n 1 -r response
echo

if [[ $response =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}[Wings Builder]:${GREEN}Downloading Wings...${NC}"
    sudo apt install git
    git clone https://github.com/pterodactyl/wings/

    echo -e "${BLUE}[Wings Builder]: Do you want to backup your old Wings install to /usr/local/bin/wings-backup? (Y/N)${NC}"
    read -n 1 -r backup_response
    echo

    if [[ $backup_response =~ ^[Yy]$ ]]; then
        systemctl stop wings
        mv /usr/local/bin/wings /usr/local/bin/wings-backup
    fi

    cd wings || exit 1
    go build
    cp ./wings /usr/local/bin

    echo -e "${BLUE}[Wings Builder]: Do you want to run Wings debug? (wings --debug) (Y/N)${NC}"
    read -n 1 -r debug_response
    echo

    if [[ $debug_response =~ ^[Yy]$ ]]; then
        wings --debug
        echo -e "${BLUE}[Wings Builder]:${RED} You will need to systemctl start wings once finished."
    else
        systemctl start wings
    fi

    echo -e "${BLUE}[Wings Builder]: ${GREEN}Wings build completed and started. See status with systemctl status wings${NC}"
elif [[ $response =~ ^[Nn]$ ]]; then
    echo -e "${BLUE}[Wings Builder]: ${RED}Wings build cancelled.${NC}"
else
    echo -e "${BLUE}[Wings Builder]: ${RED}Invalid input. Please enter Y or N.${NC}"
fi
