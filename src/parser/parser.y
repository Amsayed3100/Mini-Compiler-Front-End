<<<<<<< HEAD
%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);

/* Flex input file */
extern FILE *yyin;
%}

/*-----------------------
    Token Declaration
------------------------*/

%token INT FLOAT CHAR BOOL

%token IF ELSE WHILE FOR RETURN PRINTF

%token ID
%token INT_NUM
%token FLOAT_NUM

%token PLUS MINUS MUL DIV MOD

%token ASSIGN

%token LT GT LE GE EQ NE

%token AND OR NOT

%token SEMICOLON COMMA

%token INC
%token DEC
%token LPAREN RPAREN
%token LBRACE RBRACE
%token LBRACKET RBRACKET

/*-----------------------
    Operator Precedence
------------------------*/

%left OR
%left AND
%right NOT

%left EQ NE
%left LT GT LE GE

%left PLUS MINUS
%left MUL DIV MOD

/*-----------------------
    Start Symbol
------------------------*/

%start Program

%%

Program
    : StatementList
    ;

StatementList
    : Statement StatementList
    |
    ;

Statement
    : Declaration
    | Assignment
    | IfStatement
    | IfElseStatement
    | WhileStatement
    | ForStatement
    | PrintStatement
    ;

Declaration
    : DataType ID SEMICOLON
    | DataType ID ASSIGN Expression SEMICOLON
    ;

DataType
    : INT
    | FLOAT
    | CHAR
    | BOOL
    ;

Assignment
    : ID ASSIGN Expression SEMICOLON
    ;

Expression
    : Expression PLUS Term
    | Expression MINUS Term
    | Term
    ;

Term
    : Term MUL Factor
    | Term DIV Factor
    | Term MOD Factor
    | Factor
    ;

Factor
    : ID
    | INT_NUM
    | FLOAT_NUM
    | LPAREN Expression RPAREN
    ;

Condition
    : Expression RelationalOperator Expression
    | Condition AND Condition
    | Condition OR Condition
    | NOT Condition
    | LPAREN Condition RPAREN
    ;

RelationalOperator
    : LT
    | GT
    | LE
    | GE
    | EQ
    | NE
    ;

Block
    : LBRACE StatementList RBRACE
    ;

IfStatement
    : IF LPAREN Condition RPAREN Block
    ;

IfElseStatement
    : IF LPAREN Condition RPAREN Block ELSE Block
    ;

WhileStatement
    : WHILE LPAREN Condition RPAREN Block
    ;

AssignmentFor
    : ID ASSIGN Expression
    | ID INC
    | ID DEC
    ;

ForStatement
    : FOR LPAREN
      AssignmentFor
      SEMICOLON
      Condition
      SEMICOLON
      AssignmentFor
      RPAREN
      Block
    ;

PrintStatement
    : PRINTF LPAREN ID RPAREN SEMICOLON
    ;

%%

void yyerror(const char *s)
{
    printf("Syntax Error: %s\n", s);
}

int main()
{
    FILE *fp;

    fp = fopen("sample_programs/sample1.mc", "r");

    if (fp == NULL)
    {
        printf("Cannot open input file.\n");
        return 1;
    }

    yyin = fp;

    printf("\n===== Mini Compiler Front-End =====\n\n");

    if (yyparse() == 0)
    {
        printf("Parsing Successful.\n");
    }
    else
    {
        printf("Parsing Failed.\n");
    }

    fclose(fp);
    return 0;
}
=======
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../symbol_table/symbol_table.h"
int yylex(void);
void yyerror(const char *s);

extern FILE *yyin;
%}

%union
{
    char *str;
}
%token <str> ID

/*-----------------------
    Token Declaration
------------------------*/

%token INT FLOAT CHAR BOOL

%token IF ELSE WHILE FOR RETURN PRINTF


%type <str> DataType
%token INT_NUM
%token FLOAT_NUM

%token PLUS MINUS MUL DIV MOD

%token ASSIGN

%token LT GT LE GE EQ NE

%token AND OR NOT

%token SEMICOLON COMMA

%token INC
%token DEC
%token LPAREN RPAREN
%token LBRACE RBRACE
%token LBRACKET RBRACKET

/*-----------------------
    Operator Precedence
------------------------*/

%left OR
%left AND
%right NOT

%left EQ NE
%left LT GT LE GE

%left PLUS MINUS
%left MUL DIV MOD

/*-----------------------
    Start Symbol
------------------------*/

%start Program

%%

Program
    : StatementList
    ;

StatementList
    : Statement StatementList
    |
    ;

Statement
    : Declaration
    | Assignment
    | IfStatement
    | IfElseStatement
    | WhileStatement
    | ForStatement
    | PrintStatement
    ;

Declaration
    : DataType ID SEMICOLON
        {
            if(insertSymbol($2, $1))
                printf("Inserted: %s (%s)\n", $2, $1);
            else
                printf("Error: Variable '%s' already declared.\n", $2);
        }
    | DataType ID ASSIGN Expression SEMICOLON
        {
            if(insertSymbol($2, $1))
                printf("Inserted: %s (%s)\n", $2, $1);
            else
                printf("Error: Variable '%s' already declared.\n", $2);
        }
    ;

DataType
    : INT
        {
            $$ = strdup("int");
        }
    | FLOAT
        {
            $$ = strdup("float");
        }
    | CHAR
        {
            $$ = strdup("char");
        }
    | BOOL
        {
            $$ = strdup("bool");
        }
    ;

Assignment
    : ID ASSIGN Expression SEMICOLON
    ;

Expression
    : Expression PLUS Term
    | Expression MINUS Term
    | Term
    ;

Term
    : Term MUL Factor
    | Term DIV Factor
    | Term MOD Factor
    | Factor
    ;

Factor
    : ID
    | INT_NUM
    | FLOAT_NUM
    | LPAREN Expression RPAREN
    ;

Condition
    : Expression RelationalOperator Expression
    | Condition AND Condition
    | Condition OR Condition
    | NOT Condition
    | LPAREN Condition RPAREN
    ;

RelationalOperator
    : LT
    | GT
    | LE
    | GE
    | EQ
    | NE
    ;

Block
    : LBRACE StatementList RBRACE
    ;

IfStatement
    : IF LPAREN Condition RPAREN Block
    ;

IfElseStatement
    : IF LPAREN Condition RPAREN Block ELSE Block
    ;

WhileStatement
    : WHILE LPAREN Condition RPAREN Block
    ;

AssignmentFor
    : ID ASSIGN Expression
    | ID INC
    | ID DEC
    ;

ForStatement
    : FOR LPAREN
      AssignmentFor
      SEMICOLON
      Condition
      SEMICOLON
      AssignmentFor
      RPAREN
      Block
    ;

PrintStatement
    : PRINTF LPAREN ID RPAREN SEMICOLON
    ;

%%

void yyerror(const char *s)
{
    printf("Syntax Error: %s\n", s);
}

int main()
{
    FILE *fp;

    fp = fopen("sample_programs/sample1.mc", "r");

    if (fp == NULL)
    {
        printf("Cannot open input file.\n");
        return 1;
    }

    yyin = fp;

    initializeSymbolTable();

    printf("\n===== Mini Compiler Front-End =====\n\n");

    if (yyparse() == 0)
    {
        printf("Parsing Successful.\n");
        displaySymbolTable();
    }
    else
    {
        printf("Parsing Failed.\n");
    }

    fclose(fp);

    return 0;
}
