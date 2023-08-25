# Build an OS
Example how to build own OS.


# Source
_Thanks to [nanobyte](https://www.youtube.com/@nanobyte-dev) YouTube channel_

YouTube playlist: https://www.youtube.com/watch?v=9t-SPC7Tczc&list=PLFjM7v6KGMpiH2G-kT781ByCNC_0pKpPN


# Setup
## Linux
- Text editor
- Make
- NASM - assembler
- qemu (or any other virtualization software, e.g. VirtualBox, VMWare)
```
$ apt install make nasm qemu
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
- Enabling Windows Subsystem for Linux: https://docs.microsoft.com/en-us/wind...
- Installing Ubuntu in Windows Subsystem for Linux: https://tutorials.ubuntu.com/tutorial...

"Table of x86 Registers svg" by Immae is licensed under Creative Commons Attribution-Share Alike 3.0 Unported (https://commons.wikimedia.org/wiki/Fi...)