public with sharing class RecordDataController {
    @AuraEnabled(cacheable=true)
    public static List<account> getRecordData(Id recordId) {
        
        return [SELECT Name, AccountNumber, Phone, Type FROM Account WHERE Id = :recordId];
    }
}