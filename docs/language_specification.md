# Mini Compiler Front-End

## 1. Introduction

Mini Compiler Front-End is a simplified compiler developed for academic purposes using Flex (Lex) and Bison (Yacc).

The compiler reads a Mini C-like source program and performs the following front-end phases:

- Lexical Analysis
- Syntax Analysis
- Symbol Table Generation
- Semantic Analysis
- Intermediate Code Generation (Three Address Code)

This compiler is designed to understand a limited subset of the C programming language.

---

## 2. Project Objectives

The objectives of this project are:

- To develop a Mini Compiler Front-End using Flex and Bison.
- To perform lexical analysis and generate tokens.
- To perform syntax analysis using context-free grammar.
- To maintain a symbol table for identifiers.
- To perform semantic analysis and detect semantic errors.
- To generate intermediate code using Three Address Code (TAC).
- To improve understanding of compiler design concepts.

---

## 3. Supported Data Types

The compiler supports the following primitive data types.

| Data Type | Description |
|------------|-------------|
| int | Integer numbers |
| float | Floating point numbers |
| char | Character values |
| bool | Boolean values |

Example

```c
int age;

float cgpa;

char grade;

bool status;
```

---

## 4. Keywords

The compiler recognizes the following keywords.

| Keyword | Description |
|----------|-------------|
| int | Integer declaration |
| float | Float declaration |
| char | Character declaration |
| bool | Boolean declaration |
| if | Conditional statement |
| else | Else block |
| while | Loop |
| for | Loop |
| return | Return statement |
| printf | Output statement |

---

## 5. Operators

## Arithmetic Operators

| Operator | Meaning |
|----------|---------|
| + | Addition |
| - | Subtraction |
| * | Multiplication |
| / | Division |
| % | Modulus |

## Assignment Operator

| Operator | Meaning |
|----------|---------|
| = | Assignment |

## Relational Operators

| Operator | Meaning |
|----------|---------|
| == | Equal |
| != | Not Equal |
| < | Less Than |
| > | Greater Than |
| <= | Less Than or Equal |
| >= | Greater Than or Equal |

## Logical Operators

| Operator | Meaning |
|----------|---------|
| && | Logical AND |
| || | Logical OR |
| ! | Logical NOT |

---

## 6. Delimiters

The compiler supports the following delimiters.

```
;
,
(
)
{
}
[
]
```

---

## 7. Comments

Supported comments

Single Line

```c
// This is a comment
```

Multi Line

```c
/*
This
is
a
comment
*/
```

---

## 8. Supported Statements

The compiler supports

- Variable Declaration
- Variable Assignment
- Arithmetic Expression
- if Statement
- if-else Statement
- while Loop
- for Loop
- printf Statement
- Nested Blocks

Example

```c
int age;

age = 20;

if (age >= 18)
{
    printf(age);
}
```

---

## 9. Compiler Workflow

The Mini Compiler Front-End processes the source code through the following phases:

1. Source Code Input
2. Lexical Analysis
3. Syntax Analysis
4. Symbol Table Generation
5. Semantic Analysis
6. Intermediate Code Generation
7. Output Generation

---
## 10. Compiler Limitations

Current version does not support

- Functions
- Arrays
- Pointers
- Structures
- File Handling
- Dynamic Memory Allocation
- Switch Statement
- Do-While Loop
- Classes
- Objects

These features may be added in future versions.

---


## 11. Future Scope

The following features can be added in future versions:

- Function Definition
- Function Call
- Arrays
- Structures
- Pointer Support
- File Handling
- Switch Statement
- Do-While Loop
- Abstract Syntax Tree (AST)
- Code Optimization

---

## Note

This compiler is developed for educational purposes and implements only the front-end phases of a compiler. It is intended to demonstrate the fundamental concepts of compiler construction using Flex and Bison.
