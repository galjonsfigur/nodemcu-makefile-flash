LUAC_CROSS ?= luac.cross
NODEMCU_UPLOADER ?= nodemcu-uploader
SRC_FOLDER ?= src
LFS_SRC_FOLDER ?= lfs-src
MAIN_FILE ?= main
NODEMCU_PORT ?= /dev/ttyUSB0

SRC_FILES := $(wildcard $(SRC_FOLDER)/*.lua)
LFS_FILES := $(wildcard $(LFS_SRC_FOLDER)/*.lua)
LC_FILES  := $(SRC_FILES:.lua=.lc)

.PHONY: default
default: run

upload:
	@echo "Uploading lua files"
	$(NODEMCU_UPLOADER) --port $(NODEMCU_PORT) upload $(join $(addsuffix :, $(SRC_FILES)), $(notdir $(SRC_FILES)))
		
run:
	@echo "Running main file"
	$(NODEMCU_UPLOADER) --port $(NODEMCU_PORT) file do $(MAIN_FILE).lua

run-release:
	@echo "Running main file"
	$(NODEMCU_UPLOADER) --port $(NODEMCU_PORT) file do $(MAIN_FILE).lc
	
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

%.lc: %.lua
	@echo "Compiling Lua file:" $@
	$(LUAC_CROSS) -s -o $@ $<
	
lua-release: $(LC_FILES)
	@echo "Uploading compiled Lua files"
	$(NODEMCU_UPLOADER) --port $(NODEMCU_PORT) upload $(join $(addsuffix :, $(LC_FILES)), $(notdir $(LC_FILES)))	
clean:
	rm luac.out $(LC_FILES)
	
all: upload lfs run
all-release: lua-release lfs run-release 