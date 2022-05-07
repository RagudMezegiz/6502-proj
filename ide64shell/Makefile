# Makefile for the IDE64 dos shell program SH

OBJECTS = shell.o

AS=ca65
AFLAGS=-t c64

.SUFFIXES:
.PHONY: all, clean

all: sh

sh: shell.s
	cl65 -t c64 -C c64-asm.cfg --start-addr 49152 -o $@ $^

%.l: %.s
	$(AS) $(AFLAGS) -l $@ $<

clean:
	$(RM) $(OBJECTS) sh

