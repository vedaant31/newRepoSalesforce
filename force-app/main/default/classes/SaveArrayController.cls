public with sharing class SaveArrayController {
    @AuraEnabled
    public static void saveArray(List<Double> numericArray) {
        system.debug(numericArray);
        MonthValues__c obj = new MonthValues__c();
        obj.JanQty__c = numericArray[0];
         obj.FebQty__c = numericArray[1];

        obj.MarQty__c = numericArray[2];
        
        
        insert obj;
    }
}