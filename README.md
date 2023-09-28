# FlowFuse Installer

This repository provides the installer for local installations of the FlowFuse
platform.

Please refer to the main documentation for a complete guide to installing and
setting up the platform: https://github.com/flowfuse/flowforge/tree/main/docs

## Prerequisites

### Operating System

The install script has been tested against the following operating systems:

 - Raspbian/Raspberry Pi OS versions Buster/Bullseye [^1]
 - Debian Buster/Bullseye
 - Fedora 35
 - Ubuntu 20.04
 - CentOS 8/RHEL 8/Amazon Linux 2
 - MacOS Big Sur & Monterey on Intel & Apple M processors
 - Windows 10 & 11

[^1]: Arm6 devices, such as the original Raspberry Pi Zero and Zero W are not supported.

### Node.js

FlowFuse requires ***Node.js v16***.

#### Linux

The install script will check to see if it can find a suitable version of Node.js.
If not, it will offer to install it for you.

It will also ensure you have the appropriate build tools installed that are often
needed by Node.js modules to build native components.

#### Windows/MacOS

If the install script cannot find a suitable version of Node.js, it will exit.

You will need to manually install it before proceeding. Information about
how to do this can be found on the Node.js website here: [https://nodejs.org/en/download](https://nodejs.org/en/download)

You will also need to install the appropriate build tools.

* **Windows**: the standard Node.js installer will offer to do that for you.
* **MacOS**: you will need the `XCode Command Line Tools` to be installed. 
  This can be done by running the following command:
    ```
    xcode-select --install
    ```

## Installing FlowFuse

1. Create a directory to be the base of your FlowFuse install. For example: `/opt/flowforge` or `c:\flowforge`

   For Linux/MacOS:
    ```
    sudo mkdir /opt/flowforge
    sudo chown $USER /opt/flowforge
    ```
   
   For Windows:
    ```
    mkdir c:\flowforge
    ```

2. Download the latest [Installer zip file](https://github.com/flowfuse/installer/releases/latest/download/flowforge-installer.zip) into a temporary location.


3. Unzip the downloaded zip file and copy its contents to
   the FlowForge directory

   ### For Linux/MacOS: 
   _Assumes `/tmp/` is the directory where you downloaded `flowforge-installer.zip`_
    ```
    cd /tmp/
    unzip flowforge-installer.zip
    cp -R flowforge-installer/* /opt/flowforge
    ```
    

   ### For Windows:
   _Assumes `c:\temp` is the directory where you downloaded `flowforge-installer.zip`_
    ```
    cd c:\temp
    tar -xf flowforge-installer.zip
    xcopy /E /I flowforge-installer c:\flowforge
    ```
    


4. Run the installer and follow the prompts

   For Linux/MacOS:
    ```
    cd /opt/flowforge
    ./install.sh
    ```

   For Windows:
    ```
    cd c:\flowforge
    install.bat
    ```


### Installing as a service (optional)

On Linux, the installer will ask if you want to run FlowFuse as a service.
This will mean it starts automatically whenever you restart your device.

If you select this option, it will ask if you want to run the service as the
current user, or create a new `flowforge` user. If you choose to create the
user, it will also change the ownership of the FlowForge directory to that user.

## Configuring FlowFuse

The default FlowFuse configuration is provided in the file `flowforge.yml`
* Linux/MacOS: `/opt/flowforge/etc/flowforge.yml`
* Windows: `c:\flowforge\etc\flowforge.yml`

The default configuration file already contains everything you need to get started with FlowFuse.

It will allow you to access FlowFuse and the projects you create, from the same server running the platform. 
If you want to allow access from other devices on the network, you must edit the configuration file and 
change the `host` setting to 0.0.0.0. NOTE: We do not support changing the `host` value once you have created a project.
For more information on all of the options available, see the [configuration guide](https://github.com/flowfuse/flowforge/tree/main/docs/install/configuration.md).


## Running FlowFuse

If you have installed FlowFuse as a service, it can be started by running:

```
service flowforge start
```

To run it manually, you can use:

 - Linux/MacOS:
    ```
    /opt/flowforge/bin/flowforge.sh
    ```

 - Windows:
    ```
    c:\flowforge\bin\flowforge.bat
    ```

## First Run Setup

Once FlowFuse is started, you can access the platform in your browser at [http://localhost:3000](http://localhost:3000).

The first time you access it, the platform will take you through creating an
administrator for the platform and other configuration options.

For more information, follow [this guide](https://github.com/flowfuse/flowforge/tree/main/docs/install/first-run.md).
