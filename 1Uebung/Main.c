#include <stdio.h>
#include <time.h>
#include "randomNumbers.c"
#include "aufgabe4.c"


void print_timeB() {
  time_t current_time;

  // struct um jahr,monat,tag, etc. lesbar zu speichern
  struct tm *local_time;

  char buffer[80];

  current_time = time(NULL);
  local_time = localtime(&current_time);
  strftime(buffer, sizeof(buffer),  "%a %b %d %H:%M:%S %Z %Y", local_time);
  printf("%s", buffer);
}

void print_timeA() {

  // in sekunden seit 1970 gespeichert
  time_t current_time;

  // gibt zeit in seconds zurück
  current_time = time(NULL);

  //Formatierung
  //mit ctime in lesbare Zeichenkette umwandeln,
  // Strings sind char* in C
  char *time_string = ctime(&current_time);

  printf("%s", time_string);
}
int main() {
 // print_timeA();
 // print_timeB();

//getNumsUntilCorrectOne(10000,42);
 // numsUntilTwoSame(10000);

    computeEntropy();





  return 0;
}