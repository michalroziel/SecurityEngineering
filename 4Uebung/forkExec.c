#include <stdio.h>
#include <stdlib.h>
#include <unistd.h> // -> fork(), execvp()
#include <sys/wait.h> // -> waitpid()
#include <sys/resource.h> // -> setpriority()
#include <errno.h> // -> Fehlerbehandlung
#include <string.h> // -> Fehlerbehandlung
#include <signal.h> // -> psignal()

int main(int argc, char **argv) {

    // Programm erwartet mindestens ein Argument (-> auszuführendes Programm)
    if (argc < 2) {
        fprintf(stderr, "Usage: %s prog [arg1 arg2 ...]\n", argv[0]);
        return EXIT_FAILURE;
    }

    // HINT pid_t = Datentyp für Prozess-IDs
    // fork() erzeugt Sohnprozess, der Kopie des Vaterprozesses ist
    pid_t pid = fork();

    if (pid < 0) {
        perror("fork");
        return EXIT_FAILURE;
    }

    if (pid == 0) {
        // Kindprozess Prio verringern (0 = höchste Priorität)
        if (setpriority(PRIO_PROCESS, 0, 19) < 0) {
            perror("setpriority");
            exit(EXIT_FAILURE);
        }

        // Startet das neue Programm mit Argumenten
        // argv[0] = ./start, argv[1] = erstes Argument(prog zB "ls")
        // HINT Passendes Argument für argv[] muss Liste von Strings sein, die Auf NULL endet -> in argv + 1 genau diese Struktur vorgegeben
        execvp(argv[1], argv + 1);

        // Falls execvp fehlschlägt
        perror("execvp");
        exit(EXIT_FAILURE);

    } else {
        // HINT Deklaration, da waitpid() Adresse benötigt
        int status;

        printf("Gestarteter Prozess hat PID: %d\n", pid);

        if (waitpid(pid, &status, 0) == -1) {
            perror("waitpid");
            return EXIT_FAILURE;
        }

        if (WIFEXITED(status)) {
            printf("Prozess endete normal mit Exit-Code: %d\n", WEXITSTATUS(status));
        } else if (WIFSIGNALED(status)) {
            int sig = WTERMSIG(status);
            printf("Prozess wurde durch Signal %d beendet: ", sig);
            psignal(sig, "");
        } else {
            printf("Prozess endete auf ungewöhnliche Weise.\n");
        }
    }

    return EXIT_SUCCESS;
}