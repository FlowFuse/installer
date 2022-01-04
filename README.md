# FlowForge Alpha Installer

## Installing

### Pre Requisites

The FlowForge platform requires NodeJS 16 or newer. On Windows or OSx you will need to manually 
install this before proceeding. Please remember to install the native build tools if asked by the
NodeJS installer.

You can download the NodeJS installer here: [https://nodejs.org/en/download/](https://nodejs.org/en/download/)

The installer has been tested on

 - Raspbian Buster/Bullseye
 - Fedora 35
 - Ubuntu 20.04
 - OSx
 - Windows 10

 It should also run on CentOS/RHEL/Amazon Linux 2

 The system also makes use of the SQLite3 database engine to store state. In most cases npm should download
 pre-built binary components the will make use of any pre-installed SQLite3 libraries available on your 
 system, but in somecases it may need to build these from the bundled source which will require the build 
 tools mentioned earlier.

### Install

 - Download the Installer zip file
 - Create a directory to house the FlowForge instance
 - Unzip the Installer zip inside this directory
 - From within the directory run `./install.sh` or `install.bat` 
 - If prompted install NodeJS v16 (Linux only)
 - Once the install finishes you can start the FlowForge instance with `./flowforge.sh` or `flowforge.bat`

### First run

 - You access the platform by pointing a browser at [http://localhost:3000](http://localhost:3000)
 - You will be asked to create a Administrator user the first time you connect
 - Once logged in as the new user you will be prompted to create your first team.
 - From there you can create Projects (instances of Node-RED) which will be managed as part of the team.

 After the first start the following will be created in the working directory

  - `forge.db` this is the database that holds all the project settings
  - `localfs_root` this directory holds the userDir for each Project instance.

## Configure

Most configuration is done through the web interface, but one thing you may wish to change is the 
`BASE_URL` entry in the `.env.development` file in which will be in the root of the directory you created 
earlier. If you intend to access both the FlowForge interface and the Node-RED instances remotely 
(not via localhost) then you should change this to match the IP address of the machine running the FlowForge
instance. e.g.

```
#BASE_URL=http://localhost:3000
BASE_URL=192.168.1.100:3000
```

This change will only take effect after a restart of the FlowForge platform and will apply to Projects
created after the change.

## Issues

If you come across any issues please raise them here: [https://github.com/flowforge/flowforge/issues](https://github.com/flowforge/flowforge/issues)