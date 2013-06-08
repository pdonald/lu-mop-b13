#include <stdlib.h>
#include <stdio.h>

#include "agra.h"

pixcolor_t *frameBuffer = NULL;

int FrameBufferGetWidth() {
    return FRAME_WIDTH;
}

int FrameBufferGetHeight() {
    return FRAME_HEIGHT;
}

void FrameBufferInit() {
    int width = FrameBufferGetWidth();
    int height = FrameBufferGetHeight();
    int size = width * height;
    
    frameBuffer = NULL;
    if (width >= 0 && height >= 0 && size >= 0) {
        frameBuffer = malloc(size * sizeof(pixcolor_t));
    }
    
    if (frameBuffer == NULL) {
        printf("Could not initialize frame buffer\n");
        exit(1);
    }
}

pixcolor_t * FrameBufferGetAddress() {
    if (frameBuffer == NULL) {
        FrameBufferInit();
    }
    
    return frameBuffer;
}

int FrameShow() {
    int width = FrameBufferGetWidth();
    int height = FrameBufferGetHeight();
    pixcolor_t *fb = FrameBufferGetAddress();
    
    for (int h = 0; h < height; h++) {
        for (int w = 0; w < width; w++) {
            int i = h * width + w;
            
            if ((fb[i].r & COLOR_DEPTH) == 0 && (fb[i].g & COLOR_DEPTH) == 0 && (fb[i].b & COLOR_DEPTH) == 0) {
                printf(COLOR_BLACK);
            }
            else if ((fb[i].r & COLOR_DEPTH) == COLOR_DEPTH && (fb[i].g & COLOR_DEPTH) == COLOR_DEPTH && (fb[i].b & COLOR_DEPTH) == COLOR_DEPTH) {
                printf(COLOR_WHITE);
            }
            
            else if ((fb[i].r & COLOR_DEPTH) > (fb[i].g & COLOR_DEPTH) && (fb[i].r & COLOR_DEPTH) > (fb[i].b & COLOR_DEPTH)) {
                printf(COLOR_RED);
            }
            else if ((fb[i].g & COLOR_DEPTH) > (fb[i].r & COLOR_DEPTH) && (fb[i].g & COLOR_DEPTH) > (fb[i].b & COLOR_DEPTH)) {
                printf(COLOR_GREEN);
            }
            else if ((fb[i].b & COLOR_DEPTH) > (fb[i].r & COLOR_DEPTH) && (fb[i].b & COLOR_DEPTH) > (fb[i].g & COLOR_DEPTH)) {
                printf(COLOR_BLUE);
            }
            
            else if ((fb[i].g & COLOR_DEPTH) > (fb[i].r & COLOR_DEPTH) && (fb[i].b & COLOR_DEPTH) > (fb[i].r & COLOR_DEPTH)) {
                printf(COLOR_GREEN_BLUE);
            }
            else if ((fb[i].r & COLOR_DEPTH) > (fb[i].g & COLOR_DEPTH) && (fb[i].b & COLOR_DEPTH) > (fb[i].g & COLOR_DEPTH)) {
                printf(COLOR_RED_BLUE);
            }
            else if ((fb[i].g & COLOR_DEPTH) > (fb[i].b & COLOR_DEPTH) && (fb[i].r & COLOR_DEPTH) > (fb[i].b & COLOR_DEPTH)) {
                printf(COLOR_GREEN_RED);
            }
            
            else {
                printf(COLOR_GRAY); // r = g = b
            }
        }
        printf("\n");
    }
    
    return 0;
}
