%{
        #include <stdio.h>
        #include <stdlib.h>
        #include <string.h>
        #include <math.h>
        void yyerror (char *s);


        #define SYMBOL_TABLE_MAX 1000
        #define SYMBOL_MAX 1000

        typedef enum { false, true } bool;

        typedef struct {
        int *arguments_types;    // array of symbols
        char **arguments_names;    // array of symbols
        int num_arguments;    // number of symbols in the array
        int max_arguments;    // maximum number of symbols that can be stored
        } Arguments;

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
        Arguments* arguments; // function arguments
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

        Arguments *create_function_argumetns() {
                Arguments *arguments = malloc(sizeof(Arguments));
                arguments->arguments_types = malloc(SYMBOL_MAX * sizeof(int));
                arguments->arguments_names = malloc(SYMBOL_MAX * sizeof(char*));
                arguments->num_arguments = 0;
                arguments->max_arguments = SYMBOL_MAX;
                return arguments;
        }


        void add_symbol(SymbolTableStack *stack, char *name, int type, char* value, int line, bool is_const, bool is_enum, bool is_func, bool is_used, Arguments* arguments);
        Symbol *get_symbol(SymbolTableStack *stack, char *name);
        void push_symbol_table(SymbolTableStack *stack, SymbolTable *table);
        void pop_symbol_table(SymbolTableStack *stack);
        char *copy_value(char* value); // copy the value to a new memory address
        void* copy_void(void* value); // copy the value to a new memory address
        Symbol *void_to_symbol(void *v) {return (Symbol*)v;} 
        int check_assignment_types(int statement_type , Symbol * s , int line_num, bool is_const);
        void add_arguments(Arguments *arguments, int type, char* name);
        void assign_value(char * id  ,void *v);
        void assign_value(char * id  ,void *v );
        void check_unused_variables();
        void check_always_false( Symbol *s);
        void check_operand_types (char* op, int left_type, int right_type);
        Symbol * copy_symbol(Symbol *s);
        void print_symbol_table();


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
        Arguments *last_declared_function = NULL;
        int func_param_count = 0;


        // quadratic data 
        char QuadStack [10000][50];
        int QuadStackIndex = 0;
        
        char Quads [10000][100];
        int QuadsIndex = 0;
        char Funcs[1000][100];
        char ForIterationBuffer[1000][100];
        int FuncsIndex = 0;
        bool inFuncScope = false;
        bool inForScope = false;
        int ForIterationBufferIndex = 0;

        int tempRegIndex = 0 ;

        int label_count = 0;
        int labelStackIndex = 0;
        char labelStack[1000][100];

        // quads functions 
        void push(char *s, bool inFuncScope);
        void push_id(char *s);
        void push_value(char * value, bool inFuncScope);
        void pop(char *s, bool inFuncScope);
        void one_op(char * op, bool inFuncScope);
        void two_op(char * op, bool inFuncScope);
        void fill_quad_stack_from_for_buffer();

        // control flow functions
        void add_label();
        void add_func_label(char* func_name);
        void pop_func_label();
        void pop_labels(int num);
        void jump(bool add_label_flag, int label_offset);
        void jump_zero(bool add_label_flag);
        void jump_not_zero(bool add_label_flag);
        void print_label(bool add_label_flag, int label_offset);
        void jump_break();
        void jump_function(char* func_name);


        // quads helper
        void QuadsToFile(char * filename) ;
        FILE *st ;
        FILE * console_logs ;

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


expr    : expr PLUS expr        {Symbol *op1 = void_to_symbol($1);Symbol *op2 = void_to_symbol($3);check_operand_types("math" , op1->type,op2->type);Symbol s = add_op($1, $3); $$ = copy_void(((void*)&s));two_op("ADD", inFuncScope);}
        | expr MINUS expr       {Symbol *op1 = void_to_symbol($1);Symbol *op2 = void_to_symbol($3);check_operand_types("math" , op1->type,op2->type);Symbol s = sub_op($1, $3); $$ = copy_void(((void*)&s));two_op("SUB", inFuncScope);}
        | expr TIMES expr       {Symbol *op1 = void_to_symbol($1);Symbol *op2 = void_to_symbol($3);check_operand_types("math" , op1->type,op2->type);Symbol s = mul_op($1, $3); $$ = copy_void(((void*)&s));two_op("MUL", inFuncScope);}
        | expr DIV expr         {Symbol *op1 = void_to_symbol($1);Symbol *op2 = void_to_symbol($3);check_operand_types("math" , op1->type,op2->type);Symbol s = div_op($1, $3); $$ = copy_void(((void*)&s));two_op("DIV", inFuncScope);}
        | expr MOD expr         {Symbol *op1 = void_to_symbol($1);Symbol *op2 = void_to_symbol($3);check_operand_types("math" , op1->type,op2->type);Symbol s = mod_op($1, $3); $$ = copy_void(((void*)&s));two_op("MOD", inFuncScope);}
        | expr AND expr         {Symbol *op1 = void_to_symbol($1);Symbol *op2 = void_to_symbol($3);check_operand_types("logical" , op1->type,op2->type);char str_val[20] = ""; sprintf(str_val, "%d", atof(void_to_symbol($1)->value) && atof(void_to_symbol($3)->value)); char* val_copy = copy_value(str_val); Symbol s; s.value = val_copy; s.type = BOOL_ENUM; void *v= (void*)&s; $$ = copy_void(v); two_op("AND", inFuncScope);}
        | expr OR expr          {Symbol *op1 = void_to_symbol($1);Symbol *op2 = void_to_symbol($3);check_operand_types("logical" , op1->type,op2->type);char str_val[20] = ""; sprintf(str_val, "%d", atof(void_to_symbol($1)->value) || atof(void_to_symbol($3)->value)); char* val_copy = copy_value(str_val); Symbol s; s.value = val_copy; s.type = BOOL_ENUM; void *v= (void*)&s; $$ = copy_void(v); two_op("OR", inFuncScope);}
        | expr EQ expr          {Symbol *op1 = void_to_symbol($1);Symbol *op2 = void_to_symbol($3);check_operand_types("logical" , op1->type,op2->type);char str_val[20] = ""; sprintf(str_val, "%d", atof(void_to_symbol($1)->value) == atof(void_to_symbol($3)->value)); char* val_copy = copy_value(str_val); Symbol s; s.value = val_copy; s.type = BOOL_ENUM; void *v= (void*)&s; $$ = copy_void(v); two_op("EQ", inFuncScope);}
        | expr NE expr          {Symbol *op1 = void_to_symbol($1);Symbol *op2 = void_to_symbol($3);check_operand_types("logical" , op1->type,op2->type);char str_val[20] = ""; sprintf(str_val, "%d", atof(void_to_symbol($1)->value) != atof(void_to_symbol($3)->value)); char* val_copy = copy_value(str_val); Symbol s; s.value = val_copy; s.type = BOOL_ENUM; void *v= (void*)&s; $$ = copy_void(v); two_op("NE", inFuncScope);}
        | expr LT expr          {Symbol *op1 = void_to_symbol($1);Symbol *op2 = void_to_symbol($3);check_operand_types("logical" , op1->type,op2->type);char str_val[20] = ""; sprintf(str_val, "%d", atof(void_to_symbol($1)->value) < atof(void_to_symbol($3)->value)); char* val_copy = copy_value(str_val); Symbol s; s.value = val_copy; s.type = BOOL_ENUM; void *v= (void*)&s; $$ = copy_void(v); two_op("LT", inFuncScope);}
        | expr GT expr          {Symbol *op1 = void_to_symbol($1);Symbol *op2 = void_to_symbol($3);check_operand_types("logical" , op1->type,op2->type);char str_val[20] = ""; sprintf(str_val, "%d", atof(void_to_symbol($1)->value) > atof(void_to_symbol($3)->value)); char* val_copy = copy_value(str_val); Symbol s; s.value = val_copy; s.type = BOOL_ENUM; void *v= (void*)&s; $$ = copy_void(v); two_op("GT", inFuncScope);}
        | expr LE expr          {Symbol *op1 = void_to_symbol($1);Symbol *op2 = void_to_symbol($3);check_operand_types("logical" , op1->type,op2->type);char str_val[20] = ""; sprintf(str_val, "%d", atof(void_to_symbol($1)->value) <= atof(void_to_symbol($3)->value)); char* val_copy = copy_value(str_val); Symbol s; s.value = val_copy; s.type = BOOL_ENUM; void *v= (void*)&s; $$ = copy_void(v); two_op("LE", inFuncScope);}
        | expr GE expr          {Symbol *op1 = void_to_symbol($1);Symbol *op2 = void_to_symbol($3);check_operand_types("logical" , op1->type,op2->type);char str_val[20] = ""; sprintf(str_val, "%d", atof(void_to_symbol($1)->value) >= atof(void_to_symbol($3)->value)); char* val_copy = copy_value(str_val); Symbol s; s.value = val_copy; s.type = BOOL_ENUM; void *v= (void*)&s; $$ = copy_void(v); two_op("GE", inFuncScope);}
        | expr XOR expr         {Symbol *op1 = void_to_symbol($1);Symbol *op2 = void_to_symbol($3);check_operand_types("logical" , op1->type,op2->type);char str_val[20] = ""; sprintf(str_val, "%d", atoi(void_to_symbol($1)->value) ^ atoi(void_to_symbol($3)->value)); char* val_copy = copy_value(str_val); Symbol s; s.value = val_copy; s.type = BOOL_ENUM; void *v= (void*)&s; $$ = copy_void(v); two_op("XOR", inFuncScope);}
        | NOT expr              {Symbol *op1 = void_to_symbol($2);check_operand_types("logical" , op1->type,INT_ENUM);char str_val[20] = ""; sprintf(str_val, "%d", !atof(void_to_symbol($2)->value)); char* val_copy = copy_value(str_val); Symbol s; s.value = val_copy; s.type = BOOL_ENUM; void *v= (void*)&s; $$ = copy_void(v); one_op("NOT", inFuncScope);}
        | LPAREN expr RPAREN    {Symbol s = *void_to_symbol($2); void *v= (void*)&s; $$ = copy_void(v);}
        | func_call_stmt        {Symbol s; void *v= (void*)&s; $$ = copy_void(v);}  // TODO
        | INT                   {char str_val[20] = ""; sprintf(str_val, "%d", $1); char* val_copy = copy_value(str_val); Symbol s; s.value = val_copy; s.type = INT_ENUM;s.name = NULL; void *v= (void*)&s; $$ = copy_void(v); push(val_copy, inFuncScope);}
        | FLOAT                 {char str_val[20] = ""; sprintf(str_val, "%.2f", $1); char* val_copy = copy_value(str_val); Symbol s; s.value = val_copy; s.type = FLOAT_ENUM;s.name = NULL; void *v= (void*)&s; $$ = copy_void(v); push(val_copy, inFuncScope);}
        | BOOL                  {char str_val[20] = ""; sprintf(str_val, "%d", $1); char* val_copy = copy_value(str_val); Symbol s; s.value = val_copy; s.type = BOOL_ENUM;s.name = NULL; void *v= (void*)&s; $$ = copy_void(v); push(val_copy, inFuncScope);}
        | STRING                {char* val_copy = copy_value($1); Symbol s; s.value = val_copy; s.type = STRING_ENUM; s.name = NULL; void *v= (void*)&s; $$ = v; push(val_copy, inFuncScope);}
        | ID                    {Symbol *s = get_symbol(stack, $1); s->is_used = true ;printf("ID: %s Marked as Used \n", s->name); void *v= (void*)s; $$ = copy_void(v); push($1, inFuncScope);}
        ;

enum_val : ID {Symbol s = *get_symbol(stack, $1); void *v= (void*)&s; $$ = copy_void(v);}
         | INT  {char str_val[20] = ""; sprintf(str_val, "%d", $1); char* val_copy = copy_value(str_val); Symbol s; s.value = val_copy; void *v= (void*)&s; $$ = copy_void(v);}
         ;

assignment : type ID {push_id($2);} ASSIGN expr {
                Symbol* s = void_to_symbol($5);
                int conv = check_assignment_types($1, s, line_num,0);
                char * converted_val = malloc(sizeof(char)*50);
                if (conv == 0)
                {
                        // From float to int
                        sprintf(converted_val, "%d", (int)atof(s->value));
                } else if (conv == 1) {
                        // From int to float
                        sprintf(converted_val, "%.2f", atof(s->value));
                } else {
                        // No conversion needed
                        sprintf(converted_val, "%s", s->value);
                }
                add_symbol(stack, $2, $1, converted_val, line_num, false, false, false, false, NULL);
                free (converted_val);
                pop(QuadStack[QuadStackIndex-2], inFuncScope);
                }
              | ID ASSIGN { push_id($1);} expr {
                assign_value($1,$4);
                pop(QuadStack[QuadStackIndex-2], inFuncScope);
                }
              | CONST type ID { push_id($3);} ASSIGN expr {
                Symbol* s = void_to_symbol($6);
                add_symbol(stack, $3, $2, s->value, line_num, true, false, false, false, NULL);
                pop(QuadStack[QuadStackIndex-2], inFuncScope);
              }
              | ENUM ID ID ASSIGN enum_val {
                Symbol *enum_symbol = void_to_symbol($2);
                Symbol* s = void_to_symbol($5);
                add_symbol(stack, $3, INT_ENUM , s->value, line_num, false, true, false, false, NULL);
              }
           ;

declare : type ID {
                char* default_val = $1 == STRING_ENUM? "": "0";
                add_symbol(stack, $2, $1, default_val, line_num, false, false, false, false, NULL);
                push_id($2); // push the ID to the stack
                }
        | ENUM ID ID {
                char* default_val = "0";
                add_symbol(stack, $3, INT_ENUM, default_val, line_num, false, true, false, false, NULL);
                }
        ;

else_if_stmt : ELSEIF {jump(true, 1); print_label(false, 2);} LPAREN expr RPAREN LBRACE {push_symbol_table(stack, create_symbol_table());} body_stmt_list RBRACE {print_label(false, 1); pop_labels(2); pop_symbol_table(stack);} else_if_stmt
             | else_if_stmt ELSE {jump(true, 1); print_label(false, 2);} LBRACE {push_symbol_table(stack, create_symbol_table());} body_stmt_list RBRACE {print_label(false, 1); pop_labels(2); pop_symbol_table(stack);}
             | {printf("%d %s" , line_num , "empty else if stmt\n");}
             ;

if_stmt  : IF LPAREN expr {jump_zero(true); Symbol *s = void_to_symbol($3); printf("if expression evaluation is: %s in line: %d\n", s->value, line_num);check_always_false(s);} RPAREN LBRACE {push_symbol_table(stack, create_symbol_table());} body_stmt_list RBRACE {pop_symbol_table(stack);} if_stmt
         | ELSE {jump(true, 1); print_label(false, 2);} LBRACE {push_symbol_table(stack, create_symbol_table());} body_stmt_list RBRACE {print_label(false, 1); pop_labels(2); pop_symbol_table(stack);}
         | ELSEIF {jump(true, 1); print_label(false, 2);} LPAREN expr RPAREN LBRACE {Symbol *s = void_to_symbol($4);push_symbol_table(stack, create_symbol_table(s->value));check_always_false(s);} body_stmt_list RBRACE {print_label(false, 1); pop_labels(2); pop_symbol_table(stack);} else_if_stmt
         | ENDIF {print_label(false, 1); pop_labels(1);}
         ;

while_stmt : WHILE LPAREN {print_label(true, 1);} expr {Symbol *s = void_to_symbol($4); printf("while loop expression evaluation is: %s in line: %d\n", s->value, line_num); jump_zero(true);check_always_false(s);} RPAREN LBRACE {push_symbol_table(stack, create_symbol_table());} body_stmt_list RBRACE {jump(false, 2);  print_label(false, 1); pop_labels(2); pop_symbol_table(stack);}
           ;
           
for_stmt : FOR LPAREN assignment SEMI {print_label(true, 1);} expr {Symbol *s = void_to_symbol($6); printf("for loop expression evaluation is: %s in line: %d\n", s->value, line_num); jump_zero(true); check_always_false(s);} SEMI {inForScope = true;} assignment {inForScope = false;} RPAREN LBRACE {push_symbol_table(stack, create_symbol_table());} body_stmt_list RBRACE {fill_quad_stack_from_for_buffer(); jump(false, 2); print_label(false, 1); pop_labels(2); pop_symbol_table(stack);}
            ;

repeat_stmt : REPEAT LBRACE {{print_label(true, 1);} push_symbol_table(stack, create_symbol_table());} body_stmt_list RBRACE {pop_symbol_table(stack);} UNTIL LPAREN expr  {jump_not_zero(false); pop_labels(1); Symbol *s = void_to_symbol($9); printf("repeat loop expression evaluation is: %s in line: %d\n", s->value, line_num);check_always_false(s);}  RPAREN SEMI
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

param : type ID {add_symbol(stack, $2, $1, 0, line_num, false, false, false, false, NULL); Symbol s = *get_symbol(stack, $2); printf("%s\n", s.name); add_arguments(last_declared_function, s.type, s.name);}
      | type ID COMMA {add_symbol(stack, $2, $1, 0, line_num, false, false, false, false, NULL); Symbol s = *get_symbol(stack, $2); add_arguments(last_declared_function, s.type, s.name);} param
      |  {printf("%d %s" , line_num , "empty param list\n");}
      ;     

param_call : | expr COMMA {
                // Check if the ID exists in the symbol table
                Symbol *s = void_to_symbol($1); 
                pop(last_declared_function->arguments_names[func_param_count], inFuncScope);
                if (s->type != last_declared_function->arguments_types[func_param_count]) {
                        printf("Error: type mismatch in function call at line %d: expected: %d but found: %d\n", line_num, last_declared_function->arguments_types[func_param_count], s->type); 
                        fprintf(console_logs, "Error: type mismatch in function call at line %d: expected: %d but found: %d\n", line_num, last_declared_function->arguments_types[func_param_count], s->type);
                        exit(1);
                }
                func_param_count++;
                if (s == NULL) {
                    printf("Error: %s is not defined in line %d\n", s->name, line_num);
                    fprintf(console_logs, "Error: %s is not defined in line %d\n", s->name, line_num);
                    exit(1);
                } else {
                        // Mark the symbol as used
                        s->is_used = true;
                        printf("ID: %s Marked as Used \n", s->name);
                }
                } param_call 
             | expr {
                // Check if the ID exists in the symbol table
                Symbol *s = void_to_symbol($1); 
                pop(last_declared_function->arguments_names[func_param_count], inFuncScope);
                if (s->type != last_declared_function->arguments_types[func_param_count]) {
                        printf("Error: type mismatch in function call at line %d: expected: %d but found: %d\n", line_num, last_declared_function->arguments_types[func_param_count], s->type);
                        fprintf(console_logs, "Error: type mismatch in function call at line %d: expected: %d but found: %d\n", line_num, last_declared_function->arguments_types[func_param_count], s->type);
                        exit(1);
                }
                func_param_count++;
                if (s == NULL) {
                    printf("Error: %s is not defined in line %d\n", s->name, line_num);
                    fprintf(console_logs, "Error: %s is not defined in line %d\n", s->name, line_num);
                    exit(1);
                } else {
                        // Mark the symbol as used
                        s->is_used = true;
                        printf("ID: %s Marked as Used \n", s->name);
                }
             }
             | {printf("empty param call list\n");}
             ;




function_stmt : type ID {inFuncScope = (strcmp($2 , "main")==0 )? false :true; if(inFuncScope) add_func_label($2); add_symbol(stack, $2, $1, 0, line_num, false, false, true, false, create_function_argumetns());} LPAREN {push_symbol_table(stack, create_symbol_table()); last_declared_function = get_symbol(stack, $2)->arguments;} param RPAREN LBRACE body_stmt_list RBRACE {pop_symbol_table(stack); if(inFuncScope) pop_func_label(); inFuncScope = false;}
              | VOID ID {inFuncScope = (strcmp($2 , "main")==0 )? false :true; if(inFuncScope) add_func_label($2); add_symbol(stack, $2, VOID_ENUM, 0, line_num, false, false, true, false, create_function_argumetns());} LPAREN {push_symbol_table(stack, create_symbol_table()); last_declared_function = get_symbol(stack, $2)->arguments;} param RPAREN LBRACE body_stmt_list RBRACE {pop_symbol_table(stack); if(inFuncScope) pop_func_label(); inFuncScope = false;}



func_call_stmt : ID {
        Symbol *s = get_symbol(stack, $1); 
        if (s != NULL && s->is_func) {
        last_declared_function = s->arguments;
        }
        else {
            printf("Error: function '%s' not defined\n", $1);
            fprintf(console_logs, "Error: function '%s' not defined\n", $1);
            exit(1);
        }
        } LPAREN param_call {
                printf("func_param_count: %d\n", func_param_count);
                if (func_param_count != last_declared_function->num_arguments) {
                        printf("Error: number of arguments in function call does not match function definition at line %d: expected: %d but found: %d\n", line_num, last_declared_function->num_arguments, func_param_count);
                        fprintf(console_logs, "Error: number of arguments in function call does not match function definition at line %d: expected: %d but found: %d\n", line_num, last_declared_function->num_arguments, func_param_count);
                        exit(1);
                }
                func_param_count = 0;
        } RPAREN {jump_function($1);}
               ;

switch_stmt : SWITCH LPAREN expr  {Symbol *s = void_to_symbol($3); printf("switch expression evaluation is: %s in line: %d\n", s->value, line_num);} RPAREN LBRACE {push_symbol_table(stack, create_symbol_table());} case_stmt RBRACE {pop_symbol_table(stack);}
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
enum_body : ID COMMA {char str[20]; sprintf(str ,"%d" ,(enum_body_count++)) ;add_symbol(stack, $1, INT_ENUM, str, line_num, false, true, false, false, NULL);} enum_body 
          | ID {char str[20]; sprintf(str ,"%d" ,(enum_body_count++)) ;add_symbol(stack, $1, INT_ENUM,str , line_num, false, true, false, false, NULL);}
          ;

enum_stmt   : ENUM ID {add_symbol(stack, $2, ENUM_ENUM, 0, line_num, false, true, false, false, NULL);} LBRACE enum_body RBRACE {enum_body_count = 0; }
            ;

return_stmt : RETURN expr
            | RETURN
            ;

%%

void push_symbol_table(SymbolTableStack *stack, SymbolTable *table) {
    // check if stack is full
    if (stack->num_tables >= stack->max_tables) {
        printf("Error: symbol table stack is full\n");
        fprintf(console_logs, "Error: symbol table stack is full\n");
        exit(1);
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
        fprintf(console_logs, "Error: symbol table stack is empty\n");
        exit(1);
    }

    printf("************************************************************\n");
    SymbolTable *table = stack->tables[stack->num_tables - 1];
    printf("end scope %d at line %d\n", table->idnex, line_num);
    for (int j = 0; j < table->num_symbols; j++) {
        printf("symbol name: %s, symbol type: %d, symbol value: %s, symbol line: %d, symbol is_const: %d, symbol is_enum: %d, symbol is_func: %d\n", table->symbols[j].name, table->symbols[j].type, table->symbols[j].value, table->symbols[j].line, table->symbols[j].is_const, table->symbols[j].is_enum, table->symbols[j].is_func);
        if (table->symbols[j].is_func) {
            printf("function arguments: \n");
            for (int i = 0; i < table->symbols[j].arguments->num_arguments; i++) {
                printf("%d ", table->symbols[j].arguments->arguments_types[i]);
            }
            printf("\n");
        }
    }
    printf("************************************************************\n");

    // pop the top symbol table off the stack
    stack->num_tables--;
}

void add_symbol(SymbolTableStack *stack, char *name, int type, char* value, int line, bool is_const, bool is_enum, bool is_func, bool is_used, Arguments* arguments) {
    // check if stack is empty
    if (stack->num_tables == 0) {
        printf("Error: symbol table stack is empty\n");
        fprintf(console_logs, "Error: symbol table stack is empty\n");
        exit(1);
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
            fprintf(console_logs, "Error: symbol '%s' already defined\n", name);
            exit(1);
        }
    }

    // here make a new copy instance from the value to avoid sharing the same pointer
    char* val_copy = copy_value(value);

    Symbol symbol = {name, type, val_copy, line, is_const, is_enum, is_func , is_used, arguments};
    table->symbols[table->num_symbols++] = symbol;
    print_symbol_table();
}

