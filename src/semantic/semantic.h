#ifndef SEMANTIC_H
#define SEMANTIC_H

#include "../symbol_table/symbol_table.h"

extern int semanticErrorCount;

int checkUndeclaredVariable(const char *name);

int checkDuplicateDeclaration(const char *name);

int checkAssignmentCompatibility(const char *variableName,
                                 const char *expressionType);

int checkTypeCompatibility(const char *leftType,
                           const char *rightType);

void semanticError(const char *message);

#endif