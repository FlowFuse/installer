#!/bin/bash

echo "**************************************************************"
echo " FlowForge Installer                                        "
echo "                                                            "
echo " Warning: "
echo " The install may need root priviledges at times, it uses    "   
echo " sudo so may ask for your password.                         "
echo " root access is used to install NodeJS if needed and to set "
echo " directory pemissions                                       "                                                
echo "                                                            "
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

cd $DIR

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
    echo " NodeJS Version $MIN_NODEJS or newer found "
    echo "**************************************************************"
    if [ ! -x "$(command -v make)" ]; then
      echo "**************************************************************"
      echo " No built tools found. "
      echo " Do you want to install"
      echo "**************************************************************"
      read -p "Y/n" yn
      if [ -x "${yn}" ]; then
        yn=y
      fi
      if [[ "$yn" == "y" ]] || [[ "$yn" == "Y" ]]; then
        if [[ "$MYOS" == "debian" ]] || [[ "$MYOS" == "ubuntu" ]] || [[ "$MYOS" == "raspbian" ]]; then
          sudo apt-get install -y build-essential
        elif [[ "$MYOS" == "fedora" ]]; then
          sudo dnf group install -y "C Development Tools and Libraries"
        fi
      else
        echo "**************************************************************"
        echo " You will need to manually install Build tools first             "
        echo " exiting                                                    "
        echo "**************************************************************"
        exit 1
      fi
    fi
  else
    echo "**************************************************************"
    echo " You need NodeJS $MIN_NODEJS or newer, please upgrade "
    echo "**************************************************************"
    exit 1
  fi
else
  echo "**************************************************************"
  echo " No NodeJS found"
  echo " Do you want to install NodeJS $MIN_NODEJS?"
  echo "**************************************************************"
  read -p "y/N: " yn
  if [ -x "${yn}" ]; then
    yn=n
  fi
  if [[ "$yn" == "y" ]] || [[ "$yn" == "Y" ]]; then 
    if [[ "$MYOS" == "debian" ]] || [[ "$MYOS" == "ubuntu" ]] || [[ "$MYOS" == "raspbian" ]]; then
      if [ ! -x "$(command -v curl)" ]; then
        sudo apt-get install -y curl
      fi
      curl -sSL "https://deb.nodesource.com/setup_$MIN_NODEJS.x" | sudo -E bash -
      sudo apt-get install -y nodejs build-essential
    elif [[ "$MYOS" == "fedora" ]]; then
      sudo dnf module reset -y nodejs
      sudo dnf module install -y "nodejs:$MIN_NODEJS/default"
      sudo dnf group install -y "C Development Tools and Libraries"
    elif [[ "$MYOS" == "rhel" ]] || [[ "$MYOS" == "centos" || "$MYOS" == "amzn" ]]; then
      if [ ! -x "$(command -v curl)" ]; then
        sudo yum install -y curl
      fi
      curl -fsSL "https://rpm.nodesource.com/setup_$MIN_NODEJS.x" | sudo -E bash -
      sudo yum install -y nodejs
      sudo yum group install -y "Development Tools"
    elif [[ "$MYOS" == "darwin" ]]; then
      echo "**************************************************************"
      echo " On OSx you will need to manually install NodeJS            "
      echo " Please install the latest LTS release from:                "
      echo " https://nodejs.org/en/download/                            "
      echo "**************************************************************"
      exit 1
    else
      echo "**************************************************************"
      echo " Unkown OS $MYOS                                            "
      echo " Currently supporting:                                      "
      echo " - RasberryPi OS/Raspbain                                   "
      echo " - Debian                                                   "
      echo " - Ubuntu                                                   "
      echo " - Fedora                                                   "
      echo " - CentOS                                                   "
      echo " - RHEL                                                     "
      echo " - Amazon Linux 2                                           "
      echo " - macOS                                                    "
      echo "**************************************************************"
      exit 1 
    fi
  else
    echo "**************************************************************"
    echo " You will need to manually install NodeJS first             "
    echo " exiting                                                    "
    echo "**************************************************************"
    exit 1
  fi
fi

if [ -x "$(command -v npm)" ]; then
  echo "**************************************************************"
  echo " npm found                                                  "
  echo "**************************************************************"
  npm --version
else
  echo "**************************************************************"
  echo " No npm found exiting                                       "
  echo "**************************************************************"
  exit 1
fi

