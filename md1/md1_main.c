#include <stdio.h>
#include <stdlib.h>

unsigned long asum(unsigned long n);

int main(int argc, char **argv) {
    if (argc < 2) {
        printf("Usage: %s <n>\n", argv[0]);
        exit(1);
    }
    
    unsigned long n = strtoul(argv[1], NULL, 10);
    unsigned long s = asum(n);
    
    //printf("n = %lu, S = %lu\n", n, s);
    printf("%lu\n", s);
    
    return 0;
}
