/* This is a simpled gcc grammar */
/* Copyright (C) 1987 Free Software Foundation, Inc. */
/* BISON parser for a simplied C by Jenq-kuen Lee  Sep 20, 1993    */

%{
#include <stdio.h>
#include "SymbolTable.h"

int yylex();
void yyerror(const char* msg);
%}

/* all identifiers   that are not reserved words
   and are not declared typedefs in the current block */
/* reserved words that specify storage class.
   yylval contains an IDENTIFIER_NODE which indicates which one.  */
/* reserved words that specify type.
   yylval contains an IDENTIFIER_NODE which indicates which one.  */
/* reserved words that modify type: "const" or "volatile".
   yylval contains an IDENTIFIER_NODE which indicates which one.  */
   
   
%start program
   
/* type */   
%token TYPE_INT TYPE_DOUBLE TYPE_BOOL TYPE_CHAR

/* operator */
%token OP_PLUS OP_MINUS OP_MULTIPLE OP_DIVIDE OP_PERCENT
%token OP_2PLUS OP_2MINUS OP_LESS OP_LE OP_GREATER OP_GE OP_2EQUAL OP_NE OP_EQUAL OP_AND OP_OR OP_NOT OP_POINTER OP_ADDR

/* symbols */
%token PUNC_COLON PUNC_SEMICOLON PUNC_COMMA PUNC_DOT PUNC_LBRACKET PUNC_RBRACKET PUNC_LPERAN PUNC_RPERAN PUNC_LBRACE PUNC_RBRACE

/* the reserved words */
%token KEY_VOID KEY_NULL KEY_FOR KEY_WHILE KEY_DO KEY_IF KEY_ELSE 
%token KEY_SWITCH KEY_RETURN KEY_BREAK KEY_CONTINUE KEY_CONST KEY_TRUE KEY_FALSE KEY_STRUCT KEY_CASE KEY_DEFAULT
%token TOKEN_ID TOKEN_STRING TOKEN_CHAR TOKEN_INTEGER TOKEN_DOUBLE TOKEN_SCI

/* Define the operator tokens and their precedences.
   The value is an integer because, if used, it is the tree code
   to use in the expression made from the operator.  */
   
%nonassoc LOWER_THAN_ELSE
%nonassoc KEY_ELSE



%{
/* external function is defined here */
void error();
int TRACEON = 100;
%}



%%

program: 
		declarations functions
		;

declarations: 
		/* empty */
		| declarations declaration_ex	
		;

declaration_ex: 
		  functions
		| declaration
		;

list_of_declarations: 
		  declaration
		| list_of_declarations declaration
		;

declaration: 
		  declaration_const
		| declaration_no_const
		;

declaration_const:
		  declaration_const_1 PUNC_SEMICOLON
		| declaration_const_1 declarators_const PUNC_SEMICOLON
		;

declaration_const_1:
		 type_const types
		;

types:
		  TYPE_CHAR
		| TYPE_BOOL
		| TYPE_INT
		| TYPE_DOUBLE
		;


type_const:
		  KEY_CONST
		; 

declarators_const:
		  init_declarator_const
		| declarators_const PUNC_COMMA init_declarator_const
		;

init_declarator_const:
		  declarator_const
		| declarator_const OP_EQUAL initials
		;

declarator_const:
		  Dir_declarator_const
		; 

Dir_declarator_const:
		  TOKEN_ID
		| PUNC_LPERAN declarator_const PUNC_RPERAN
		| Dir_declarator_const PUNC_LPERAN PUNC_RPERAN
		| Dir_declarator_const PUNC_LPERAN paras PUNC_RPERAN
		| Dir_declarator_const PUNC_LPERAN ids PUNC_RPERAN
		;

declaration_no_const:
		  declarations_no_const PUNC_SEMICOLON
		| declarations_no_const declarators_no_const PUNC_SEMICOLON
		;

declarations_no_const:
		  types
		| types declarations_no_const
		;


declarators_no_const:
		  init_declarator_no_const
		| declarators_no_const PUNC_COMMA init_declarator_no_const
		;

