Marlin build and configuration change tracking script
=====================================================

This script ease the tracking of changes between firmware build and configuration change when using PlatformIO framework on linux.

I use it for my SKR Mini E3 V1.2 on my Ender 3 but should work the same way for others. You can create a `env` file or edit `make.sh` to change `DEFAULT_ENV` to reflect `platformio.ini`'s `default_envs` value.

Usage
-----

It's better to create a dedicated branch in your Marlin's checkout for your changes to merge back upstream code changes (eg: `git checkout -b my-configuration`).

1. Commit your changes (build won't start if things remains uncommitted)
2. Build firmware using `./make.sh`

This will build and copy the firmware in `bins` folder, using the following convention `${MARLIN_VERSION}_${BUILD_DATE}_${GIT_SHORT_REV}.bin` (eg: `2.0.5.3_20200517-121705_054294f63.bin`).

Internal values of the built firmware are also updated, so you can know which version is currently running on your board. Those values can be seen on the boot screen, in the info menu or in the greeting line when you connect via serial.

Install
-------

You need to have a proper build system already working and GNU flavor `sed` (default in Ubuntu/Debian etc distributions, probably others too).

1. Clone this project somewhere and symlink `make.sh` at the root of Marlin checkout.
2. In your `Configuration.h`, uncomment `CUSTOM_VERSION_FILE` and set the value to the following `#define CUSTOM_VERSION_FILE _Version.h // Path from the root directory (no quotes)`
3. Copy `Marlin/Version.h` to `Marlin/_Version.h`
4. In the newly created `Marlin/_Version.h`, uncomment `#define SHORT_BUILD_VERSION` and `#define WEBSITE_URL`, the later is used to store the build date and time.
5. Commit all your changes
6. Build by running `./make.sh`
