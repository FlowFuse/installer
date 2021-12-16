#!/bin/bash

echo "**************************************************************"
echo "* FlowForge Installer                                        *"
echo "*                                                            *"
echo "* Warning:                                                   *"
echo "* If this script needs to install NodeJS it may ask for your *"
echo "* password in able to run some commands as root.             *"
echo "*                                                            *"
echo "**************************************************************"

MIN_NODEJS=16

case "$OSTYPE" in
  darwin*) 
    MYOS=darwin
  ;;
  linux*)
    MYOS=$(cat /etc/*-release | grep "^ID=" | cut -d = -f 2)
  ;;
  *) 
    # unknown OS
  ;;
esac

if [ -x "$(command -v node)" ]; then
  echo NodeJS found
  VERSION=`node --version | cut -d "." -f1 | cut -d "v" -f2`
  if [[ $VERSION -ge $MIN_NODEJS ]]; then
    echo "**************************************************************"
    echo "* NodeJS Version $MIN_NODEJS or newer found                          *"
    echo "**************************************************************"
  else
    echo "**************************************************************"
    echo "* You need NodeJS $MIN_NODEJS or newer, please upgrade               *"
    echo "**************************************************************"
    exit 1
  fi
else
  echo "**************************************************************"
  echo "* No NodeJS found                                            *"
  echo "* Do you want to install NodeJS $MIN_NODEJS?                           *"
  echo "**************************************************************"
  read -p "y/N" yn
  if [[ "$yn" == "y" ]] || [[ "$yn" == "Y" ]]; then 
    if [[ "$MYOS" == "debian" ]] || [[ "$MYOS" == "ubuntu" ]] || [[ "$MYOS" == "raspbian" ]]; then
      curl -sSL "https://deb.nodesource.com/setup_$MIN_NODEJS.x" | sudo -E bash -
      sudo apt-get install -y nodejs build-essential
    elif [[ "$MYOS" == "fedora" ]]; then
      sudo dnf module reset -y nodejs
      sudo dnf module install -y "nodejs:$MIN_NODEJS/default"
      sudo dnf group install -y "C Development Tools and Libraries"
    elif [[ "$MYOS" == "rhel" ]] || [[ "$MYOS" == "centos"  ]]; then
      curl -fsSL "https://rpm.nodesource.com/setup_$MIN_NODEJS.x" | sudo -E bash -
      sudo yum install -y nodejs
      sudo yum group install -y "Development Tools"
    elif [[ "$MYOS" == "darwin" ]]; then
      echo "**************************************************************"
      echo "* On OSx you will need to manually install NodeJS            *"
      echo "* Please install the latest LTS release from:                *"
      echo "* https://nodejs.org/en/download/                            *"
      echo "**************************************************************"
      exit 1
    else
      echo "**************************************************************"
      echo "* Unkown OS $MYOS                                            *"
      echo "* Currently supporting:                                      *"
      echo "* - Debian                                                   *"
      echo "* - Fedora                                                   *"
      echo "* - CentOS                                                   *"
      echo "* - RHEL                                                     *"
      echo "* - OSx                                                      *"
      echo "**************************************************************"
      exit 1 
    fi
  else
    echo "**************************************************************"
    echo "* You will need to manually install NodeJS first             *"
    echo "* exiting                                                    *"
    echo "**************************************************************"
    exit 1
  fi
fi

if [ -x "$(command -v npm)" ]; then
  echo "**************************************************************"
  echo "* npm found                                                  *"
  echo "**************************************************************"
  npm --version
else
  echo "**************************************************************"
  echo "* No npm found exiting                                       *"
  echo "**************************************************************"
  exit 1
fi

#clean up for upgrades
rm -rf node_modules package-lock.json

echo "**************************************************************"
echo "* Installing FlowForge                                       *"
echo "**************************************************************"

npm install --production --@flowforge:registry=https://npm.hardill.me.uk --no-fund --no-audit
