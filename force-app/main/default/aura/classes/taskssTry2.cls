public with sharing class taskssTry2 {
    public Quote quote { get; set; }
    public Opportunity opp { get; set; }
    public List<QuoteLineItem> quoteItems { get; set; }
    
    public taskssTry2() {
        // Get the Opportunity Id from the URL parameter
        String oppId = ApexPages.currentPage().getParameters().get('oppId');
        if (oppId != null) {
            opp = [SELECT Id, Name, Account.BillingStreet, Account.BillingCity, Account.BillingState, Account.BillingPostalCode, 
                          (SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingPostalCode FROM Quotes)
                   FROM Opportunity WHERE Id = :oppId LIMIT 1];
            
            if (opp.Quotes.size() > 0) {
                quote = opp.Quotes[0];
                quoteItems = [SELECT Id, Product2.Name, Quantity, UnitPrice FROM QuoteLineItem WHERE QuoteId = :quote.Id];
            }
        }
    }
}