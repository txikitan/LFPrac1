%option noyywrap

%{
  #include <stdlib.h>

  int apertura = 0;
  int cierre = 0;
  int texto = 0;
  int atributo = 0;
  int tagsunomasatributos = 0;
  int caracteres_texto = 0;
%}

%%

\<[a-zA-Z_]+/>   { apertura++; }
\<[a-zA-Z_]+[ ]+ { apertura++; tagsunomasatributos++;}
\<\/[a-zA-Z_]+> { cierre++; }
[ ]*[a-zA-Z_]+[ ]*=[ ]*["'][a-zA-Z_]+["'] { atributo++; }
>([^><&"']+)/<\/ { texto++; caracteres_texto += strlen(yytext); printf("texto es: %s \n",yytext);}


%%

int cuentaatributos(char *yytext) {

}

int main(int argc, char **argv)
{
  if(argc > 1) {
    if(!(yyin = fopen(argv[1], "r"))) {
      perror(argv[1]);
      return EXIT_FAILURE;
    }
  }
  yylex();
  printf("\naperturas = %d\ncierres = %d\ntexto = %d\natributos = %d\nnum caracteres = %d\n", apertura, cierre, texto, atributo, caracteres_texto);
}