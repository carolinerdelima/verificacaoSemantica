import java.io.*;
import java.util.*;

class Param {
    String type;
    String name;

    Param(String type, String name) {
        this.type = type;
        this.name = name;
    }
}

class Symbol {
    String name;
    String type;

    Symbol(String name, String type) {
        this.name = name;
        this.type = type;
    }
}

class FunctionSymbol extends Symbol {
    List<String> parameterTypes;

    FunctionSymbol(String name, String type, List<String> parameterTypes) {
        super(name, type);
        this.parameterTypes = parameterTypes;
    }
}

class SymbolTable {
    private Map<String, Symbol> table;

    SymbolTable() {
        table = new HashMap<>();
    }

    void addSymbol(String name, String type) {
        table.put(name, new Symbol(name, type));
    }

    Symbol getSymbol(String name) {
        return table.get(name);
    }

    boolean contains(String name) {
        return table.containsKey(name);
    }
}

public class Parser {
    private Yylex lexer;
    private ParserVal yylval;
    private SymbolTable globalTable = new SymbolTable();
    private SymbolTable currentLocalTable;
    private FunctionSymbol currentFunction;

    public Parser(Reader r) {
        lexer = new Yylex(r, this);
    }

    private int yylex() {
        int yyl_return = -1;
        try {
            yylval = new ParserVal(0);
            yyl_return = lexer.yylex();
        } catch (IOException e) {
            System.err.println("IO error: " + e);
        }
        return yyl_return;
    }

    public void yyerror(String error) {
        System.err.println("Error: " + error);
    }

    public static void main(String[] args) throws IOException {
        System.out.println("");
        Parser yyparser;
        if (args.length > 0) {
            yyparser = new Parser(new FileReader(args[0]));
        } else {
            System.out.print("> ");
            yyparser = new Parser(new InputStreamReader(System.in));
        }
        yyparser.yyparse();
        System.out.println("done!");
    }

    private void addGlobalVariable(String name, String type) {
        if (globalTable.contains(name)) {
            yyerror("Variável global " + name + " já declarada.");
        } else {
            globalTable.addSymbol(name, type);
        }
    }

    private void addLocalVariable(String name, String type) {
        if (currentLocalTable.contains(name)) {
            yyerror("Variável local " + name + " já declarada.");
        } else {
            currentLocalTable.addSymbol(name, type);
        }
    }

    private void addFunction(String name, String returnType, List<String> parameterTypes) {
        if (globalTable.contains(name)) {
            yyerror("Função " + name + " já declarada.");
        } else {
            globalTable.addSymbol(name, new FunctionSymbol(name, returnType, parameterTypes));
        }
    }

    private Symbol lookupVariable(String name) {
        if (currentLocalTable != null && currentLocalTable.contains(name)) {
            return currentLocalTable.getSymbol(name);
        } else if (globalTable.contains(name)) {
            return globalTable.getSymbol(name);
        } else {
            yyerror("Variável " + name + " não declarada.");
            return null;
        }
    }

    private FunctionSymbol lookupFunction(String name) {
        Symbol symbol = globalTable.getSymbol(name);
        if (symbol instanceof FunctionSymbol) {
            return (FunctionSymbol) symbol;
        } else {
            yyerror("Função " + name + " não declarada.");
            return null;
        }
    }

    private void checkFunctionCall(String name, List<String> argumentTypes) {
        FunctionSymbol function = lookupFunction(name);
        if (function != null) {
            if (function.parameterTypes.size() != argumentTypes.size()) {
                yyerror("Número de argumentos incorreto para a função " + name);
            } else {
                for (int i = 0; i < argumentTypes.size(); i++) {
                    if (!function.parameterTypes.get(i).equals(argumentTypes.get(i))) {
                        yyerror("Tipo do argumento " + (i + 1) + " incorreto na chamada da função " + name);
                    }
                }
            }
        }
    }

    public void yyparse() {
        // Implementação do parser aqui
        // Adicione as chamadas para os métodos de verificação de tipos conforme necessário
    }
}
