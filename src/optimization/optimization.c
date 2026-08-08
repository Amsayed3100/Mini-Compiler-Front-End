#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

#include "../tac/tac.h"
#include "optimization.h"

#define MAX_VAR 200

typedef struct
{
    char name[30];
    char value[30];
} Constant;

Constant table[MAX_VAR];
int tableCount = 0;


/*=============================
    Check Number
=============================*/

int isNumber(char *str)
{
    if(str == NULL || str[0] == '\0')
        return 0;

    int i = 0;

    if(str[0] == '-')
        i++;

    for(; str[i]; i++)
    {
        if(!isdigit((unsigned char)str[i]))
            return 0;
    }

    return 1;
}


/*=============================
    Clear Constant Table
=============================*/

void clearConstants()
{
    tableCount = 0;
}


/*=============================
    Add Constant
=============================*/

void addConstant(char *name, char *value)
{
    for(int i = 0; i < tableCount; i++)
    {
        if(strcmp(table[i].name, name) == 0)
        {
            strcpy(table[i].value, value);
            return;
        }
    }

    strcpy(table[tableCount].name, name);
    strcpy(table[tableCount].value, value);

    tableCount++;
}


/*=============================
    Get Constant
=============================*/

char *getConstant(char *name)
{
    for(int i = 0; i < tableCount; i++)
    {
        if(strcmp(table[i].name, name) == 0)
            return table[i].value;
    }

    return NULL;
}

/*=============================
 Replace Variable by Constant
=============================*/

void replaceVariable(char *line)
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
        char *v1 = getConstant(op1);
        char *v2 = getConstant(op2);

        if(v1)
            strcpy(op1, v1);

        if(v2)
            strcpy(op2, v2);

        sprintf(line,
                "%s = %s %c %s",
                left,
                op1,
                op,
                op2);

        return;
    }

    char right[30];

    if(sscanf(line,
              "%s = %s",
              left,
              right) == 2)
    {
        char *v = getConstant(right);

        if(v)
        {
            sprintf(line,
                    "%s = %s",
                    left,
                    v);
        }
    }
}

/*==================================================
    CONSTANT FOLDING
==================================================*/

void constantFolding()
{
    char left[30];
    char op1[30];
    char op2[30];
    char oper;

    for(int i = 0; i < instructionCount; i++)
    {
        if(sscanf(intermediateCode[i],
                  "%s = %s %c %s",
                  left,
                  op1,
                  &oper,
                  op2) == 4)
        {
            if(isNumber(op1) && isNumber(op2))
            {
                int a = atoi(op1);
                int b = atoi(op2);
                int result;

                switch(oper)
                {
                    case '+':
                        result = a + b;
                        break;

                    case '-':
                        result = a - b;
                        break;

                    case '*':
                        result = a * b;
                        break;

                    case '/':
                        if(b == 0)
                            continue;
                        result = a / b;
                        break;

                    case '%':
                        if(b == 0)
                            continue;
                        result = a % b;
                        break;

                    default:
                        continue;
                }

                sprintf(intermediateCode[i],
                        "%s = %d",
                        left,
                        result);

                addConstant(left, intermediateCode[i] + strlen(left) + 3);
            }
        }
    }
}

/*==================================================
    ALGEBRAIC SIMPLIFICATION
==================================================*/

void algebraicSimplification()
{
    char left[30];
    char op1[30];
    char op2[30];
    char oper;

    for(int i = 0; i < instructionCount; i++)
    {
        if(sscanf(intermediateCode[i],
                  "%s = %s %c %s",
                  left,
                  op1,
                  &oper,
                  op2) == 4)
        {
            /* x + 0 */
            if(oper == '+' && strcmp(op2,"0")==0)
            {
                sprintf(intermediateCode[i],
                        "%s = %s",
                        left,
                        op1);
            }

            /* 0 + x */
            else if(oper == '+' && strcmp(op1,"0")==0)
            {
                sprintf(intermediateCode[i],
                        "%s = %s",
                        left,
                        op2);
            }

            /* x - 0 */
            else if(oper == '-' && strcmp(op2,"0")==0)
            {
                sprintf(intermediateCode[i],
                        "%s = %s",
                        left,
                        op1);
            }

            /* x * 1 */
            else if(oper == '*' && strcmp(op2,"1")==0)
            {
                sprintf(intermediateCode[i],
                        "%s = %s",
                        left,
                        op1);
            }

            /* 1 * x */
            else if(oper == '*' && strcmp(op1,"1")==0)
            {
                sprintf(intermediateCode[i],
                        "%s = %s",
                        left,
                        op2);
            }

            /* x * 0 */
            else if(oper == '*' && strcmp(op2,"0")==0)
            {
                sprintf(intermediateCode[i],
                        "%s = 0",
                        left);
            }

            /* 0 * x */
            else if(oper == '*' && strcmp(op1,"0")==0)
            {
                sprintf(intermediateCode[i],
                        "%s = 0",
                        left);
            }

            /* x / 1 */
            else if(oper == '/' && strcmp(op2,"1")==0)
            {
                sprintf(intermediateCode[i],
                        "%s = %s",
                        left,
                        op1);
            }

            /* 0 / x */
            else if(oper == '/' && strcmp(op1,"0")==0)
            {
                sprintf(intermediateCode[i],
                        "%s = 0",
                        left);
            }
        }
    }
}


