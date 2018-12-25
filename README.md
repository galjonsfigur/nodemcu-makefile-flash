## NodeMCU makefile flash

A simple makefile to simplify process of uploading Lua code to ESP8266. Supports LFS. Uses luac.cross to make LFS image and [nodemcu-uploader](https://github.com/kmpm/nodemcu-uploader) to upload files to SPIFFS. This repository contains example use of this makefile using LFS image with telnet from [nodemcu-firmware](https://github.com/nodemcu/nodemcu-firmware).

### How to use

Project directory structure:

 - `src/`: Here you can put your .lua files that you want to be uploaded to SPIFFS. Directory structure in this folder will be omitted.
 - `lfs-src/`: .lua files in this directory will be used to make LFS image.
 
#### Makefile parameters:

 - `LUAC_CROSS`: Path to luac.cross executable.
 - `NODEMCU_UPLOADER`: Path to nodemcu-uploader script. Typically don't have to be modified if nodemcu-uploader was installed using pip.
 - `MAIN_FILE`: Main .lua file used by `run` target. It is very useful for testing because there is no need for using init.lua which can cause problems when there is an error in script.
 - `NODEMCU_PORT`: Path to serial port. Default is /dev/ttyUSB0.

#### Makefile targets:

 - `upload`: Uploads all lua files in src directory.
 - `upload-release`: Compiles and uploads all lua files in src directory.
 - `run`: Executes MAIN_FILE.
 - `run-release`: Executes precompiled version ofMAIN_FILE.
 - `build-lfs-image`: Creates LFS image.
 - `flash-lfs-image`: Uploads and reloads LFS image.
 - `lfs`: Creates, uploads and reloads LFS image.
 - `all`: Uploads Lua code, creates and installs LFS image and runs main file. 
 - `all-release`: Compiles and uploads Lua code, creates and installs LFS image and runs main file.

When used with no specified target, `run` target is used.


#### Other information: 
- License: MIT
- Author: Galion