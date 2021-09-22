trigger UpdateAccountCA on Order (after update) {
	
    set<Id> sAccountToRecalculate = new set<Id>();

    for(Order o : Trigger.New){
        sAccountToRecalculate.add(o.AccountId);
    }

    if(sAccountToRecalculate.size() > 0) AccountManager.calculateAmount(sAccountToRecalculate)
    
    /*
    for(integer i=0; i< trigger.new.size(); i++){
        Order newOrder= trigger.new[i];
       
        Account acc = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id =:newOrder.AccountId ];
        acc.Chiffre_d_affaire__c = acc.Chiffre_d_affaire__c + newOrder.TotalAmount;
        update acc;¨
    }
    */
}