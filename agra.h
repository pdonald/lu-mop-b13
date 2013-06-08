// Krâsas tips punktam: 
//    r,g,b ir sarkanâ, zaïâ, un zilâ krâsu komponentes, 
//    op  ir operâcija, kas jâizpilda ðim pikselim ar fona krâsu. 0 - nozîmç rakstît pâri.
typedef struct {
    int r  : 10;
    int g  : 10;
    int b  : 10;
    int op: 2;
} pixcolor_t;
 
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

#define FrameWidth  40
#define FrameHeight  20
