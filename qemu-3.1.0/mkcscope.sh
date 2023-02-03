#!/bin/sh

rm -rf cscope.out cscope.files

#
#[----exclude----]
#type = directory, path= $pwd/build  -prune
#[----include----]
#name = *.cu or name = *.c ...... or name = *.S -print
#괄호 쓸 때는 \ 붙일 것

find $PWD \( \( -type d -path $PWD/vanilla_qemu_mode -o -path $PWD/qemu_mode -o -path $PWD/dir_elf \) -prune -name '*.cu' -o -name '*.c.inc' -o -name '*.c' -o -name '*.c' -o -name '*.C' -o -name '*.cpp' -o -name '*.cc' -o -name '*.h' -o -name '*.s' -o -name '*.S' -o -name '*.py' \) -print  > cscope.files

cscope -i cscope.files
