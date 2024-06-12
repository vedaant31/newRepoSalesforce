public with sharing class productController {
    @AuraEnabled(cacheable=true)
    public static List<ProductWrapper> getProducts() {
        List<ProductWrapper> productsWithPrices = new List<ProductWrapper>();

        List<Product2> products = [SELECT Id, 
                                   Name, 
                                   TotalQty__c, 
                                   TotalYearPrice__c, 
                                   JanQty__c, 
                                   FebQty__c, 
                                   MarQty__c, 
                                   AprQty__c, 
                                   MayQty__c, 
                                   JunQty__c, 
                                   JulQty__c, 
                                   AugQty__c, 
                                   SepQty__c, 
                                   OctQty__c, 
                                   NovQty__c, 
                                   DecQty__c,
                                   (SELECT UnitPrice 
                                    FROM PricebookEntries 
                                    WHERE Pricebook2.Name = 'Standard') 
                                   FROM Product2];

        for (Product2 prod : products) {
            for (PricebookEntry pbe : prod.PricebookEntries) {
                productsWithPrices.add(new ProductWrapper(
                    prod.Id, 
                    prod.Name, 
                    pbe.UnitPrice,
                    prod.TotalQty__c,
                    prod.TotalYearPrice__c,
                    prod.JanQty__c,
                    prod.FebQty__c,
                    prod.MarQty__c,
                    prod.AprQty__c,
                    prod.MayQty__c,
                    prod.JunQty__c,
                    prod.JulQty__c,
                    prod.AugQty__c,
                    prod.SepQty__c,
                    prod.OctQty__c,
                    prod.NovQty__c,
                    prod.DecQty__c
                ));
            }
        }

        return productsWithPrices;
    }

    @AuraEnabled
    public static void saveProductData(List<Product2> products) {
        try {
            System.debug(products);
        } catch (Exception e) {
            throw new AuraHandledException('Error saving product data: ' + e.getMessage());
        }
    }

    public class ProductWrapper {
        @AuraEnabled
        public Id productId { get; set; }
        @AuraEnabled
        public String name { get; set; }
        @AuraEnabled
        public Decimal unitPrice { get; set; }
        @AuraEnabled
        public Decimal totalQty { get; set; }
        @AuraEnabled
        public Decimal totalYearPrice { get; set; }
        @AuraEnabled
        public Decimal janQty { get; set; }
        @AuraEnabled
        public Decimal febQty { get; set; }
        @AuraEnabled
        public Decimal marQty { get; set; }
        @AuraEnabled
        public Decimal aprQty { get; set; }
        @AuraEnabled
        public Decimal mayQty { get; set; }
        @AuraEnabled
        public Decimal junQty { get; set; }
        @AuraEnabled
        public Decimal julQty { get; set; }
        @AuraEnabled
        public Decimal augQty { get; set; }
        @AuraEnabled
        public Decimal sepQty { get; set; }
        @AuraEnabled
        public Decimal octQty { get; set; }
        @AuraEnabled
        public Decimal novQty { get; set; }
        @AuraEnabled
        public Decimal decQty { get; set; }

        public ProductWrapper(Id productId, String name, Decimal unitPrice, Decimal totalQty, Decimal totalYearPrice, 
                              Decimal janQty, Decimal febQty, Decimal marQty, Decimal aprQty, Decimal mayQty, 
                              Decimal junQty, Decimal julQty, Decimal augQty, Decimal sepQty, Decimal octQty, 
                              Decimal novQty, Decimal decQty) {
            this.productId = productId;
            this.name = name;
            this.unitPrice = unitPrice;
            this.totalQty = totalQty;
            this.totalYearPrice = totalYearPrice;
            this.janQty = janQty;
            this.febQty = febQty;
            this.marQty = marQty;
            this.aprQty = aprQty;
            this.mayQty = mayQty;
            this.junQty = junQty;
            this.julQty = julQty;
            this.augQty = augQty;
            this.sepQty = sepQty;
            this.octQty = octQty;
            this.novQty = novQty;
            this.decQty = decQty;
        }
    }
}