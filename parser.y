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

    extern int line_num ;

    char* getSymbol(char *name);
    void setSymbol(char *name, char *type, char *value, int line);
    struct SymbolTable symbolTable[10000];
    
%}

%union{
    int integer;
    float floatval;
    int boolean;
    char *id;
    char *string;
}
%start program
%token <id> ID
%token <integer> INT
%token <floatval> FLOAT
%token <boolean> BOOL
%token <string> STRING
%token IF ENDIF ELSE ELSEIF WHILE FOR BREAK CONTINUE REPEAT UNTIL SWITCH CASE DEFAULT
%token RETURN PRINT CONST EXIT
%token INTTYPE FLOATTYPE BOOLTYPE STRINGTYPE VOID ENUM 
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

stmt    : expr SEMI {printf("%d %s" , line_num , "expr\n");}
        | if_stmt  {printf("%d %s" , line_num , "if\n");}
        | assignment SEMI {printf("%d %s" , line_num , "assignment\n");}
        | while_stmt {printf("%d %s" , line_num , "while\n");}
        | repeat_stmt {printf("%d %s" , line_num , "repeat\n");}
        | print_stmt SEMI {printf("%d %s" , line_num , "print\n");}
        | for_stmt {printf("%d %s" , line_num , "for\n");}
        | switch_stmt {printf("%d %s" , line_num , "switch\n");}
        | break_stmt SEMI {printf("%d %s" , line_num , "break\n");}
        | block_stmt {printf("%d %s" , line_num , "block\n");}
        | enum_stmt SEMI {printf("%d %s" , line_num , "enum\n");}
        | return_stmt SEMI {printf("%d %s" , line_num , "return\n");}
        | CONTINUE SEMI {printf("%d %s" , line_num , "continue\n");}
        | declare SEMI { printf("%d %s" , line_num , "declare\n");}
        | func_call_stmt SEMI {printf("%d %s" , line_num , "function call\n");}
        ;

stmt_list : stmt stmt_list 
          | function_stmt stmt_list
          | stmt
          | {printf("%d %s" , line_num , "empty stmt list\n");}
          ;

body_stmt_list : stmt body_stmt_list 
          | stmt
          | {printf("%d %s" , line_num , "empty body stmt list\n");}
          ;


expr    : expr PLUS expr  
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
        | func_call_stmt
        | INT
        | FLOAT
        | BOOL
        | STRING
        | ID
        ;

enum_val : ID
         | INT
         ;

assignment : type ID ASSIGN expr
              | ID ASSIGN expr
              | CONST type ID ASSIGN expr
              | ENUM ID ID ASSIGN enum_val
           ;
declare : type ID 
        | ENUM ID ID 
        ;

else_if_stmt : ELSEIF LPAREN expr RPAREN LBRACE body_stmt_list RBRACE else_if_stmt
             | else_if_stmt ELSE LBRACE body_stmt_list RBRACE
             | {printf("%d %s" , line_num , "empty else if stmt\n");}
             ;

if_stmt  : IF LPAREN expr RPAREN LBRACE body_stmt_list RBRACE ENDIF
         | IF LPAREN expr RPAREN LBRACE body_stmt_list RBRACE ELSE LBRACE body_stmt_list RBRACE
         | IF LPAREN expr RPAREN LBRACE body_stmt_list RBRACE ELSEIF LPAREN expr RPAREN LBRACE body_stmt_list RBRACE else_if_stmt
         ;

while_stmt : WHILE LPAREN expr RPAREN LBRACE body_stmt_list RBRACE
           ;
           
for_stmt : FOR LPAREN assignment SEMI expr SEMI assignment RPAREN LBRACE body_stmt_list RBRACE
            ;

repeat_stmt : REPEAT LBRACE body_stmt_list RBRACE UNTIL LPAREN expr RPAREN SEMI
            ;
        
print_stmt : PRINT LPAREN expr RPAREN 

type : INTTYPE
     | FLOATTYPE
     | BOOLTYPE
     | STRINGTYPE
     | ENUM
     ;

param : type ID
      | type ID COMMA param   
      |  {printf("%d %s" , line_num , "empty param list\n");}
      ;

param_call : | ID COMMA param_call 
             | ID
             | {printf("empty param call list\n");}
             ;

function_stmt : type ID LPAREN param RPAREN LBRACE body_stmt_list RBRACE {printf("%d %s" , line_num , "function\n");}
              | VOID ID LPAREN param RPAREN LBRACE body_stmt_list RBRACE {printf("%d %s" , line_num , "function\n");}
              ;

func_call_stmt : ID LPAREN param_call RPAREN
               ;

switch_stmt : SWITCH LPAREN expr RPAREN LBRACE case_stmt RBRACE
            ;

break_stmt : BREAK
           | {printf("empty break statement\n");}
           ;

case_stmt :   CASE expr COLON body_stmt_list case_stmt
            | CASE expr COLON body_stmt_list  
            | DEFAULT COLON body_stmt_list  
            | {printf("empty case statement\n");}
            ;

block_stmt : LBRACE body_stmt_list RBRACE
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

void yyerror (char *s) {fprintf (stderr, "error: %s\n", s);} 
