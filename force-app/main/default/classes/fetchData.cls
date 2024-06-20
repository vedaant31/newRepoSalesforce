public with sharing class fetchData {
    
    @AuraEnabled
    public static Map<String, String> getAllObject(){
        Map<String,String> returnObjectMap = new Map<String,String>();
        
        Map<String, Schema.SObjectType> objectMap = Schema.getGlobalDescribe();
        
        for(Schema.SObjectType objType : objectMap.values()){
            String key = objType.getDescribe().getName();
            String value = objType.getDescribe().getLabel();
            returnObjectMap.put(key, value);
        }
        
        return returnObjectMap;
    }
    
    @AuraEnabled 
    public static List<Map<String, String>> getAllfields(String objectName){
        List<Map<String, String>> allFields = new List<Map<String, String>>();
        
        Map<String, Schema.SObjectType> objectMap = Schema.getGlobalDescribe();
        SObjectType objType = objectMap.get(objectName);
        
        Map<String,Schema.SObjectField> objTypeFields = objType.getDescribe().fields.getMap();
        
        for (String fieldName : objTypeFields.keySet()) {
            Map<String, String> fieldMap = new Map<String, String>();
            fieldMap.put('value', fieldName);
            fieldMap.put('label', objTypeFields.get(fieldName).getDescribe().getLabel());
            allFields.add(fieldMap);
        }
        
        return allFields;
    }
    
    @AuraEnabled
    public static List<sObject> fetchRecords(String objectName, List<String> fieldNames) {
        String query = 'SELECT ';
        for (String field : fieldNames) {
            query += field + ', ';
        }
        query = query.substring(0, query.length() - 2); 

        query += ' FROM ' + objectName;

        try {
            return Database.query(query);
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching records: ' + e.getMessage());
        }
    }
}