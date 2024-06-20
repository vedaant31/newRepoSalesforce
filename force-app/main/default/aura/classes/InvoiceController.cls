public class InvoiceController {
    public Opportunity opp { get; set; }
    public Quote qt { get; set; }
    
    public List<QuoteLineItem> qtLineItems { get; set; }
    public List<OpportunityLineItem> oppLineItems { get; set; }
   	
        public String CompanyName { get; set; }
        public String CompanyAddress { get; set; }
   		 public  Double TotalAmount{get; set;}
    public Double TaxValue{get;set;}
    public Double NetAmount{get; set;}
        public Double NetDiscount{get; set;}
    public Double DiscAmount{get; set;}
        public Double AfterDiscAmount{get; set;}
            public Double FinalAmount{get; set;}




    public String billerName { get; set; }
    public String billerAddress { get; set; }
    public String billerCity { get; set; }
    public String billerCountry { get; set; }
    public String billerPostal { get; set; }
    public String billerStreet { get; set; }
    
    public String receiverName { get; set; }
    public String receiverAddress { get; set; }
    public String receiverCity { get; set; }
    public String receiverCountry { get; set; }
    public String receiverPostal { get; set; }
    public String receiverStreet { get; set; }

    public InvoiceController() {
        String quoteId = ApexPages.currentPage().getParameters().get('id');
        
        if (String.isNotBlank(quoteId)) {
            qt = [SELECT Id, OpportunityId, BillingName, BillingCity, ShippingName, ShippingCity, BillingAddress, ShippingStreet, ShippingPostalCode, ShippingCountry,
                  BillingStreet, BillingPostalCode, BillingCountry,Subtotal,GST__c,Taxes__c,Discounts__c,Disc__c, net_disc_price__c,Final_amount__c
                  FROM Quote
                  WHERE Id = :quoteId
                  LIMIT 1];
            
            if (qt != null && qt.OpportunityId != null) {
                opp = [SELECT Id, AccountId
                       FROM Opportunity
                       WHERE Id = :qt.OpportunityId
                       LIMIT 1];
                
                if (opp != null && opp.AccountId != null) {
                    Account acc = [SELECT Id, Name, BillingCity
                                   FROM Account
                                   WHERE Id = :opp.AccountId
                                   LIMIT 1];
                    billerName = qt.BillingName;
                    billerCity = qt.BillingCity;
                    billerStreet = qt.BillingStreet;
                    billerPostal = qt.BillingPostalCode;
                    billerCountry = qt.BillingCountry;
                    receiverName = qt.ShippingName;
                    receiverCity = qt.ShippingCity;
                    receiverStreet = qt.ShippingStreet;
                    receiverPostal = qt.ShippingPostalCode;
                    receiverCountry = qt.ShippingCountry;

                    qtLineItems = [SELECT Product2.Name, UnitPrice, Quantity, TotalPrice
                                   FROM QuoteLineItem
                                   WHERE QuoteId = :qt.Id];
                                    CompanyName=acc.Name;
                    TotalAmount=qt.Subtotal;
                    TaxValue=qt.Taxes__c;
                    NetAmount=qt.GST__c;
                    
                    NetDiscount=qt.Disc__c;
                    DiscAmount=qt.Discounts__c;
                    AfterDiscAmount=qt.net_disc_price__c;
                    FinalAmount=qt.Final_amount__c;

                }
            }
        }
    }
}