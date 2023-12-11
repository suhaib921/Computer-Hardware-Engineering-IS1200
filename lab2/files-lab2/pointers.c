


#include <stdio.h>

char* text1 = "This is a string.";
char* text2 = "Yet another thing.";
//################

int lista1[20];  // En int är 4 bytes, behöver        
int lista2[20];  // allokera 80 bytes vilket blir 20 då 20x4 = 80 bytes
int count = 0; 

void work() // 
{
	
	copycodes(text1, lista1, &count);
	copycodes(text2, lista2, &count);
}

void copycodes(char* text, int* lista, int* count)  // addressen till två char arrays och räknare får vi här som parameterar.
{

	while(*text != 0) {
		
		*lista = *text; //sw	$t0,0($a1) 
		
		text++; //increment till nästa addresen av text character med 1 !-$a0, text  addi $a0,$a0,1
		lista++; //ändra addressen! med 4- $a1, lista     addi $a1,$a1,4 
		(*count)++; // ändra värdet!, räknare  //dereferencing the pointer and incrementing the value
	}
}
//#########


void printlist(const int* lst){
  printf("ASCII codes and corresponding characters.\n");
  while(*lst != 0){
    printf("0x%03X '%c' ", *lst, (char)*lst);
    lst++;
  }
  printf("\n");
}
//prints the values of the last byte(g) in a 4-byte integer
//big-endian stores the most significant byte first
// whether big or little indian it affects how multi-bytes values are stored and read from the memory
void endian_proof(const char* c){
  printf("\nEndian experiment: 0x%02x,0x%02x,0x%02x,0x%02x\n", 
         (int)*c,(int)*(c+1), (int)*(c+2), (int)*(c+3));
  
}

int main(void){
  work();

  printf("\nlist1: ");
  printlist(list1);
  printf("\nlist2: ");
  printlist(list2);
  printf("\nCount = %d\n", count);

  endian_proof((char*) &count);
}
