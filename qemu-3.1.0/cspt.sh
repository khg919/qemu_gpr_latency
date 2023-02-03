#!/bin/sh


./configure --disable-system --enable-linux-user --disable-gtk --disable-sdl --disable-vnc --target-list=x86_64-linux-user,aarch64-linux-user --enable-pie --disable-kvm