init_declarator_no_const:
		  declarator_no_const
		| declarator_no_const OP_EQUAL initials
		;

declarator_no_const:
		  Dir_declarator_no_const
		; 

Dir_declarator_no_const:
		  TOKEN_ID
		| Dir_declarator_no_const PUNC_LPERAN PUNC_RPERAN
		| Dir_declarator_no_const PUNC_LPERAN ids PUNC_RPERAN
		| Dir_declarator_no_const PUNC_LPERAN paras PUNC_RPERAN		
		| Dir_declarator_no_const PUNC_LBRACKET TOKEN_INTEGER PUNC_RBRACKET
		| PUNC_LPERAN declarator_no_const PUNC_RPERAN
		;


functions:
		  declarations_no_const declarator_no_const compounds
		| declarations_no_const declarator_no_const list_of_declarations compounds
		| KEY_VOID declarator_no_const compounds
		| KEY_VOID declarator_no_const list_of_declarations compounds
		;



initials:
		  assigns_no_func
		| PUNC_LBRACE PUNC_RBRACE
		| PUNC_LBRACE initials_list PUNC_RBRACE
		| PUNC_LBRACE initials_list PUNC_COMMA PUNC_RBRACE		 
		;

initials_list:
		  designators initials
		| initials
		| initials_list PUNC_COMMA initials
		| initials_list PUNC_COMMA designators initials
		;

designators:
		  designator_list OP_EQUAL
		;

designator_list:
		  designator
		| designator_list designator
		;

designator:
		  PUNC_DOT TOKEN_ID
		;


ids:
	  TOKEN_ID
	| ids PUNC_COMMA TOKEN_ID
	;


paras:
		  paras_declare
		| paras PUNC_COMMA paras_declare
		;

paras_declare:
		  declarations_no_const
		| declarations_no_const declarator_no_const
		;

compounds:
		  PUNC_LBRACE blocks PUNC_RBRACE
		;

blocks:
		  declarations statements
		;


statements:
		  /* empty */
		| statements statement
		;

statement:
		  compounds
		| expressions
		| while_or_for
		| if_else_switch
		| continue_break_return
		;

expressions:
		  PUNC_SEMICOLON
		| expression PUNC_SEMICOLON
		;

expression:
		  assigns
		| expression PUNC_COMMA assigns
		;

assigns:
		  logical_ors
		| unarys OP_EQUAL assigns
		;

assigns_no_func:
		  logical_ors_no_func
		| unarys_no_func OP_EQUAL assigns_no_func
		;

logical_ors:
		  logical_ands
		| logical_ors OP_OR logical_ands
		;

logical_ands:
		  ands
		| logical_ands OP_AND ands
		;

ands:
		  equals
		| ands OP_ADDR equals
		;

equals:
		  relations
		| equals OP_NE relations
		| equals OP_2EQUAL relations
		;

relations:
		  additives
		| relations OP_GE additives
		| relations OP_LE additives
		| relations OP_LESS additives
		| relations OP_GREATER additives
		;

additives:
		  multiplies
		| additives OP_PLUS multiplies
		| additives OP_MINUS multiplies
		;

multiplies:
		  unarys
		| multiplies OP_DIVIDE unarys
		| multiplies OP_PERCENT unarys
		| multiplies OP_MULTIPLE unarys				
		;

unarys:
		  postfixs
		| OP_2PLUS unarys
		| OP_2MINUS unarys
		| unary_op unarys
		; 

unary_op:
		  OP_NOT
		| OP_ADDR
		| OP_PLUS
		| OP_MINUS
		| OP_POINTER		
		;

postfixs:
		  primarys
		| postfixs OP_2PLUS
		| postfixs OP_2MINUS
		| postfixs PUNC_DOT TOKEN_ID
		| postfixs PUNC_LPERAN PUNC_RPERAN
		| postfixs PUNC_LBRACKET expression PUNC_RBRACKET		
		| postfixs PUNC_LPERAN argument_expression_list PUNC_RPERAN		
		; 

