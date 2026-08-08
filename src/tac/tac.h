#ifndef TAC_H
#define TAC_H
#include "../parser/condition.h" 

#define MAX_LABEL_STACK 100
#define MAX_TAC 500

extern char labelStack[MAX_LABEL_STACK][20];
extern int labelTop;

extern int instructionCount;
extern char intermediateCode[500][100];

void pushLabel(const char *label);
void popLabel(char *label);
void peekLabel(char *label);

void initializeTAC();

void optimizeCode();

void generateTemporary(char *temp);
void generateLabel(char *label);

void emit(char *instruction);

void emitGoto(const char *label);

void emitIfFalse(const char *left,
                 const char *op,
                 const char *right,
                 const char *label);

void emitCondition(ConditionNode *condition,
                   const char *falseLabel);

void emitLabel(const char *label);

void displayTAC();

#endif