void print_symbol_table()
{
        fprintf(st,"%d\n",line_num);
        fprintf(st,"name, type, value, line, is_const, is_enum, is_func , is_used, scope\n");
        for (int i = stack->num_tables - 1; i>=0 ; i--) {
        SymbolTable *table = stack->tables[i];
        for (int j = 0; j < table->num_symbols; j++) {
                fprintf(st,"%s, %d, %s, %d, %d, %d, %d, %d , %d\n",table->symbols[j].name, table->symbols[j].type, table->symbols[j].value, table->symbols[j].line, table->symbols[j].is_const, table->symbols[j].is_enum, table->symbols[j].is_func , table->symbols[j].is_used,i);
                }
        }
        fprintf(st,"==================================================================================================\n");

}


int check_assignment_types(int statement_type , Symbol * s , int line_num, bool is_const)
{
        if(is_const)
        {
                printf("Error: cannot assign a value to const at line %d\n", line_num);
                fprintf(console_logs,"Error: cannot assign a value to const at line %d\n", line_num);
                exit(1);
        }
        // Apply type conversion from int to float and vice versa
        if (statement_type == INT_ENUM && s->type == FLOAT_ENUM)
        {
                printf("Warning: type conversion from float to int at line %d\n", line_num);
                fprintf(console_logs,"Warning: type conversion from float to int at line %d\n", line_num);
                if (s->name == NULL)
                {
                        sprintf(Quads[QuadsIndex++], "Convi %s"  , s->value);
                }else {
                        sprintf(Quads[QuadsIndex++], "Convi %s"  , s->name);
                }
                return 0;
        }
        else if (statement_type == FLOAT_ENUM && s->type == INT_ENUM)
        {
                printf("Warning: type conversion from int to float at line %d\n", line_num);
                fprintf(console_logs,"Warning: type conversion from int to float at line %d\n", line_num);
                if (s->name == NULL)
                {
                        sprintf(Quads[QuadsIndex++], "Convf %s"  , s->value);
                }else {
                        sprintf(Quads[QuadsIndex++], "Convf %s"  , s->name);
                }
                return 1;
        }
        else if (statement_type != s->type)
        {
                printf("Error: type mismatch in assignment at line %d\n", line_num);
                fprintf(console_logs,"Error: type mismatch in assignment at line %d\n", line_num);
                exit(1);
        }
        return -1;
}

