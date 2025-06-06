CC=gcc
CFLAGS=-Wall -Werror
TARGET=forkExec
SRC=4Uebung/forkExec.c

all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) -o $(TARGET) $(SRC)

clean:
	rm -f $(TARGET)

.PHONY: all clean