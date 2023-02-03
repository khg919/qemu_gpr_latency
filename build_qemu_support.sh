#!/bin/sh
#
# american fuzzy lop - QEMU build script
# --------------------------------------
CPU_TARGET=aarch64 
VERSION=3.1.0

#
# Written by Andrew Griffiths <agriffiths@google.com> and
#            Michal Zalewski <lcamtuf@google.com>
#
# Copyright 2015, 2016, 2017 Google Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at:
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# This script downloads, patches, and builds a version of QEMU with
# minor tweaks to allow non-instrumented binaries to be run under
# afl-fuzz. 
#
# The modifications reside in patches/*. The standalone QEMU binary
# will be written to ../afl-qemu-trace.
#

echo "[*] Configuring QEMU for $CPU_TARGET..."

ORIG_CPU_TARGET="$CPU_TARGET"

test "$CPU_TARGET" = "" && CPU_TARGET="`uname -m`"
test "$CPU_TARGET" = "i686" && CPU_TARGET="i386"

cd qemu-$VERSION || exit 1

make clean
make distclean

CFLAGS="-O3 -ggdb -static" ./configure --disable-system  \
  --enable-linux-user --disable-gtk --disable-sdl --disable-vnc \
  --target-list="${CPU_TARGET}-linux-user,aarch64-linux-user" --enable-pie --disable-kvm \
  --extra-cflags=-Dkwon_mixcoffee \
  || exit 1

#--extra-cflags=-Dkwon_perf \
#--extra-cflags=-Dkwon_perf_stat \
#--extra-cflags=-Dkwon_perf_single \
#--extra-cflags=-Dkwon_mixcoffee \
#--extra-cflags=-Dkwon_mixcoffee_pc \

echo "[+] Configuration complete."

echo "[*] Attempting to build QEMU (fingers crossed!)..."

make -j20   || exit 1

echo "[+] Build process successful!"

echo "[*] Copying binary..."

cp -f "${CPU_TARGET}-linux-user/qemu-${CPU_TARGET}" "../mixcoffee-qemu-aarch64" || exit 1


echo "[+] Successfully created '../mixcoffee-qemu-aarch64'."

