#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#define MAX_SYMBOLS 100

typedef struct
{
    char name[50];
    char type[20];
} Symbol;

extern Symbol symbolTable[MAX_SYMBOLS];
extern int symbolCount;

void initializeSymbolTable();
int searchSymbol(const char *name);
int insertSymbol(const char *name, const char *type);
void displaySymbolTable();

#endif