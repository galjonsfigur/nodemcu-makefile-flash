LUAC_CROSS ?= ../luac.cross
NODEMCU_UPLOADER ?= nodemcu-uploader
SRC_FOLDER ?= src
MAIN_FILE ?= main.lua
NODEMCU_PORT ?= /dev/ttyUSB0

SRC_FILES := $(wildcard $(SRC_FOLDER)/*.lua)

run:
	$(NODEMCU_UPLOADER) exec $(MAIN_FILE) -p $(NODEMCU_PORT)
burn:
	$(NODEMCU_UPLOADER) upload $(SRC_FILES) -p $(NODEMCU_PORT)
flash: burn run



all: flash