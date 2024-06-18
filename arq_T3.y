%{
        import java.io.*; 
%}

%token NL
%token <sval> IDENT ARRAY
%token <ival> NUM

%token BOOLEAN INT DOUBLE
%token FUNC RETURN VOID 
%token WHILE IF ELSE 
%token GTE LTE

%right '='
%left NOT OR AND EQU DIF
%left '<' '>' GTE LTE
%left '-' '+' 
%left '/' '*'

%%

Prog: ListaDecl;

ListaDecl: DeclVar ListaDecl
        |  DeclFun ListaDecl
        |  /* vazio */
        ;

DeclVar: Tipo ListaIdent ';'
        | Tipo ListaArray ';'
        ;
LDeclVar: LDeclVar DeclVar
        |  /* vazio */ 
        ;

Tipo: INT
        | DOUBLE
        | BOOLEAN 
        ;

ListaArray: restoListaArray ARRAY
        ;
restoListaArray: restoListaArray ARRAY ','
        | /* vazio */
        ;

ListaIdent: restoListaIdent IDENT
        ;
restoListaIdent: restoListaIdent IDENT ','
        | /* vazio */
        ;

DeclFun: FUNC TipoOuVoid IDENT '(' FormalPar ')' '{' LDeclVar ListaCmd Retorno '}'
        ;

Retorno: RETURN E ';'
        | /* vazio */
        ;

TipoOuVoid: Tipo 
        | VOID 
        ;

FormalPar: ParamList 
        | /* vazio */
        ;

ParamList: restoParamList Tipo IDENT
        ;

restoParamList: restoParamList Tipo IDENT ','
        | /* vazio */
        ;

Bloco: '{' ListaCmd '}' 
        ;

ListaCmd: ListaCmd Cmd
    |    /* vazio */
        ;

Cmd: Bloco
        | IDENT '=' E ';'
        | IDENT '=' '[' Lista ']' ';'
        | WHILE '(' E ')' Cmd
        | IF '(' E ')' Cmd ELSE Cmd
        | IF '(' E ')' Cmd
        ;

Lista: Lista ',' NUM
        | Lista ',' IDENT
        | NUM
        | IDENT
        |    /* vazio */
        ;

E: NUM     
        | AuxIdent
        | E '+' E        
        | E '-' E        
        | E '*' E        
        | E '/' E        
        | '(' E ')'      
        | E OR E         
        | E AND E        
        | NOT E          
        | E '>' E
        | E '<' E
        | E GTE E
        | E LTE E
        | E EQU E
        | E DIF E
        ;

AuxIdent : IDENT
        | IDENT '(' ListaIdent ')'
        | IDENT '(' ')'
        ;

%%

        private Yylex lexer;


        private int yylex () {
                int yyl_return = -1;
        try {
                yylval = new ParserVal(0);
                yyl_return = lexer.yylex();
        }
        catch (IOException e) {
                System.err.println("IO error :"+e);
        }
                return yyl_return;
        }


        public void yyerror (String error) {
                System.err.println ("Error: " + error);
        }


        public Parser(Reader r) {
                lexer = new Yylex(r, this);
        }


        static boolean interactive;

        public static void main(String args[]) throws IOException {
                System.out.println("");

                Parser yyparser;
                if ( args.length > 0 ) {
                        // parse a file
                        yyparser = new Parser(new FileReader(args[0]));
                }
                else {System.out.print("> ");
                        interactive = true;
                        yyparser = new Parser(new InputStreamReader(System.in));
                }

                yyparser.yyparse();
                
                //  if (interactive) {
                System.out.println();
                System.out.println("done!");
                //  }
        }
