%{
#include <stdio.h>
#include <stdlib.h>

#include "../parser/parser.tab.h"

int line = 1;

extern FILE *yyin;
%}

%option noyywrap

LETTER      [A-Za-z_]
DIGIT       [0-9]

ID          {LETTER}({LETTER}|{DIGIT})*
INT_NUM     {DIGIT}+
FLOAT_NUM   {DIGIT}+"."{DIGIT}+

%%

"int"           { printf("KEYWORD\t\tint\n"); return INT; }
"float"         { printf("KEYWORD\t\tfloat\n"); return FLOAT; }
"char"          { printf("KEYWORD\t\tchar\n"); return CHAR; }
"bool"          { printf("KEYWORD\t\tbool\n"); return BOOL; }

"if"            { printf("KEYWORD\t\tif\n"); return IF; }
"else"          { printf("KEYWORD\t\telse\n"); return ELSE; }
"while"         { printf("KEYWORD\t\twhile\n"); return WHILE; }
"for"           { printf("KEYWORD\t\tfor\n"); return FOR; }

"return"        { printf("KEYWORD\t\treturn\n"); return RETURN; }
"printf"        { printf("KEYWORD\t\tprintf\n"); return PRINTF; }

"++"            { printf("INC\t\t++\n"); return INC; }
"--"            { printf("DEC\t\t--\n"); return DEC; }

"=="            { printf("EQ\t\t==\n"); return EQ; }
"!="            { printf("NE\t\t!=\n"); return NE; }
"<="            { printf("LE\t\t<=\n"); return LE; }
">="            { printf("GE\t\t>=\n"); return GE; }

"&&"            { printf("AND\t\t&&\n"); return AND; }
"||"            { printf("OR\t\t||\n"); return OR; }
"!"             { printf("NOT\t\t!\n"); return NOT; }

"<"             { printf("LT\t\t<\n"); return LT; }
">"             { printf("GT\t\t>\n"); return GT; }

"+"             { printf("PLUS\t\t+\n"); return PLUS; }
"-"             { printf("MINUS\t\t-\n"); return MINUS; }
"*"             { printf("MUL\t\t*\n"); return MUL; }
"/"             { printf("DIV\t\t/\n"); return DIV; }
"%"             { printf("MOD\t\t%%\n"); return MOD; }

"="             { printf("ASSIGN\t\t=\n"); return ASSIGN; }

";"             { printf("SEMICOLON\t;\n"); return SEMICOLON; }
","             { printf("COMMA\t\t,\n"); return COMMA; }

"("             { printf("LPAREN\t\t(\n"); return LPAREN; }
")"             { printf("RPAREN\t\t)\n"); return RPAREN; }

"{"             { printf("LBRACE\t\t{\n"); return LBRACE; }
"}"             { printf("RBRACE\t\t}\n"); return RBRACE; }

"["             { printf("LBRACKET\t[\n"); return LBRACKET; }
"]"             { printf("RBRACKET\t]\n"); return RBRACKET; }

{FLOAT_NUM}     { printf("FLOAT\t\t%s\n", yytext); return FLOAT_NUM; }
{INT_NUM}       { printf("INTEGER\t\t%s\n", yytext); return INT_NUM; }

{ID}            { printf("IDENTIFIER\t%s\n", yytext); return ID; }

"//".*          ;

[ \t\r]+        ;

\n              { line++; }

.               {
                    printf("LEXICAL ERROR (Line %d): %s\n", line, yytext);
                }

%%
