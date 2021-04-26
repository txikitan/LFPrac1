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

%%

\<[a-zA-Z_]+>   { apertura++; }

\<[a-zA-Z_]+>/\<\/[a-zA-Z_]+> { apertura++; elementovacio++;}
\<[a-zA-Z_]+/[ ]+[^>]+>\<\/[a-zA-Z_]+> { apertura++; elementovacio++; tagsunomasatributos++;}

\<[a-zA-Z_]+>/([^><&"']+)\<\/[a-zA-Z_]+> { apertura++; elementosimple++;}
\<[a-zA-Z_]+/[ ]+[^>]+>([^><&"']+)\<\/[a-zA-Z_]+> { apertura++; elementosimple++; tagsunomasatributos++;}

\<[a-zA-Z_]+[ ]+ { apertura++; tagsunomasatributos++;}
\<\/[a-zA-Z_]+> { cierre++; }
> {}
[ ]*[a-zA-Z_]+[ ]*=[ ]*["'][a-zA-Z_]+["'] { atributo++; }
([^><&"']+)/<\/ { texto++; caracteres_texto += yyleng; printf("texto es: %s \n", yytext); }

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
  printf("\naperturas = %d\ncierres = %d\ntexto = %d\natributos = %d\nnum caracteres = %d\n tags con mas de un atributo = %d\n elementos vacios = %d\n elementos simples = %d\n", apertura, cierre, texto, atributo, caracteres_texto, tagsunomasatributos, elementovacio, elementosimple);
}