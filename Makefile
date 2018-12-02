LUAC_CROSS ?= /media/wolumen/git/nodemcu-firmware/luac.cross
NODEMCU_UPLOADER ?= nodemcu-uploader
SRC_FOLDER ?= src
LFS_SRC_FOLDER ?= lfs-src
MAIN_FILE ?= main.lua
NODEMCU_PORT ?= /dev/ttyUSB0

SRC_FILES := $(wildcard $(SRC_FOLDER)/*.lua)
LFS_FILES := $(wildcard $(SRC_FOLDER)/*.lua)

burn:
	@echo "Burning lua files"
	$(NODEMCU_UPLOADER) --port $(NODEMCU_PORT) upload $(addsuffix $(notdir $(SRC_FILES)), $(SRC_FILES):)
		
run:
	@echo "Running main file"
	$(NODEMCU_UPLOADER) --port $(NODEMCU_PORT) file do $(MAIN_FILE)
	
build-lfs-image:
	@echo "Building LFS image"
	$(LUAC_CROSS) -f $(LFS_FILES)
	
flash-lfs-image:
	@echo "Installing LFS image"
	$(NODEMCU_UPLOADER) --port $(NODEMCU_PORT) upload luac.out
	
clean:
	rm luac.out
all: burn run