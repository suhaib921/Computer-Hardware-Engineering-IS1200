#include <stdint.h>
#include <pic32mx.h>
#include "mipslab.h"

//På PORTD finns både knapparnas och switcharnas data

int getbtns(){ //7, 6, 5. Knappar 4, 3, 2
  int knappar = PORTD>>5;
  return (knappar & 0x0007); //0000 0000 0000 0111. 
}

int getsw(){ //11, 10, 9, 8. Switchar 4, 3, 2, 1
  int switchar = PORTD>>8;
  return (switchar & 0x000f); //0000 0000 0000 1111
}

//1111 0000 1010 0011

//0000000 10101011