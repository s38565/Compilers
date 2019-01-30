/* scanner.l */
%{
#include "y.tab.h"

#include <math.h>
#include <string.h>
#include <stdlib.h>
#include <malloc.h>


int lineno = 1;
char str[256];
int isSourceOn = 1;
int isTokenOn = 1;

void print_string();
void newLine();

%}


/* Definitions */
%x VARIFIED
%s COMMENT

SOURCEOFF		("#pragma source off")
SOURCEON		("#pragma source on")
TOKENOFF		("#pragma token off")
TOKENON			("#pragma token on")

STRING 			(\042[^\042\n]*\042)
CHARACTER		(\047[^\047\n]\047)
INTEGER_ZERO	(0)
INTEGER			([1-9]+[0-9]*)
DOUBLE 			([1-9]+[0-9]*"."[0-9]+)
DOUBLE_ZERO		(0.[0-9]+)
SCI_NOTATION	([0-9]+["."[0-9]*]?[eE][+-]?[0-9]+)
KEY_WORDS		("double"|"int"|"char"|"bool"|"void"|"null"|"for"|"while"|"do"|"if"|"else"|"switch"|"return"|"break"|"continue"|"const"|"true"|"false"|"struct"|"case"|"default")

SINGLE_COMMENT	("//"[^\n]*)

IDENTIFIER		([_a-zA-Z][_a-zA-Z0-9]*)



%%
{SINGLE_COMMENT}	{ strcat(str,yytext);}
"/*"				{ BEGIN(COMMENT); strcat(str,yytext);}
<COMMENT>[^*\n]*    { strcat(str,yytext);}
<COMMENT>"*"+[^*/\n]* { strcat(str,yytext);}
<COMMENT>\n 		{ newLine(); }
<COMMENT>"*"+"/"	{ BEGIN(INITIAL); strcat(str,yytext);}

{SOURCEON}			{ isSourceOn = 1; strcat(str,yytext);}
{TOKENON}			{ isTokenOn = 1; strcat(str,yytext);}
{SOURCEOFF}			{ isSourceOn = 0; strcat(str,yytext);}
{TOKENOFF}			{ isTokenOn = 0; strcat(str,yytext);}

{STRING}			{ strcat(str,yytext); if(isTokenOn == 1){print_string();} return TOKEN_STRING; }

