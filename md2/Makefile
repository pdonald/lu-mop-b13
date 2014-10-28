CC = arm-linux-gnueabi-gcc
CFLAGS = -g -O0 -Wall -static

QEMU = qemu-arm

.PHONY: all clean test

all: md2

md2: md2.o md2_main.o
	$(CC) $(CFLAGS) -o $@ $^

md2.o: md2.s
	$(CC) $(CFLAGS) -c $^
	
md2_main.o: md2_main.c md2.h
	$(CC) $(CFLAGS) -c $^

clean:
	$(RM) md2 md2.o md2_main.o md2.h.gch

test: md2
	@echo "0 0 0 0" | $(QEMU) md2 | awk '{ print "#1 " ($$0 == "0 0 " ? "ok" : ":(") }'
	@echo "0 0 1 1 1" | $(QEMU) md2 > /dev/null ; echo $$? | awk '{ print "#2 " ($$1 == 1 ? "ok" : ":(") }'
	@echo "1 1 1 0 0" | $(QEMU) md2 > /dev/null ; echo $$? | awk '{ print "#3 " ($$1 == 1 ? "ok" : ":(") }'
	@echo "1 0 0 0" | $(QEMU) md2 > /dev/null ; echo $$? | awk '{ print "#4 " ($$1 == 1 ? "ok" : ":(") }'
	@echo "0 1 0 0" | $(QEMU) md2 > /dev/null ; echo $$? | awk '{ print "#4 " ($$1 == 1 ? "ok" : ":(") }'
	@echo "0 0 1 0" | $(QEMU) md2 > /dev/null ; echo $$? | awk '{ print "#4 " ($$1 == 1 ? "ok" : ":(") }'
	@echo "0 0 0 1" | $(QEMU) md2 > /dev/null ; echo $$? | awk '{ print "#4 " ($$1 == 1 ? "ok" : ":(") }'
	@echo "1 0 1 0" | $(QEMU) md2 > /dev/null ; echo $$? | awk '{ print "#5 " ($$1 == 1 ? "ok" : ":(") }'
	@echo "0 1 0 1" | $(QEMU) md2 > /dev/null ; echo $$? | awk '{ print "#5 " ($$1 == 1 ? "ok" : ":(") }'
	@echo "1 1 1 1 1 1" | $(QEMU) md2 | awk '{ print "#6 " ($$0 == "1 1 1 " ? "ok" : ":(") }'
	@echo "1 1 1 1 1 2" | $(QEMU) md2 | awk '{ print "#7 " ($$0 == "1 1 2 " ? "ok" : ":(") }'
	@echo "2 3 1 2 3 4 5 6 3 2 7 8 9 10 11 12" | $(QEMU) md2 | awk '{ print "#8 " ($$0 == "2 2 58 64 139 154 " ? "ok" : ":(") }'
	@echo "1 3 3 4 2 3 4 13 9 7 15 8 7 4 6 6 4 0 3" | $(QEMU) md2 | awk '{ print "#9 " ($$0 == "1 4 83 63 37 75 " ? "ok" : ":(") }'
	@echo "2 2 1 2 3 4 2 2 2 0 1 2" | $(QEMU) md2 | awk '{ print "#10 " ($$0 == "2 2 4 4 10 8 " ? "ok" : ":(") }'
	@echo "2 2 2 0 1 2 2 2 1 2 3 4" | $(QEMU) md2 | awk '{ print "#11 " ($$0 == "2 2 2 4 7 10 " ? "ok" : ":(") }'
	@echo "2 2 1 2 3 4 2 2 1 2 3 4" | $(QEMU) md2 | awk '{ print "#12 " ($$0 == "2 2 7 10 15 22 " ? "ok" : ":(") }'
	@echo "2 3 1 0 -2 0 3 -1 3 2 0 3 -2 -1 0 4" | $(QEMU) md2 | awk '{ print "#13 " ($$0 == "2 2 0 -5 -6 -7 " ? "ok" : ":(") }'
	@echo "4 2 7 3 2 5 6 8 9 0 2 3 7 4 9 8 1 5" | $(QEMU) md2 | awk '{ print "#14 " ($$0 == "4 3 73 31 78 54 13 43 106 32 94 63 36 81 " ? "ok" : ":(") }'
	@echo "2 3 1 2 3 4 5 6 3 4 7 8 9 10 11 12 13 14 15 16 17 18" | $(QEMU) md2 | awk '{ print "#15 " ($$0 == "2 4 74 80 86 92 173 188 203 218 " ? "ok" : ":(") }'
	@echo "1 1 1 2 2 1 2 3 4" | $(QEMU) md2 > /dev/null ; echo $$? | awk '{ print "#16 " ($$1 == 1 ? "ok" : ":(") }'
