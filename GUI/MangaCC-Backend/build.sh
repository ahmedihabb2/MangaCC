#! /bin/bash
FILENAME=$1
rm -f lex.yy.c parser.tab.c parser.tab.h
flex scanner.l
bison -d parser.y -o parser.tab.c
gcc -o mangcc parser.tab.c lex.yy.c 

./mangcc < $FILENAME

rm -f lex.yy.c parser.tab.c parser.tab.h
