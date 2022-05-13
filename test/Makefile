# Makefile for test programs

AS=ca65
AFLAGS=-t c64

.SUFFIXES:
.PHONY: all, clean

all: zplocs

zplocs: zplocs.c zp_locs.s
	cl65 -t c64 $^

