# Grammar Design

## 1. Introduction

This document defines the Context-Free Grammar (CFG) of the Mini Compiler Front-End. The grammar specifies the syntax rules for the supported Mini C-like programming language. It will be implemented using Bison (Yacc) during the parser development phase.

---

## 2. Start Symbol

```
Program
```

---

## 3. Program

```
Program → StatementList
```

A program consists of one or more statements.

---

## 4. Statement List

```
StatementList → Statement StatementList
StatementList → ε
```

A statement list may contain multiple statements or be empty.

---

## 5. Statement

```
Statement → Declaration
Statement → Assignment
Statement → SelectionStatement
Statement → WhileStatement
Statement → ForStatement
Statement → PrintStatement
```

---

## 6. Declaration

```
Declaration → DataType Identifier ';'

Declaration → DataType Identifier '=' Expression ';'
```

### Example

```c
int age;

float cgpa;

char grade;

bool status;

int marks = 100;
```

---

## 7. Data Type

```
DataType → int

DataType → float

DataType → char

DataType → bool
```

---

## 8. Assignment

```
Assignment → Identifier '=' Expression ';'
```

### Example

```c
age = 20;

marks = marks + 10;
```

---

## 9. Expression

```
Expression → Expression '+' Term

Expression → Expression '-' Term

Expression → Term
```

Expressions perform addition and subtraction.

---

## 10. Term

```
Term → Term '*' Factor

Term → Term '/' Factor

Term → Term '%' Factor

Term → Factor
```

Terms perform multiplication, division and modulus operations.

---

## 11. Factor

```
Factor → Identifier

Factor → Integer

Factor → Float

Factor → '(' Expression ')'
```

A factor is the smallest unit of an expression.

---

## 12. Number

```
Number → Integer

Number → Float
```

---

## 13. Integer

```
Integer → Digit Integer

Integer → Digit
```

---

## 14. Float

```
Float → Integer '.' Integer
```

---

## 15. Condition

```
Condition → Expression RelationalOperator Expression
```

A condition compares two expressions.

---

## 16. Relational Operator

```
RelationalOperator → <

RelationalOperator → >

RelationalOperator → <=

RelationalOperator → >=

RelationalOperator → ==

RelationalOperator → !=
```

---

## 17. Selection Statement

SelectionStatement → if '(' Condition ')' Block

SelectionStatement → if '(' Condition ')' Block else Block

### Example

```c
if (age >= 18)
{
    printf(age);
}
```

---

## 18. While Statement

```
WhileStatement → while '(' Condition ')' Block
```

### Example

```c
while (age < 30)
{
    age = age + 1;
}
```

---

## 19. For Statement

```
ForStatement
→ for '(' AssignmentFor ';' Condition ';' AssignmentFor ')' Block

AssignmentFor → Identifier '=' Expression

AssignmentFor → Identifier ++

AssignmentFor → Identifier --
```

### Example

```c
for(i = 0; i < 10; i = i + 1)
{
    printf(i);
}
```

---

## 20. Print Statement

```
PrintStatement → printf '(' String PrintArguments ')' ';'

PrintStatement → cout CoutArguments ';'
```

### Example

```c
printf(age);
```

---

## 21. Block

```
Block → '{' StatementList '}'
```

A block contains one or more statements enclosed within braces.

---

## 22. Identifier

```
Identifier → Letter IdentifierTail
```

---

## 23. Identifier Tail

```
IdentifierTail → Letter IdentifierTail

IdentifierTail → Digit IdentifierTail

IdentifierTail → '_' IdentifierTail

IdentifierTail → ε
```

---

## 24. Letter

```
Letter → a-z

Letter → A-Z

Letter → _
```

---

## 25. Digit

```
Digit → 0

Digit → 1

Digit → 2

Digit → 3

Digit → 4

Digit → 5

Digit → 6

Digit → 7

Digit → 8

Digit → 9
```

---

## 26. Supported Grammar Features

This grammar supports the following language constructs:

- Variable Declaration
- Variable Initialization
- Variable Assignment
- Arithmetic Expressions
- Relational Expressions
- Selection Statement (if / if-else)
- While Loop
- For Loop
- Print Statement
- Nested Blocks

---

## 27. Current Limitations

The current grammar does not support:

- Logical Operators (&&, ||, !)
- Functions
- Arrays
- Structures
- Pointers
- Switch Statement
- Do-While Loop
- User-defined Functions

Logical expressions are not yet parsed.

---

## 28. Note

This grammar is designed according to the language specification defined in `language_specification.md`. It will be directly implemented in `parser.y` using Bison (Yacc). The current version focuses on building a stable and easy-to-maintain compiler front-end before introducing more advanced language features.


## Supported Language

This compiler currently supports:

- C
- C++
- Java (Common Syntax Only)

Shared constructs include:

- Variable Declaration
- Assignment
- Arithmetic Expressions
- if / if-else
- while
- for
- printf
- cout