%option noyywrap

%{
  #include <stdlib.h>

  int apertura = 0;
  int cierre = 0;
  int texto = 0;
  int atributo = 0;
  int tagsunomasatributos = 0;
  int caracteres_texto = 0;
  int elementovacio = 0;
  int elementosimple = 0;
%}
APERTURA    \<[a-zA-Z0-9_]+> 
CIERRE      \<\/[a-zA-Z0-9_]+>
ATRIBUTO    [ ]*[a-zA-Z0-9_]+[ ]*=[ ]*["'][a-zA-Z0-9_]+["']  
TEXTO       ([^><&"']+)  
APERTURATRIB     \<[a-zA-Z0-9_]+   
%%

{APERTURA}  { apertura++; }
{APERTURA}/{CIERRE} { apertura++; elementovacio++;}
{APERTURATRIB}/[ ]+[^>]+>{CIERRE} { apertura++; elementovacio++; tagsunomasatributos++;}
{APERTURA}/{TEXTO}{CIERRE} { apertura++; elementosimple++;}
{APERTURATRIB}/[ ]+[^>]+>{TEXTO}{CIERRE} { apertura++; elementosimple++; tagsunomasatributos++;}
{APERTURATRIB}[ ]+ { apertura++; tagsunomasatributos++;}
{CIERRE} { cierre++; }
{ATRIBUTO} { atributo++; }
{TEXTO}/<\/ { texto++; caracteres_texto += yyleng; }
> {}

%%

int main(int argc, char **argv)
{
  if(argc > 1) {
    if(!(yyin = fopen(argv[1], "r"))) {
      perror(argv[1]);
      return EXIT_FAILURE;
    }
  }
  yylex();
  printf("\nNum aperturas = %d\nNum cierres = %d\nNum textos = %d\nNum atributos = %d\nNum caracteres total = %d\nNum elementos con uno o mas atributos = %d\nNum elementos vacios = %d\nNum elementos simples = %d\n", apertura, cierre, texto, atributo, caracteres_texto, tagsunomasatributos, elementovacio, elementosimple);
}