primarys:
		  TOKEN_ID
		| constant
		| TOKEN_STRING
		| PUNC_LPERAN expression PUNC_RPERAN
		;

constant:
		  TOKEN_SCI
		| TOKEN_DOUBLE
		| TOKEN_INTEGER
		;

logical_ors_no_func:
		  logical_ands_no_func
		| logical_ors_no_func OP_OR logical_ands_no_func
		;

logical_ands_no_func:
		  ands_no_func
		| logical_ands_no_func OP_AND ands_no_func
		;

ands_no_func:
		  equals_no_func
		| ands_no_func OP_ADDR equals_no_func
		;

equals_no_func:
		  relations_no_func
		| equals_no_func OP_NE relations_no_func
		| equals_no_func OP_2EQUAL relations_no_func		
		;

relations_no_func:
		  additives_no_func
		| relations_no_func OP_GREATER additives_no_func
		| relations_no_func OP_GE additives_no_func
		| relations_no_func OP_LESS additives_no_func
		| relations_no_func OP_LE additives_no_func
		;

additives_no_func:
		  multiplies_no_func
		| additives_no_func OP_PLUS multiplies_no_func
		| additives_no_func OP_MINUS multiplies_no_func
		;

multiplies_no_func:
		  unarys_no_func
		| multiplies_no_func OP_MULTIPLE unarys_no_func
		| multiplies_no_func OP_DIVIDE unarys_no_func
		| multiplies_no_func OP_PERCENT unarys_no_func
		;

unarys_no_func:
		  postfixs_no_func
		| OP_2PLUS unarys_no_func
		| OP_2MINUS unarys_no_func
		| unary_op unarys_no_func
		; 

postfixs_no_func:
		  primarys_no_func
		| postfixs_no_func PUNC_LBRACKET TOKEN_INTEGER PUNC_RBRACKET
		| postfixs_no_func PUNC_DOT TOKEN_ID
		| postfixs_no_func OP_2PLUS
		| postfixs_no_func OP_2MINUS
		;

primarys_no_func:
		  TOKEN_ID
		| constant
		| TOKEN_STRING
		| PUNC_LPERAN expression PUNC_RPERAN
		;


argument_expression_list:
		  assigns
		| argument_expression_list PUNC_COMMA assigns
		;

if_else_switch:
		  KEY_IF PUNC_LPERAN expression PUNC_RPERAN statement KEY_ELSE statement
		| KEY_IF PUNC_LPERAN expression PUNC_RPERAN statement %prec LOWER_THAN_ELSE
		| KEY_SWITCH PUNC_LPERAN ids PUNC_RPERAN PUNC_LBRACE switches PUNC_RBRACE
		;

switches:
		  cases
		| cases defaults
		;

cases:
		  case_expression
		| cases case_expression
		;

case_expression:
		  KEY_CASE int_or_char_const PUNC_COLON statements
		;

defaults:
		  KEY_DEFAULT PUNC_COLON statements
		;

int_or_char_const:
		  TOKEN_INTEGER
		| TOKEN_CHAR
		;

while_or_for:
		  KEY_WHILE PUNC_LPERAN expression PUNC_RPERAN statement
		| KEY_DO statement KEY_WHILE PUNC_LPERAN expression PUNC_RPERAN PUNC_SEMICOLON
		| KEY_FOR PUNC_LPERAN expressions expressions PUNC_RPERAN statement
		| KEY_FOR PUNC_LPERAN expressions expressions expression PUNC_RPERAN statement
		| KEY_FOR PUNC_LPERAN declaration expressions PUNC_RPERAN statement
		| KEY_FOR PUNC_LPERAN declaration expressions expression PUNC_RPERAN statement
		;

continue_break_return:
		  KEY_CONTINUE PUNC_SEMICOLON
		| KEY_BREAK PUNC_SEMICOLON
		| KEY_RETURN PUNC_SEMICOLON
		| KEY_RETURN expression PUNC_SEMICOLON
		;

		
%%

int main(){
	yyparse();
	fprintf(stdout, "No syntax error!\n");
	return 0;
}

