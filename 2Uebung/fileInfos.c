//
// Created by Michal Roziel on 06.05.25.
//

#include <stdio.h>
#include <sys/stat.h>

void printInfos() {
    printf("File Infos:\n\n");

    struct stat fileStat;

    if (stat("2Uebung/poem.txt", &fileStat) != 0) {

        perror("Error retrieving file information");

    } else {

        printf("File size: %lld bytes\n", fileStat.st_size);
        printf("Last modified: %ld\n", fileStat.st_mtime);


    }
}

int main(void) {
    printInfos();
    return 0;
}