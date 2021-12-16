# FlowForge Alpha Installer

## Installing

### Pre Requisites

The FlowForge platform requires NodeJS 16 or newer. On Windows or OSx you will need to manually 
install this before proceeding. Please remember to install the native build tools if asked by the
NodeJS installer.

You can download the NodeJS installer here: [https://nodejs.org/en/download/](https://nodejs.org/en/download/)

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

## Configure

Most configuration is done through the web interface, but one thing you may wish to change is the 
`BASE_URL` entry in the `.env.development` file in which will be in the root of the directory you created 
earlier. If you intend to access both the FlowForge interface and the Node-RED instances remotely 
(not via localhost) then you should change this to match the IP address of the machine running the FlowForge
instance.

This change will only take effect after a restart of the FlowForge platform and will only apply to new Projects
created.

## Issues

If you come across any issues please raise them here 