void check_operand_types (char* op, int left_type, int right_type)
{
        if (op == "math")
        {
                if ( left_type == STRING_ENUM || right_type == STRING_ENUM)
                {
                        printf("Error: type mismatch in math operation at line %d strings not allowed \n", line_num);
                        fprintf(console_logs,"Error: type mismatch in math operation at line %d strings not allowed \n", line_num);
                        exit(1);
                }
        } 
        else if (op == "logical")
        {
                if (!((left_type == BOOL_ENUM || left_type ==INT_ENUM ) && (right_type == BOOL_ENUM || right_type ==INT_ENUM )))
                {
                        printf("Error: type mismatch in logical operation at line %d operands must be int or bool \n", line_num);
                        fprintf(console_logs,"Error: type mismatch in logical operation at line %d operands must be int or bool \n", line_num);
                        exit(1);
                }
        }
}

void check_always_false(Symbol *s) {
    if (atoi(s->value) == 0 && s->type == BOOL_ENUM && s->name == NULL){
        printf("Warning: condition is always false at line %d\n", line_num);
        fprintf(console_logs,"Warning: condition is always false at line %d\n", line_num);
    }
    return;
}


char* copy_value(char* value) {
    char* val_copy = NULL;
    if (value != NULL) {
        val_copy = malloc(strlen(value) + 1);
        if (val_copy != NULL) {
            strcpy(val_copy, value);
        } else {
            printf("Error: failed to allocate memory for value copy\n");
            fprintf(console_logs,"Error: failed to allocate memory for value copy\n");
            exit(1);
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
    printf("Error: Undefined '%s' at line %d \n", name, line_num);
    fprintf(console_logs,"Error: Undefined '%s' at line %d \n", name, line_num);
    exit(1);
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
                if (s1->type == INT_ENUM && s1->value != NULL)
                        int_val1 = atoi(s1->value);
                else if (s1->type == FLOAT_ENUM && s1->value != NULL)
                        float_val1 = atof(s1->value);

                if (s2->type == INT_ENUM && s2->value != NULL)
                        int_val2 = atoi(s2->value);
                else if (s2->type == FLOAT_ENUM && s2->value != NULL)
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
                        fprintf(console_logs,"Error: invalid types for addition\n");
                        exit(1);
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
                if (s1->type == INT_ENUM && s1->value != NULL)
                        int_val1 = atoi(s1->value);
                else if (s1->type == FLOAT_ENUM && s1->value != NULL)
                        float_val1 = atof(s1->value);

                if (s2->type == INT_ENUM && s2->value != NULL)
                        int_val2 = atoi(s2->value);
                else if (s2->type == FLOAT_ENUM && s2->value != NULL)
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
                        fprintf(console_logs,"Error: invalid types for subtraction\n");
                        exit(1);
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
                fprintf(console_logs,"Error: variable %s not declared in line %d\n", id, line_num);
                exit(1);
        }
        int conv = check_assignment_types(lhs_symbol->type , s,line_num,lhs_symbol->is_const);
        char * converted_val = malloc(sizeof(char)*50);
        if (conv == 0)
        {
                // From float to int
                sprintf(converted_val, "%d", (int)atof(s->value));
        } else if (conv == 1) {
                // From int to float
                sprintf(converted_val, "%.2f", atof(s->value));
        } else {
                // No conversion needed
                sprintf(converted_val, "%s", s->value);
        }
        lhs_symbol->value = copy_value(converted_val);
        print_symbol_table();
        free(converted_val);
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
                if (s1->type == INT_ENUM && s1->value != NULL)
                        int_val1 = atoi(s1->value);
                else if (s1->type == FLOAT_ENUM && s1->value != NULL)
                        float_val1 = atof(s1->value);

                if (s2->type == INT_ENUM && s2->value != NULL)
                        int_val2 = atoi(s2->value);
                else if (s2->type == FLOAT_ENUM && s2->value != NULL)
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
                        fprintf(console_logs,"Error: invalid types for multiplication\n");
                        exit(1);
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
                int int_val2 = 1;
                float float_val1 = 0;
                float float_val2 = 1.0;
                if (s1->type == INT_ENUM && s1->value != NULL)
                        int_val1 = atoi(s1->value);
                else if (s1->type == FLOAT_ENUM && s1->value != NULL)
                        float_val1 = atof(s1->value);

                if (s2->type == INT_ENUM && s2->value != NULL)
                        int_val2 = atoi(s2->value);
                else if (s2->type == FLOAT_ENUM && s2->value != NULL)
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
                        fprintf(console_logs,"Error: invalid types for division\n");
                        exit(1);
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
                        fprintf(console_logs,"Error: invalid types for modulo\n");
                        exit(1);
                }

                // convert from string according to symbol type
                int int_val1 = 0;
                int int_val2 = 0;
                int_val1 = atoi(s1->value != NULL ? s1->value : "0");
                int_val2 = atoi(s2->value != NULL ? s2->value : "1");

                sprintf(str_val, "%d", int_val1 % int_val2);
                s.type = INT_ENUM;

                char* val_copy = copy_value(str_val);
                s.value = val_copy;
                return s;
}

