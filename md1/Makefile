CC = arm-linux-gnueabi-gcc
CFLAGS = -g -O0 -Wall -static

QEMU = qemu-arm-static

.PHONY: all clean test
	
all: md1

md1: md1.o md1_main.o
	$(CC) $(CFLAGS) -o $@ $^

md1.o: md1.s
	$(CC) $(CFLAGS) -c $^
	
md1_main.o: md1_main.c
	$(CC) $(CFLAGS) -c $^

clean:
	$(RM) md1 md1.o md1_main.o

test:
	$(QEMU) md1 0
	$(QEMU) md1 1
	$(QEMU) md1 2
	$(QEMU) md1 3
	$(QEMU) md1 5
	$(QEMU) md1 10
	$(QEMU) md1 100
	$(QEMU) md1 65535
	$(QEMU) md1 65536
	$(QEMU) md1 92681
	$(QEMU) md1 92682
	$(QEMU) md1 4294967294
	$(QEMU) md1 4294967295
	$(QEMU) md1 4294967296
	$(QEMU) md1 -1
	$(QEMU) md1 abc
