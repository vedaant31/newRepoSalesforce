trigger assing2 on Quote (after insert, after update) {
    
List<Opportunity> opportunities = [SELECT Id, Quote__c, old_primary__c FROM Opportunity WHERE Id = :trigger.new[0].OpportunityId];
    system.debug(opportunities);
    List<Opportunity> toUpdate = new List<Opportunity>();
        List<Quote> toUpdateQuotes = new List<Quote>();

    Id primaryQuoteId=null;
    for (Quote quote : Trigger.new) 
    {
        Opportunity opp = new Opportunity(Id = quote.OpportunityId);
        if (quote.Primary_Quote__c) {
                 if(opportunities[0].Quote__c!=null)
                 {
                      primaryQuoteId= opportunities[0].Quote__c;
                 }
                system.debug(quote.Id);               
                opp.old_primary__c = opportunities[0].Quote__c ;  
                system.debug(opp.old_primary__c);
                opp.Quote__c = quote.Id;      
                toUpdate.add(opp);
            }
        }
    if (primaryQuoteId != null) {
                Quote qq = new Quote(Id = primaryQuoteId, Primary_Quote__c = false);
                toUpdateQuotes.add(qq);
            }
        
    

    if (!toUpdateQuotes.isEmpty()) {
        update toUpdateQuotes;
    }

    if (!toUpdate.isEmpty()) {
        update toUpdate;
    }
}