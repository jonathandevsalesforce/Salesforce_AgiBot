public with sharing class PricebookEntryDAO {
    @AuraEnabled
    public static Decimal getUnitPriceByProductName(String nomeProduto) {
        if (String.isBlank(nomeProduto)) {
            throw new AuraHandledException('Informe o nome do produto.');
        }
        PricebookEntry nomePriceBook = [
            SELECT UnitPrice, Product2.Name
            FROM PricebookEntry
            WHERE Product2.Name = :nomeProduto
            ORDER BY CreatedDate DESC
            LIMIT 1
        ];
        return nomePriceBook != null ? nomePriceBook.UnitPrice : null;
    }
}
