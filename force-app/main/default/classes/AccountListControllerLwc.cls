public with sharing class AccountListControllerLwc {
    @AuraEnabled(cacheable=true)
  
        public static List<Account> queryAccountsByRevenue(Decimal annualRevenue) {
          return [Select name from account where annualRevenue>= :AnnualRevenue	];
        }

}