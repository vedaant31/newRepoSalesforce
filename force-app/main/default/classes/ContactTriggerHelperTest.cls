@isTest
private class ContactTriggerHelperTest {
    @isTest
    static void testUpdateAccount() {
        Account acc = new Account(Name = 'Tester Account');
        insert acc;

        Contact con = new Contact(LastName = 'Tester Contact', AccountId = acc.Id);
        insert con;

        Map<Id, Contact> oldMap = new Map<Id, Contact>{con.Id => con};
        Test.startTest();
        ContactTriggerHelper.updateAccount(new List<Contact>{con}, oldMap);
        Test.stopTest();
        List<Account> updatedAccounts = [SELECT Id, NoOfContact__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(1, updatedAccounts.size());

        Account updatedAccount = updatedAccounts[0];
        System.assertEquals('1', updatedAccount.NoOfContact__c, 'Number of contacts for the account should be updated to 1');
    }
}