void add_arguments(Arguments* arguments, int type, char* name) {
    arguments->arguments_types[arguments->num_arguments] = type;
        arguments->arguments_names[arguments->num_arguments] = name;
    arguments->num_arguments++;
}

// Loop over symbol table and raise warning if any variable is not used
void check_unused_variables() {
        SymbolTable *table = stack->tables[stack->num_tables - 1];
        for (int j = 0; j < table->num_symbols; j++) {
            if (table->symbols[j].is_used == 0 && table->symbols[j].is_func == 0) {
                printf("Warning: variable %s declared but not used\n", table->symbols[j].name);
                fprintf(console_logs, "Warning: variable %s declared but not used\n", table->symbols[j].name);
            }
        }
}

/// Quads functions
void push(char *s, bool inFuncScope) {
        strcpy(QuadStack[QuadStackIndex++] , s);
        if (inFuncScope) {
                sprintf(Funcs[FuncsIndex++], "PUSH %s "  , s);
        } else if (inForScope) {
                sprintf(ForIterationBuffer[ForIterationBufferIndex++], "PUSH %s "  , s);
        }
         else {
                sprintf(Quads[QuadsIndex++], "PUSH %s "  , s); 
        }
}

void push_id(char *s) {
        strcpy(QuadStack[QuadStackIndex++] , s);
}

