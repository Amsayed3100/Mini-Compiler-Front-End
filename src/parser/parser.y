%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../semantic/semantic.h"
#include "../symbol_table/symbol_table.h"
#include "../tac/tac.h"
#include "condition.h"
#include "../optimization/optimization.h"
#include "../codegen/codegen.h"

int yylex(void);
void yyerror(const char *s);

extern FILE *yyin;
char *currentDataType;
char forInitInstruction[100];
char forIncrementInstruction[100];
 
%}

/*----------------------------------
        TOKEN DECLARATION
-----------------------------------*/

%code requires {
    #include "condition.h"
}

%union
{
    char *str;

    ConditionNode *condition;
}

/*----------------------------------
          DATA TYPES
-----------------------------------*/

%token INT FLOAT CHAR BOOL

/*----------------------------------
        CONTROL STATEMENTS
-----------------------------------*/

%token IF ELSE
%token WHILE FOR
%token RETURN
%token INCLUDE HEADER MAIN
%token USING NAMESPACE STD
%token PUBLIC
%token STATIC
%token VOID
%token STRING_TYPE
%token LESS GREATER

/*----------------------------------*
*INPUT / OUTPUT*
*-----------------------------------*/

%token PRINT
%token PRINTF
%token COUT
%token PRINTLN
%token INSERTION
%token ENDL

/*----------------------------------
      TOKENS WITH YYSTYPE
-----------------------------------*/

%token <str> ID
%token <str> INT_NUM
%token <str> FLOAT_NUM
%token <str> STRING

/*----------------------------------
      OPERATORS
-----------------------------------*/

%token ASSIGN

%token PLUS_ASSIGN
%token MINUS_ASSIGN
%token MUL_ASSIGN
%token DIV_ASSIGN
%token PLUS MINUS MUL DIV MOD

%token LT GT LE GE EQ NE

%token AND OR NOT

%token INC DEC

/*----------------------------------
      PUNCTUATIONS
-----------------------------------*/

%token LPAREN RPAREN
%token LBRACE RBRACE
%token LBRACKET RBRACKET

%token SEMICOLON
%token COMMA

/*----------------------------------
        NON TERMINALS
-----------------------------------*/
%type <str> DataType Expression Term Factor RelationalOperator IdentifierList
%type <str> ForInit AssignmentFor

%type <condition> Condition

/*----------------------------------
      OPERATOR PRECEDENCE
-----------------------------------*/

%left OR
%left AND

%right NOT

%left EQ NE
%left LT GT LE GE

%left PLUS MINUS
%left MUL DIV MOD

/* Solve Dangling Else */

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

/*----------------------------------
        START SYMBOL
-----------------------------------*/

%start Program

%%

Program
:
Header MainFunction
| JavaMain
;


Header
:
INCLUDE LT HEADER GT
;

MainFunction
    : INT MAIN LPAREN RPAREN LBRACE StatementList RBRACE
    ;

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
| IncrementStatement
| SelectionStatement
| WhileStatement
| ForStatement
| PrintStatement
| ReturnStatement
;


PrintStatement
    : PRINT LPAREN Expression RPAREN SEMICOLON
    {
        char instruction[100];

        sprintf(instruction, "print %s", $3);

        emit(instruction);
    }

    | PRINT LPAREN STRING RPAREN SEMICOLON
    {
        char instruction[100];

        sprintf(instruction, "print %s", $3);

        emit(instruction);
    }

    | PRINTLN LPAREN Expression RPAREN SEMICOLON
    {
        char instruction[100];

        sprintf(instruction, "print %s", $3);

        emit(instruction);
    }

    | PRINTLN LPAREN STRING RPAREN SEMICOLON
    {
        char instruction[100];

        sprintf(instruction, "print %s", $3);

        emit(instruction);
    }

    | PRINTF LPAREN Expression RPAREN SEMICOLON
    {
        char instruction[100];

        sprintf(instruction, "print %s", $3);

        emit(instruction);
    }

    | PRINTF LPAREN STRING RPAREN SEMICOLON
    {
        char instruction[100];

        sprintf(instruction, "print %s", $3);

        emit(instruction);
    }

    | PRINTF LPAREN STRING COMMA Expression RPAREN SEMICOLON
    {
        char instruction[100];

        sprintf(instruction, "print %s", $5);

        emit(instruction);
    }

    | COUT INSERTION Expression SEMICOLON
    {
        char instruction[100];

        sprintf(instruction, "print %s", $3);

        emit(instruction);
    }

    | COUT INSERTION STRING SEMICOLON
    {
        char instruction[100];

        sprintf(instruction, "print %s", $3);

        emit(instruction);
    }

    | COUT INSERTION Expression INSERTION ENDL SEMICOLON
    {
        char instruction[100];

        sprintf(instruction, "print %s", $3);

        emit(instruction);
    }

    | COUT INSERTION STRING INSERTION ENDL SEMICOLON
    {
        char instruction[100];

        sprintf(instruction, "print %s", $3);

        emit(instruction);
    }
    ;

