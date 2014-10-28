TARGET := fib
OBJ := $(TARGET)_main.o $(TARGET).o

ASFLAGS = -mcpu=xscale -alh=$*.lis -L
CFLAGS = -O0 -Wall
LDFLAGS = -g -static

CC := arm-linux-gnueabi-gcc
AS := arm-linux-gnueabi-as

.PHONY: test all clean distclean

test: all
	qemu-arm-static $(TARGET) 10

all: $(TARGET)

clean:
	$(RM) $(TARGET) *.o

allhfiles := $(wildcard *.h)

$(TARGET): $(OBJ)
	$(CC) $(LDFLAGS) -o $@ $^

%.o: %.s
	$(AS) -g $(ASFLAGS) -o $@ $<

%.o: %.c $(allhfiles)
	$(CC) -g $(CFLAGS) -o $@ -c $<

%.s: %.c $(allhfiles)
	$(CC) $(CFLAGS) -fomit-frame-pointer -o $@ -S $<
