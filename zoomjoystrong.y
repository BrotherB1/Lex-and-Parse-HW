%{
/*
zoomjoystrong.y
Author Luke Bassett
With help from Brian Moore
*/
/*djslafjdkslafj*/
#include"zoomjoystrong.h"
#include<stdio.h>
#include<stdlib.h>
int yylex(void);
int yyerror(char* msg);
void pointFunction(int x, int y);
void lineFunction(int x, int y, int a, int b);
void rectangleFunction(int x, int y, int w, int h);
void circleFunction(int x, int y, int r);
void setColorFunction(int r, int g, int b);
void errorFunction();
void end();

%}

%union {
  int iVal;
  float fVal;
  char* sVal;
}


%start program
%token END
%token END_STATEMENT
%token POINT
%token LINE
%token CIRCLE
%token RECTANGLE
%token SET_COLOR
%token ERROR
%token <iVal> INT
%token <fVal> FLOAT


%%
program:	statement_list END END_STATEMENT{end();}
	|	END END_STATEMENT {end();}
	;
statement_list: statement
	|	statement statement_list
	;

statement: 	POINT INT INT END_STATEMENT{pointFunction($2, $3);}
	|	LINE INT INT INT INT END_STATEMENT{lineFunction($2, $3,$4,$5);}
	| 	CIRCLE INT INT INT END_STATEMENT{circleFunction($2, $3,$4);}
	|	RECTANGLE INT INT INT INT END_STATEMENT{rectangleFunction($2, $3, $4,$5);}
	|	SET_COLOR INT INT INT END_STATEMENT{setColorFunction($2, $3, $4);}
	|	ERROR{errorFunction();}
	|	ERROR END_STATEMENT{errorFunction();}	
	;

%%
#include "zoomjoystrong.h"

int main(int argc, char ** argv)
{
  setup();
  yyparse();
  return 0;
}

int yyerror(char* msg)
{
  return fprintf(stderr, "%s\n", msg);
}

void errorFunction(){
  fprintf(stderr, "An error has occured");
}

void pointFunction(int x, int y){
	if(x > WIDTH || y > HEIGHT){
		yyerror("Point off Screen");
	}else{
		point(x,y);
	}
}
void lineFunction(int x, int y, int a, int b){
	if(x > WIDTH || y > HEIGHT || a > WIDTH || b > HEIGHT){
		yyerror("Line off screen");
	}else{
		line(x,y,a,b);
	}
}

void rectangleFunction(int x, int y, int w, int h){
	if(x > WIDTH || y > HEIGHT || w > WIDTH || h > HEIGHT){
		yyerror("Rectangle can't be drawn in space");
	}else{
		rectangle(x,y,w,h);
	}
}

void circleFunction(int x, int y, int r){
	if(x > WIDTH || y > HEIGHT || r > x || r > y || r > WIDTH - x || r > HEIGHT - y){
		yyerror("Circle not in range");
	}else{
		circle(x,y,r);
	}
}

void setColorFunction(int r, int g, int b){
	if(r > 255 || g > 255 || b > 255){
		yyerror("Colors out of range");
	}else{
		set_color(r,g,b);
	}
}

void end()
{
	finish();
	exit(0);
}