Declaration
    : DataType IdentifierList SEMICOLON
    ;

IdentifierList
    : ID
    {
        insertSymbol($1, currentDataType);
    }

    | ID ASSIGN Expression
    {
        insertSymbol($1, currentDataType);

        char instruction[100];
        sprintf(instruction, "%s = %s", $1, $3);
        emit(instruction);
    }

    | IdentifierList COMMA ID
    {
        insertSymbol($3, currentDataType);
    }

    | IdentifierList COMMA ID ASSIGN Expression
    {
        insertSymbol($3, currentDataType);

        char instruction[100];
        sprintf(instruction, "%s = %s", $3, $5);
        emit(instruction);
    }
;

DataType
: INT
{
    $$ = "int";
    currentDataType = "int";
}
| FLOAT
{
    $$ = "float";
    currentDataType = "float";
}
| CHAR
{
    $$ = "char";
    currentDataType = "char";
}
| BOOL
{
    $$ = "bool";
    currentDataType = "bool";
}
;

Assignment
: ID ASSIGN Expression SEMICOLON
{
    checkUndeclaredVariable($1);

    char instruction[100];

    sprintf(instruction, "%s = %s", $1, $3);

    emit(instruction);
}

| ID PLUS_ASSIGN Expression SEMICOLON
{
checkUndeclaredVariable($1);

char instruction[100];

sprintf(instruction,
"%s = %s + %s",
$1,
$1,
$3);

emit(instruction);
}


| ID MINUS_ASSIGN Expression SEMICOLON
{
checkUndeclaredVariable($1);

char instruction[100];

sprintf(instruction,
"%s = %s - %s",
$1,
$1,
$3);

emit(instruction);
}


| ID MUL_ASSIGN Expression SEMICOLON
{
checkUndeclaredVariable($1);

char instruction[100];

sprintf(instruction,
"%s = %s * %s",
$1,
$1,
$3);

emit(instruction);
}


| ID DIV_ASSIGN Expression SEMICOLON
{
checkUndeclaredVariable($1);

char instruction[100];

sprintf(instruction,
"%s = %s / %s",
$1,
$1,
$3);

emit(instruction);
}
;

ForInit
:
ID ASSIGN Expression
{
sprintf(forInitInstruction,
"%s = %s",
$1,
$3);

$$ = strdup($1);
}
;

IncrementStatement
:
ID INC SEMICOLON
{
char instruction[100];

sprintf(instruction,
"%s = %s + 1",
$1,
$1);

emit(instruction);
}


| ID DEC SEMICOLON
{
char instruction[100];

sprintf(instruction,
"%s = %s - 1",
$1,
$1);

emit(instruction);
}

;

AssignmentFor
:
ID ASSIGN Expression
{
sprintf(forIncrementInstruction,
"%s = %s",
$1,
$3);
}


| ID INC
{
sprintf(forIncrementInstruction,
"%s = %s + 1",
$1,
$1);
}

| ID DEC
{
sprintf(forIncrementInstruction,
"%s = %s - 1",
$1,
$1);
}
;


Factor
    : ID
    {
        checkUndeclaredVariable($1);
        $$ = strdup($1);
    }

    | INT_NUM
    {
    $$ = strdup($1);
    }

    | FLOAT_NUM
    {
    $$ = strdup($1);
    }
    | LPAREN Expression RPAREN
    {
        $$ = $2;
    }
    ;
Expression
:
Expression PLUS Term
{
    char temp[20];
    char instruction[100];

    generateTemporary(temp);

    sprintf(instruction,"%s = %s + %s",
            temp,
            $1,
            $3);

    emit(instruction);

    $$ = strdup(temp);
}

| Expression MINUS Term
{
    char temp[20];
    char instruction[100];

    generateTemporary(temp);

    sprintf(instruction,"%s = %s - %s",
            temp,
            $1,
            $3);

    emit(instruction);

    $$ = strdup(temp);
}

| Term
{
    $$=$1;
}
;

