public with sharing class fetchRecordsController {
    @AuraEnabled(cacheable=true)
    public static List<sobject> fetchRecords(String objectName, List<String> fieldNames) {
        String query = 'SELECT ';
        query += String.join(fieldNames, ', ');
        query += ' FROM ' + objectName;
        
        return Database.query(query);
        /*List<RecordWrapper> wrappedRecords = new List<RecordWrapper>();
        
        for (sObject record : records) {
            wrappedRecords.add(new RecordWrapper(record, fieldNames));
        }
        
        return wrappedRecords;*/
    }
    
   public class RecordWrapper {
    @AuraEnabled
    public Map<String, Object> recordData { get; set; }
    
    public RecordWrapper(SObject record, List<String> fieldNames) {
        recordData = new Map<String, Object>();
        for (String fieldName : fieldNames) {
            recordData.put(fieldName, record.get(fieldName));
        }
    }
}

}