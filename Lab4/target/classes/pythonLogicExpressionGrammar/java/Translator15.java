import grammar.objects.nonterminals.NonTerminal;
import grammar.objects.attributes.Attribute;
import utils.Table;
import java.util.Map;
import java.util.List;

public class Translator15 { 
   public static void run(List<Map<String, Attribute>> args) { 
       args.get(0).get("ans").setValue(args.get(1).get("ans").getValue()); 
   }
}