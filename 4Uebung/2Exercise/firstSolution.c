#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>      // für shm_open
#include <sys/mman.h>   // für mmap
#include <sys/stat.h>   // für Rechte (0666)
#include <sys/wait.h>   // für wait


#define N_DATA 2000000
#define N_SHARED 2000



#define MY_SHM_NAME "MySharedMemory" // Name des Shared Memory Segments
#define SHM_SIZE (N_DATA * sizeof(int)) // Größe des Shared Memory Segments

// Function to map shared memory into process address space
void *map_shared_memory(int shm_fd, size_t size) {
    void *addr = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, shm_fd, 0);
    if (addr == MAP_FAILED) {
        perror("Memory mapping failed");
        exit(EXIT_FAILURE);
    }
    return addr;
}

int main() {
    // Shared Memory Segment anlegen
    // 666 -> Zugriffsrechte für alle Benutzer (Lesen und Schreiben)


   // https://www.geeksforgeeks.org/posix-shared-memory-api/
    int shm_fd = shm_open(MY_SHM_NAME, O_CREAT | O_RDWR, 0666);
    if (shm_fd == -1) {
        perror("shm_open");
        exit(EXIT_FAILURE);
    }

    // https://www.tutorialspoint.com/unix_system_calls/ftruncate.html
    // Das shared memory Segment hat am anfang 0 Bytes, wir erwitern

    if (ftruncate(shm_fd, SHM_SIZE) == -1) {
        perror("ftruncate Failure !");
        exit(EXIT_FAILURE);
    }

    // In den Adressraum einbinden
    void *shm_ptr = map_shared_memory(shm_fd, SHM_SIZE);

    // wir erzeugen einen Kindprozess, der auf das Shared Memory zugreift
    pid_t pid = fork();

    if (pid < 0) {
        perror("fork failure !");
        exit(EXIT_FAILURE);
    }

    if (pid == 0) {


        // Process 2 (P2) - Child Process


        sleep(3); // Warten, damit P1 zuerst schreiben kann


        char* mem_string = (char *) shm_ptr;
        printf("Shared Memory Content READ by Child Process [P2]: %s\n", mem_string);

        //shm_ptr pointer to previously mapped shared memory
        // munmap - remove a mapping to shared memory
        // // https://www.tutorialspoint.com/unix_system_calls/munmap.htm

        munmap(shm_ptr, SHM_SIZE);
        exit(EXIT_SUCCESS);


    } else {
        // Process 1 (P1) - Parent Process

        const char *msg = "[WRITTEN IN SHARED MEMORY]";

        strcpy((char *)shm_ptr, msg);

        printf("Shared Memory Content WRITE by Parent Process [P1]  %s\n", msg);

        wait(NULL); // auf Kindprozess warten

        munmap(shm_ptr, SHM_SIZE);

        // now we can unlink the shared memory segment
        // https://pubs.opengroup.org/onlinepubs/009696699/functions/shm_unlink.html


        shm_unlink(MY_SHM_NAME); // Speichersegment löschen
    }

    return 0;
}