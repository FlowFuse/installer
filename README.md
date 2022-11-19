# FlowForge Installer

This repository provides the installer for local installations of the FlowForge
platform.

Please refer to the main documentation for a complete guide to installing and
setting up the platform: https://github.com/flowforge/flowforge/tree/main/docs

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

### Node.js

FlowForge requires ***Node.js v16***.

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

## Installing FlowForge

1. Create a directory to be the base of your FlowForge install. For example: `/opt/flowforge` or `c:\flowforge`

   For Linux/MacOS:
    ```
    sudo mkdir /opt/flowforge
    sudo chown $USER /opt/flowforge
    ```
   
   For Windows:
    ```
    mkdir c:\flowforge
    ```

2. Download the Installer zip file from https://github.com/flowforge/installer/releases

3. Unzip the downloaded file into a temporary location and copy its contents to
   the FlowForge directory

   For Linux/MacOS:
   ```
   cd /tmp/
   unzip flowforge-installer-x.y.z.zip
   cp -R flowforge-installer-x.y.z/* /opt/flowforge
   ```

   For Windows:
   ```
   mkdir cd c:\temp
   cd c:\temp
   tar -xf flowforge-installer-x.y.z.zip
   xcopy /E /I flowforge-installer-x.y.z c:\flowforge
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

On Linux, the installer will ask if you want to run FlowForge as a service.
This will mean it starts automatically whenever you restart your device.

If you select this option, it will ask if you want to run the service as the
current user, or create a new `flowforge` user. If you choose to create the
user, it will also change the ownership of the FlowForge directory to that user.

## Configuring FlowForge (optional)

The default FlowForge configuration is provided in the file `flowforge.yml`
* Linux/MacOS: `/opt/flowforge/etc/flowforge.yml`
* Windows: `c:\flowforge\etc\flowforge.yml`

For more details on the options available, see the [configuration guide](https://github.com/flowforge/flowforge/tree/main/docs/install/configuration.md).

## Before running FlowForge (Windows Only)
Some Windows applications like Hyper-V and WSL can reserve TCP ports. This can prevent FlowForge from running correctly. If necessary, adjust the starting port variable `driver.options.start_port` in the FlowForge configuration yaml file.

You can see which ports are reserved on a Windows machine using the command...
```console
netsh interface ipv4 show excludedportrange protocol=tcp
```

IMPORTANT: When modifying `start_port` (default 7880), be aware that FlowForge uses port numbers incrementally and in pairs separated by 1000. e.g. If `start_port` is set to `6000`, it will allocate ports `6000` and `7000` to the 1st project then ports `6001` and `7001` to the next project (and so on). 

_INFO: Ports between 10000 ~ 49000 on windows are typically not included in the default reservation_

## Running FlowForge

If you have installed FlowForge as a service, it can be started by running:

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

Once FlowForge is started, you can access the platform in your browser at [http://localhost:3000](http://localhost:3000).

The first time you access it, the platform will take you through creating an
administrator for the platform and other configuration options.

For more information, follow [this guide](https://github.com/flowforge/flowforge/tree/main/docs/install/first-run.md).