{CHARACTER}			{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#char:%s\n",yytext);} return TOKEN_CHAR; }

{INTEGER}			{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#integer:%s\n",yytext);} return TOKEN_INTEGER;}
{INTEGER_ZERO}		{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#integer:%s\n",yytext);} return TOKEN_INTEGER;}


{DOUBLE}			{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#double:%s\n",yytext);} return TOKEN_DOUBLE; }
{DOUBLE_ZERO}		{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#double:%s\n",yytext);} return TOKEN_DOUBLE; }

{SCI_NOTATION}		{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#sci:%s\n",yytext);} return TOKEN_SCI;}


[\n]				{ newLine();}
[ \t\r]+          	{ strcat(str,yytext);}

"int"				{ BEGIN(VARIFIED); strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#key:%s\n",yytext);} return TYPE_INT; }
"double"			{ BEGIN(VARIFIED); strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#key:%s\n",yytext);} return TYPE_DOUBLE; }
"bool"				{ BEGIN(VARIFIED); strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#key:%s\n",yytext);} return TYPE_BOOL; }
"char"				{ BEGIN(VARIFIED); strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#key:%s\n",yytext);} return TYPE_CHAR; }
<VARIFIED>"="			{ BEGIN(INITIAL); strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#op:%s\n",yytext);} return OP_EQUAL; }
<VARIFIED>";"			{ BEGIN(INITIAL); strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#punc:%s\n",yytext);} return PUNC_SEMICOLON; }
<VARIFIED>[ \t\r]+   	{ strcat(str,yytext);}
<VARIFIED>"*"			{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#op:%s\n",yytext);} return OP_MULTIPLE;}

<VARIFIED>{IDENTIFIER} { BEGIN(INITIAL);strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#id:%s\n",yytext);} return TOKEN_ID; }

"true"				{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#key:%s\n",yytext);} return KEY_TRUE; }
"false"				{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#key:%s\n",yytext);} return KEY_FALSE; }
"struct"			{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#key:%s\n",yytext);} return KEY_STRUCT; }
"case"				{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#key:%s\n",yytext);} return KEY_CASE; }
"default"			{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#key:%s\n",yytext);} return KEY_DEFAULT; }
"void"				{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#key:%s\n",yytext);} return KEY_VOID; }
"null"				{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#key:%s\n",yytext);} return KEY_NULL; }
"for"				{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#key:%s\n",yytext);} return KEY_FOR; }
"while"				{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#key:%s\n",yytext);} return KEY_WHILE; }
"do"				{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#key:%s\n",yytext);} return KEY_DO; }
"if"				{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#key:%s\n",yytext);} return KEY_IF; }
"else"				{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#key:%s\n",yytext);} return KEY_ELSE; }
"switch"			{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#key:%s\n",yytext);} return KEY_SWITCH; }
"return"			{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#key:%s\n",yytext);} return KEY_RETURN; }
"break"				{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#key:%s\n",yytext);} return KEY_BREAK; }
"continue"			{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#key:%s\n",yytext);} return KEY_CONTINUE; }
"const"				{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#key:%s\n",yytext);} return KEY_CONST; }


"+"					{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#op:%s\n",yytext);} return OP_PLUS; }
"-"					{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#op:%s\n",yytext);} return OP_MINUS; }
"*"					{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#op:%s\n",yytext);} return OP_MULTIPLE; }
"/"					{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#op:%s\n",yytext);} return OP_DIVIDE; }
"%"					{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#op:%s\n",yytext);} return OP_PERCENT; }
"!"					{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#op:%s\n",yytext);} return OP_NOT; }
"&"					{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#op:%s\n",yytext);} return OP_ADDR; }
"="					{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#op:%s\n",yytext);} return OP_EQUAL; }
"<"					{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#op:%s\n",yytext);} return OP_LESS; }
">"					{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#op:%s\n",yytext);} return OP_GREATER; }

"++"				{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#op:%s\n",yytext);} return OP_2PLUS; }
"--"				{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#op:%s\n",yytext);} return OP_2MINUS; }
"<="				{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#op:%s\n",yytext);} return OP_LE; }
">="				{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#op:%s\n",yytext);} return OP_GE; }
"=="				{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#op:%s\n",yytext);} return OP_2EQUAL; }
"!="				{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#op:%s\n",yytext);} return OP_NE; }
"&&"				{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#op:%s\n",yytext);} return OP_AND; }
"||"				{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#op:%s\n",yytext);} return OP_OR; }

"["					{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#punc:%s\n",yytext);} return PUNC_LBRACKET; }
"]"					{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#punc:%s\n",yytext);} return PUNC_RBRACKET; }
"("					{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#punc:%s\n",yytext);} return PUNC_LPERAN; }
")"					{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#punc:%s\n",yytext);} return PUNC_RPERAN; }
"{"					{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#punc:%s\n",yytext);} return PUNC_LBRACE; }
"}"					{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#punc:%s\n",yytext);} return PUNC_RBRACE; }

":"					{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#punc:%s\n",yytext);} return PUNC_COLON; }
";"					{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#punc:%s\n",yytext);} return PUNC_SEMICOLON; }
","					{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#punc:%s\n",yytext);} return PUNC_COMMA; }
"."					{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#punc:%s\n",yytext);} return PUNC_DOT; }

{IDENTIFIER}		{ strcat(str,yytext); if(isTokenOn == 1){fprintf(stdout,"#id:%s\n",yytext);} return TOKEN_ID; }


%%


int yywrap(){
	return 1;
}

void yyerror(const char *msg ) 
{	
	fprintf( stderr, "*** Error at line %d: %s\n", lineno, str );
	fprintf( stderr, "\n" );
	fprintf( stderr, "Unmatched token: %s\n", yytext );
	fprintf( stderr, "*** syntax error\n");	
	exit(-1);
}

void print_string(){
	char a[256];
	int i = 1;
	for(i=1; yytext[i]!='\042'; i++)
	{
		a[i-1]=yytext[i];
	}
	a[i-1]='\0';
	fprintf(stdout,"#string:%s\n", a);
}


void newLine(){
	if(isSourceOn == 1){
		fprintf(stdout,"%d:%s\n",lineno,str);
	}
	memset(str,0,sizeof(str));
	lineno++;
}


