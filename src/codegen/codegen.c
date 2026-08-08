#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "../tac/tac.h"
#include "codegen.h"

void initializeCodeGeneration()
{
    /* Future initialization */
}

static int isNumber(const char *str)
{
    if(str == NULL || str[0] == '\0')
        return 0;

    int i = 0;

    if(str[0] == '-')
        i++;

    for(; str[i] != '\0'; i++)
    {
        if(str[i] < '0' || str[i] > '9')
            return 0;
    }

    return 1;
}

static void generateAssignment(char *line)
{
    char left[30];
    char right[30];

    if(sscanf(line, "%s = %s", left, right) == 2)
    {
        printf("MOV %s, %s\n", left, right);
    }
}

static void generateArithmetic(char *line)
{
    char left[30];
    char op1[30];
    char op2[30];
    char op;

    if(sscanf(line,
              "%s = %s %c %s",
              left,
              op1,
              &op,
              op2) == 4)
    {
        printf("MOV R0, %s\n", op1);

        switch(op)
        {
            case '+':
                printf("ADD R0, %s\n", op2);
                break;

            case '-':
                printf("SUB R0, %s\n", op2);
                break;

            case '*':
                printf("MUL R0, %s\n", op2);
                break;

            case '/':
                printf("DIV R0, %s\n", op2);
                break;

            case '%':
                printf("MOD R0, %s\n", op2);
                break;

            default:
                return;
        }

        printf("MOV %s, R0\n", left);
    }
}

static void generatePrint(char *line)
{
    char value[50];

    if(sscanf(line, "print %s", value) == 1)
    {
        printf("PRINT %s\n", value);
    }
}

static void generateTargetLabel(char *line)
{
    printf("%s\n", line);
}

static void generateGoto(char *line)
{
    char label[30];

    if(sscanf(line, "goto %s", label) == 1)
    {
        printf("JMP %s\n", label);
    }
}

static void generateIfFalse(char *line)
{
    char left[30];
    char op[10];
    char right[30];
    char label[30];

    if(sscanf(line,
              "ifFalse %s %s %s goto %s",
              left,
              op,
              right,
              label) == 4)
    {
        printf("CMP %s, %s\n", left, right);

        if(strcmp(op, "<") == 0)
        {
            printf("JGE %s\n", label);
        }
        else if(strcmp(op, ">") == 0)
        {
            printf("JLE %s\n", label);
        }
        else if(strcmp(op, "<=") == 0)
        {
            printf("JG %s\n", label);
        }
        else if(strcmp(op, ">=") == 0)
        {
            printf("JL %s\n", label);
        }
        else if(strcmp(op, "==") == 0)
        {
            printf("JNE %s\n", label);
        }
        else if(strcmp(op, "!=") == 0)
        {
            printf("JE %s\n", label);
        }
    }
}

void generateTargetCode()
{
    printf("\n");
    printf("=====================================\n");
    printf("          TARGET CODE\n");
    printf("=====================================\n");

    for(int i = 0; i < instructionCount; i++)
    {
        char *line = intermediateCode[i];

        /* Label */
        if(line[0] == 'L')
        {
            generateTargetLabel(line);
        }

        /* ifFalse */
        else if(strncmp(line, "ifFalse", 7) == 0)
        {
            generateIfFalse(line);
        }

        /* goto */
        else if(strncmp(line, "goto", 4) == 0)
        {
            generateGoto(line);
        }

        /* print */
        else if(strncmp(line, "print", 5) == 0)
        {
            generatePrint(line);
        }

        /* Assignment / Arithmetic */
        else if(strchr(line, '=') != NULL)
        {
            char op;

            char tempLeft[30];
            char tempOp1[30];
            char tempOp2[30];

            if(sscanf(line,
                      "%s = %s %c %s",
                      tempLeft,
                      tempOp1,
                      &op,
                      tempOp2) == 4)
            {
                generateArithmetic(line);
            }
            else
            {
                generateAssignment(line);
            }
        }
    }

    printf("=====================================\n");
}