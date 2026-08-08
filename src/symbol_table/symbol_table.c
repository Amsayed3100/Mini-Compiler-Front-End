#include <stdio.h>
#include <string.h>

#include "symbol_table.h"



Symbol symbolTable[MAX_SYMBOLS];
int symbolCount = 0;



void initializeSymbolTable()
{
    symbolCount = 0;
}


int searchSymbol(const char *name)
{
    int i;

    for(i = 0; i < symbolCount; i++)
    {
        if(strcmp(symbolTable[i].name, name) == 0)
        {
            return i;
        }
    }

    return -1;
}


int insertSymbol(const char *name, const char *type)
{
    

    if (searchSymbol(name) != -1)
    {
        printf("Semantic Error: Variable '%s' already declared.\n", name);
        return 0;
    }

   

    if (symbolCount >= MAX_SYMBOLS)
    {
        printf("Error: Symbol Table Overflow.\n");
        return 0;
    }



    strcpy(symbolTable[symbolCount].name, name);
    strcpy(symbolTable[symbolCount].type, type);

    symbolCount++;

    return 1;
}


char *getSymbolType(const char *name)
{
    int i;

    for(i = 0; i < symbolCount; i++)
    {
        if(strcmp(symbolTable[i].name, name) == 0)
        {
            return symbolTable[i].type;
        }
    }

    return NULL;
}



void displaySymbolTable()
{
    int i;

    printf("\n");
    printf("=====================================\n");
    printf("           SYMBOL TABLE\n");
    printf("=====================================\n");

    printf("%-20s %-15s\n", "Identifier", "Data Type");
    printf("-------------------------------------\n");

    for (i = 0; i < symbolCount; i++)
    {
        printf("%-20s %-15s\n",
               symbolTable[i].name,
               symbolTable[i].type);
    }

    printf("=====================================\n");
}