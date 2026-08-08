
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
STRING      \"([^\"\n]|\\.)*\"

%%

"#include"      { printf("INCLUDE\t\t#include\n"); return INCLUDE; }
"iostream"      { printf("HEADER\t\tiostream\n"); return HEADER; }
"System.out.println" {printf("PRINTLN\tSystem.out.println\n");return PRINTLN;}
"stdio.h"       { printf("HEADER\t\tstdio.h\n"); return HEADER; }
"using"         { printf("KEYWORD\t\tusing\n"); return USING; }
"namespace"     { printf("KEYWORD\t\tnamespace\n"); return NAMESPACE; }
"std"           { printf("KEYWORD\t\tstd\n"); return STD; }
"public"        {printf("KEYWORD\tpublic\n");return PUBLIC;}
"static"        {printf("KEYWORD\tstatic\n");return STATIC;}
"void"          {printf("KEYWORD\tvoid\n");return VOID;}
"String"        {printf("TYPE\tString\n");return STRING_TYPE;}
"main"          { printf("MAIN\t\tmain\n"); return MAIN; }


"int"           { printf("KEYWORD\t\tint\n"); return INT; }
"float"         { printf("KEYWORD\t\tfloat\n"); return FLOAT; }
"char"          { printf("KEYWORD\t\tchar\n"); return CHAR; }
"bool"          { printf("KEYWORD\t\tbool\n"); return BOOL; }

"if"            { printf("KEYWORD\t\tif\n"); return IF; }
"else"          { printf("KEYWORD\t\telse\n"); return ELSE; }
"while"         { printf("KEYWORD\t\twhile\n"); return WHILE; }
"for"           { printf("KEYWORD\t\tfor\n"); return FOR; }

"return"        { printf("KEYWORD\t\treturn\n"); return RETURN; }
"print"         { printf("KEYWORD\t\tprint\n"); return PRINT; }
"printf"        { printf("KEYWORD\t\tprintf\n"); return PRINTF; }
"cout"          { printf("KEYWORD\t\tcout\n"); return COUT; }
"<<"            { printf("INSERTION\t<<\n"); return INSERTION; }
"endl"          { printf("ENDL\t\tendl\n"); return ENDL; }

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

"+="            { printf("PLUS_ASSIGN\t\t+=\n"); return PLUS_ASSIGN; }
"-="            { printf("MINUS_ASSIGN\t\t-=\n"); return MINUS_ASSIGN; }
"*="            { printf("MUL_ASSIGN\t\t*=\n"); return MUL_ASSIGN; }
"/="            { printf("DIV_ASSIGN\t\t/=\n"); return DIV_ASSIGN; }

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

{FLOAT_NUM}     {printf("FLOAT\t\t%s\n", yytext);yylval.str = _strdup(yytext);return FLOAT_NUM;}

{INT_NUM}       {printf("INTEGER\t\t%s\n", yytext);yylval.str = _strdup(yytext);return INT_NUM;}
{STRING}        {printf("STRING\t\t%s\n", yytext);yylval.str = _strdup(yytext);return STRING;}

{ID}            {printf("IDENTIFIER\t%s\n", yytext);yylval.str = strdup(yytext);return ID;}


"//".*          ;

[ \t\r]+        ;

\n              { line++; }

.               {
                    printf("LEXICAL ERROR (Line %d): %s\n", line, yytext);
                }

%%



