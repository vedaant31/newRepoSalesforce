public class QuoteTriggerHandler {
    
    public static void onAfterInsert(List<Quote> newList,Map<Id,Quote> newMap,List<Quote>oldList, Map<Id,Quote>oldMap){
        for(Quote qt: newList)
        {            
            if(qt.OpportunityId!=null && newList!=null && qt.Primary_Quote__c && oldMap==null){
                system.debug('insert case');
        QuoteTriggerHelper.solve(newList,newMap,oldList,oldMap );
            }
        }
    }
    
    public static void onAfterUpdate(List<Quote> newList,Map<Id,Quote> newMap,List<Quote> oldList,Map<Id,Quote> oldMap){
        
        for(Quote qt:newList)
        {
            
            //case-->1 agar non primary quote ko primary krdiya
            
            if((qt.OpportunityId != null && qt.Primary_Quote__c && oldMap.get(qt.Id).Primary_Quote__c != qt.Primary_Quote__c) ||
              qt.OpportunityId != null && !qt.Primary_Quote__c && oldMap.get(qt.Id).Primary_Quote__c != qt.Primary_Quote__c)
            {
                system.debug('case1');
                QuoteTriggerHelper.solve(newList,newMap,oldList,oldMap);
            }
            
            // case-->2 agar pehele primary ho aur ab primary na ho
          /* else if(qt.OpportunityId!=null & oldMap.get(qt.Id).Primary_Quote__c==true && qt.Primary_Quote__c==false )
            {
                system.debug('ab yeh waala case hai');
                    
                    QuoteTriggerHelper.solve(newList,newMap,oldList,oldMap);
              }
*/

            
        }
    }
    
    public static void onBeforeDelete(List<Quote> oldList,Map<Id,Quote> oldMap){
        
        
        QuoteTriggerHelper.PrimaryDelete(oldList,oldMap);
        
    }
    
    
}