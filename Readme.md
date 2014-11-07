# ARM assembly

Homework for Machine Oriented Programming (MOP) at University of Latvia in 2013.

## agra

It's a simple drawing library that can

* draw a line
* fill a triangle
* draw a circle
* color a pixel

## Setup

Ubuntu Server 14.04 LTS

    sudo apt-get install -y gcc-arm-linux-gnueabi qemu-user-static make

Build

    arm-linux-gnueabi-gcc -O3 -Wall -static -std=c99 -o app *.o

Run

    qemu-arm-static app arg1 arg2

## License

Apache 2.0
