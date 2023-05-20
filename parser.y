%{
        #include <stdio.h>
        #include <stdlib.h>
        #include <string.h>
        #include <math.h>
        void yyerror (char *s);


        #define SYMBOL_TABLE_MAX 1000
        #define SYMBOL_MAX 1000

        typedef enum { false, true } bool;

        // Datastructures for symbol table
        typedef struct {
        char *name;         // symbol name
        int type;           // symbol type (int, float, etc.)
        char* value;          // symbol value
        int line;
        bool is_const;      // is the symbol a constant?
        bool is_enum;       // is the symbol an enum?
        bool is_func;       // is the symbol a function?
        bool is_used;       // is the symbol used?
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


        void add_symbol(SymbolTableStack *stack, char *name, int type, char* value, int line, bool is_const, bool is_enum, bool is_func,bool is_used);
        Symbol *get_symbol(SymbolTableStack *stack, char *name);
        void push_symbol_table(SymbolTableStack *stack, SymbolTable *table);
        void pop_symbol_table(SymbolTableStack *stack);
        char *copy_value(char* value); // copy the value to a new memory address
        void* copy_void(void* value); // copy the value to a new memory address
        Symbol *void_to_symbol(void *v) {return (Symbol*)v;} 
        void check_assignment_types(int statement_type , Symbol * s , int line_num, bool is_const);
        void assign_value(char * id  ,void *v );
        void check_unused_variables() ;


        // operrator functions
        Symbol add_op(void *a, void *b);
        Symbol sub_op(void *a, void *b);
        Symbol mul_op(void *a, void *b);
        Symbol div_op(void *a, void *b);
        Symbol mod_op(void *a, void *b);


        // Global variables

        SymbolTableStack *stack;

        extern int line_num ;
        int enum_body_count = 0 ;
%}

%union{
    int integer;
    float floatval;
    int boolean;
    char *id;
    char *string;
    void *voidval;
    void *symbolval;
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
%type <symbolval> expr enum_val
%type <integer> type
%type <voidval> VOID
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

program :  stmt_list {pop_symbol_table(stack);}
        ;

stmt    : expr SEMI // {printf("%d %s" , line_num , "expr\n");}
        | if_stmt  {printf("%d %s" , line_num , "if\n");}
        | assignment SEMI // {printf("%d %s" , line_num , "assignment\n");}
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
        | declare SEMI // { printf("%d %s" , line_num , "declare\n");}
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


expr    : expr PLUS expr        {Symbol s = add_op($1, $3); $$ = copy_void(((void*)&s));}
        | expr MINUS expr       {Symbol s = sub_op($1, $3); $$ = copy_void(((void*)&s));}
        | expr TIMES expr       {Symbol s = mul_op($1, $3); $$ = copy_void(((void*)&s));}
        | expr DIV expr         {Symbol s = div_op($1, $3); $$ = copy_void(((void*)&s));}
        | expr MOD expr         {Symbol s = mod_op($1, $3); $$ = copy_void(((void*)&s));}
        | expr AND expr         {char str_val[20] = ""; sprintf(str_val, "%d", atof(void_to_symbol($1)->value) && atof(void_to_symbol($3)->value)); char* val_copy = copy_value(str_val); Symbol s; s.value = val_copy; s.type = BOOL_ENUM; void *v= (void*)&s; $$ = copy_void(v);}
        | expr OR expr          {char str_val[20] = ""; sprintf(str_val, "%d", atof(void_to_symbol($1)->value) || atof(void_to_symbol($3)->value)); char* val_copy = copy_value(str_val); Symbol s; s.value = val_copy; s.type = BOOL_ENUM; void *v= (void*)&s; $$ = copy_void(v);}
        | expr EQ expr          {char str_val[20] = ""; sprintf(str_val, "%d", atof(void_to_symbol($1)->value) == atof(void_to_symbol($3)->value)); char* val_copy = copy_value(str_val); Symbol s; s.value = val_copy; s.type = BOOL_ENUM; void *v= (void*)&s; $$ = copy_void(v);}
        | expr NE expr          {char str_val[20] = ""; sprintf(str_val, "%d", atof(void_to_symbol($1)->value) != atof(void_to_symbol($3)->value)); char* val_copy = copy_value(str_val); Symbol s; s.value = val_copy; s.type = BOOL_ENUM; void *v= (void*)&s; $$ = copy_void(v);}
        | expr LT expr          {char str_val[20] = ""; sprintf(str_val, "%d", atof(void_to_symbol($1)->value) < atof(void_to_symbol($3)->value)); char* val_copy = copy_value(str_val); Symbol s; s.value = val_copy; s.type = BOOL_ENUM; void *v= (void*)&s; $$ = copy_void(v);}
        | expr GT expr          {char str_val[20] = ""; sprintf(str_val, "%d", atof(void_to_symbol($1)->value) > atof(void_to_symbol($3)->value)); char* val_copy = copy_value(str_val); Symbol s; s.value = val_copy; s.type = BOOL_ENUM; void *v= (void*)&s; $$ = copy_void(v);}
        | expr LE expr          {char str_val[20] = ""; sprintf(str_val, "%d", atof(void_to_symbol($1)->value) <= atof(void_to_symbol($3)->value)); char* val_copy = copy_value(str_val); Symbol s; s.value = val_copy; s.type = BOOL_ENUM; void *v= (void*)&s; $$ = copy_void(v);}
        | expr GE expr          {char str_val[20] = ""; sprintf(str_val, "%d", atof(void_to_symbol($1)->value) >= atof(void_to_symbol($3)->value)); char* val_copy = copy_value(str_val); Symbol s; s.value = val_copy; s.type = BOOL_ENUM; void *v= (void*)&s; $$ = copy_void(v);}
        | expr XOR expr         {char str_val[20] = ""; sprintf(str_val, "%d", atoi(void_to_symbol($1)->value) ^ atoi(void_to_symbol($3)->value)); char* val_copy = copy_value(str_val); Symbol s; s.value = val_copy; s.type = BOOL_ENUM; void *v= (void*)&s; $$ = copy_void(v);}
        | NOT expr              {char str_val[20] = ""; sprintf(str_val, "%d", !atof(void_to_symbol($2)->value)); char* val_copy = copy_value(str_val); Symbol s; s.value = val_copy; s.type = BOOL_ENUM; void *v= (void*)&s; $$ = copy_void(v);}
        | LPAREN expr RPAREN    {Symbol s = *void_to_symbol($2); void *v= (void*)&s; $$ = copy_void(v);}
        | func_call_stmt        {Symbol s; void *v= (void*)&s; $$ = copy_void(v);}  // TODO
        | INT                   {char str_val[20] = ""; sprintf(str_val, "%d", $1); char* val_copy = copy_value(str_val); Symbol s; s.value = val_copy; s.type = INT_ENUM; void *v= (void*)&s; $$ = copy_void(v);}
        | FLOAT                 {char str_val[20] = ""; sprintf(str_val, "%.2f", $1); char* val_copy = copy_value(str_val); Symbol s; s.value = val_copy; s.type = FLOAT_ENUM; void *v= (void*)&s; $$ = copy_void(v);}
        | BOOL                  {char str_val[20] = ""; sprintf(str_val, "%d", $1); char* val_copy = copy_value(str_val); Symbol s; s.value = val_copy; s.type = BOOL_ENUM; void *v= (void*)&s; $$ = copy_void(v);check_always_false($1);}
        | STRING                {char* val_copy = copy_value($1); Symbol s; s.value = val_copy; s.type = STRING_ENUM; void *v= (void*)&s; $$ = v;}
        | ID                    {Symbol *s = get_symbol(stack, $1); s->is_used = true ;printf("ID: %s Marked as Used \n", s->name); void *v= (void*)s; $$ = copy_void(v);}
        ;

enum_val : ID {Symbol s = *get_symbol(stack, $1); void *v= (void*)&s; $$ = copy_void(v);}
         | INT  {char str_val[20] = ""; sprintf(str_val, "%d", $1); char* val_copy = copy_value(str_val); Symbol s; s.value = val_copy; void *v= (void*)&s; $$ = copy_void(v);}
         ;

assignment : type ID ASSIGN expr {
                Symbol* s = void_to_symbol($4);
                check_assignment_types($1, s, line_num,0);
                add_symbol(stack, $2, $1, s->value, line_num, false, false, false,false);
                }
              | ID ASSIGN expr {
                assign_value($1,$3);
                }
              | CONST type ID ASSIGN expr {
                Symbol* s = void_to_symbol($5);
                add_symbol(stack, $3, $2, s->value, line_num, true, false, false,false);
              }
              | ENUM ID ID ASSIGN enum_val {
                Symbol* s = void_to_symbol($5);
                add_symbol(stack, $3, INT_ENUM , s->value, line_num, false, true, false,false);
              }
           ;

declare : type ID {
                add_symbol(stack, $2, $1, 0, line_num, false, false, false,false);
                }
        | ENUM ID ID {
                add_symbol(stack, $3, INT_ENUM, 0, line_num, false, true, false,false);
                }
        ;

else_if_stmt : ELSEIF LPAREN expr {Symbol *s = void_to_symbol($3); printf("if expression evaluation is: %s in line: %d\n", s->value, line_num);} RPAREN LBRACE  {push_symbol_table(stack, create_symbol_table());} body_stmt_list RBRACE {pop_symbol_table(stack);} else_if_stmt
             | else_if_stmt ELSE LBRACE  {push_symbol_table(stack, create_symbol_table());} body_stmt_list RBRACE {pop_symbol_table(stack);}
             | {printf("%d %s" , line_num , "empty else if stmt\n");}
             ;

if_stmt  : IF LPAREN expr {Symbol *s = void_to_symbol($3); printf("if expression evaluation is: %s in line: %d\n", s->value, line_num);} RPAREN LBRACE {push_symbol_table(stack, create_symbol_table());} body_stmt_list RBRACE ENDIF {pop_symbol_table(stack);}
         | IF LPAREN expr {Symbol *s = void_to_symbol($3); printf("if expression evaluation is: %s in line: %d\n", s->value, line_num);} RPAREN LBRACE {push_symbol_table(stack, create_symbol_table());} body_stmt_list RBRACE {pop_symbol_table(stack);} ELSE LBRACE {push_symbol_table(stack, create_symbol_table());} body_stmt_list RBRACE {pop_symbol_table(stack);}
         | IF LPAREN expr {Symbol *s = void_to_symbol($3); printf("if expression evaluation is: %s in line: %d\n", s->value, line_num);} RPAREN LBRACE {push_symbol_table(stack, create_symbol_table());} body_stmt_list RBRACE {pop_symbol_table(stack);} ELSEIF LPAREN expr RPAREN LBRACE {push_symbol_table(stack, create_symbol_table());} body_stmt_list RBRACE {pop_symbol_table(stack);} else_if_stmt
         ;

while_stmt : WHILE LPAREN expr {Symbol *s = void_to_symbol($3); printf("while loop expression evaluation is: %s in line: %d\n", s->value, line_num);} RPAREN LBRACE {push_symbol_table(stack, create_symbol_table());} body_stmt_list RBRACE {pop_symbol_table(stack);}
           ;
           
for_stmt : FOR LPAREN assignment SEMI expr {Symbol *s = void_to_symbol($5); printf("for loop expression evaluation is: %s in line: %d\n", s->value, line_num);} SEMI assignment RPAREN LBRACE {push_symbol_table(stack, create_symbol_table());} body_stmt_list RBRACE {pop_symbol_table(stack);}
            ;

repeat_stmt : REPEAT LBRACE {push_symbol_table(stack, create_symbol_table());} body_stmt_list RBRACE {pop_symbol_table(stack);} UNTIL LPAREN expr  {Symbol *s = void_to_symbol($9); printf("repeat loop expression evaluation is: %s in line: %d\n", s->value, line_num);}  RPAREN SEMI
            ;
        
print_stmt : PRINT LPAREN expr RPAREN {
        Symbol* s = void_to_symbol($3);
        printf("print %d: %s\n" , line_num , s->value);
        }
        ;

type : INTTYPE {$$ = INT_ENUM;}
     | FLOATTYPE {$$ = FLOAT_ENUM;}
     | BOOLTYPE {$$ = BOOL_ENUM;}
     | STRINGTYPE {$$ = STRING_ENUM;}
     | ENUM {$$ = ENUM_ENUM;}
     ;

param : type ID {add_symbol(stack, $2, $1, 0, line_num, false, false, false,false);}
      | type ID COMMA param {add_symbol(stack, $2, $1, 0, line_num, false, false, false,false);}
      |  {printf("%d %s" , line_num , "empty param list\n");}
      ;

param_call : | ID COMMA {
                // Check if the ID exists in the symbol table
                Symbol* s = get_symbol(stack, $1);
                if (s == NULL) {
                    printf("Error: %s is not defined in line %d\n", $1, line_num);
                    exit(1);
                } else {
                        // Mark the symbol as used
                        s->is_used = true;
                        printf("ID: %s Marked as Used \n", s->name);
                }} param_call 
             | ID {
                // Check if the ID exists in the symbol table
                Symbol* s = get_symbol(stack, $1);
                if (s == NULL) {
                    printf("Error: %s is not defined in line %d\n", $1, line_num);
                    exit(1);
                } else {
                        // Mark the symbol as used
                        s->is_used = true;
                        printf("ID: %s Marked as Used \n", s->name);
                }
             }
             | {printf("empty param call list\n");}
             ;

function_stmt : type ID {add_symbol(stack, $2, $1, 0, line_num, false, false, true,false);} LPAREN {printf("start new func scope %d\n", line_num); push_symbol_table(stack, create_symbol_table());} param RPAREN LBRACE body_stmt_list RBRACE {pop_symbol_table(stack);}
              | VOID ID {add_symbol(stack, $2, VOID_ENUM, 0, line_num, false, false, true,false);} LPAREN {printf("start new func scope %d\n", line_num); push_symbol_table(stack, create_symbol_table());} param RPAREN LBRACE body_stmt_list RBRACE {pop_symbol_table(stack);}
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

block_stmt : LBRACE { push_symbol_table(stack, create_symbol_table());} body_stmt_list RBRACE {pop_symbol_table(stack);}
           ;
// need to be changed    
enum_body : ID COMMA {char str[20]; sprintf(str ,"%d" ,(enum_body_count++)) ;add_symbol(stack, $1, INT_ENUM, str, line_num, false, true, false,false);} enum_body 
          | ID {char str[20]; sprintf(str ,"%d" ,(enum_body_count++)) ;add_symbol(stack, $1, INT_ENUM,str , line_num, false, true, false,false);}
          ;

enum_stmt   : ENUM ID LBRACE enum_body RBRACE {enum_body_count = 0; }
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
    check_unused_variables();
    // check if stack is empty
    if (stack->num_tables == 0) {
        printf("Error: symbol table stack is empty\n");
        return;
    }

    printf("************************************************************\n");
    SymbolTable *table = stack->tables[stack->num_tables - 1];
    printf("end scope %d at line %d\n", table->idnex, line_num);
    for (int j = 0; j < table->num_symbols; j++) {
        printf("symbol name: %s, symbol type: %d, symbol value: %s, symbol line: %d, symbol is_const: %d, symbol is_enum: %d, symbol is_func: %d\n", table->symbols[j].name, table->symbols[j].type, table->symbols[j].value, table->symbols[j].line, table->symbols[j].is_const, table->symbols[j].is_enum, table->symbols[j].is_func);
    }
    printf("************************************************************\n");

    // pop the top symbol table off the stack
    stack->num_tables--;
}

void add_symbol(SymbolTableStack *stack, char *name, int type, char* value, int line, bool is_const, bool is_enum, bool is_func, bool is_used) {
    // check if stack is empty
    if (stack->num_tables == 0) {
        printf("Error: symbol table stack is empty\n");
        return;
    }
    SymbolTable *table  = NULL;
    if (is_enum){
        // get the global symbol table
       table = stack->tables[0];
    }else {
        // get the top symbol table on the stack
       table = stack->tables[stack->num_tables - 1];
    }

    // check if symbol already exists in the table
    for (int i = 0; i < table->num_symbols; i++) {
        if (strcmp(table->symbols[i].name, name) == 0) {
            printf("Error: symbol '%s' already defined\n", name);
            return;
        }
    }

    // here make a new copy instance from the value to avoid sharing the same pointer
    char* val_copy = copy_value(value);

    Symbol symbol = {name, type, val_copy, line, is_const, is_enum, is_func, is_used};

    table->symbols[table->num_symbols++] = symbol;
}


void check_assignment_types(int statement_type , Symbol * s , int line_num, bool is_const)
{
    if(is_const)
    {
        printf("Error: cannot assign a value to const at line %d\n", line_num);
        exit(1);
    }
    if (statement_type != s->type)
    {
        printf("Error: type mismatch in assignment at line %d\n", line_num);
        exit(1);
    } 
    return ;
}

void check_always_false(int bool_val){
    if (bool_val == 0){
        printf("Warning: condition is always false at line %d\n", line_num);
    }
    return ;
}


char* copy_value(char* value) {
    char* val_copy = NULL;
    if (value != NULL) {
        val_copy = malloc(strlen(value) + 1);
        if (val_copy != NULL) {
            strcpy(val_copy, value);
        } else {
            printf("Error: failed to allocate memory for value copy\n");
            return "";
        }
    }
    return val_copy;
}

void* copy_void(void* value) {
    size_t size = sizeof(Symbol);

    // Allocate memory for the copy
    void* copy = malloc(size);

    // Copy the data
    memcpy(copy, value, size);

    return copy;
}


Symbol *get_symbol(SymbolTableStack *stack, char *name) {
    // search for symbol in the stack of tables, starting from the top
    for (int i = stack->num_tables - 1; i >= 0; i--) {
        SymbolTable *table = stack->tables[i];
        for (int j = 0; j < table->num_symbols; j++) {
            // printf("line: %i, table: %i, name: %s, address: %x, value: %s\n", line_num, i, table->symbols[j].name, &table->symbols[j], table->symbols[j].value);
            if (strcmp(table->symbols[j].name, name) == 0) {
                return &table->symbols[j];
            }
        }
    }

    // symbol not found
    return NULL;
}

Symbol add_op(void *a, void *b) {
                Symbol s;
                Symbol *s1 = void_to_symbol(a);
                Symbol *s2 = void_to_symbol(b);
                char str_val[20] = "";
                // convert from string according to symbol type
                int int_val1 = 0;
                int int_val2 = 0;
                float float_val1 = 0;
                float float_val2 = 0;
                if (s1->type == INT_ENUM)
                        int_val1 = atoi(s1->value);
                else if (s1->type == FLOAT_ENUM)
                        float_val1 = atof(s1->value);

                if (s2->type == INT_ENUM)
                        int_val2 = atoi(s2->value);
                else if (s2->type == FLOAT_ENUM)
                        float_val2 = atof(s2->value);
                // perform operation
                if (s1->type == INT_ENUM && s2->type == INT_ENUM) {
                        sprintf(str_val, "%d", int_val1 + int_val2);
                        s.type = INT_ENUM;
                } else if (s1->type == INT_ENUM && s2->type == FLOAT_ENUM) {
                        sprintf(str_val, "%.2f", int_val1 + float_val2);
                        s.type = FLOAT_ENUM;
                } else if (s1->type == FLOAT_ENUM && s2->type == INT_ENUM) {
                        sprintf(str_val, "%.2f", float_val1 + int_val2);
                        s.type = FLOAT_ENUM;
                } else if (s1->type == FLOAT_ENUM && s2->type == FLOAT_ENUM) {
                        sprintf(str_val, "%.2f", float_val1 + float_val2);
                        s.type = FLOAT_ENUM;
                } else {
                        printf("Error: invalid types for addition\n");
                        return s;
                }

                char* val_copy = copy_value(str_val);
                s.value = val_copy;
                return s;
}

Symbol sub_op(void *a, void *b) {
                Symbol s;
                Symbol *s1 = void_to_symbol(a);
                Symbol *s2 = void_to_symbol(b);
                char str_val[20] = "";

                // convert from string according to symbol type
                int int_val1 = 0;
                int int_val2 = 0;
                float float_val1 = 0;
                float float_val2 = 0;
                if (s1->type == INT_ENUM)
                        int_val1 = atoi(s1->value);
                else if (s1->type == FLOAT_ENUM)
                        float_val1 = atof(s1->value);

                if (s2->type == INT_ENUM)
                        int_val2 = atoi(s2->value);
                else if (s2->type == FLOAT_ENUM)
                        float_val2 = atof(s2->value);

                // perform operation
                if (s1->type == INT_ENUM && s2->type == INT_ENUM) {
                        sprintf(str_val, "%d", int_val1 - int_val2);
                        s.type = INT_ENUM;
                } else if (s1->type == INT_ENUM && s2->type == FLOAT_ENUM) {
                        sprintf(str_val, "%.2f", int_val1 - float_val2);
                        s.type = FLOAT_ENUM;
                } else if (s1->type == FLOAT_ENUM && s2->type == INT_ENUM) {
                        sprintf(str_val, "%.2f", float_val1 - int_val2);
                        s.type = FLOAT_ENUM;
                } else if (s1->type == FLOAT_ENUM && s2->type == FLOAT_ENUM) {
                        sprintf(str_val, "%.2f", float_val1 - float_val2);
                        s.type = FLOAT_ENUM;
                } else {
                        printf("Error: invalid types for subtraction\n");
                        return s;
                }

                char* val_copy = copy_value(str_val);
                s.value = val_copy;
                return s;
}

void assign_value(char * id  ,void *v ) {
    Symbol* s = void_to_symbol(v);
    Symbol* lhs_symbol = get_symbol(stack, id);
    if (lhs_symbol == NULL) {
        printf("Error: variable %s not declared in line %d\n", id, line_num);
        exit(1);
    }
    check_assignment_types(lhs_symbol->type , s,line_num,lhs_symbol->is_const);
    lhs_symbol->value = copy_value(s->value);
}

Symbol mul_op(void *a, void *b) {
                Symbol s;
                Symbol *s1 = void_to_symbol(a);
                Symbol *s2 = void_to_symbol(b);
                char str_val[20] = "";

                // convert from string according to symbol type
                int int_val1 = 0;
                int int_val2 = 0;
                float float_val1 = 0;
                float float_val2 = 0;
                if (s1->type == INT_ENUM)
                        int_val1 = atoi(s1->value);
                else if (s1->type == FLOAT_ENUM)
                        float_val1 = atof(s1->value);

                if (s2->type == INT_ENUM)
                        int_val2 = atoi(s2->value);
                else if (s2->type == FLOAT_ENUM)
                        float_val2 = atof(s2->value);

                // perform operation
                if (s1->type == INT_ENUM && s2->type == INT_ENUM) {
                        sprintf(str_val, "%d", int_val1 * int_val2);
                        s.type = INT_ENUM;
                } else if (s1->type == INT_ENUM && s2->type == FLOAT_ENUM) {
                        sprintf(str_val, "%.2f", int_val1 * float_val2);
                        s.type = FLOAT_ENUM;
                } else if (s1->type == FLOAT_ENUM && s2->type == INT_ENUM) {
                        sprintf(str_val, "%.2f", float_val1 * int_val2);
                        s.type = FLOAT_ENUM;
                } else if (s1->type == FLOAT_ENUM && s2->type == FLOAT_ENUM) {
                        sprintf(str_val, "%.2f", float_val1 * float_val2);
                        s.type = FLOAT_ENUM;
                } else {
                        printf("Error: invalid types for multiplication\n");
                        return s;
                }

                char* val_copy = copy_value(str_val);
                s.value = val_copy;
                return s;
}

Symbol div_op(void *a, void *b) {
                Symbol s;
                Symbol *s1 = void_to_symbol(a);
                Symbol *s2 = void_to_symbol(b);
                char str_val[20] = "";

                // convert from string according to symbol type
                int int_val1 = 0;
                int int_val2 = 0;
                float float_val1 = 0;
                float float_val2 = 0;
                if (s1->type == INT_ENUM)
                        int_val1 = atoi(s1->value);
                else if (s1->type == FLOAT_ENUM)
                        float_val1 = atof(s1->value);

                if (s2->type == INT_ENUM)
                        int_val2 = atoi(s2->value);
                else if (s2->type == FLOAT_ENUM)
                        float_val2 = atof(s2->value);

                // perform operation
                if (s1->type == INT_ENUM && s2->type == INT_ENUM) {
                        sprintf(str_val, "%d", int_val1 / int_val2);
                        s.type = INT_ENUM;
                } else if (s1->type == INT_ENUM && s2->type == FLOAT_ENUM) {
                        sprintf(str_val, "%.2f", int_val1 / float_val2);
                        s.type = FLOAT_ENUM;
                } else if (s1->type == FLOAT_ENUM && s2->type == INT_ENUM) {
                        sprintf(str_val, "%.2f", float_val1 / int_val2);
                        s.type = FLOAT_ENUM;
                } else if (s1->type == FLOAT_ENUM && s2->type == FLOAT_ENUM) {
                        sprintf(str_val, "%.2f", float_val1 / float_val2);
                        s.type = FLOAT_ENUM;
                } else {
                        printf("Error: invalid types for division\n");
                        return s;
                }

                char* val_copy = copy_value(str_val);
                s.value = val_copy;
                return s;
}

Symbol mod_op(void *a, void *b) {
                Symbol s;
                Symbol *s1 = void_to_symbol(a);
                Symbol *s2 = void_to_symbol(b);
                char str_val[20] = "";

                // check if one of the operands are float type and return error
                if (s1->type == FLOAT_ENUM || s2->type == FLOAT_ENUM) {
                        printf("Error: invalid types for modulo\n");
                        return s;
                }

                // convert from string according to symbol type
                int int_val1 = 0;
                int int_val2 = 0;
                int_val1 = atoi(s1->value);
                int_val2 = atoi(s2->value);

                sprintf(str_val, "%d", int_val1 % int_val2);
                s.type = INT_ENUM;

                char* val_copy = copy_value(str_val);
                s.value = val_copy;
                return s;
}

// Loop over symbol table and raise warning if any variable is not used
void check_unused_variables() {
        SymbolTable *table = stack->tables[stack->num_tables - 1];
        for (int j = 0; j < table->num_symbols; j++) {
            if (table->symbols[j].is_used == 0 && table->symbols[j].is_func == 0) {
                printf("Warning: variable %s declared but not used\n", table->symbols[j].name);
            }
        }
}


int main (void) {
        stack = create_symbol_table_stack();
        push_symbol_table(stack, create_symbol_table());

        
	return yyparse ( );
}

void yyerror (char *s) {fprintf (stderr, "error: %s\n", s);} 
