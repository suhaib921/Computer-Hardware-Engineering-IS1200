
#include <stdio.h>
#include <time.h>
#include <math.h>
clock_t start_t,end_t;

int is_prime(int n){
  int primtal;
  int i=2;
  for(i; i<=sqrt(n); i++)
    {
      if(n%i==0)
      { primtal = 0;
        break;
      }
      else 
        primtal=1;
         
    }
   
   return primtal;
}

int main(void){
  start_t=clock();
   
  printf("%d\n", is_prime(11));  // 11 is a prime.      Should print 1.
  printf("%d\n", is_prime(383)); // 383 is a prime.     Should print 1.
  printf("%d\n", is_prime(987)); // 987 is not a prime. Should print 0.
  end_t=clock();

  double total_t= (double) ((end_t-start_t)/CLOCKS_PER_SEC);

  printf("totat_time: %f\n", total_t);
}