Term
    : Term MUL Factor
    {
        char temp[20];
        char instruction[100];

        generateTemporary(temp);

        sprintf(instruction,
                "%s = %s * %s",
                temp,
                $1,
                $3);

        emit(instruction);

        $$ = strdup(temp);
    }

    | Term DIV Factor
    {
        char temp[20];
        char instruction[100];

        generateTemporary(temp);

        sprintf(instruction,
                "%s = %s / %s",
                temp,
                $1,
                $3);

        emit(instruction);

        $$ = strdup(temp);
    }

    | Term MOD Factor
    {
        char temp[20];
        char instruction[100];

        generateTemporary(temp);

        sprintf(instruction,
                "%s = %s %% %s",
                temp,
                $1,
                $3);

        emit(instruction);

        $$ = strdup(temp);
    }

    | Factor
    {
        $$ = $1;
    }
;

Condition
    : Expression RelationalOperator Expression
    {
        $$ = createSimpleCondition($1, $2, $3);
    }

    | Condition AND Condition
    {
        $$ = createAndCondition($1, $3);
    }

    | Condition OR Condition
    {
        $$ = createOrCondition($1, $3);
    }

    | NOT Condition
    {
        $$ = createNotCondition($2);
    }

    | LPAREN Condition RPAREN
    {
        $$ = $2;
    }
    ;

RelationalOperator
    : LT { $$ = "<"; }
    | GT { $$ = ">"; }
    | LE { $$ = "<="; }
    | GE { $$ = ">="; }
    | EQ { $$ = "=="; }
    | NE { $$ = "!="; }
    ;

Block
    : LBRACE StatementList RBRACE
    ;

IfAction
    :
    {
        char label[20];

        generateLabel(label);

        emitCondition($<condition>-1, label);

        pushLabel(label);
    }
    ;


SelectionStatement
    : IF LPAREN Condition RPAREN
      IfAction
      Block
      {
          char falseLabel[20];

          popLabel(falseLabel);

          emitLabel(falseLabel);
      }
      %prec LOWER_THAN_ELSE

    | IF LPAREN Condition RPAREN
      IfAction
      Block
      ELSE
      {
          char falseLabel[20];
          char endLabel[20];

          popLabel(falseLabel);

          generateLabel(endLabel);

          emitGoto(endLabel);

          emitLabel(falseLabel);

          pushLabel(endLabel);
      }
      Block
      {
          char endLabel[20];

          popLabel(endLabel);

          emitLabel(endLabel);
      }
    ;
  
WhileStatement
:
WHILE
{
    char startLabel[20];

    generateLabel(startLabel);

    emitLabel(startLabel);

    pushLabel(startLabel);
}

LPAREN Condition RPAREN
{
    char falseLabel[20];

    generateLabel(falseLabel);


    emitCondition($4, falseLabel);


    pushLabel(falseLabel);
}

Block
{
    char falseLabel[20];
    char startLabel[20];


    popLabel(falseLabel);

    popLabel(startLabel);


    emitGoto(startLabel);

    emitLabel(falseLabel);
}
;

ForStatement
:
FOR LPAREN
ForInit
{
    emit(forInitInstruction);
}
SEMICOLON

Condition

SEMICOLON

AssignmentFor

RPAREN

{
    char startLabel[20];
    char falseLabel[20];

    generateLabel(startLabel);
    generateLabel(falseLabel);

    emitLabel(startLabel);

    emitCondition($6,falseLabel);
    pushLabel(startLabel);
    pushLabel(falseLabel);
}

Block

{
    char startLabel[20];
    char falseLabel[20];


    popLabel(falseLabel);
    popLabel(startLabel);


    emit(forIncrementInstruction);

    emitGoto(startLabel);

    emitLabel(falseLabel);
}

;

ReturnStatement
:
    RETURN INT_NUM SEMICOLON
;

JavaMain
    : PUBLIC STATIC VOID MAIN LPAREN STRING_TYPE ID LBRACKET RBRACKET RPAREN
      LBRACE StatementList RBRACE
    ;

%%

void yyerror(const char *s)
{
    printf("Syntax Error: %s\n", s);
}

int main()
{
    initializeSymbolTable();
    initializeTAC();

    printf("\n===== Mini Compiler Front-End =====\n\n");

    yyin = stdin;

    if (yyparse() == 0)
    {
        if (semanticErrorCount == 0)
        {
            printf("\nParsing Successful.\n");
        }
        else
        {
            printf("\nParsing Completed with %d Semantic Error(s).\n",semanticErrorCount);
        }

        displaySymbolTable();
        displayTAC();
        optimizeCode();

        generateTargetCode();
    }
    else
    {
        printf("\nParsing Failed.\n");
    }

    return 0;
}

