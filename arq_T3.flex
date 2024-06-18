%%

%{
  private Parser yyparser;

  public Yylex(java.io.Reader r, Parser yyparser) {
    this(r);
    this.yyparser = yyparser;
  }

%} 

%unicode
%integer
%line
%char

WHITE_SPACE_CHAR=[\n\r\ \t\b\012]

%%

"while"	 	{ return Parser.WHILE; }
"if"		{ return Parser.IF; }
"else"		{ return Parser.ELSE; }
"boolean" { return Parser.BOOLEAN; }
"int" { return Parser.INT; }
"double" { return Parser.DOUBLE; }
"func" { return Parser.FUNC; }
"void" { return Parser.VOID; }
"return" { return Parser.RETURN; }
"=="     { return Parser.EQU; }
"!="     { return Parser.DIF; }
"!"     { return Parser.NOT; }
"||"     { return Parser.OR; }
"&&"    { return Parser.AND; }
"<="    { return Parser.LTE; }
">="     { return Parser.GTE; }

[:jletter:][:jletterdigit:]*               { return Parser.IDENT; }  
[0-9]+ 	                                   { return Parser.NUM; }
[:jletter:][:jletterdigit:]*"["[0-9]*"]" { return Parser.ARRAY; }

"{" |
"}" |
";" |
"(" |
")" |
"+" |
"-" |
"/" |
"*" |
"=" |
"<" |
">" |
"[" |
"]" |
","   	{ return yytext().charAt(0); } 

{WHITE_SPACE_CHAR}+ { }

. { System.out.println("Erro lexico: caracter invalido: <" + yytext() + ">"); }