void pop(char *s, bool inFuncScope) {
       --QuadStackIndex;
        if (inFuncScope) {
                sprintf(Funcs[FuncsIndex++], "POP %s "  , s);
         } if (inForScope) {
                sprintf(ForIterationBuffer[ForIterationBufferIndex++], "POP %s "  , s);
         } 
         else {
                sprintf(Quads[QuadsIndex++], "POP %s "  , s);
         }
}

void one_op(char * op, bool inFuncScope) {
        char * arg = strdup(QuadStack[--QuadStackIndex]);
        char tempReg[10];       
        sprintf(tempReg, "t%d", tempRegIndex++);
        strcpy(QuadStack[QuadStackIndex++], tempReg);
        if (inFuncScope) {
                sprintf(Funcs[FuncsIndex++], "%s %s %s ", op, arg, QuadStack[QuadStackIndex-1]);
        } else if (inForScope) {
                sprintf(ForIterationBuffer[ForIterationBufferIndex++], "%s %s %s ", op, arg, QuadStack[QuadStackIndex-1]);
        }
         else {
                sprintf(Quads[QuadsIndex++], "%s %s %s ", op, arg, QuadStack[QuadStackIndex-1]);
        }
}

void two_op(char* op, bool inFuncScope) {
        char * arg1 = strdup(QuadStack[QuadStackIndex-2]);
        char * arg2 = strdup(QuadStack[QuadStackIndex-1]);
        QuadStackIndex-= 2;
        char tempReg[10];
        sprintf(tempReg, "t%d", tempRegIndex++);
        strcpy(QuadStack[QuadStackIndex++], tempReg);
        if (inFuncScope) {
                sprintf(Funcs[FuncsIndex++], "%s %s %s %s ", op, arg1, arg2, QuadStack[QuadStackIndex-1]);
        } else if (inForScope) {
                sprintf(ForIterationBuffer[ForIterationBufferIndex++], "%s %s %s %s ", op, arg1, arg2, QuadStack[QuadStackIndex-1]);
        } else {
                sprintf(Quads[QuadsIndex++], "%s %s %s %s ", op, arg1, arg2, QuadStack[QuadStackIndex-1]);
        }
}

