// Kr�sas tips punktam: 
//    r,g,b ir sarkan�, za��, un zil� kr�su komponentes, 
//    op  ir oper�cija, kas j�izpilda �im pikselim ar fona kr�su. 0 - noz�m� rakst�t p�ri.
typedef struct {
    unsigned int r  : 10;
    unsigned int g  : 10;
    unsigned int b  : 10;
    unsigned int op : 2;
} pixcolor_t;
 
// Oper�cijas iesp�jas pikselim ar fona (FrameBuffer) kr�su.
// Izmantots pixcolor_t strukt�ras lauk� "op".
typedef enum {
    PIXEL_COPY = 0,
    PIXEL_AND  = 1,
    PIXEL_OR   = 2,
    PIXEL_XOR  = 3
} pixop_t;
 
// Funkcija krasas (un oper�cijas) uzt�d��anai
void setPixColor( pixcolor_t * color_op);
 
// Funkcija viena pikse�a uzstad��anai
void pixel(int x, int y, pixcolor_t * colorop);
 
// Funkcija l�nijas z�m��anai starp punktiem
void line(int x1, int y1, int x2, int y2);
 
// Funkcija trijst�ra aizpild��anai ar teko�o kr�su
void triangleFill(int x1, int y1, int x2, int y2, int x3, int y3);
 
// Funkcija ri��a l�nijas z�m��anai
void circle(int x1, int y1, int radius);

// Kadra bufera s�kuma adrese
pixcolor_t * FrameBufferGetAddress();
 
// Kadra platums
int FrameBufferGetWidth();
 
// Kadra augstums
int FrameBufferGetHeight();
 
// Kadra izvad��ana uz "displeja iek�rtas".
int FrameShow();

#define FRAME_WIDTH  40
#define FRAME_HEIGHT 20

#define COLOR_BLACK      " "
#define COLOR_WHITE      "*"
#define COLOR_RED        "R"
#define COLOR_GREEN      "G"
#define COLOR_BLUE       "B"
#define COLOR_GREEN_BLUE "C"
#define COLOR_RED_BLUE   "M"
#define COLOR_GREEN_RED  "Y"
#define COLOR_GRAY       "*"

#define COLOR_DEPTH 0x3ff