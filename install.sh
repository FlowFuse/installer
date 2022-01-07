#!/bin/bash

echo "**************************************************************"
echo "* FlowForge Installer                                        *"
echo "*                                                            *"
echo "* Warning:                                                   *"
echo "* If this script needs to install NodeJS it may ask for your *"
echo "* password in able to run some commands as root.             *"
echo "*                                                            *"
echo "**************************************************************"

realpath() {
  OURPWD=$PWD
  cd "$(dirname "$1")"
  LINK=$(readlink "$(basename "$1")")
  while [ "$LINK" ]; do
    cd "$(dirname "$LINK")"
    LINK=$(readlink "$(basename "$1")")
  done
  REALPATH="$PWD/$(basename "$1")"
  cd "$OURPWD"
  echo "$REALPATH"
}

DIR="$(dirname "$(realpath "$0")")"

MIN_NODEJS=16

case "$OSTYPE" in
  darwin*) 
    MYOS=darwin
  ;;
  linux*)
    MYOS=$(cat /etc/os-release | grep "^ID=" | cut -d = -f 2 | tr -d '"')
  ;;
  *) 
    # unknown OS
  ;;
esac

createUser() {
  if [[ "$MYOS" == "debian" ]] || [[ "$MYOS" == "ubuntu" ]] || [[ "$MYOS" == "raspbian" ]]; then
    sudo adduser --system --home $DIR --group --no-create-home --disabled-login --disabled-password --quiet flowforge
  elif [[ "$MYOS" == "rhel" ]] || [[ "$MYOS" == "centos" || "$MYOS" == "amzn" || "$MYOS" == "fedora" ]]; then
    sudo adduser --system --home $DIR --no-create-home -U -s /sbin/nologin flowforge
  fi

  return $?
}


if [ -x "$(command -v node)" ]; then
  echo NodeJS found
  VERSION=`node --version | cut -d "." -f1 | cut -d "v" -f2`
  if [[ $VERSION -ge $MIN_NODEJS ]]; then
    echo "**************************************************************"
    echo "* NodeJS Version $MIN_NODEJS or newer found                           *"
    echo "**************************************************************"
  else
    echo "**************************************************************"
    echo "* You need NodeJS $MIN_NODEJS or newer, please upgrade                *"
    echo "**************************************************************"
    exit 1
  fi
else
  echo "**************************************************************"
  echo "* No NodeJS found                                            *"
  echo "* Do you want to install NodeJS $MIN_NODEJS?                            *"
  echo "**************************************************************"
  read -p "y/N: " yn
  if [ -x "${yn}"]; then
    yn=n
  fi
  if [[ "$yn" == "y" ]] || [[ "$yn" == "Y" ]]; then 
    if [[ "$MYOS" == "debian" ]] || [[ "$MYOS" == "ubuntu" ]] || [[ "$MYOS" == "raspbian" ]]; then
      curl -sSL "https://deb.nodesource.com/setup_$MIN_NODEJS.x" | sudo -E bash -
      sudo apt-get install -y nodejs build-essential
    elif [[ "$MYOS" == "fedora" ]]; then
      sudo dnf module reset -y nodejs
      sudo dnf module install -y "nodejs:$MIN_NODEJS/default"
      sudo dnf group install -y "C Development Tools and Libraries"
    elif [[ "$MYOS" == "rhel" ]] || [[ "$MYOS" == "centos" || "$MYOS" == "amzn" ]]; then
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
      echo "* - RasberryPi OS/Raspbain                                   *"
      echo "* - Debian                                                   *"
      echo "* - Ubuntu                                                   *"
      echo "* - Fedora                                                   *"
      echo "* - CentOS                                                   *"
      echo "* - RHEL                                                     *"
      echo "* - Amazon Linux 2                                           *"
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

npm install --production --@flowforge:registry=https://npm.hardill.me.uk --no-fund --no-audit --silent

if [[ "$OSTYPE" == linux* ]]; then
  if [ -x "$(command -v systemctl)" ]; then

    echo "**************************************************************"
    echo "* Do you want to run FlowForge as a service?                 *"
    echo "**************************************************************"
    read -p "Y/n: " yn
    if [ -z "${yn}" ]; then
      yn=Y
    fi
    if [[ "$yn" == "y" ]] || [[ "$yn" == "Y" ]]; then 

      echo "**************************************************************"
      echo "* Do you want to run FlowForge as the current user ($USER)   *"
      echo "* or create a flowforge user?                                *"
      echo "**************************************************************"

      read -p "Current/FlowForge (C/f): " cf
      if [[ "$cf" == "c" ]] || [[ "$cf" == "C" ]]; then

        FF_USER=`id -u -n`
        FF_GROUP=`id -g -n`

      elif [[ "$cf" == "f" ]] || [[ "$cf" == "F" ]]; then
        echo "Using sudo to create a new user, please enter password if asked"

        if createUser; then
          FF_USER=flowforge
          FF_GROUP=flowforge
          sudo chown -R $FF_USER .
        else
          echo "**************************************************************"
          echo "* Failed to create flowforge user                            *"
          echo "**************************************************************"
          exit 1
        fi
      else
        # unknown value
        echo "**************************************************************"
        echo "* Not C or F                                                 *"
        echo "**************************************************************"
        exit 1
      fi 
      
      sed 's!/opt/flowforge!'$DIR'!;s!User=pi!User='$FF_USER'!;s!Group=pi!Group='$FF_GROUP'!' systemd/flowforge.service-skel > systemd/flowforge.service

      
      if [[ "$MYOS" == "debian" ]] || [[ "$MYOS" == "ubuntu" ]] || [[ "$MYOS" == "raspbian" ]]; then
        #Debian/Ubuntu /lib/systemd/system/
        sudo cp systemd/flowforge.service /lib/systemd/system/
      elif [[ "$MYOS" == "rhel" ]] || [[ "$MYOS" == "centos" || "$MYOS" == "amzn" || "$MYOS" == "fedora" ]]; then
        #RHEL/Fedora /etc/systemd/system/
        sudo cp systemd/flowforge.service /etc/systemd/system/
      fi

      sudo systemctl daemon-reload

      echo "**************************************************************"
      echo "* Service installed but not started, to start run the        *"
      echo "* following: service flowforge start                         *"
      echo "**************************************************************"

    fi
  fi
fi