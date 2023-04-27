%{
    #include <stdio.h>
    #include <stdlib.h>
    void yyerror (char *s);
    struct SymbolTable{
        char *name;
        char *type;
        char *value;
        int line;
    };

    char* getSymbol(char *name);
    void setSymbol(char *name, char *type, char *value, int line);
    struct SymbolTable symbolTable[10000];
    
%}

%union{
    int integer;
    float floatval;
    int boolean;
    char *id;
}
%start program
%token <id> ID
%token <integer> INT
%token <floatval> FLOAT
%token <boolean> BOOL
%token IF ENDIF ELSE WHILE FOR BREAK CONTINUE REPEAT UNTIL SWITCH CASE DEFAULT
%token RETURN PRINT CONST EXIT
%token INTTYPE FLOATTYPE BOOLTYPE VOID ENUM
%token PLUS MINUS TIMES DIV MOD ASSIGN COMMA COLON
%token LT GT EQ NE LE GE AND OR NOT XOR
%token LPAREN RPAREN LBRACE RBRACE SEMI 


%right ASSIGN
%left OR 
%left AND
%left EQ NE
%left LT GT LE GE
%left PLUS MINUS
%left TIMES DIV MOD
%right NOT
%left XOR

%%

program :  stmt_list
        ;

stmt    : expr SEMI
        | assignment SEMI
        | if_stmt 
        | while_stmt
        | repeat_stmt
        | print_stmt SEMI
        | for_stmt
        | function_stmt
        | switch_stmt
        | break_stmt SEMI
        | block_stmt
        | enum_stmt
        | return_stmt SEMI
        ;

stmt_list : stmt 
          | stmt stmt_list
          ;


expr    : expr PLUS expr  {printf("PLUS\n");}
        | expr MINUS expr
        | expr TIMES expr
        | expr DIV expr
        | expr MOD expr
        | expr AND expr
        | expr OR expr
        | expr EQ expr
        | expr NE expr
        | expr LT expr
        | expr GT expr
        | expr LE expr
        | expr GE expr
        | expr XOR expr
        | NOT expr
        | LPAREN expr RPAREN
        | INT
        | FLOAT
        | BOOL
        | ID
        ;

assignment : ID ASSIGN expr
           ;

if_stmt  : IF LPAREN expr RPAREN LBRACE stmt_list RBRACE ENDIF
         | IF LPAREN expr RPAREN LBRACE stmt_list RBRACE ELSE LBRACE stmt_list RBRACE
         ;

while_stmt : WHILE LPAREN expr RPAREN LBRACE stmt_list RBRACE
           ;
           
for_stmt : FOR LPAREN assignment SEMI expr SEMI assignment RPAREN LBRACE stmt_list RBRACE
            ;

repeat_stmt : REPEAT LBRACE stmt_list RBRACE UNTIL LPAREN expr RPAREN
            ;
        
print_stmt : PRINT LPAREN expr RPAREN

type : INTTYPE
     | FLOATTYPE
     | BOOLTYPE
     | VOID
     | ENUM
     ;

param : type ID
      | type ID COMMA param    
      |  {printf("empty param list\n");}
      ;

function_stmt : type ID LPAREN param RPAREN LBRACE stmt_list RBRACE {printf("function\n");}
              ;

switch_stmt : SWITCH LPAREN expr RPAREN LBRACE case_stmt RBRACE
            ;

break_stmt : BREAK
           | {printf("empty break statement\n");}
           ;

case_stmt :   CASE expr COLON stmt_list break_stmt SEMI case_stmt
            | CASE expr COLON stmt_list break_stmt SEMI
            | DEFAULT COLON stmt_list break_stmt SEMI
            | {printf("empty case statement\n");}
            ;

block_stmt : LBRACE stmt_list RBRACE
           ;

enum_body : ID COMMA enum_body
          | ID
          ;

enum_stmt   : ENUM ID LBRACE enum_body RBRACE 
            ;

return_stmt : RETURN expr
            | RETURN
            ;

%%

int main (void) {

	return yyparse ( );
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 
