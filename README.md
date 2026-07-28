# Mini Compiler Front-End

## Project Overview

Mini Compiler Front-End is a simplified compiler developed using Flex (Lex) and Bison (Yacc). The compiler processes a Mini C-like programming language and performs the front-end phases of compilation.

---
## Features
- Lexical Analysis
- Syntax Analysis
- Symbol Table Generation
- Semantic Analysis
- Three Address Code (TAC) Generation
- Error Detection

---
## Technologies Used
- C Programming Language
- Flex (Lex)
- Bison (Yacc)
- GCC Compiler
- Visual Studio Code
- Git & GitHub

---
## Project Structure

```text
Mini-Compiler-Front-End/
│
├── docs/
├── src/
├── tests/
├── output/
├── sample_programs/
├── Makefile
├── README.md
└── LICENSE
```
---

## Completed Tasks

### Day 1 – Project Setup

- Created project folder structure
- Initialized Git repository
- Added README.md
- Added LICENSE
- Added Makefile

---

### Day 2 – Language Design

Completed Documentation:

- language_specification.md
- grammar.md

Implemented:

- Language Specification
- Supported Data Types
- Keywords
- Operators
- Delimiters
- Statements
- Compiler Workflow
- Compiler Limitations
- Context-Free Grammar (CFG)

---

### Day 3 – Lexical Analyzer

Implemented using Flex.

Completed:

- Keywords
- Identifiers
- Integer Numbers
- Floating Numbers
- Arithmetic Operators
- Relational Operators
- Logical Operators
- Assignment Operator
- Delimiters
- Comments
- Lexical Error Detection

File:

```text
src/lexer/lexer.l
```
---
### Day 4 – Parser

Implemented using Bison.

Completed:
- Parser Grammar
- Operator Precedence
- Expression Parsing
- Declaration Parsing
- Assignment Parsing
- If Statement
- If-Else Statement
- While Loop
- For Loop
- Print Statement
- Block Parsing
- Lexer and Parser Integration
- Successful Parsing
