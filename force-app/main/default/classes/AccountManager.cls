public with sharing class AccountManager {
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
                lAccountToUpdate.add(new Account(Id= accountId, Chiffre_affaire__c = mAccountAmount.get(accountId) ));
            }

            update lAccountToUpdate; 

        // on update la liste
    }
}