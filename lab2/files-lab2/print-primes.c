#include <stdio.h>
#include <stdlib.h>
#include <math.h>


#define COLUMNS 6

int antaltal = 0;

int is_prime(int n)
{
  int primtal;
  int i = 2;

  for(i; i <= sqrt(n); i++)
  {
    if(n % i == 0)
    {
      primtal = 0;
      break;
    }
    else
    {
      primtal = 1;
    }
  }
  
  return primtal;
}
void print_number(int n)
{
  if(antaltal % COLUMNS == 0 && antaltal != 0)
  {
    printf("\n");
  }

  printf("%10d ", n);
  antaltal++;

}
//add print_prime void som skriver ut.



// 'argc' contains the number of program arguments, and
// 'argv' is an array of char pointers, where each
// char pointer points to a null-terminated string.
int main(int argc, char argv[]){
  if(argc == 2)
    print_primes(atoi(argv[1])); //atoi = "Ascii to integer" och omvandlar en sträng (en sekvens av ASCII-tecken) till ett heltal
  else
    printf("Please state an interger number.\n");
  return 0;
}

/*
Create a new body for the function
print_primes.The function should print all prime numbers from 2 to n by calling
functions print_number and is_prime.
*/

