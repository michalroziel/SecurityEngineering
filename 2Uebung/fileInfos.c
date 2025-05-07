//
// Created by Michal Roziel on 06.05.25.
//

#include <stdio.h>
#include <sys/stat.h>
#include <time.h>
#include <pwd.h>

void formatTime(time_t timeGiven) {
    char *time_string = ctime(&timeGiven);

    printf("%s", time_string);
}

//https://stackoverflow.com/questions/47561721/c-sys-stat-h-find-file-type
//Stack OverFLow : Benutzen von BitMasken, um den File Type rauszulesen


const char* getFileType(struct stat fileStat) {
    switch (fileStat.st_mode & S_IFMT) {
        case S_IFREG:
            return "Regular file";
        case S_IFDIR:
            return "Directory";
        case S_IFCHR:
            return "Character device";
        case S_IFBLK:
            return "Block device";
        case S_IFIFO:
            return "FIFO/pipe";
        case S_IFLNK:
            return "Symbolic link";
        case S_IFSOCK:
            return "Socket";
        default:
            return "Unknown";
    }
}


void printInfos(const char *filePath) {
    printf("File Infos for %s: \n\n", filePath);

    struct stat fileStat;

    if (stat(filePath, &fileStat) != 0) {

        perror("Problem bei  file information");

    } else {

        // File Type :
        printf("File type: %s\n", getFileType(fileStat));

        // File Size :
        printf("File size: %lld bytes\n", fileStat.st_size);





        // User iD :
        printf("UiD : %d\n", fileStat.st_uid);

        // Group iD :
        printf("GiD : %d\n", fileStat.st_gid);

        // Name des Benutzer :

        struct passwd *pw = getpwuid(fileStat.st_uid);
        if (pw) {
            printf("Benutzername: %s\n", pw->pw_name);
        } else {
            printf("Benutzername nicht gefunden\n");
        }

        // Access Rechte mit oktaler BitMaske:

        printf("Zugriffsrechte: %04o \n", fileStat.st_mode & 07777);


        // Letzter Zugriff auf Datei - Lesen :
        printf("Last Read Access: \n");
        formatTime(fileStat.st_atime);


        // Inode Modified - Änderung der Meta Daten :
        printf("Last Inode Modification: \n");
        formatTime(fileStat.st_ctime);

        // Letzte Änderung der File :
        printf("Last modified: \n");
        formatTime(fileStat.st_mtime);














    }
}


int main(int argc, char *argv[]) {

    // Check if a file path was provided

    if (argc < 2) {

        printf("Usage: %s <filepath>\n", argv[0]);
        return 1;
    }

    // Call printInfos with the provided file path
    printInfos(argv[1]);

    return 0;
}