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
    pixcolor_t *white = make_color(0x3ff, 0x3ff, 0x3ff, 0);
    pixcolor_t *red = make_color(0x3ff, 0, 0, 0);
    pixcolor_t *green = make_color(0, 0x3ff, 0, 0);
    pixcolor_t *blue = make_color(0, 0, 0x3ff, 0);
    
    // 1. definēt ekrāna buferi ar izmēru 40 x 20 (lietojot jūsu framebuffer.c versiju)
    FrameBufferSetSize(40, 20);
    
    // 2. notīrīt buferi, aizpildīt katru pikseli ar 0x00000000
    int width = FrameBufferGetWidth();
    int height = FrameBufferGetHeight();

    for (int w = 0; w < width; w++) {
        for (int h = 0; h < height; h++) {
            pixel(w, h, black);
        }
    }
    
    // 3. zīmēt pikseli koordinātās (25,2), baltu.
    pixel(25, 2, white);
    
    // 4. zīmēt līniju no (0,0) līdz (39,19), zilu, ar intensitāti 0x03ff
    setPixColor(blue);
    line(0, 0, 39, 19);
    
    // 5. zīmēt aizpildītu trijstūri, zaļu, ar intensitāti 0x03ff
    setPixColor(green);
    triangleFill(0, 19, 20, 19, 0, 10);
    //triangleFill(0, 10, 0, 19, 20, 19);
    //triangleFill(0, 0, 0, 19, 39, 19);
    //triangleFill(39, 0, 0, 19, 39, 15);
    //triangleFill(15, 0, 3, 10, 37, 10);
    //triangleFill(1, 1, 20, 1, 10, 10);
    //triangleFill(10, 10, 1, 1, 20, 1);
    //triangleFill(20, 0, 0, 10, 30, 15);
    //triangleFill(30, 15, 0, 10, 20, 0);
    
    // 6. zīmēt riņķa līniju ar centru (20,10) un rādiusu 5, sarkanu, ar intensitāti 0x03ff
    setPixColor(red);
    circle(20, 10, 5);
    
    // operācijas
    pixcolor_t *white_and = make_color(0x3ff, 0x3ff, 0x3ff, 1);
    pixcolor_t *blue_or = make_color(0, 0, 0x3ff, 2);
    pixcolor_t *green_xor = make_color(0, 0x3ff, 0, 3);
    // op = and
    pixel(37, 0, red); // sarkans = R
    pixel(37, 0, white_and); // joprojām sarkans = R
    // op = or
    pixel(38, 0, red); // sarkans = R
    pixel(38, 0, blue_or); // sarkanzils = M
    // op = xor
    pixel(39, 0, red); // sarkans = R
    pixel(39, 0, green_xor); // sarkanzaļš = Y
    
    // 7. izsaukt funkciju FrameShow()
    FrameShow();
    
    return 0;
}
