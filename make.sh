#!/bin/bash

# load config if exists
[ -e env ] && source env

# Taken from the platformio.ini (can be overriden with env file)
DEFAULT_ENV=${DEFAULT_ENV:-STM32F103RC_btt_512K_USB}

GIT_SHORT_REV=$(git rev-parse --short HEAD)
BUILD_DATE="$(date +%Y%m%d-%H%M%S)"
MARLIN_VERSION=$(grep '#define SHORT_BUILD_VERSION ' Marlin/src/inc/Version.h | cut -d\" -f 2)
UNCOMMITTED_STUFF=$(git status --untracked-files=no --porcelain | wc -l)

[ ${UNCOMMITTED_STUFF} -ne 0 ] && echo "Uncommitted stuff... no build :D [need the commit hash]" && exit 1

PIO=~/.platformio/penv/bin/pio

# make the folder
[ ! -d bins ] && mkdir bins

sed -i -r \
    -e 's,#define WEBSITE_URL.+,#define WEBSITE_URL __DATE__ " " __TIME__",' \
    -e 's,#define SHORT_BUILD_VERSION .+,#define SHORT_BUILD_VERSION "'${MARLIN_VERSION}-$GIT_SHORT_REV'",' \
    Marlin/_Version.h
$PIO run -t clean
$PIO run
cp .pio/build/${DEFAULT_ENV}/firmware.bin bins/${MARLIN_VERSION}_${BUILD_DATE}_${GIT_SHORT_REV}.bin
