//
// Created by Michal Roziel on 14.04.25.
//

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
void getNumsUntilCorrectOne(int upperLimit,int magicNum){

    // a) ein vorgegebener Wert y ausgegeben wird (simuliert Pre-Image)

    // new seeding für den Zufallsgenerator
    // durch NULL wird es mit der aktuellen Uhrzeit initialisiert
    srand(time(NULL));

    // GesamtAnzahl der Versuche über alle Durchläufe
    int total = 0;

    for (int i = 0; i < 10000; i++) {

        // guessCounter für einzelne Durchlaufe
        int guessCounter = 0;
        int guessNum;
        // srand(time(NULL));
        do {

            //modulo zum reduzieren der Zahl kleineren Bereich
            guessNum = rand() % (upperLimit+1);

            // addieren + 1 zu den Versuchen
            guessCounter ++;

        } while (guessNum != magicNum);
        // printf("The Number %d was guessed, no. of tries : %d", magicNum, guessCounter);
       total+= guessCounter;
    }

    // nach 10k runs wird der mittelwert berechnet
    int mittelWert = total / 10000;

    printf("der Mittelwert ist : %d ", mittelWert);
}




void numsUntilTwoSame(int upperLimit) {

    // b) ein Wert y ausgegeben wird, der mit einem der vorherigen Werte ¨ ubereinstimmt
    // (simuliert Collision)

    // 10000 Proben zur Berechnung des Mittelwerts
    int trials = 10000;   // Anzahl der Wiederholungen
    long total = 0;       // Summe der Zählwerte aller Versuche

    // Zufallszahlengenerator einmal initialisieren
    srand(time(NULL));

    for (int i = 0; i < trials; i++) {
        // Für jeden Durchlauf wird ein neues "visited"-Array angelegt

        // Array zum schauen welche Zahlen bereits gezogen wurden
        int visited[upperLimit + 1];

        // zu beginn alle Einträge auf 0 setzen
        for (int j = 0; j < upperLimit + 1; j++) {
            visited[j] = 0;
        }

        int counter = 0;  // Zähler für diesen Versuch

        while (1) {
            //Zahl ziehen und durch Modulo auf Limit-Bereich beschränken
            int num = rand() % (upperLimit + 1);
            counter++;

            if (visited[num] == 0) {

                // wenn wir eine Zahl ziehen, markieren wir

                // in dem Array eine 1
                visited[num] = 1;
            } else {
                // Kollision gefunden: die Zahl ist schon zuvor aufgetreten
                //DH : wir können den loop abbrechen
                break;
            }
        }
        // Anzahl der Versuche zu total addieren
        total += counter;
    }

    // wir können den Mittelwert bestimmen
    int mittelWert = total / trials;
    printf("Der Mittelwert der Versuche bis zur ersten Kollision beträgt: %d\n", mittelWert);
}

