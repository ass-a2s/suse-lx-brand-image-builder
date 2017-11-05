#!/bin/sh

### LICENSE - (BSD 2-Clause) // ###
#
# Copyright (c) 2017, Daniel Plominski (ASS-Einrichtungssysteme GmbH)
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
# list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice, this
# list of conditions and the following disclaimer in the documentation and/or
# other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
### // LICENSE - (BSD 2-Clause) ###

### ### ### ASS // ### ### ###

SUSE=$(grep -s "^ID=" /etc/os-release | sed 's/ID=//g' | sed 's/"//g')
VERSION=$(grep -s "^VERSION=" /etc/os-release | sed 's/VERSION="12-//g' | sed 's/"//g')
DOCKERVERSION=$(grep -s "^VERSION=" /etc/os-release | sed 's/VERSION="12-//g' | sed 's/"//g' | sed 's/SP/sp/g')

ADIR="$PWD"

#// FUNCTION: run script as root (Version 1.0)
check_root_user() {
if [ "$(id -u)" != "0" ]; then
   echo "[ERROR] This script must be run as root" 1>&2
   exit 1
fi
}

#// FUNCTION: check state (Version 1.0)
check_hard() {
if [ $? -eq 0 ]
then
   echo "[$(printf "\033[1;32m  OK  \033[0m\n")] '"$@"'"
else
   echo "[$(printf "\033[1;31mFAILED\033[0m\n")] '"$@"'"
   sleep 1
   exit 1
fi
}

#// FUNCTION: prepare_suse_sles (Version 1.0)
prepare_suse_sles() {
if [ "$SUSE" = "sles" ]
then
   #// check repositories
   if [ ! -f /etc/zypp/services.d/Containers_Module_12_x86_64.service ]
   then
      echo "[$(printf "\033[1;31mFAILED\033[0m\n")] can't find Containers_Module_12_x86_64 Repositories!"
      echo "YaST -> Software -> Software-Repositories -> Add -> Extensions and Modules from Registration Server -> Containers Module 12 x86_64"
      exit 1
   fi
   #// zypper refresh
   zypper refresh
   check_hard refresh: zypper
   #// install docker
   zypper --non-interactive install docker
   check_hard install: docker
   #// install sle2docker
   zypper --non-interactive install sle2docker
   check_hard install: sle2docker
   #// zypper refresh
   zypper refresh
   check_hard refresh: zypper
   #// start docker
   systemctl start docker
   check_hard start: docker
   #// status docker
   systemctl status docker
   check_hard status: docker
   #// fetch base sles images
   zypper --non-interactive install suse-sles12"$DOCKERVERSION"-image
   check_hard install: suse-sles12"$DOCKERVERSION"-image
   #// activate sles docker image
   GETDOCKERIMAGENAME=$(sle2docker list | grep 'sles12"'$DOCKERVERSION'"' | awk '{print $2}' | head -n 1)
   sle2docker activate "$GETDOCKERIMAGENAME"
   check_hard activate: docker image "$GETDOCKERIMAGENAME"
   #// list docker images
   docker images
   check_hard list: docker images
fi
}

#// FUNCTION: clone_git (Version 1.0)
clone_git() {
git clone https://github.com/ass-a2s/sdc-vmtools-lx-brand "$ADIR"/root/root/guesttools
if [ $? -eq 128 ]
then
   printf "\033[1;33mWARNING: skips the git repository clone because the directory exists\033[0m\n"
fi
}

#// FUNCTION: check_git (Version 1.0)
check_git() {
if [ "$(ls -A $ADIR/root/root/guesttools)" ]
then
   : # dummy
else
   echo "[$(printf "\033[1;31mFAILED\033[0m\n")] can not find ../root/root/guesttools"
   sleep 1
   exit 1
fi
}

#// FUNCTION: build_suse_sles (Version 1.0)
build_suse_sles() {
if [ "$SUSE" = "sles" ]
then
   : # dummy
fi
}

#// RUN

check_root_user
prepare_suse_sles
#/clone_git
#/check_git
#/build_suse_sles

### ### ### // ASS ### ### ###
exit 0
# EOF
