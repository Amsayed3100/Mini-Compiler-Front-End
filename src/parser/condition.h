#ifndef CONDITION_H
#define CONDITION_H

#include <stdlib.h>
#include <string.h>

typedef struct ConditionNode
{

    char *left;
    char *op;
    char *right;

    int isLogical;
    int isNot;

    char *logic;

    struct ConditionNode *first;
    struct ConditionNode *second;

} ConditionNode;


static inline ConditionNode *
createSimpleCondition(char *left,
                      char *op,
                      char *right)
{
    ConditionNode *node =
        (ConditionNode *)malloc(sizeof(ConditionNode));

    node->left = strdup(left);
    node->op = strdup(op);
    node->right = strdup(right);

    node->isLogical = 0;
    node->isNot = 0;

    node->logic = NULL;

    node->first = NULL;
    node->second = NULL;

    return node;
}


static inline ConditionNode *
createAndCondition(ConditionNode *a,
                   ConditionNode *b)
{
    ConditionNode *node =
        (ConditionNode *)malloc(sizeof(ConditionNode));

    node->left = NULL;
    node->op = NULL;
    node->right = NULL;

    node->logic = "&&";

    node->isLogical = 1;
    node->isNot = 0;

    node->first = a;
    node->second = b;

    return node;
}


static inline ConditionNode *
createOrCondition(ConditionNode *a,
                  ConditionNode *b)
{
    ConditionNode *node =
        (ConditionNode *)malloc(sizeof(ConditionNode));

    node->left = NULL;
    node->op = NULL;
    node->right = NULL;

    node->logic = "||";

    node->isLogical = 1;
    node->isNot = 0;

    node->first = a;
    node->second = b;

    return node;
}


static inline ConditionNode *
createNotCondition(ConditionNode *a)
{
    ConditionNode *node =
        (ConditionNode *)malloc(sizeof(ConditionNode));

    node->left = NULL;
    node->op = NULL;
    node->right = NULL;

    node->logic = "!";

    node->isLogical = 0;
    node->isNot = 1;

    node->first = a;
    node->second = NULL;

    return node;
}

#endif