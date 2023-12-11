/*	mipslabwork.c:

   This file written 2015 by F Lundevall
   Updated 2017-04-21 by F Lundevall

   This file should be changed by YOU! So you must
   add comment(s) here with your name(s) and date(s):

   This file modified 2017-04-31 by Ture Teknolog 

   For copyright and licensing, see file COPYING */

#include <stdint.h>   /* Declarations of uint_32 and the like */
#include <pic32mx.h>  /* Declarations of system-specific addresses etc */
#include "mipslab.h"  /* Declatations for these labs */

int mytime = 0x1653;

char textstring[] = "text, more text, and even more text!";

// Pekarna förklaras volatile för att undvika kompilatoroptimering som kan göra dem statiska
volatile int *Eport;
volatile int *trise;



/* Interrupt Service Routine */
void user_isr( void )
{
  return;
}

/* Lab-specific initialization goes here */
void labinit( void )
{
	//initialize Port E so that bits 7 through 0 of Port E are set as outputs (i.e., the 8 least significant bits). These bits are connected to 8 green
	//LEDs on the Basic IO Shield. 
	//Register trise has address 0xbf886100.You should initialize the port using your own volatile pointer, that is, you should not use the definitions in pic32mx.h, yet.
	//Do not change the function (direction) of any other bits of Port E.

  //HUR HITTAR VI ADRESSEN?
  //trise sätts till 0xbf886100 medan Eport sätts till 0xbf886110 (enligt instruktionerna)
  Eport = (volatile int*) 0xbf886110; 
  trise = (volatile int*) 0xbf886100; 
  *trise = *trise & 0xffffff00; // Trises innehåll ska enbart ha kvar de 2 LSB
  *Eport = 0x00000000; //Vi sätter innehållet på Eport till 0 så att vi kan se eventuella förändringar tydligt
  TRISD = TRISD | 0x0fe0; //OR med 1111 1110 0000
  return;
}

/* This function is called repetitively from the main program */
void labwork( void )
{
  int knappar = getbtns();
  int switchar = getsw();

//Tiden är 0000 0000:0000 0000
//         0000 0001

	switch(knappar) {
	  case 1: // Knapp 2 (001)
		mytime = mytime & 0xff0f;
		mytime = (switchar << 4) | mytime;
		break;
	  case 2: // Knapp 3 (010)
		mytime = mytime & 0xf0ff;
		mytime = (switchar << 8) | mytime;
		break;
	  case 4: // Knapp 4 (100)
		mytime = mytime & 0x0fff;
		mytime = (switchar << 12) | mytime;
		break;
	  case 3: // Knapp 2 och 3 (011)
		mytime = mytime & 0xf0f;
		mytime = (switchar << 4) | (mytime & 0xf00) | (switchar << 8);
		break;
	  case 5: // Knapp 2 och 4 (101)
		mytime = mytime & 0xf00f;
		mytime = (switchar << 4) | (mytime & 0xf0) | (switchar << 12);
		break;
	  case 6: // Knapp 3 och 4 (110)
		mytime = mytime & 0x0fff;
		mytime = (switchar << 8) | (mytime & 0xf00) | (switchar << 12);
		break;
	  case 7: // Knapp 2, 3, och 4 (111)
		mytime = (switchar << 4) | (switchar << 8) | (switchar << 12);
		break;
	  default:
		// Ingen knapp
		break;
	}
  delay( 10000 ); //pausar programmet i en sekund? innan nästa iteration av slingan körs.
  time2string( textstring, mytime );
  display_string( 3, textstring );
  display_update(); //uppdaterar skärmen med den senaste informationen
  tick( &mytime ); //uppdaterar tidsvariabeln genom att öka den med en sekund
  display_image(96, icon); //visar en bild på LCD-skärmen 
  *Eport = 0x00000001 + *Eport;
  
}

