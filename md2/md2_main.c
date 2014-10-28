#include <stdio.h>
#include <stdlib.h>

#include "md2.h"

int main() {
    int w1, h1, w2, h2;
    int *m1, *m2, *m3;
    int i;
    
    scanf("%d %d", &h1, &w1);
    m1 = malloc((w1*h1) * sizeof(m1));
    for (i = 0; i < w1*h1; i++) {
        scanf("%d", &m1[i]);
    }
    
    scanf("%d %d", &h2, &w2);
    m2 = malloc((w2*h2) * sizeof(m2));
    for (i = 0; i < w2*h2; i++) {
        scanf("%d", &m2[i]);
    }
    
    m3 = malloc((h1*w2) * sizeof(m3));
    
    int ret = matmul(h1, w1, m1, h2, w2, m2, m3);
    
    if (ret == 1) {
        return 1;
    }
    
    printf("%d %d ", h1, w2);
    for (i = 0; i < h1*w2; i++) {
        printf("%d ", m3[i]);
    }
    printf("\n");
    
    return 0;
}
