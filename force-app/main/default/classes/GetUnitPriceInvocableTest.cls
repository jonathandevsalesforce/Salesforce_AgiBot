@IsTest
private class GetUnitPriceInvocableTest {

    @TestSetup
    static void setupData() {
        Product2 prod = new Product2(
            Name = 'Produto Teste',
            IsActive = true
        );
        insert prod;

        PricebookEntry standardPbe = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id   = prod.Id,
            UnitPrice    = 100,
            IsActive     = true
        );
        insert standardPbe;

        Pricebook2 customPb = new Pricebook2(
            Name = 'PB Custom Teste',
            IsActive = true
        );
        insert customPb;

        PricebookEntry customPbe = new PricebookEntry(
            Pricebook2Id = customPb.Id,
            Product2Id   = prod.Id,
            UnitPrice    = 100,
            IsActive     = true
        );
        insert customPbe;
    }

    @IsTest
    static void testSucessoProdutoEncontrado() {
        GetUnitPriceInvocable.Input input = new GetUnitPriceInvocable.Input();
        input.productName = 'Produto Teste';

        Test.startTest();
        List<GetUnitPriceInvocable.Output> results = GetUnitPriceInvocable.getUnitPrice(
            new List<GetUnitPriceInvocable.Input>{ input }
        );
        Test.stopTest();

        System.assertEquals(1, results.size());
        System.assertEquals(100, results[0].unitPrice);
        System.assertEquals(null, results[0].error);
    }

    @IsTest
    static void testProdutoNaoEncontrado() {
        GetUnitPriceInvocable.Input input = new GetUnitPriceInvocable.Input();
        input.productName = 'Produto Inexistente';

        Test.startTest();
        List<GetUnitPriceInvocable.Output> results = GetUnitPriceInvocable.getUnitPrice(
            new List<GetUnitPriceInvocable.Input>{ input }
        );
        Test.stopTest();

        System.assertEquals(1, results.size());
        System.assertEquals(null, results[0].unitPrice);
        System.assertNotEquals(null, results[0].error);
    }

    @IsTest
    static void testNomeProdutoVazio() {
        GetUnitPriceInvocable.Input input = new GetUnitPriceInvocable.Input();
        input.productName = null;

        Test.startTest();
        List<GetUnitPriceInvocable.Output> results = GetUnitPriceInvocable.getUnitPrice(
            new List<GetUnitPriceInvocable.Input>{ input }
        );
        Test.stopTest();

        System.assertEquals(1, results.size());
        System.assertEquals(null, results[0].unitPrice);
        System.assertEquals('Nome do produto não informado.', results[0].error);
    }
}