public class OpportunityHelper {
    public static void cloneOpportunityLineItems(List<Opportunity> newOpportunities,set<Id>oppID) {
        
        Set<Id> originalOppIds = new Set<Id>();
        Map<Id, Id> oppIdMap = new Map<Id, Id>();

        for (Opportunity newOpp : newOpportunities) {
            originalOppIds.add(newOpp.Id);
        }

        List<OpportunityLineItem> originalLineItems = [SELECT Id, OpportunityId, Quantity, PricebookEntryId, UnitPrice, ServiceDate, Description 
                                                       FROM OpportunityLineItem 
                                                       WHERE OpportunityId IN :originalOppIds];
        
        system.debug('New--->'+originalOppIds);

        List<OpportunityLineItem> lineItemsToInsert = new List<OpportunityLineItem>();

        for (OpportunityLineItem oli : originalLineItems) {
            OpportunityLineItem newOli = oli.clone(false, false, false, false);
            newOli.OpportunityId = oppIdMap.get(oli.OpportunityId);
            lineItemsToInsert.add(newOli);
        }

        if (!lineItemsToInsert.isEmpty()) {
            insert lineItemsToInsert;
        }

    }
    
    
}