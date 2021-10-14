PRJ=vernam
CC=gcc
CFLAGS=-std=c99 -Wall -Wextra -pedantic

.PHONY: run clean

run: $(PRJ).c
	$(CC) $(CFLAGS) $(PRJ).c -o $(PRJ)

clean:
	rm -f *.o $(PRJ)