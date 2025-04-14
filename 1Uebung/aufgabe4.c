//
// Created by Michal Roziel on 14.04.25.
//
#include <stdio.h>
#include <math.h>


#define GERMANDICT 84578
#define ENGLISHDICT 104334



void computeEntropy(void) {
    srand(time(NULL));

    float resultGER = log2(GERMANDICT);
    float resultENG = log2(ENGLISHDICT);

    printf("Die Entropie der Wörter aus dem Deutschen Wörterbuch beträgt : %.2f \n", resultGER);
    printf("Die Entropie der Wörter aus dem Eglischen Wörterbuch beträgt : %.2f \n", resultENG);
}