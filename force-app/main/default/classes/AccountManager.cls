public with sharing class AccountManager {
    
    public static void calculateAmount(Set<Id> sAccountToRecalculate) {
        // Select accounts using the account Ids from the set
        List<Account> accounts = [ SELECT Id, Chiffre_d_affaire__c , (SELECT TotalAmount FROM Orders WHERE Status = 'Ordered') FROM Account WHERE Id IN :sAccountToRecalculate ];
        // Iterate through accounts and their related orders (if present)
        // to calculate Account Total Revenue
        for (Account account : accounts) {
            account.Chiffre_d_affaire__c = 0;
            if (account.Orders != null && account.Orders.size() > 0) {
                for (Order order : account.Orders) {
                    account.Chiffre_d_affaire__c += order.TotalAmount;
                }
            }
        }
        // Update the database
        update accounts;
    }
}