public with sharing class productGetter 
{    @AuraEnabled(cacheable=true)

      public static List<Product2> sendData() {
            
            List<Product2>UpdatedList=[SELECT Id, 
                                   TotalQty__c, TotalYearPrice__c,JanQty__c,FebQty__c, 
                                       MarQty__c, AprQty__c, MayQty__c, JunQty__c, 
                                       JulQty__c, AugQty__c, SepQty__c, OctQty__c, 
                                       NovQty__c, DecQty__c
                                   FROM Product2];
            
            return UpdatedList;
        }


}