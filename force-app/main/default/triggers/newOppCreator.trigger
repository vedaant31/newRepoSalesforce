trigger newOppCreator on Opportunity (after update) {
    List<Opportunity> opportunitiesToClone = new List<Opportunity>();
    Map<Id, Opportunity> originalOppMap = new Map<Id, Opportunity>();

    for (Opportunity opp : Trigger.new) {
        if (opp.StageName == 'Closed Won' && Trigger.oldMap.get(opp.Id).StageName != 'Closed Won') {
            Opportunity newOpp = opp.clone(false, true, true, false);
            newOpp.CloseDate = opp.CloseDate.addMonths(1);
            newOpp.StageName = 'New';
            newOpp.related_Opportunity__c = opp.Id;
            opportunitiesToClone.add(newOpp);
            originalOppMap.put(opp.Id, opp);
        }
    }

    if (!opportunitiesToClone.isEmpty()) {
        insert opportunitiesToClone;
        system.debug('Inserted Opportunities: ' + opportunitiesToClone);

        Map<Id, Id> oldToNewOppMap = new Map<Id, Id>();
        for (Opportunity clonedOpp : opportunitiesToClone) {
            oldToNewOppMap.put(clonedOpp.related_Opportunity__c, clonedOpp.Id);
        }
        system.debug('oldToNewOppMap: ' + oldToNewOppMap);

        List<OpportunityLineItem> oppLineItems = [
            SELECT Id, OpportunityId, Product2Id, Quantity, UnitPrice, TotalPrice, PricebookEntryId, Product_Type__c,name
            FROM OpportunityLineItem
            WHERE OpportunityId IN :originalOppMap.keySet()
        ];
        system.debug('oppLineItems: ' + oppLineItems);

        List<OpportunityLineItem> newOppLineItems = new List<OpportunityLineItem>();
        List<Entitlement> newEntitlements = new List<Entitlement>();
        List<Asset> newAssets = new List<Asset>();

        for (OpportunityLineItem oli : oppLineItems) {
            OpportunityLineItem newOli = new OpportunityLineItem();
            newOli.OpportunityId = oldToNewOppMap.get(oli.OpportunityId);
            newOli.Product2Id = oli.Product2Id;
            newOli.Quantity = oli.Quantity;
            //newOli.UnitPrice = oli.UnitPrice;
            newOli.TotalPrice = oli.TotalPrice;
            newOli.PricebookEntryId = oli.PricebookEntryId;

            if (oli.Product_Type__c == 'Subscription') {
                Entitlement newEntitlement = new Entitlement();
                newEntitlement.Name = oli.Name;
                newEntitlement.Opportunity__c = oli.OpportunityId;
                newEntitlement.AccountId='001IS000005byHMYAY';

                newEntitlements.add(newEntitlement);
            } else if (oli.Product_Type__c == 'Non Subscription') {
                Asset newAsset = new Asset();
                newAsset.Name = oli.Name;
                newAsset.Opportunity__c = oli.OpportunityId;
                newAsset.AccountId='001IS000005byHMYAY';
                newAssets.add(newAsset);
            }
        }

       

        if (!newEntitlements.isEmpty()) {
            insert newEntitlements;
            system.debug('Inserted Entitlements: ' + newEntitlements);
        }

        if (!newAssets.isEmpty()) {
            insert newAssets;
            system.debug('Inserted Assets: ' + newAssets);
        }
    }
}