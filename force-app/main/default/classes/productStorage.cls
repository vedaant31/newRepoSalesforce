public with sharing class productStorage{
    @AuraEnabled
    public static void saveProductData(List<Product2> products) {
        try {
            upsert products;
            system.debug(products);
        } catch (Exception e) {
            throw new AuraHandledException('Error saving product data: ' + e.getMessage());
        }
    }
    

    
    
	}