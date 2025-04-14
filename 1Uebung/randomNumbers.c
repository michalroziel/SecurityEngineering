//
// Created by Michal Roziel on 14.04.25.
//

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
void getNumsUntilCorrectOne(int upperLimit,int magicNum){

    srand(time(NULL)); // new seeding

    int total = 0;

    for (int i = 0; i < 10000; i++) {
        int guessCounter = 0;
        int guessNum;
        // srand(time(NULL));
        do {
            guessNum = rand() % (upperLimit+1);
            guessCounter ++;
        } while (guessNum != magicNum);
        // printf("The Number %d was guessed, no. of tries : %d", magicNum, guessCounter);
       total+= guessCounter;
    }

    int mittelWert = total / 10000;

    printf("der Mittelwert ist : %d ", mittelWert);
}

void numsUntilTwoSame(int upperLimit) {
    int trials = 10000;   // Anzahl der Wiederholungen
    long total = 0;       // Summe der Zählwerte aller Versuche

    // Zufallszahlengenerator einmal initialisieren
    srand(time(NULL));

    for (int i = 0; i < trials; i++) {
        // Für jeden Durchlauf wird ein neues "visited"-Array angelegt

        int visited[upperLimit + 1];
        for (int j = 0; j < upperLimit + 1; j++) {
            visited[j] = 0;
        }



        int counter = 0;  // Zähler für diesen Versuch

        while (1) {
            int num = rand() % (upperLimit + 1);
            counter++;

            if (visited[num] == 0) {
                visited[num] = 1;
            } else {
                // Kollision gefunden: die Zahl ist schon zuvor aufgetreten
                break;
            }
        }
        total += counter;
    }

    int mittelWert = total / trials;
    printf("Der Mittelwert der Versuche bis zur ersten Kollision beträgt: %d\n", mittelWert);
}

