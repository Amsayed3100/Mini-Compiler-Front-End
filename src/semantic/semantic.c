#include <stdio.h>
#include <string.h>

#include "semantic.h"
#include "../symbol_table/symbol_table.h"
int semanticErrorCount = 0;
/*-----------------------------------------
    Undeclared Variable Check
-----------------------------------------*/

int checkUndeclaredVariable(const char *name)
{
    if (searchSymbol(name) == -1)
{
    char message[100];

    sprintf(message,
            "Variable '%s' is not declared.",
            name);

    semanticError(message);

    return 0;
}
}

/*-----------------------------------------
    Duplicate Declaration Check
-----------------------------------------*/

int checkDuplicateDeclaration(const char *name)
{
    return 1;
}

/*-----------------------------------------
    Assignment Compatibility
-----------------------------------------*/
int checkAssignmentCompatibility(const char *variableName, const char *expressionType)
{
    char *variableType = getSymbolType(variableName);

    if(variableType == NULL)
        return 0;

   if(strcmp(variableType, expressionType) != 0)
{
    char message[150];

    sprintf(message,
            "Cannot assign %s to %s variable '%s'.",
            expressionType,
            variableType,
            variableName);

    semanticError(message);

    return 0;
}

    return 1;
}
/*-----------------------------------------
    Type Compatibility
-----------------------------------------*/

int checkTypeCompatibility(const char *leftType, const char *rightType)
{
    return 1;
}

/*-----------------------------------------
    Semantic Error
-----------------------------------------*/

void semanticError(const char *message)
{
    semanticErrorCount++;
    printf("Semantic Error: %s\n", message);
}