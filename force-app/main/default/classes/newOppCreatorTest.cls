@isTest
public class newOppCreatorTest {
    @testSetup
    static void setup() {
        Id pricebookId = Test.getStandardPricebookId();     
        Product2 product = new Product2(Name = 'Test Product', ProductCode = 'TP01', IsActive = true);
        insert product;
        Product2 productt = new Product2(Name = 'Test Product 2', ProductCode = 'TP02', IsActive = true);
        insert productt;
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = product.Id,
            UnitPrice = 100,
            IsActive = true
        );
        insert pbe;
        PricebookEntry pbe2 = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = productt.Id,
            UnitPrice = 200,
            IsActive = true
        );
        insert pbe2;
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today(),
            AccountId = acc.Id
        );
        insert opp;
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId = opp.Id,
             Product2Id = product.Id,
            PricebookEntryId = pbe.Id,
            Quantity = 1,
            TotalPrice = 100,
            Product_Type__c = 'Subscription'
        );
        insert oli;
        
         OpportunityLineItem oli2 = new OpportunityLineItem(
            OpportunityId = opp.Id,
             Product2Id = productt.Id,
            PricebookEntryId = pbe2.Id,
            Quantity = 3,
           
            TotalPrice = 600,
            Product_Type__c = 'Non Subscription'
        );   

        insert oli2;
    }
    @isTest
    static void testOpportunityCloneAndRelatedRecords() {
        Opportunity opp = [SELECT Id, StageName FROM Opportunity WHERE Name = 'Test Opportunity' LIMIT 1];
        opp.StageName = 'Closed Won';
        update opp;
        
        List<Opportunity> newOpps = [SELECT Id, StageName, CloseDate, related_Opportunity__c FROM Opportunity WHERE related_Opportunity__c = :opp.Id];
       System.assertEquals(1, newOpps.size());
       Opportunity newOpp = newOpps[0];
        System.assertEquals('New', newOpp.StageName);
        System.assertEquals(Date.today().addMonths(1), newOpp.CloseDate);
        System.assertEquals(opp.Id, newOpp.related_Opportunity__c);
        
 		List<OpportunityLineItem> newOliList = [SELECT Id, OpportunityId, Product2Id, Quantity, TotalPrice, PricebookEntryId FROM OpportunityLineItem WHERE OpportunityId = :opp.Id];
         System.assertEquals(2, newOliList.size());
       OpportunityLineItem newOli = newOliList[0];
        System.assertEquals(1, newOli.Quantity);
       System.assertEquals(100, newOli.TotalPrice);
       List<Entitlement> entitlements = [SELECT Id, Name, Opportunity__c, AccountId FROM Entitlement WHERE Opportunity__c = :opp.Id];
      System.assertEquals(1, entitlements.size());
  
    }
}