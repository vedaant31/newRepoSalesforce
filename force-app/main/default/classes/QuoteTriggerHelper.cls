public class QuoteTriggerHelper
{
    public static void solve(List<Quote> newList, Map<Id, Quote> newMap, List<Quote>oldList, Map<Id, Quote> oldMap) 
    {               Map<Id, Quote> opportunityUnPrimaryQuoteMap = new Map<Id, Quote>();
     
     system.debug('solve called');
     Set<Id> opportunityIds = new Set<Id>(); 
     Map<Id, Id> opportunityPrimaryQuoteMap = new Map<Id, Id>();
     List<Quote> quoteNewList = new List<Quote>();
     
     
     for (Quote newQuote : newList) {
         if (newQuote.OpportunityId != null && !newQuote.Primary_Quote__c && oldMap.get(newQuote.Id).Primary_Quote__c != newQuote.Primary_Quote__c)
         {
             opportunityIds.add(newQuote.OpportunityId);
             opportunityUnPrimaryQuoteMap.put(newQuote.Id, newQuote);
             
             quoteNewList.add(newQuote);
         }
     }       
     for (Opportunity opp : [SELECT Id, Quote__c, old_primary__c FROM Opportunity WHERE Id IN :opportunityIds ]) 
     {
         opportunityPrimaryQuoteMap.put(opp.Id, opp.Quote__c);
     }
     system.debug(opportunityPrimaryQuoteMap);
     List<Opportunity> toUpdateOpportunities = new List<Opportunity>();
     List<Quote> toUpdateQuotes = new List<Quote>();
     
     if(!quoteNewList.isEmpty()){
         for (Quote qt : quoteNewList)
         {
             
             if(qt.Opportunityid!=null ){
                 
                 Opportunity opp = new Opportunity(Id = qt.OpportunityId);
                 Id prevPrimaryQuoteId = opportunityPrimaryQuoteMap.get(qt.OpportunityId);
                 system.debug('current primary quote id'+ qt.id);
                 system.debug('prev primary quote id'+ prevPrimaryQuoteId);                
                 if (qt.Primary_Quote__c) {
                     
                     opp.old_primary__c = prevPrimaryQuoteId;
                     opp.Quote__c =  qt.Id;
                     toUpdateOpportunities.add(opp);
                 }
                 
                 else if(opportunityUnPrimaryQuoteMap.containsKey(qt.Id) && !qt.Primary_Quote__c  )
                 {
                     system.debug('primary quote true---> false case');
                     opp.old_primary__c=qt.Id;
                     opp.Quote__c=null;
                     toUpdateOpportunities.add(opp);
                     
                 }
                 if (prevPrimaryQuoteId != null) {
                     Quote primaryQuote = new Quote(Id = prevPrimaryQuoteId, Primary_Quote__c = false);
                     toUpdateQuotes.add(primaryQuote);
                 }  
             }
         }
     }
     
     if (!toUpdateOpportunities.isEmpty()) {
         update toUpdateOpportunities;
     }        
     if (!toUpdateQuotes.isEmpty()) {
         update toUpdateQuotes;
     }
     
     /*if(!quoteNewList.isEmpty()){
unPrimaryQuote(quoteNewList, oldMap);
}*/
     
     
    }
    
    /*  public static void unPrimaryQuote(List<Quote> newList, Map<Id, Quote> oldMap ){

Map<Id, Quote> opportunityUnPrimaryQuoteMap = new Map<Id, Quote>();
Map<Id, Id> opportunityPrimaryQuoteMap = new Map<Id, Id>();

List<Quote> quoteNewList = new List<Quote>();
List<Quote> toUpdateQuotes = new List<Quote>();
Set<Id> OppIdSetForUnPrimary = New Set<Id>();
List<Opportunity> toUpdateOpportunities2 = new List<Opportunity>();
String UnPrimary;
Opportunity opp;
for(Quote qc :newList){
if(qc.OpportunityId != null && !qc.Primary_Quote__c && oldMap.get(qc.Id).Primary_Quote__c != qc.Primary_Quote__c){
OppIdSetForUnPrimary.add(qc.OpportunityId);
opportunityUnPrimaryQuoteMap.put(qc.Id, qc);
}
}
for (Opportunity oppt : [SELECT Id, Quote__c, old_primary__c FROM Opportunity WHERE Id IN :OppIdSetForUnPrimary ]) 
{
opportunityPrimaryQuoteMap.put(opp.Id, oppt.Quote__c);
}



if(!OppIdSetForUnPrimary.isEmpty()){
// for(Opportunity oppt : [Select id,  Quote__c, old_primary__c,(Select id, Primary_Quote__c from Quotes) from Opportunity where ID IN: OppIdSetForUnPrimary])
// {
//  system.debug('oppt.Quotes------>'+oppt.Quotes);
for(Quote qt :newList){
if(!qt.Primary_Quote__c && opportunityUnPrimaryQuoteMap.containsKey(qt.Id)){
opp = new Opportunity();
opp.Id =qt.OpportunityId;
opp.Quote__c = null;

opp.old_primary__c = opportunityUnPrimaryQuoteMap.get(qt.Id).Id;
toUpdateOpportunities2.add(opp);

} 

else{
Id prevPrimaryQuoteId = opportunityPrimaryQuoteMap.get(qt.OpportunityId);
opp = new Opportunity();

opp.old_primary__c = prevPrimaryQuoteId;
opp.Quote__c =  qt.Id;
toUpdateOpportunities2.add(opp);

if (prevPrimaryQuoteId != null) {
Quote primaryQuote = new Quote(Id = prevPrimaryQuoteId, Primary_Quote__c = false);
toUpdateQuotes.add(primaryQuote);
}  

}
}
//}
if (!toUpdateOpportunities2.isEmpty()) {
update toUpdateOpportunities2;
} 

if(!quoteNewList.isEmpty()){
unPrimaryQuote(quoteNewList, oldMap);
}
}
}
*/
    
    public static void PrimaryDelete(List<Quote> oldQuotes,Map<Id, Quote> oldMap) {
        system.debug('Hi');
        for (Quote deletedQuote : oldQuotes) {
            if (deletedQuote!=null &&deletedQuote.Primary_Quote__c) {
                deletedQuote.addError('Cannot delete primary quote');
            }
        }
    }
}