CC=gcc
CFLAGS=-Wall
TARGET=APP
SRC=4Uebung/semaphore.c

all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) -o $(TARGET) $(SRC)

clean:
	rm -f $(TARGET)

.PHONY: all clean
