import java.util.List;

class FunctionSymbol extends Symbol {
    List<String> parameterTypes;

    FunctionSymbol(String name, String type, List<String> parameterTypes) {
        super(name, type);
        this.parameterTypes = parameterTypes;
    }
}
