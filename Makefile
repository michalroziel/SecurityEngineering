CC=gcc
CFLAGS=-Wall -Werror
TARGET=fileInfos
SRC=2Uebung/fileInfos.c

all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) -o $(TARGET) $(SRC)

clean:
	rm -f $(TARGET)

.PHONY: all clean