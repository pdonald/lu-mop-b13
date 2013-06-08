// Kr�sas tips punktam: 
//    r,g,b ir sarkan�, za��, un zil� kr�su komponentes, 
//    op  ir oper�cija, kas j�izpilda �im pikselim ar fona kr�su. 0 - noz�m� rakst�t p�ri.
typedef struct {
    int r  : 10;
    int g  : 10;
    int b  : 10;
    int op: 2;
} pixcolor_t;
 
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

#define FrameWidth  40
#define FrameHeight  20
