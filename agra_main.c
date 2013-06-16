#include <stdlib.h>
#include <stdio.h>

#include "agra.h"

pixcolor_t *make_color(unsigned r, unsigned g, unsigned b, unsigned op) {
    pixcolor_t *color = malloc(sizeof(pixcolor_t*));
    color->r = r;
    color->g = g;
    color->b = b;
    color->op = op;
    return color;
}

int main() {
    pixcolor_t *black = make_color(0, 0, 0, 0);
    pixcolor_t *white = make_color(COLOR_DEPTH, COLOR_DEPTH, COLOR_DEPTH, 0);
    pixcolor_t *red = make_color(0x3ff, 0, 0, 0);
    pixcolor_t *green = make_color(0, 0x3ff, 0, 0);
    pixcolor_t *blue = make_color(0, 0, 0x3ff, 0);
    
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
    //triangleFill(0, 19, 20, 19, 0, 10);
    
    setPixColor(red);
    circle(20, 10, 5);
    
    pixcolor_t *blue_or = make_color(0, 0, 0x3ff, 2);
    pixel(39, 0, red); // sarkans = R
    pixel(39, 0, blue_or); // sarkan zils = M
    
    FrameShow();
    return 0;
}
