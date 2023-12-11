#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>
clock_t start_t,end_t;


#define COLUMNS 6

int antaltal = 0;
void print_number(int n)
{
  if(antaltal % COLUMNS == 0 && antaltal != 0)
  {
    printf("\n");
  }

  printf("%10d ", n);
  antaltal++;
}

void print_sieves(int n)
{
    int i;
    int k;
    char *siffra;

    if((siffra = malloc(sizeof(char) * n)) == NULL)
    {
        printf("Allokering av minnet misslyckades");
        exit(0);
    }

    for(i = 0; i < n; i++)
    {
       siffra[i] = 1;
    }

    for(i = 2; i <= (int) sqrt(n); i++)
    {
        if (siffra[i])
        {
            for(k = i*i; k < n; k+= i)
            {
                siffra[k] = 0;
            }
        }
    }

    for(i = 2; i < n; i++)
    {
        if((int) siffra[i])
        {
            print_number(i);
        }
    }

    printf("\n");
    free(siffra);
}

// 'argc' contains the number of program arguments, and
// 'argv' is an array of char pointers, where each
// char pointer points to a null-terminated string.
int main(int argc, char *argv[]){
	start_t=clock();
	if(argc == 2)
		print_sieves(atoi(argv[1]));
	else
		printf("Please state an interger number.\n");
	end_t=clock();
	double total_t= (double) ((end_t-start_t)/CLOCKS_PER_SEC);

  	printf("totat_time: %f\n", total_t);
	return 0;
}
