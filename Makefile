LUAC_CROSS ?= luac.cross
NODEMCU_UPLOADER ?= nodemcu-uploader
SRC_FOLDER ?= src
LFS_SRC_FOLDER ?= lfs-src
MAIN_FILE ?= main.lua
NODEMCU_PORT ?= /dev/ttyUSB0

SRC_FILES := $(wildcard $(SRC_FOLDER)/*.lua)
LFS_FILES := $(wildcard $(LFS_SRC_FOLDER)/*.lua)

.PHONY: default
default: run

upload:
	@echo "Uploading lua files"
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
# Workaround to https://github.com/kmpm/nodemcu-uploader/issues/76
	$(NODEMCU_UPLOADER) --port $(NODEMCU_PORT) upload flashreload.lua
	$(NODEMCU_UPLOADER) --port $(NODEMCU_PORT) file do flashreload.lua
	
lfs: build-lfs-image flash-lfs-image

clean:
	rm luac.out
	
all: upload flash-lfs-image run