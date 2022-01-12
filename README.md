# FlowForge Alpha Installer

## Installing

### Pre Requisites

The FlowForge platform requires NodeJS 16 or newer. On Windows or OSx you will need to manually install this before proceeding. Please remember to install the native build tools if asked by the NodeJS installer.

You can download the NodeJS installer here: [https://nodejs.org/en/download/](https://nodejs.org/en/download/)

The install scripts has been tested on

 - Raspbian/Raspberry Pi OS versions Buster/Bullseye ~
 - Debian Buster/Bullseye
 - Fedora 35
 - Ubuntu 20.04
 - CentOS 8/RHEL 8/Amzon Linux 2
 - OSx Catalina
 - Windows 10

 ~ Not supporting Arm6 based machines (e.g. Original Raspberry Pi Zero and Zero W) as NodeJS installer no longer supports this platform. 

FlowForge also makes use of the SQLite3 database engine to store state. In most cases npm should download pre-built binary components the will make use of any pre-installed SQLite3 libraries available on your system, but in somecases it may need to build these from the bundled source which will require the build tools mentioned earlier.

### Install

 - Download the Installer zip file
 - Create a directory to house the FlowForge instance e.g. `/opt/flowforge`
 - Unzip the Installer zip inside this directory
 - From within the directory run `./install.sh` or `install.bat` 
 - If prompted install NodeJS v16 (Linux only)
 - On Linux you will be asked if you want to run FlowForge as a service, if you answer yes:
   - Decide if you want to run the sevice as the current user or as a new `flowforge` user
   - Once complete you can start the service with `sudo service flowforge start`
 - If you answer no to the service or are running on OSx or Windows then:
   - Once the install completes you can start the FlowForge platform with `./flowforge.sh` or `flowforge.bat`

### Configuration

Most configuration is done via the web interface. The following values can be changed in the `.env.development` file in the FlowForge home directory.

- `PORT` Which port to the FlowForge platform should listen on. default `3000`
- `BASE_URL` The URL to access the FlowForge platform. default `http://localhost:3000`
- `LOCALFS_ROOT` Where to store the userDir directories for the Node-RED instances. default `localfs_root` in the FlowForge home directory
- `LOCALFS_START_PORT` The port number to start from for Node-RED instances. default `7880`
- `LOCALFS_NODE_PATH` The path to the node binary to use for starting Node-RED instances. Sometimes needed when using nvm. default not set
- `SMTP_TRANSPORT_HOST` The hostname for a SMTP server to be used to send email. default not set (email disabled)
- `SMTP_TRANSPORT_PORT` The port for the SMTP server to be used to send email. default not set
- `SMTP_TRANSPORT_TLS` To use TLS when connecting to SMTP server. default `false`
- `SMTP_TRANSPORT_AUTH_USER` A username to authenticate with the SMTP server
- `SMTP_TRANSPORT_AUTH_PASS` A passsword to authenticate with the SMTP server

Apart from setting the SMTP details the most likely change to make will be the `BASE_URL` value. Chaning this to the match the IP address of the machine running FlowForge will allow you to access both the FlowForge UI and the Node-RED instances from other machines on your network. e.g. if running on `192.168.1.10` then `BASE_URL=http://192.168.1.10:3000` would be the correct setting.

Changes to `.env.development` only take effect when the platform is restarted.

### First run

 - You access the platform by pointing a browser at [http://localhost:3000](http://localhost:3000)
 - You will be asked to create a Administrator user the first time you connect
 - Once logged in as the new user you will be prompted to create your first team.
 - From there you can create Projects (instances of Node-RED) which will be managed as part of the team.

 After the first start the following will be created in the working directory

  - `forge.db` this is the database that holds all the project settings
  - `localfs_root` this directory holds the userDir for each Project instance.


## Issues

If you come across any issues please raise them here: [https://github.com/flowforge/flowforge/issues](https://github.com/flowforge/flowforge/issues)