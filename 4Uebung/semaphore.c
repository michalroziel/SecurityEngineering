#include <stdio.h>
#include <stdlib.h> // lrand48() für Zufallszahlen
#include <unistd.h> // fork()
#include <sys/ipc.h> // Inter Process Communication (IPC) Funktionen
#include <sys/shm.h> //  Shared Memory Funktionen
#include <sys/sem.h> // Semaphoren Funktionen
#include <sys/wait.h> //  waitpid() - Warten auf Kindprozess
#include <time.h> // -> Zeitfunktionen für Zufallszahlengenerierung

#define N_DATA 2000000 // Anzahl der zu generierenden Daten
#define N_SHARED 2000 // Anzahl der Daten im Shared Memory

// FIX kEy

#define SHM_KEY 1234 // Schlüssel für Shared Memory
#define SEM_KEY 5678 // Schlüssel für Semaphoren

#define SEM_CAN_WRITE 0 // Semaphore für Schreibzugriff
#define SEM_CAN_READ 1 // Semaphore für Lesezugriffls


//https://man7.org/linux/man-pages/man2/semop.2.html

//https://www.tutorialspoint.com/inter_process_communication/inter_process_communication_semaphores.html


// Semaphore Operationen deklarieren
struct sembuf sem_wait_op(int semnum) {
    return (struct sembuf){
        semnum, -1, 0
    };


} // sem_wait_op - (Warten auf Semaphore) ~= "wait" oder "lock"

struct sembuf sem_signal_op(int semnum) {
    return (struct sembuf){
        semnum, +1, 0
    };

} //  sem_signal_op - (Freigeben der Semaphore) ~= "signal" oder "unlock"

// Shared Memory initialisieren
int* init_shared_memory(int *shm_id) {
    //
    //    https://stackoverflow.com/questions/50096350/use-of-ftok-to-create-key-and-how-to-use-the-key
    //     FTOK() - Erzeugt einen eindeutigen Schlüssel für IPC-Objekte
    //
    // HIER : einfacher Key


    // Erstellen Shared Memory Segment,
    // SIZE: sizeof(int) * N_SHARED --> 2000 Integer Vals.

    *shm_id = shmget(SHM_KEY, sizeof(int) * N_SHARED, IPC_CREAT | 0666);

     // IPC_CREAT: If not already exists, create a new shared memory segment

     // 0666: Zugriffsrechte Read and Write für alle Benutzer
     // 0 -> signalisiert C Compiler, dass es sich um Oktalzahl handelt

    if (*shm_id == -1) {
      // falls shmget fehlschlägt, wird -1 zurückgegeben
        perror("shmget");
        exit(EXIT_FAILURE);
    }


    //https://stackoverflow.com/questions/48671885/accessing-a-shared-memory-buffer-in-another-process
    // Anhängen des Shared Memory Segments an den Adressraum des Prozesses gibt Pointer auf Shared Memory Segment zurück
    // Pointer auf shared mem, falls wir shared mem seg dort anhängen
    int *shared_buffer = (int *)shmat(*shm_id, NULL, 0);

    if (shared_buffer == (void *)-1) {
        perror("shmat");
        exit(EXIT_FAILURE);
    }

    return shared_buffer;
}

// Semaphoren initialisieren

int init_semaphores() {
    // FIX KEY for semaphores
    int sem_id = semget(SEM_KEY, 2, IPC_CREAT | 0666);
    // Erstellen eines Semaphor-Sets mit 2 Semaphoren (für Schreiben und Lesen), falls es nicht existiert
    // IPC_CREAT: Set erstellen, falls es nicht existiert

    if (sem_id == -1) {
        perror("semget");
        exit(EXIT_FAILURE);
    }

    // https://www.ibm.com/docs/en/zos/2.4.0?topic=functions-semctl-semctl64-semaphore-control-operations

    semctl(sem_id, SEM_CAN_WRITE, SETVAL, 1); // Initialisieren der Schreib-Semaphore auf 1 (erlaubt Schreiben)
    semctl(sem_id, SEM_CAN_READ, SETVAL, 0); // Initialisieren der Lese-Semaphore auf 0 (nicht erlaubt zu lesen, bis Daten geschrieben wurden)

    return sem_id;
}

