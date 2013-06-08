#include <stdlib.h>
#include <stdio.h>

#include "agra.h"

pixcolor_t *make_color(int r, int g, int b) {
    pixcolor_t *color = malloc(sizeof(pixcolor_t*));
    color->r = r;
    color->g = g;
    color->b = b;
    color->op = 0;
    return color;
}

int main() {
    pixcolor_t *black = make_color(0, 0, 0);
    pixcolor_t *white = make_color(COLOR_DEPTH, COLOR_DEPTH, COLOR_DEPTH);
    pixcolor_t *red = make_color(0x3ff, 0, 0);
    pixcolor_t *green = make_color(0, 0x3ff, 0);
    pixcolor_t *blue = make_color(0, 0, 0x3ff);
    
    int width = FrameBufferGetWidth();
    int height = FrameBufferGetHeight();

    for (int w = 0; w < width; w++) {
        for (int h = 0; h < height; h++) {
            pixel(w, h, black);
        }
    }
    
    pixel(25, 2, white);
    
    setPixColor(blue);
    line(0, 0, 39, 19);
    
    setPixColor(green);
    triangleFill(0, 19, 20, 19, 0, 10);
    
    setPixColor(red);
    circle(20, 10, 5);
    
    FrameShow();
    return 0;
}
