public with sharing class S3Storage {
    public static void saveToS3Sim(String inputProtocol, String bodyJson) {
        Log_S3__c s3Record = new Log_S3__c();
        s3Record.Bucket__c = 'byteforce-data-prd';
        s3Record.Key__c = 'byteforce/orders/' + inputProtocol + '.json';
        s3Record.ContentType__c = 'application/json';
        s3Record.Body__c = bodyJson;
        
        try {
            upsert s3Record;
            system.debug(s3Record.Id);
        } catch (Exception e) {
            s3Record.Error__c = e.getMessage();
            upsert s3Record;
        }
    }
    
    public static Log_S3__c getS3RecordByKey(String key) {
        if (key == null || key == '') {
            return null;
        }
        Log_S3__c record = [
            SELECT Id, Bucket__c, Key__c, ContentType__c, Body__c, Error__c
            FROM Log_S3__c
            WHERE Key__c = :key
            LIMIT 1
        ];
        return record;
    }
}