void fill_quad_stack_from_for_buffer() { 
        for (int i = 0; i < ForIterationBufferIndex; i++) {
                strcpy(Quads[QuadsIndex++], ForIterationBuffer[i]);
        }
        ForIterationBufferIndex = 0;
        inForScope = false;
}


void add_label() {
        char temp_label[10];
        sprintf(temp_label, "L%d", label_count++);
        strcpy(labelStack[labelStackIndex++], temp_label);
}

void add_func_label(char *func_name) {
        sprintf(Funcs[FuncsIndex++], "%s: ", func_name);
}

void pop_labels(int num) {
        labelStackIndex -= num;
}

void pop_func_label() {
        sprintf(Funcs[FuncsIndex++], "%s", "return");
}

void jump(bool add_label_flag, int label_offset) {
        if (add_label_flag) {
                add_label();
        }
        sprintf(Quads[QuadsIndex++], "JUMP %s ", labelStack[labelStackIndex-label_offset]);
}

void jump_function(char *func_name) {
        sprintf(Quads[QuadsIndex++], "JUMP %s ", func_name);
}

void jump_zero(bool add_label_flag) {
        if (add_label_flag) {
                add_label();
        }
        sprintf(Quads[QuadsIndex++], "JUMPZERO %s ", labelStack[labelStackIndex-1]);
}

