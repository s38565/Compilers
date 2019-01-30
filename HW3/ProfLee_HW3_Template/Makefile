all:
	flex ss2.source
	byacc -d -v y2.y
	gcc -o codegen lex.yy.c y.tab.c code.c -ll
clean:
	rm -f lex.yy.c codegen y.tab.h y.tab.c
