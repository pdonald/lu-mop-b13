#include <stdio.h>
#include <stdlib.h>
#include "fib.h"
int main (int argc, char **argv)
{
if (argc < 2)
{
printf("Usage:\n\t%s non_neg_index\n",
argv[0]);
exit(1);
}
int i = atoi(argv[1]);
printf("Fib(%u) = %lu\n", i, fib(i));
return 0;
}
