CC = arm-linux-gnueabi-gcc
CFLAGS = -O3 -Wall -static -std=c99

.PHONY: all clean
	
all: agra

agra: agra.o agra_main.o framebuffer.o
	$(CC) $(CFLAGS) -o $@ $^

agra.o: agra.s
	$(CC) $(CFLAGS) -c $^
	
agra_main.o: agra_main.c agra.h framebuffer.c
	$(CC) $(CFLAGS) -c $^

clean:
	$(RM) agra agra.o agra_main.o agra.h.gch framebuffer.o
