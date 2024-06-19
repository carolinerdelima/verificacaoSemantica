import java.util.HashMap;
import java.util.Map;

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
