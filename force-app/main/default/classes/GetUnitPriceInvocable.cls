public with sharing class GetUnitPriceInvocable {

    @InvocableMethod(label='Obter UnitPrice por Nome do Produto')
    public static List<Output> getUnitPrice(List<Input> inputs) {
        List<Output> results = new List<Output>();
        for (Input inParam : inputs) {
            Output o = new Output();
            try {
                String nome = (inParam != null && !String.isBlank(inParam.productName)) ? inParam.productName.trim() : null;
                if (String.isBlank(nome)) {
                    o.error = 'Nome do produto não informado.';
                } else {
                    Decimal price = PricebookEntryDAO.getUnitPriceByProductName(nome);
                    if (price == null) {
                        o.error = 'Produto não encontrado ou sem PricebookEntry ativo.';
                    } else {
                        o.unitPrice = price;
                    }
                }
            } catch (Exception e) {
                o.error = 'Erro ao obter UnitPrice: ' + e.getMessage();
            }
            results.add(o);
        }
        return results;
    }

    public class Input {
        @InvocableVariable(required=true label='Nome do Produto')
        public String productName;
    }

    public class Output {
        @InvocableVariable(label='UnitPrice')
        public Decimal unitPrice;
        @InvocableVariable(label='Erro')
        public String error;
    }
}
