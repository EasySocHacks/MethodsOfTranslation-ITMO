package grammar.objects.nonterminals;

import grammar.objects.GrammarObject;
import grammar.objects.attributes.Attribute;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

public class NonTerminal implements GrammarObject {
    private final String name;
    private final HashMap<String, Attribute<?>> attributes = new HashMap<>();

    public NonTerminal(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        NonTerminal that = (NonTerminal) o;
        return Objects.equals(name, that.name);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name);
    }

    @Override
    public String toString() {
        if (attributes.isEmpty()) {
            return getName();
        } else {
            return String.format("%s %s", getName(), attributes);
        }
    }

    @Override
    public Map<String, Attribute<?>> getAttributes() {
        return attributes;
    }
}
