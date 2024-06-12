public class AccountController {
    @AuraEnabled
    public static List<Account> saveAccounts(List<Account> accounts) {
        List<Account> insertedAccounts = new List<Account>();
        if (accounts != null && !accounts.isEmpty()) {
            try {
                insert accounts;
                insertedAccounts.addAll(accounts);
                System.debug('Accounts inserted: ' + insertedAccounts);
            } catch (Exception e) {
                System.debug('Error saving accounts: ' + e.getMessage());
            }
        }
        system.debug(accounts);
        return accounts;
    }
}