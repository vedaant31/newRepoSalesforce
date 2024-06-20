public with sharing class DynamicFieldQuery {
        @AuraEnabled(cacheable=true)

    public static List<SObject> getRecords(String objectName, List<String> fields) {
        // Validate input
        if (String.isBlank(objectName) || fields==null) {
            throw new IllegalArgumentException('Object name and fields cannot be blank.');
        }
        

        for (Integer i = 0; i < fields.size(); i++) {
            fields[i] = fields[i].trim();
        }
        
        String query = 'SELECT ' + String.join(fields, ',') + ' FROM ' + objectName;
        
        List<SObject> results;
            results = Database.query(query);
        
        
        return results;
    }

}