void jump_not_zero(bool add_label_flag) {
        if (add_label_flag) {
                add_label();
        }
        sprintf(Quads[QuadsIndex++], "JUMPNONZERO %s ", labelStack[labelStackIndex-1]);
}

void print_label(bool add_label_flag, int label_offset) {
        if (add_label_flag) {
                add_label();
        }
        sprintf(Quads[QuadsIndex++], "%s: ", labelStack[labelStackIndex-label_offset]);
}

void jump_break() {
        sprintf(Quads[QuadsIndex++], "JUMP %s ", labelStack[labelStackIndex-1]);
}

void QuadsToFile(char * filename) {
        FILE * fp;
        fp = fopen(filename, "w");
        for (int i = 0; i < QuadsIndex; i++) {
                fprintf(fp, "%s\n", Quads[i]);
        }
        fprintf(fp, "%s\n", "\n\n\n hlt \n\n\n");

        for (int i = 0; i < FuncsIndex; i++) {
                fprintf(fp, "%s\n", Funcs[i]);
        }
        fclose(fp);
}


int main (void) {
        stack = create_symbol_table_stack();
        push_symbol_table(stack, create_symbol_table());
        st = fopen("symbol_table.txt", "w");
        console_logs = fopen("console_logs.txt", "w");
        yyparse ();
        QuadsToFile("quads.txt");
        fclose(st);
        fclose(console_logs);
        // free memory
        free(stack);
        return 0;
}

void yyerror (char *s) {fprintf (stderr, "error in line %d: %s\n", line_num, s);} 
