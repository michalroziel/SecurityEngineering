#include <stdio.h>
#include <stdlib.h> // -> lrand48() für Zufallszahlen
#include <unistd.h> // -> fork()
#include <sys/ipc.h> // -> IPC-Schlüssel
#include <sys/shm.h> // -> Shared Memory Funktionen
#include <sys/sem.h> // -> Semaphoren Funktionen
#include <sys/wait.h> // -> waitpid()
#include <time.h> // -> Zeitfunktionen für Zufallszahlengenerierung

#define N_DATA 2000000 // Anzahl der zu generierenden Daten
#define N_SHARED 2000 // Anzahl der Daten im Shared Memory
// HINT Schlüssel der Einfachheit halber fest gewählt
#define SHM_KEY 1234 // Schlüssel für Shared Memory
#define SEM_KEY 5678 // Schlüssel für Semaphoren

#define SEM_CAN_WRITE 0 // Semaphore für Schreibzugriff
#define SEM_CAN_READ 1 // Semaphore für Lesezugriffls

// Semaphore Operationen deklarieren
struct sembuf P(int semnum) {
    return (struct sembuf){
        semnum, -1, 0
    };
} // HINT P-Operation (Warten auf Semaphore) ~= "wait" oder "lock"
struct sembuf V(int semnum) {
    return (struct sembuf){
        semnum, +1, 0
    };
} // HINT V-Operation (Freigeben der Semaphore) ~= "signal" oder "unlock"

// Shared Memory initialisieren
int* init_shared_memory(int *shm_id) {
    // HINT man wuerde normalerweise hier einen IPC-Schlüssel genereieren lasssen mittels ftok() zB, fuer die Demo verwenden wir der Einfachheit halber einen festen Schlüssel
    *shm_id = shmget(SHM_KEY, sizeof(int) * N_SHARED, IPC_CREAT | 0666); // Erstellen Shared Memory Segment, Größe: sizeof(int) * N_SHARED => 2000 int-Werte
     // IPC_CREAT: Segment erstellen, falls es nicht existiert
     // 0666: Zugriffsrechte (Lesen und Schreiben für alle)
     // HINT 0 -> signalisiert C Compiler, dass es sich um Oktalzahl handelt

    if (*shm_id == -1) {
        perror("shmget");
        exit(EXIT_FAILURE);
    }

    int *shared_buffer = (int *)shmat(*shm_id, NULL, 0); // Anhängen des Shared Memory Segments an den Adressraum des Prozesses gibt Pointer auf Shared Memory Segment zurück

    if (shared_buffer == (void *)-1) {
        perror("shmat");
        exit(EXIT_FAILURE);
    }

    return shared_buffer;
}

// Semaphoren initialisieren
int init_semaphores() {
    // auch hier der Einfachheit halber einen festen Schlüssel verwendet
    int sem_id = semget(SEM_KEY, 2, IPC_CREAT | 0666);
    // Erstellen eines Semaphor-Sets mit 2 Semaphoren (für Schreiben und Lesen), falls es nicht existiert
    // IPC_CREAT: Set erstellen, falls es nicht existiert

    if (sem_id == -1) {
        perror("semget");
        exit(EXIT_FAILURE);
    }

    semctl(sem_id, SEM_CAN_WRITE, SETVAL, 1); // Initialisieren der Schreib-Semaphore auf 1 (erlaubt Schreiben)
    semctl(sem_id, SEM_CAN_READ, SETVAL, 0); // Initialisieren der Lese-Semaphore auf 0 (nicht erlaubt zu lesen, bis Daten geschrieben wurden)

    return sem_id;
}

// Ressourcen entfernen
void remove_resources(int shm_id, int sem_id, int *shared_buffer) {
    shmdt(shared_buffer);
    shmctl(shm_id, IPC_RMID, NULL);
    semctl(sem_id, 0, IPC_RMID);
}

// Erzeugerprozess wird Daten generieren und in den Shared Memory schreiben
void producer_process(int *shared_buffer, int sem_id) {
    srand48(time(NULL));
    int data[N_DATA];
    for (int i = 0; i < N_DATA; i++) {
        data[i] = lrand48();
    }

    for (int i = 0; i < N_DATA; i += N_SHARED) {
        int count = (N_DATA - i < N_SHARED) ? (N_DATA - i) : N_SHARED;

        struct sembuf p_op = P(SEM_CAN_WRITE); // P-Operation auf Schreib-Semaphore
        semop(sem_id, &p_op, 1); // Warten auf Schreib-Semaphore

        printf("Producer: schreibe Datenblock %d (Index %d bis %d)\n",
           i / N_SHARED, i, i + count - 1);

        // Daten in den Shared Memory schreiben
        for (int j = 0; j < count; j++) {
            shared_buffer[j] = data[i + j];
        }

        printf("Producer: Datenblock %d geschrieben, Consumer darf lesen.\n", i / N_SHARED);

        struct sembuf v_op = V(SEM_CAN_READ); // V-Operation auf Lese-Semaphore

        // Freigeben des Lese-Semaphore, damit der Verbraucher lesen kann
        semop(sem_id, &(v_op), 1);
    }
}

// Verbraucherprozess wird Daten aus dem Shared Memory lesen
void consumer_process(int *shared_buffer, int sem_id) {
    for (int i = 0; i < N_DATA; i += N_SHARED) {
        int count = (N_DATA - i < N_SHARED) ? (N_DATA - i) : N_SHARED;

        struct sembuf p_op = P(SEM_CAN_READ);

        printf("Consumer: warte auf Datenblock %d\n", i / N_SHARED);

        semop(sem_id, &p_op, 1); // Warten auf Lese-Semaphore

        for (int j = 0; j < count; j++) {
            volatile int val = shared_buffer[j]; // Lesen der Daten aus dem Shared Memory -> Datenverarbeitung
        }

        printf("Consumer: habe Datenblock %d gelesen (Index %d bis %d)\n",
           i / N_SHARED, i, i + count - 1);

        struct sembuf v_op = V(SEM_CAN_WRITE);
        semop(sem_id, &v_op, 1); // Freigeben des Schreib-Semaphore, damit der Erzeuger weiterschreiben kann
    }

    shmdt(shared_buffer); // Trennen von Shared Memory Segment

    exit(EXIT_SUCCESS);
}

int main() {
    int shm_id;
    int *shared_buffer = init_shared_memory(&shm_id);
    int sem_id = init_semaphores();

    pid_t pid = fork();

    if (pid < 0) {
        perror("fork");
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
    //HINT nachschauen, ob Shared Memory und Semaphoren korrekt entfernt wurden: ipcs
}