/* mipslabwork.c

   This file written 2015 by F Lundevall
   Updated 2017-04-21 by F Lundevall

   This file should be changed by YOU! So you must
   add comment(s) here with your name(s) and date(s):

   This file modified 2017-04-31 by Ture Teknolog 

   For copyright and licensing, see file COPYING */

#include <stdint.h>   /* Declarations of uint_32 and the like */
#include <pic32mx.h>  /* Declarations of system-specific addresses etc */
#include "mipslab.h"  /* Declatations for these labs */

int prime = 1234567;

int mytime = 0x1653;

char textstring[] = "text, more text, and even more text!";

int timeoutcount = 0;

// Pekarna förklaras volatile för att undvika kompilatoroptimering som kan göra dem statiska
volatile int *Eport;
volatile int *trise;

/* Interrupt Service Routine */
void user_isr( void )
{
  	//Timern går upp till PR2 och sätter flaggan nedan till 1
  if(IFS(0) & 0x100){ //Vi kollar bit 8
    timeoutcount++;
	
	  if(timeoutcount == 10){
		  //time2string, display_string, display_update och tick bara anropas en gång av 10 time-outhändelser
		  //tidsvisningen uppdateras en gång per sekund
		  //delay( 1000 ); VI KOMMENTERAR UT DENNA
		  time2string( textstring, mytime );
		  display_string( 3, textstring );
		  display_update();
		  tick( &mytime );
		  timeoutcount = 0;
			//*Eport = 0x00000001 + *Eport; VI KOMMENTERAR UT DENNA

		  }	
    IFSCLR(0) = 0x100; //Återställ event flag med det rensade registret
  }
    if(IFS(0) & 0x80000)
	{
		PORTE = PORTE + 0x1; // Increment value in PORTE
		IFSCLR(0) = 0x80000; // Clear INT1IF
	}
	display_image(96, icon);

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
  TRISD = TRISD | 0x0fe0; //AND med 1111 1110 0000
  
  T2CON = 0x0; //Bara när T2CON-registret är satt kan PR2 hämtas.
  T2CONSET = 0x70; 
  TMR2 = 0x0; //Återställ timerregistret
  PR2 = ((80000000/256)/10); //100 ms mellanrum
  T2CONSET = 0x8000;
  
  //aktivera avbrott från Timer 2
  //aktivera avbrott globalt
  
  //s. 90 http://ww1.microchip.com/downloads/en/DeviceDoc/61143H.pdf
  
  
  IECSET(0) = 0x100; //åttonde biten för TIMER2 på s. 90 sätts till 1. Detta aktiverar flaggan.
  IPCSET(2) = 0x1F; //För att prioritera vår interrupt sätter vi enl. instr. bit 4-2 (priority) samt 1-0 (subpriority) till 1. S. 90
  
  //Överraskningsuppgift
  
  IECSET(0) = 0x80000; //sjunde biten för External Interrupt 1 på s. 90 sätts till 1. Detta aktiverar flaggan.
  IPCSET(2) = 0x1F000000; //För att prioritera vår interrupt sätter vi enl. instr. bit 28-26 (priority) samt 25-24 (subpriority) till 1. S. 90
  enable_interrupt();

  //Rad 1357 i pic32mx.h:

  
  return;
}

/* This function is called repetitively from the main program */
void labwork( void ) {
  prime = nextprime(prime);
  display_string(0, itoaconv(prime));
  display_update();
}
