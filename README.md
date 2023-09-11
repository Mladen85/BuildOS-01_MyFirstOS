# Build an OS
Example how to build own OS on "floppy disk".


# Source
_Thanks to [nanobyte](https://www.youtube.com/@nanobyte-dev) YouTube channel_

YouTube playlist: https://www.youtube.com/watch?v=9t-SPC7Tczc&list=PLFjM7v6KGMpiH2G-kT781ByCNC_0pKpPN


# Setup
## Linux
- Text editor<br>
If using Visual Studio Code, install extension `x86 and x86_64 Assembly.`

- Make
```
$ apt install make
```

- NASM - assembler
```
$ apt install nasm
```

- qemu (or any other virtualization software, e.g. VirtualBox, VMWare)
```
$ apt install qemu-system-x86
```

- bochs - emulator and debugger for x86 proccessor
```
$ apt install bochs
$ apt install bochs-sdl bochsbios vgabios 
```

- Open Watcom - 16 bit C/C++ compiler (other older 16 bit C/C++ compilers are: "Digital Mars", "bcc", "tcc"...)
```
https://github.com/open-watcom/open-watcom-v2/releases
```
In Current Build open Assets and download version for your OS (e.g. "open-watcom-2_0-c-linux-x64"). Set `chmod` to `+x` and run as superuser. Select 16 bit compiler and Huge memory model.
### Run `bochs`
Create configuration file `bochs_config`.<br>
Run `debug.sh` to start emulation.


# Run
Run virtual machine with our boot
```
$ qemu-system-i386 -fda build/main_floppy.img
```
Or run `run.sh`<br>
(First set run.sh as executable `chmod +x run.sh`).


Test image
```
$ mdir -i build/main_floppy.img
```


# Branching:
## `master` branch
Will be used for release version.

## `development` branch
Will be used during development.<br>
Release versions will be merged to `master` branch.

## `feature-XXX` branch
Will be used for feature adding.<br>
Feature complete will be merged to `development` branch.<br>
`feature-XXX` branch will be deleted after merge.

## `plan-upd-XXX` branch
Will be used to update planning documents.<br>
will be merged to `master` branch.<br>
`plan-upd-XXX` branch will be deleted after merge.

## `path-X.X.X` branch
Will be used in case project is split to different development paths.


# Links
Original source code: https://github.com/nanobyte-dev/nanobyte_os


# Documentation:
- Enabling Windows Subsystem for Linux: https://learn.microsoft.com/en-us/windows/wsl/install
- Installing Ubuntu in Windows Subsystem for Linux: https://ubuntu.com/tutorials/install-ubuntu-on-wsl2-on-windows-10#5-install-your-first-package

"Table of x86 Registers svg" by Immae is licensed under Creative Commons Attribution-Share Alike 3.0 Unported (https://commons.wikimedia.org/wiki/File:Table_of_x86_Registers_svg.svg)