// Ressourcen entfernen
void remove_resources(int shm_id, int sem_id, int *shared_buffer) {

      // Trennt das Shared Memory Segment vom Adressraum des Prozesses
        shmdt(shared_buffer);
      // Zeiger auf Shared Memory Segment wird freigegeben
        shmctl(shm_id, IPC_RMID, NULL);
        // Entfernt das Shared Memory Segment
        semctl(sem_id, 0, IPC_RMID);
}

// Erzeugerprozess wird Daten generieren und in den Shared Memory schreiben
void producer_process(int *shared_buffer, int sem_id) {


    // Initialisieren des Zufallszahlengenerators
    srand48(time(NULL));

    // Generieren von N_DATA array mit Zufallszahlen
    int data[N_DATA];
    for (int i = 0; i < N_DATA; i++) {

      // lrand48() generiert eine Zufallszahl
        data[i] = lrand48();
    }

    // Zufallszahlen Blockweise in den Shared Memory schreiben
    for (int i = 0; i < N_DATA; i += N_SHARED) {


        // Anzahl der zu schreibenden Daten im aktuellen Block
        //Falls die verbleibenden Daten weniger als "N_SHARED" sind,
        // wird nur dieser kleinere Wert [ N_DATA - i ] benutzt
        int count = (N_DATA - i < N_SHARED) ? (N_DATA - i) : N_SHARED;

        struct sembuf p_op = sem_wait_op(SEM_CAN_WRITE); // Producer-Operation auf Schreib-Semaphore
        semop(sem_id, &p_op, 1); // Warten auf Schreib-Semaphore, frei zum Schreiben ?

        printf("Producer: schreibe Datenblock %d (Index %d bis %d)\n",
           i / N_SHARED, i, i + count - 1);

        // Daten in den Shared Memory schreiben
        for (int j = 0; j < count; j++) {
            shared_buffer[j] = data[i + j];
        }

        printf("Producer: Datenblock %d geschrieben, Consumer darf lesen.\n", i / N_SHARED);

        struct sembuf prod_op = sem_signal_op(SEM_CAN_READ); // Producer-Operation auf Lese-Semaphore

        // Freigeben des Lese-Semaphore, damit der Verbraucher lesen kann
        semop(sem_id, &(prod_op), 1);
    }
}

// Verbraucherprozess wird Daten aus dem Shared Memory lesen
void consumer_process(int *shared_buffer, int sem_id) {

    for (int i = 0; i < N_DATA; i += N_SHARED) {

      // wenn wniger als N_SHARED Daten übrig sind, dann nur die verbleibenden lesen
        int count = (N_DATA - i < N_SHARED) ? (N_DATA - i) : N_SHARED;

        struct sembuf p_op = sem_wait_op(SEM_CAN_READ);

        printf("Consumer: warte auf Datenblock %d\n", i / N_SHARED);

        semop(sem_id, &p_op, 1); // Warten durch Consumer auf Lese-Semaphore


        printf("Consumer: habe Datenblock %d gelesen (Index %d bis %d)\n",
           i / N_SHARED, i, i + count - 1);

        // Mitteilen, dass der Verbraucher den Datenblock gelesen hat
        struct sembuf cons_op = sem_signal_op(SEM_CAN_WRITE);
        semop(sem_id, &cons_op, 1); // Freigeben des Schreib-Semaphore, damit der Erzeuger weiterschreiben kann
    }

    shmdt(shared_buffer); // Trennen von Shared Memory Segment

    exit(EXIT_SUCCESS);
}

int main() {
    // N_DATA / N_SHARED Mal — in dem Fall 1000
    int shm_id;
    // zeiger shared buffer auf Shared Memory Segment
    int *shared_buffer = init_shared_memory(&shm_id);
    //Synchrinisation mit Semaphoren
    int sem_id = init_semaphores();

    // Erzeugen eines Kindprozesses
    pid_t pid = fork();

    if (pid < 0) {
        perror("fork Failure");
        remove_resources(shm_id, sem_id, shared_buffer); // Ressourcen entfernen bei Fehler
        exit(EXIT_FAILURE);
    } else if (pid == 0) {
        consumer_process(shared_buffer, sem_id); // Kindprozess führt Verbraucherprozess aus
    } else {
        producer_process(shared_buffer, sem_id); // Elternprozess führt Erzeugerprozess aus
        wait(NULL); // Warten auf den Kindprozess, um sicherzustellen, dass er beendet ist
        remove_resources(shm_id, sem_id, shared_buffer);
    }

    return EXIT_SUCCESS;

}