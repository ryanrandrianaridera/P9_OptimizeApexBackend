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
 
    /*
   public static void calculateAmount(Set<Id> sAccountToRecalculate){
        // Get order list with status Ordered
        List<Order> lOrders = [SELECT Id, TotalAmount, NetAmount__c, AccountId FROM Order WHERE AccountId IN :sAccountToRecalculate AND Status = 'Ordered'];
        // Create a map with Id, Amount
        Map<Id, Decimal> mAccountAmount = new Map<Id, Decimal>();
        // Loop through them 
        for(Order o : lOrders){
            Decimal amount = mAccountAmount.get(o.AccountId);
            // update amount
            if(amount != null){
                amount += o.NetAmount__c;
                mAccountAmount.put(o.AccountId, amount);
            }
            else{
                mAccountAmount.put(o.AccountId, o.NetAmount__c);
            }
        }

        // on boucle sur notre map
                // cree un account avec l'id et le chiffre d'affaire
                // new Account(Id= map.id, CA=map.value)
                // on isere l'accout dans une liste

            List<Account> lAccountToUpdate = new List<Account>();

            for (Id accountId : mAccountAmount.keySet()) {
                lAccountToUpdate.add(new Account(Id= accountId, Chiffre_d_affaire__c = mAccountAmount.get(accountId) ));
            }
// on update la liste
            update lAccountToUpdate;         
    }
    */
}