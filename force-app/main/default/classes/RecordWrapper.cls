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