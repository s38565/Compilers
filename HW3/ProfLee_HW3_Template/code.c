
/*
   This is a very simple c compiler written by Prof. Jenq Kuen Lee,
   Department of Computer Science, National Tsing-Hua Univ., Taiwan,
   Fall 1995.

   This is used in compiler class.
   This file contains Symbol Table Handling.

*/

#include <stdio.h> 
#include <string.h>
#include "code.h"

extern FILE *f_asm;
int cur_counter = 0;
int cur_scope   = 1;

char *copys();



/*

  init_symbol_table();

*/
init_symbol_table()
{

  bzero(&table[0], sizeof(struct symbol_entry)*MAX_TABLE_SIZE);

}

/*
   To install a symbol in the symbol table 

*/
char  *
install_symbol(char *s,int cur_mode)
{

   if (cur_counter >= MAX_TABLE_SIZE)
     err("Symbol Table Full");
   else {
    table[cur_counter].scope = cur_scope;
    table[cur_counter].name = copys(s);
    table[cur_counter].mode = cur_mode;
    table[cur_counter].offset = cur_counter;
    cur_counter++;
    printf("cur_counter==%d\n",cur_counter);
    printf("cur_scope==%d\n",cur_scope);
  }
   return(s);
}



/*
   To return an integer as an index of the symbol table

*/
int
look_up_symbol(s)
char *s;
{
   int i;

   if (cur_counter==0) return(-1);
   for (i=cur_counter-1;i>=0; i--)
     {
       if (!strcmp(s,table[i].name))
	 return(i);
     }
   return(-1);
 }


/*
   Pop up symbols of the given scope from the symbol table upon the
   exit of a given scope.

*/
void
pop_up_symbol(scope)
int scope;
{
   int i;
   if (cur_counter==0) return;
   
   for (i=cur_counter-1;i>=0; --i)
     {
       printf("scope=%d\n",table[i].scope);
       if (table[i].scope !=scope) break;
     }
   printf("pop==%d\n",scope);
   if (i<0) cur_counter = 0;
   cur_counter = i+1;
   printf("pop_cur_counter==%d\n",cur_counter);
  
}



/*
   Set up parameter scope and offset

*/
set_scope_and_offset_of_param(s)
char *s;
{

  int i,j,index;
  int total_args;

   index = look_up_symbol(s);
   if (index<0) err("Error in function header");
   else {
      table[index].type = T_FUNCTION;
      total_args = cur_counter -index -1;
      table[index].total_args=total_args;
      for (j=total_args, i=cur_counter-1;i>index; i--,j--)
        {
          table[i].scope= cur_scope;
          table[i].offset= j;
          table[i].mode  = ARGUMENT_MODE;
        }
   }

}



/*
   Set up local var offset

*/
set_local_vars(functor)
char *functor;
{

  int i,j,index,index1;
  int total_locals;

  index = look_up_symbol(functor);
  index1 = index + table[index].total_args;
  total_locals= cur_counter -index1 -1;
  printf("total_local: %d\n",total_locals);
  if (total_locals <0)
     err("Error in number of local variables");
  table[index].total_locals=total_locals;
  for (j=total_locals, i=cur_counter-1;j>0; i--,j--)
        {
          table[i].scope= cur_scope;
          table[i].offset= j;
          table[i].mode  = LOCAL_MODE;
        }

}



/*
  Set GLOBAL_MODE to global variables

*/

set_global_vars(s)
char *s;
{
  int index;
  index =look_up_symbol(s);
  table[index].mode = GLOBAL_MODE;
  table[index].scope =1;
  fprintf(f_asm, "    ! Global Variable %s\n", s);
  fprintf(f_asm, "    .global %s\n", s);
  fprintf(f_asm, "    .section .bss\n");
  fprintf(f_asm, "    .align  2\n");
  fprintf(f_asm, "    .type   %s, @object\n", s);
  fprintf(f_asm, "    .size   %s, 4\n", s);
  fprintf(f_asm, "%s:\n", s);
  fprintf(f_asm, "    .zero   4\n");
}


/*

To generate house-keeping work at the beginning of the function

*/

code_gen_func_header(functor)
char *functor;
{

/*fprintf(f_asm,"   ;    %s\n",functor);
fprintf(f_asm,"        assume cs:_TEXT\n");
fprintf(f_asm,"_%s      proc  near\n",functor);
fprintf(f_asm,"        push bp\n");
fprintf(f_asm,"        mov  bp,sp\n");
fprintf(f_asm,"   ;    \n");*/

fprintf(f_asm, "    .text\n");
fprintf(f_asm, "    .align  1\n");
fprintf(f_asm, "    .global _Z%d%sv\n", strlen(functor), functor);
fprintf(f_asm, "    .type   _Z%d%sv, @function\n", strlen(functor), functor);
fprintf(f_asm, "_Z%d%sv:\n", strlen(functor), functor);
fprintf(f_asm, "    push.s  { $lp }\n");
fprintf(f_asm, "    addi    $sp, $sp, -8\n");
fprintf(f_asm, "    swi     $fp, [$sp + (4)]\n");
fprintf(f_asm, "    addi    $fp, $sp, 0\n");

}

/*

  To generate global symbol vars

*/
code_gen_global_vars()
{
  int i;

  fprintf(f_asm,"_BSS     segment word public 'BSS'\n");
  for (i=0; i<cur_counter; i++)
     {
       if (table[i].mode == GLOBAL_MODE)
	 {
            fprintf(f_asm,"_%s	label	word\n",table[i].name);
            fprintf(f_asm,"	db	2 dup (?)\n");
         }
     }
 fprintf(f_asm,"_BSS    ends\n");

}


/*

 To geenrate house-keeping work at the end of a function

*/

code_gen_at_end_of_function_body(functor)
char *functor;
{
  int i;

  //fprintf(f_asm,"   ;    \n");
  //fprintf(f_asm,"        mov sp, bp\n");
  //fprintf(f_asm,"        pop bp\n");
  //fprintf(f_asm,"        ret\n");
  //fprintf(f_asm,"_%s     endp\n",functor);
  fprintf(f_asm, "._Z%d%sv_END:\n", strlen(functor),functor);
  fprintf(f_asm, "    addi    $sp, $fp, 0\n");
  fprintf(f_asm, "    lwi     $fp, [$sp + (4)]\n");
  fprintf(f_asm, "    addi    $sp, $sp, 8\n");
  fprintf(f_asm, "    pop.s   { $lp }\n");
  fprintf(f_asm, "    ret\n");
  fprintf(f_asm, "    .size   _Z%d%sv, .-_Z%d%sv\n", strlen(functor),functor, strlen(functor),functor);
}





/*******************Utility Functions ********************/
/*
 * copyn -- makes a copy of a string with known length
 *
 * input:
 *	  n - lenght of the string "s"
 *	  s - the string to be copied
 *
 * output:
 *	  pointer to the new string
 */

char   *
copyn(n, s)
	register int n;
	register char *s;
{
	register char *p, *q;
	void   *calloc();

	p = q = (char*)calloc(1,n);
	while (--n >= 0)
		*q++ = *s++;
	return (p);
}


/*
 * copys -- makes a copy of a string
 *
 * input:
 *	  s - string to be copied
 *
 * output:
 *	  pointer to the new string
 */
char   *
copys(s)
	char   *s;
{
	return (copyn(strlen(s) + 1, s));
}






