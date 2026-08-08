#include <stdio.h>
#include <string.h>
#include "tac.h"

char tacList[MAX_TAC][100];
int tacCount = 0;

char intermediateCode[500][100];
char labelStack[MAX_LABEL_STACK][20];
int labelTop = -1;

int instructionCount = 0;
int tempCount = 0;
int labelCount = 0;

void peekLabel(char *label)
{
    if (labelTop >= 0)
    {
        strcpy(label, labelStack[labelTop]);
    }
}

void emitGoto(const char *label)
{
    char instruction[100];

    sprintf(instruction, "goto %s", label);

    emit(instruction);
}

void initializeTAC()
{
    instructionCount = 0;
    tempCount = 0;
    labelCount = 0;
    labelTop = -1;
}

void generateTemporary(char *temp)
{
    sprintf(temp, "t%d", ++tempCount);
}

void generateLabel(char *label)
{
    sprintf(label, "L%d", ++labelCount);
}

void pushLabel(const char *label)
{
    labelTop++;

    strcpy(labelStack[labelTop], label);
}

void popLabel(char *label)
{
    if(labelTop >= 0)
    {
        strcpy(label, labelStack[labelTop]);

        labelTop--;
    }
}

void emit(char *instruction)
{
    strcpy(intermediateCode[instructionCount], instruction);
    instructionCount++;
}

void emitIfFalse(const char *left,
                 const char *op,
                 const char *right,
                 const char *label)
{
    char instruction[100];

    sprintf(instruction,
            "ifFalse %s %s %s goto %s",
            left,
            op,
            right,
            label);

    emit(instruction);
}
void emitCondition(ConditionNode *node,
                   const char *falseLabel)
{
    if(node == NULL)
        return;

   
    if(node->isLogical == 0)
    {
        emitIfFalse(
            node->left,
            node->op,
            node->right,
            falseLabel
        );
        return;
    }

    if(strcmp(node->logic, "&&") == 0)
    {
        emitCondition(node->first, falseLabel);
        emitCondition(node->second, falseLabel);
        return;
    }

    
    if(strcmp(node->logic, "||") == 0)
    {
        
        emitCondition(node->first, falseLabel);
        emitCondition(node->second, falseLabel);
        return;
    }

   
    if(node->isNot)
    {
        emitCondition(node->first, falseLabel);
        return;
    }
}

void emitLabel(const char *label)
{
    char instruction[100];

    sprintf(instruction, "%s:", label);

    emit(instruction);
}


void displayTAC()
{
    int i;

    printf("\n");
    printf("=====================================\n");
    printf("     INTERMEDIATE CODE GENERATION \n");
    printf("=====================================\n");

    if (instructionCount == 0)
    {
        printf("No Intermediate Code Generated.\n");
    }
    else
    {
        for (i = 0; i < instructionCount; i++)
        {
            printf("%s\n", intermediateCode[i]);
        }
    }

    printf("=====================================\n");
}