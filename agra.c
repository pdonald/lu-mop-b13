#include <stdlib.h>
#include "agra.h"

pixcolor_t *currentColor;

void pixel(int x, int y, pixcolor_t *colorop) {
    //int w = FrameBufferGetWidth();
    //int h = FrameBufferGetHeight();
    
    //if (x < 0 || x >= w) return;
    //if (y < 0 || y >= h) return;

    pixcolor_t *frameBuffer = FrameBufferGetAddress();
    int index = 1; //y * w + x;
    frameBuffer[index].r = colorop->r;
    frameBuffer[index].g = colorop->g;
    frameBuffer[index].b = colorop->b;
}

void setPixColor(pixcolor_t *color_op) {
    currentColor = color_op;
}

void line(int x0, int y0, int x1, int y1) {
   int dx = abs(x1-x0);
   int dy = abs(y1-y0);
   int sx = x0 < x1 ? 1 : -1;
   int sy = y0 < y1 ? 1 : -1;
   int err = dx-dy;
 
   while (1) {
     pixel(x0, y0, currentColor);
     if (x0 == x1 && y0 == y1)
        break;
     int e2 = 2*err;
     if (e2 > -dy) {
       err = err - dy;
       x0 = x0 + sx;
     }
     if (x0 == x1 && y0 == y1) {
       pixel(x0,y0, currentColor);
       break;
     }
     if (e2 < dx) {
       err = err + dx;
       y0 = y0 + sy;
     }
   }
}
 

// The '(x != 0 && y != 0)' test in the last line of this function
// may be omitted for a performance benefit if the radius of the
// circle is known to be non-zero.
void plot4points(int cx, int cy, int x, int y) {
  pixel(cx + x, cy + y, currentColor);
  if (x != 0) pixel(cx - x, cy + y, currentColor);
  if (y != 0) pixel(cx + x, cy - y, currentColor);
  if (x != 0 && y != 0) pixel(cx - x, cy - y, currentColor);
}

void plot8points(int cx, int cy, int x, int y) {
  plot4points(cx, cy, x, y);
  if (x != y) plot4points(cx, cy, y, x);
}

void circle(int cx, int cy, int radius) {
  int error = -radius;
  int x = radius;
  int y = 0;
 
  // The following while loop may be altered to 'while (x > y)' for a
  // performance benefit, as long as a call to 'plot4points' follows
  // the body of the loop. This allows for the elimination of the
  // '(x != y)' test in 'plot8points', providing a further benefit.
  //
  // For the sake of clarity, this is not shown here.
  while (x >= y)
  {
    plot8points(cx, cy, x, y);
 
    error += y;
    ++y;
    error += y;
 
    // The following test may be implemented in assembly language in
    // most machines by testing the carry flag after adding 'y' to
    // the value of 'error' in the previous step, since 'error'
    // nominally has a negative value.
    if (error >= 0)
    {
      error -= x;
      --x;
      error -= x;
    }
  }
}
