#include <stdio.h>
#include "agra.h"

int main() {
    //int ret = 
    //circle(1, 2, 3);
    //printf("circle: %d\n", ret);
    
    pixcolor_t white, *whitep = &white;
    white.r = 255;
    white.g = 255;
    white.b = 255;
    
    pixel(0, 0, whitep);
    pixel(1, 0, whitep);
    pixel(0, 1, whitep);
    setPixColor(whitep);
    line(0, 0, 39, 19);
    line(39, 0, 0, 19);
    line(39, 19, 0, 0);
    circle(20, 10, 7);
    
    //triangleFill(0, 0, 0, 19, 39, 0);
    
    FrameShow();
    return 0;
}
