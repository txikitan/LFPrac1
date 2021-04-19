%option noyywrap

%{
  #include <stdlib.h>

  int apertura = 0;
  int cierre = 0;
  int nombre = 0;
  int texto = 0;
  int atributo = 0;
%}

%%

<[a-zA-Z_]+>  { apertura++; }
<\/[a-zA-Z_]+> { cierre++; }
[a-zA-Z_]+ { nombre++; }
^[^><&"']+$ { texto++; }
<[a-zA-Z_]+[ ]*[a-zA-Z_]+[ ]*=[ ]*["'][a-zA-Z_]+["']> { apertura++; atributo++;  }

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
  printf("\naperturas = %d\ncierres = %d\nnombres = %d\ntexto = %d\ntextos = %d\natributos = %d\n", apertura, cierre, nombre, texto, atributo);
}