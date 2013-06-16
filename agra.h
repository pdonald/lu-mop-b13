// Krâsas tips punktam: 
//    r,g,b ir sarkanâ, zaïâ, un zilâ krâsu komponentes, 
//    op  ir operâcija, kas jâizpilda ðim pikselim ar fona krâsu. 0 - nozîmç rakstît pâri.
typedef struct {
    unsigned int r  : 10;
    unsigned int g  : 10;
    unsigned int b  : 10;
    unsigned int op : 2;
} pixcolor_t;
 
// Operâcijas iespçjas pikselim ar fona (FrameBuffer) krâsu.
// Izmantots pixcolor_t struktûras laukâ "op".
typedef enum {
    PIXEL_COPY = 0,
    PIXEL_AND  = 1,
    PIXEL_OR   = 2,
    PIXEL_XOR  = 3
} pixop_t;
 
// Funkcija krasas (un operâcijas) uztâdîðanai
void setPixColor( pixcolor_t * color_op);
 
// Funkcija viena pikseïa uzstadîðanai
void pixel(int x, int y, pixcolor_t * colorop);
 
// Funkcija lînijas zîmçðanai starp punktiem
void line(int x1, int y1, int x2, int y2);
 
// Funkcija trijstûra aizpildîðanai ar tekoðo krâsu
void triangleFill(int x1, int y1, int x2, int y2, int x3, int y3);
 
// Funkcija riòía lînijas zîmçðanai
void circle(int x1, int y1, int radius);

// Kadra bufera sâkuma adrese
pixcolor_t * FrameBufferGetAddress();
 
// Kadra platums
int FrameBufferGetWidth();
 
// Kadra augstums
int FrameBufferGetHeight();
 
// Kadra izvadîðana uz "displeja iekârtas".
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