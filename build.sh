#! /bin/bash
rm -f lex.yy.c parser.tab.c parser.tab.h
flex scanner.l 
bison -d parser.y
gcc -o mangcc parser.tab.c lex.yy.c 

