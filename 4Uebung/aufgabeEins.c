#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/resource.h>
#include <errno.h>
#include <string.h>
#include <signal.h>

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s prog [args...]\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    pid_t pid = fork();

    if (pid < 0) {
        perror("fork failed");
        exit(EXIT_FAILURE);
    }

    if (pid == 0) { // Kindprozess
        // Priorität setzen: PRIO_PROCESS, pid=0 (aktueller Prozess), Wert=19 (niedrigste)
        if (setpriority(PRIO_PROCESS, 0, 19) < 0) {
            perror("setpriority failed");
            exit(EXIT_FAILURE);
        }

        // execvp erwartet: execvp(prog, args) → argv[1], argv+1
        execvp(argv[1], argv + 1);

        // Falls execvp fehlschlägt
        perror("execvp failed");
        exit(EXIT_FAILURE);
    } else { // Elternprozess
        int status;
        if (waitpid(pid, &status, 0) == -1) {
            perror("waitpid failed");
            exit(EXIT_FAILURE);
        }

        printf("Child process PID: %d\n", pid);

        if (WIFEXITED(status)) {
            printf("Return code: %d\n", WEXITSTATUS(status));
        } else if (WIFSIGNALED(status)) {
            int sig = WTERMSIG(status);
            printf("Terminated by signal: %d\n", sig);
            psignal(sig, "Signal description");
        } else {
            printf("Child exited abnormally\n");
        }
    }

    return 0;
}
