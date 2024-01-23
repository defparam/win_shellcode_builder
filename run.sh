#!/bin/bash

# build the image with proper compiler and SDK
docker build -t win_shellcode_build .

# clean
rm -f ./src/*.exe
rm -f ./src/*.obj
rm -f ./src/*.map
rm -f ./src/*.bin

# run the compilation
docker run -v "$(pwd)/src:/src" -w /src win_shellcode_build make

# move result here
mv -f ./src/shellcode.bin .



