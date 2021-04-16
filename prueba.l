%option noyywrap

%{
  #include <stdlib.h>

  int chars = 0;
  int words = 0;
  int lines = 0;
%}

%%

[a-zA-Z]+ { words++; chars += strlen(yytext); }
\n        { chars++; lines++; }
.         { chars++; }

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
  printf("\nlines = %d\nwords = %d\nchars = %d\n", lines, words, chars);
}