/*==================================================
    CONSTANT PROPAGATION
==================================================*/

void constantPropagation()
{
    clearConstants();

    for(int i = 0; i < instructionCount; i++)
    {
        replaceVariable(intermediateCode[i]);

        char left[30];
        char right[30];

        if(sscanf(intermediateCode[i],
                  "%s = %s",
                  left,
                  right) == 2)
        {
        
            if(strchr(intermediateCode[i], '+') == NULL &&
               strchr(intermediateCode[i], '-') == NULL &&
               strchr(intermediateCode[i], '*') == NULL &&
               strchr(intermediateCode[i], '/') == NULL &&
               strchr(intermediateCode[i], '%') == NULL)
            {
                if(isNumber(right))
                {
                    addConstant(left, right);
                }
            }
        }
    }
}


/*==================================================
    COPY PROPAGATION
==================================================*/

void copyPropagation()
{
    char from[100][30];
    char to[100][30];
    int total = 0;

    for(int i = 0; i < instructionCount; i++)
    {
        char left[30], right[30];

        if(sscanf(intermediateCode[i], "%s = %s", left, right) == 2)
        {
            if(!isNumber(right) &&
               strchr(intermediateCode[i], '+') == NULL &&
               strchr(intermediateCode[i], '-') == NULL &&
               strchr(intermediateCode[i], '*') == NULL &&
               strchr(intermediateCode[i], '/') == NULL &&
               strchr(intermediateCode[i], '%') == NULL)
            {
                strcpy(from[total], left);
                strcpy(to[total], right);
                total++;
            }
        }

        char l[30], a[30], b[30], op;

        if(sscanf(intermediateCode[i],
                  "%s = %s %c %s",
                  l,
                  a,
                  &op,
                  b) == 4)
        {
            for(int j = 0; j < total; j++)
            {
                if(strcmp(a, from[j]) == 0)
                    strcpy(a, to[j]);

                if(strcmp(b, from[j]) == 0)
                    strcpy(b, to[j]);
            }

            sprintf(intermediateCode[i],
                    "%s = %s %c %s",
                    l,
                    a,
                    op,
                    b);
        }
    }
}


/*==================================================
    REMOVE UNUSED TEMPORARY
==================================================*/

void removeUnusedTemporary()
{
    for(int i = 0; i < instructionCount; i++)
    {
        char left[30];

        if(sscanf(intermediateCode[i], "%s =", left) == 1)
        {
            if(left[0] != 't')
                continue;

            int used = 0;

            for(int j = i + 1; j < instructionCount; j++)
            {
                if(strstr(intermediateCode[j], left))
                {
                    used = 1;
                    break;
                }
            }

            if(!used)
            {
                for(int k = i; k < instructionCount - 1; k++)
                {
                    strcpy(intermediateCode[k],
                           intermediateCode[k + 1]);
                }

                instructionCount--;
                i--;
            }
        }
    }
}


/*==================================================
    DEAD CODE ELIMINATION
==================================================*/

void deadCodeElimination()
{
    for(int i = 0; i < instructionCount; i++)
    {
        char left[30];
        char right[30];

        if(sscanf(intermediateCode[i],
                  "%s = %s",
                  left,
                  right) != 2)
            continue;

        if(left[0] == 't')
            continue;

        int used = 0;

        for(int j = i + 1; j < instructionCount; j++)
        {
            if(strstr(intermediateCode[j], left))
            {
                used = 1;
                break;
            }
        }

        if(!used){
    
    if(left[0] != 't')
        continue;

    for(int k = i; k < instructionCount - 1; k++)
    {
        strcpy(intermediateCode[k],
               intermediateCode[k + 1]);
    }

    instructionCount--;
    i--;
        }
    }
}


/*==================================================
    STRENGTH REDUCTION
==================================================*/

void strengthReduction()
{
    char left[30];
    char op1[30];
    int value;
    char op;

    for(int i = 0; i < instructionCount; i++)
    {
        if(sscanf(intermediateCode[i],
                  "%s = %s %c %d",
                  left,
                  op1,
                  &op,
                  &value) == 4)
        {
            if(op == '*' && value == 2)
            {
                sprintf(intermediateCode[i],
                        "%s = %s + %s",
                        left,
                        op1,
                        op1);
            }
            else if(op == '/' && value == 2)
            {
                sprintf(intermediateCode[i],
                        "%s = %s >> 1",
                        left,
                        op1);
            }
        }
    }
}


/*==================================================
    FINAL OPTIMIZER
==================================================*/

void optimizeCode()
{
    printf("\n=====================================\n");
    printf("        OPTIMIZED CODE\n");
    printf("=====================================\n");

    constantFolding();

    algebraicSimplification();

    constantPropagation();

    copyPropagation();

    constantFolding();

    algebraicSimplification();

    removeUnusedTemporary();

    deadCodeElimination();

    for(int i = 0; i < instructionCount; i++)
    {
        printf("%s\n", intermediateCode[i]);
    }

    printf("=====================================\n");
}