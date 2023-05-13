%{
        #include <stdio.h>
        #include <stdlib.h>
        #include <string.h>
        void yyerror (char *s);


        #define SYMBOL_TABLE_MAX 1000
        #define SYMBOL_MAX 1000

        // Datastructures for symbol table
        typedef struct {
        char *name;         // symbol name
        int type;           // symbol type (int, float, etc.)
        char* value;          // symbol value
        int line;
        } Symbol;

        typedef struct {
        Symbol *symbols;    // array of symbols
        int num_symbols;    // number of symbols in the array
        int max_symbols;    // maximum number of symbols that can be stored
        int idnex;
        } SymbolTable;

        typedef struct {
        SymbolTable **tables;   // stack of symbol tables
        int num_tables;         // number of tables in the stack
        int max_tables;         // maximum number of tables that can be stored
        } SymbolTableStack;

        enum types {
        INT_ENUM = 1,
        FLOAT_ENUM = 2,
        BOOL_ENUM = 3,
        STRING_ENUM = 4,
        ENUM_ENUM = 5,
        VOID_ENUM = 6
        };



        // Symbol table functions
        SymbolTable *create_symbol_table() {
                SymbolTable *table = malloc(sizeof(SymbolTable));
                table->symbols = malloc(SYMBOL_MAX * sizeof(Symbol));
                table->num_symbols = 0;
                table->max_symbols = SYMBOL_MAX;
                return table;
        }

        SymbolTableStack *create_symbol_table_stack() {
                SymbolTableStack *stack = malloc(sizeof(SymbolTableStack));
                stack->tables = malloc(SYMBOL_TABLE_MAX * sizeof(SymbolTable *));
                stack->num_tables = 0;
                stack->max_tables = SYMBOL_TABLE_MAX;
                return stack;
        }


        void add_symbol(SymbolTableStack *stack, char *name, int type, char* value, int line);
        Symbol *get_symbol(SymbolTableStack *stack, char *name);
        void push_symbol_table(SymbolTableStack *stack, SymbolTable *table);
        void pop_symbol_table(SymbolTableStack *stack);
        
        SymbolTableStack *stack;

        extern int line_num ;

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
%type <string> expr
%type <integer> type


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
        | print_stmt SEMI // {printf("%d %s" , line_num , "print\n");}
        | for_stmt {printf("%d %s" , line_num , "for\n");}
        | switch_stmt {printf("%d %s" , line_num , "switch\n");}
        | break_stmt SEMI {printf("%d %s" , line_num , "break\n");}
        | block_stmt // {printf("%d %s" , line_num , "block\n");}
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


expr    : expr PLUS expr {$$ = "$1 + $3";}
        | expr MINUS expr {$$ = "$1 - $3";}
        | expr TIMES expr       {$$ = "$1 * $3";}
        | expr DIV expr        {$$ = "$1 / $3";}
        | expr MOD expr       {$$ = "$1  $3";}
        | expr AND expr      {$$ = "$1 && $3";}
        | expr OR expr     {$$ = "$1 || $3";}
        | expr EQ expr          {$$ = "$1 == $3";}
        | expr NE expr        {$$ = "$1 != $3";}
        | expr LT expr      {$$ = "$1 < $3";}
        | expr GT expr   {$$ = "$1 > $3";}
        | expr LE expr  {$$ = "$1 <= $3";}
        | expr GE expr  {$$ = "$1 >= $3";}
        | expr XOR expr {$$ = "$1 ^ $3";}
        | NOT expr      {$$ = "!$2";}
        | LPAREN expr RPAREN    {$$ = "$2";}
        | func_call_stmt        {$$ = "$1";}
        | INT                {char str_val[100]; sprintf(str_val, "%d", $1); $$ = str_val;}
        | FLOAT             {char str_val[100]; sprintf(str_val, "%.2f", $1); $$ = str_val;}
        | BOOL            {char str_val[100]; sprintf(str_val, "%d", $1); $$ = str_val;}
        | STRING        {$$ = $1;}
        | ID            {$$ = get_symbol(stack, $1)->value;}
        ;

enum_val : ID
         | INT
         ;

assignment : type ID ASSIGN expr {
                add_symbol(stack, $2, $1, $4, line_num);
                // printf("%d value after: %s\n", line_num, get_symbol(stack, $2)->value);
                }
              | ID ASSIGN expr {
                printf("in rule %i, name: %s, address: %x, value: %s\n",line_num, get_symbol(stack, $1)->name, get_symbol(stack, $1), get_symbol(stack, $1)->value);
                get_symbol(stack, $1)->value = $3;
                // printf("%d value after: %s\n", line_num, get_symbol(stack, $1)->value);
                }
              | CONST type ID ASSIGN expr
              | ENUM ID ID ASSIGN enum_val
           ;
declare : type ID {
                add_symbol(stack, $2, $1, 0, line_num);
                // printf("%d value after: %s\n", line_num, get_symbol(stack, $2)->value);
                }
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
        
print_stmt : PRINT LPAREN expr RPAREN {
        printf("print %d: %s\n" , line_num , $3);
        }
           ;

type : INTTYPE {$$ = INT_ENUM;}
     | FLOATTYPE {$$ = FLOAT_ENUM;}
     | BOOLTYPE {$$ = BOOL_ENUM;}
     | STRINGTYPE {$$ = STRING_ENUM;}
     | ENUM {$$ = ENUM_ENUM;}
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

block_stmt : LBRACE { SymbolTable *table = create_symbol_table(); push_symbol_table(stack, table);} body_stmt_list RBRACE {pop_symbol_table(stack);}
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

void push_symbol_table(SymbolTableStack *stack, SymbolTable *table) {
    // check if stack is full
    if (stack->num_tables >= stack->max_tables) {
        printf("Error: symbol table stack is full\n");
        return;
    }

    // push new symbol table onto the stack
    table->idnex = stack->num_tables;
    stack->tables[stack->num_tables++] = table;
}

void pop_symbol_table(SymbolTableStack *stack) {
    // check if stack is empty
    if (stack->num_tables == 0) {
        printf("Error: symbol table stack is empty\n");
        return;
    }

    // pop the top symbol table off the stack
    stack->num_tables--;
}

void add_symbol(SymbolTableStack *stack, char *name, int type, char* value, int line) {
    // check if stack is empty
    if (stack->num_tables == 0) {
        printf("Error: symbol table stack is empty\n");
        return;
    }

    // get the top symbol table on the stack
    SymbolTable *table = stack->tables[stack->num_tables - 1];

    // check if symbol already exists in the table
    for (int i = 0; i < table->num_symbols; i++) {
        if (strcmp(table->symbols[i].name, name) == 0) {
            printf("Error: symbol '%s' already defined\n", name);
            return;
        }
    }

    Symbol symbol = {name, type, value, line};
    table->symbols[table->num_symbols++] = symbol;
}

Symbol *get_symbol(SymbolTableStack *stack, char *name) {
    // search for symbol in the stack of tables, starting from the top
    for (int i = stack->num_tables - 1; i >= 0; i--) {
        SymbolTable *table = stack->tables[i];
        for (int j = 0; j < table->num_symbols; j++) {
                printf("line: %i, table: %i, name: %s, address: %x, value: %s\n", line_num, i, table->symbols[j].name, &table->symbols[j], table->symbols[j].value);
            if (strcmp(table->symbols[j].name, name) == 0) {
                return &table->symbols[j];
            }
        }
    }

    // symbol not found
    return NULL;
}




int main (void) {
        stack = create_symbol_table_stack();
        push_symbol_table(stack, create_symbol_table());

        
	return yyparse ( );
}

void yyerror (char *s) {fprintf (stderr, "error: %s\n", s);} 
