#include <stdio.h>
#include <time.h>

void print_timeB() {
  time_t current_time;
  struct tm *local_time;
  char buffer[80];
  current_time = time(NULL);
  local_time = localtime(&current_time);
  strftime(buffer, sizeof(buffer),  "%a %b %d %H:%M:%S %Z %Y", local_time);
  printf("%s", buffer);
}

void print_timeA() {
  time_t current_time;

  current_time = time(NULL);

  char *time_string = ctime(&current_time);

  printf("%s", time_string);
}
int main() {
  print_timeA();
  print_timeB();
  return 0;
}