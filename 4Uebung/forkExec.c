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
        printf("Usage: %s prog [args...]\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    pid_t pid = fork();

    if (pid < 0) {
        perror("fork failed");
        exit(EXIT_FAILURE);
    }

    if (pid == 0) {
        // Child process

        int priority = getpriority(PRIO_PROCESS, 0);
        printf("Initial priority of child process: %d\n", priority);


        setpriority(PRIO_PROCESS, 0, 19);

        priority = getpriority(PRIO_PROCESS, 0);
        printf("Priority of child process after setpriority: %d\n", priority);



        execvp(argv[1], argv+1);

        // If execvp returns, it means there was an error
        perror("execvp failed");
        exit(EXIT_FAILURE);
    } else {
        // Parent process
        printf("Started child process with PID %d\n", pid);

        int status;
        wait(&status);

        if (WIFEXITED(status)) {
            printf("Process exited with return code %d\n", WEXITSTATUS(status));
        } else if (WIFSIGNALED(status)) {
            int sig = WTERMSIG(status);
            printf("Process terminated by signal %d: ", sig);
            psignal(sig, "");
        } else {
            printf("Process ended in an unexpected way\n");
        }
    }

    return 0;
}


