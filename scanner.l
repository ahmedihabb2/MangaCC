%{
    #include "parser.tab.h"
    void yyerror (char *s);
    int line_num = 1;

%}

%%

"if"         {return IF;}
"endif"      {return ENDIF;}
"else"       {return ELSE;}
"else if"    {return ELSEIF;}
"while"      {return WHILE;}
"for"        {return FOR;}
"break"      {return BREAK;}
"continue"   {return CONTINUE;}
"return"     {return RETURN;}
"int"        {return INTTYPE;}
"float"      {return FLOATTYPE;}
"bool"       {return BOOLTYPE;}
"string"     {return STRINGTYPE;}
"void"       {return VOID;}
"print"      {return PRINT;}
"const"      {return CONST;}
"repeat"     {return REPEAT;}
"until"      {return UNTIL;}
"switch"     {return SWITCH;}
"case"       {return CASE;}
"default"    {return DEFAULT;}
"enum"       {return ENUM;}
"exit"       {return EXIT;}
"+"          {return PLUS;}
"-"          {return MINUS;}
"*"          {return TIMES;}
"/"          {return DIV;}
"%"          {return MOD;}
"="          {return ASSIGN;}
"("          {return LPAREN;}
")"          {return RPAREN;}
"{"          {return LBRACE;}
"}"          {return RBRACE;}
";"          {return SEMI;}
":"          {return COLON;}
"<"          {return LT;}
">"          {return GT;}
","          {return COMMA;}
"=="          {return EQ;}
"!="          {return NE;}
"<="          {return LE;}
">="          {return GE;}
"and"        {return AND;}
"or"         {return OR;}
"not"        {return NOT;}
"xor"        {return XOR;}
"true"|"false" {yylval.boolean = yytext[0]=='t'; return BOOL;}

[ \t]+        {;}
\/\/.*        {;}
\n          {line_num++;}

[-]?[0-9]+                  {yylval.integer = atoi(yytext); return INT;}
[-]?[0-9]+\.[0-9]+          {yylval.floatval = atof(yytext); return FLOAT;}
[a-zA-Z_][a-zA-Z0-9_]*  {yylval.id = strdup(yytext); return ID;}
\".*\"                  {yylval.string = strdup(yytext); return STRING;}
\'.*\'                    {yylval.string = strdup(yytext); return STRING;}

.             {yyerror("Unexpected Token");}


%%

int yywrap (void) {return 1;}