#ensure executables are executable
echo "**************************************************************"
echo " Setting execute bit on FlowForge binaries, this uses sudo  "
echo " to ensure correct permissions                              "
echo "**************************************************************"
sudo chmod +x $DIR/bin/*

#clean up for upgrades
cd $DIR/app
rm -rf node_modules package-lock.json

echo "**************************************************************"
echo " Installing FlowForge                                       "
echo "**************************************************************"

npm install --production --no-fund --no-audit --silent 

cd ..
if [ ! -f $DIR/etc/flowforge.yml ]; then
  cp $DIR/app/node_modules/@flowforge/flowforge/etc/flowforge.yml $DIR/etc/flowforge.yml
fi
if [ ! -f $DIR/etc/flowforge-storage.yml ]; then
  cp $DIR/app/node_modules/@flowforge/file-server/etc/flowforge-storage.yml $DIR/etc/flowforge-storage.yml
fi

echo "**************************************************************"
echo " Installing latest Node-RED as a stack"
echo "**************************************************************"
$DIR/bin/ff-install-stack.sh latest


if [[ "$OSTYPE" == linux* ]]; then
  if [ -x "$(command -v systemctl)" ]; then

    echo "**************************************************************"
    echo " Do you want to run FlowForge as a service?"
    echo "**************************************************************"
    read -p "Y/n: " yn
    if [ -z "${yn}" ]; then
      yn=Y
    fi
    if [[ "$yn" == "y" ]] || [[ "$yn" == "Y" ]]; then 

      echo "**************************************************************"
      echo " Do you want to run FlowForge as the current user ($USER)   "
      echo " or create a flowforge user?                                "
      if [ $EUID -eq 0  ]; then
        echo " running as root is a really bad idea, please create a new user"
      fi
      echo "**************************************************************"

      read -p "Current/FlowForge (c/F): " cf
      if [ -z "${cf}" ]; then
        cf=F
      fi
      if [[ "$cf" == "c" ]] || [[ "$cf" == "C" ]]; then

        FF_USER=`id -u -n`
        FF_GROUP=`id -g -n`

      elif [[ "$cf" == "f" ]] || [[ "$cf" == "F" ]]; then
        echo "Using sudo to create a new user, please enter password if asked"

        if createUser; then
          FF_USER=flowforge
          FF_GROUP=flowforge
        else
          echo "**************************************************************"
          echo " Failed to create flowforge user                             "
          echo "**************************************************************"
          exit 1
        fi
      else
        # unknown value
        echo "**************************************************************"
        echo " Not C or F                                                  "
        echo "**************************************************************"
        exit 1
      fi 
      
      sed 's!/opt/flowforge!'$DIR'!;s!User=pi!User='$FF_USER'!;s!Group=pi!Group='$FF_GROUP'!' $DIR/etc/systemd/flowforge.service-skel > $DIR/etc/systemd/flowforge.service
      sed 's!/opt/flowforge!'$DIR'!;s!User=pi!User='$FF_USER'!;s!Group=pi!Group='$FF_GROUP'!' $DIR/etc/systemd/flowforge-file.service-skel > $DIR/etc/systemd/flowforge-file.service

      
      if [[ "$MYOS" == "debian" ]] || [[ "$MYOS" == "ubuntu" ]] || [[ "$MYOS" == "raspbian" ]]; then
        #Debian/Ubuntu /lib/systemd/system/
        sudo cp $DIR/etc/systemd/flowforge.service /lib/systemd/system/
      elif [[ "$MYOS" == "rhel" ]] || [[ "$MYOS" == "centos" || "$MYOS" == "amzn" || "$MYOS" == "fedora" ]]; then
        #RHEL/Fedora /etc/systemd/system/
        sudo cp $DIR/etc/systemd/flowforge.service /etc/systemd/system/
      fi

      sudo chown -R $FF_USER $DIR

      sudo -u $FF_USER test -x $DIR/bin/flowforge.sh
      if [ $? -eq 1 ]; then
        sudo -u $FF_USER namei -l $DIR
        echo "**************************************************************"
        echo " User $FF_USER does not have access to $DIR, "
        echo " please check the permissions on all the full path before "
        echo " trying to start the service"
        echo "**************************************************************"
      fi

      sudo systemctl daemon-reload

      echo "**************************************************************"
      echo " Service installed but not started, to start run the        "
      echo " following: sudo service flowforge start                    "
      echo "**************************************************************"

    fi
  fi
else
  echo "**************************************************************"
  echo " Install complete "
  echo " You can start FlowForge by running './bin/flowforge.sh'"
  echo "**************************************************************"
fi
