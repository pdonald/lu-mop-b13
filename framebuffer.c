#include <stdlib.h>
#include <stdio.h>

#include "agra.h"

pixcolor_t *frameBuffer = NULL;

int FrameBufferGetWidth() {
    return FrameWidth;
}

int FrameBufferGetHeight() {
    return FrameHeight;
}

void FrameBufferInit() {
    int width = FrameBufferGetWidth();
    int height = FrameBufferGetHeight();
    int size = width * height;
    
    if (width >= 0 && height >= 0 && size >= 0) {
        frameBuffer = malloc(size * sizeof(pixcolor_t));
    }
    
    if (frameBuffer == NULL) {
        printf("Could not initialize frame buffer\n");
        exit(1);
    }
    
    for (int i = 0; i < size; i++) {
        frameBuffer[i].r = 0;
        frameBuffer[i].g = 0;
        frameBuffer[i].b = 0;
        frameBuffer[i].op = 0;
    }
}

pixcolor_t * FrameBufferGetAddress() {
    if (frameBuffer == NULL) {
        FrameBufferInit();
    }
    
    return frameBuffer;
}

int FrameShow() {
    printf("%dx%d\n", FrameBufferGetWidth(), FrameBufferGetHeight());
    
    int width = FrameBufferGetWidth();
    int height = FrameBufferGetHeight();
    pixcolor_t *frameBuffer = FrameBufferGetAddress();
    
    for (int h = 0; h < height; h++) {
        for (int w = 0; w < width; w++) {
            int i = h * width + w;
            if (frameBuffer[i].r == 0 && frameBuffer[i].g == 0 && frameBuffer[i].b == 0) {
                printf(" ");
            } else if (frameBuffer[i].r == 255 && frameBuffer[i].g == 255 && frameBuffer[i].b == 255) {
                printf("*");
            } else {
                printf("?");
            }
        }
        printf("\n");
    }
    
    return 0;
}