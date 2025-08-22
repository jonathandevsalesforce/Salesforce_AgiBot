@isTest
public class S3StorageTest {

    @isTest
    static void testSaveToS3Sim() {
        String testProtocol = 'ORD-123';
        String testBody = '{"order":"123","status":"created"}';

        // Chama o método para inserir registro simulado
        Test.startTest();
        S3Storage.saveToS3Sim(testProtocol, testBody);
        Test.stopTest();

        // Verifica se inseriu o registro
        Log_S3__c insertedRecord = [
            SELECT Bucket__c, Key__c, ContentType__c, Body__c, Error__c
            FROM Log_S3__c
            WHERE Key__c = :('byteforce/orders/' + testProtocol + '.json')
            LIMIT 1
        ];

        System.assertEquals('byteforce-data-prd', insertedRecord.Bucket__c);
        System.assertEquals('byteforce/orders/' + testProtocol + '.json', insertedRecord.Key__c);
        System.assertEquals('application/json', insertedRecord.ContentType__c);
        System.assertEquals(testBody, insertedRecord.Body__c);
        System.assertEquals(null, insertedRecord.Error__c);
    }

    @isTest
    static void testGetS3RecordByKey() {
        // Insere um registro para teste
        Log_S3__c testRecord = new Log_S3__c();
        testRecord.Bucket__c = 'byteforce-data-prd';
        testRecord.Key__c = 'byteforce/orders/ORD-456.json';
        testRecord.ContentType__c = 'application/json';
        testRecord.Body__c = '{"order":"456","status":"pending"}';
        insert testRecord;

        Test.startTest();
        Log_S3__c result = S3Storage.getS3RecordByKey('byteforce/orders/ORD-456.json');
        Test.stopTest();

        System.assertNotEquals(null, result);
        System.assertEquals('byteforce/orders/ORD-456.json', result.Key__c);
        System.assertEquals('{"order":"456","status":"pending"}', result.Body__c);
    }

    @isTest
    static void testGetS3RecordByKeyNotFound() {
        Test.startTest();
        Log_S3__c result = S3Storage.getS3RecordByKey('non-existent-key.json');
        Test.stopTest();
        System.assertEquals(null, result);
    }

    @isTest
    static void testGetS3RecordByKeyNull() {
        Test.startTest();
        Log_S3__c result = S3Storage.getS3RecordByKey(null);
        Test.stopTest();
        System.assertEquals(null, result);
    }
}
