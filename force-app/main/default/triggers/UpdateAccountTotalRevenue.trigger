trigger UpdateAccountTotalRevenue on Order (after update) {
	// Declare a new Set of Account Ids
    set<Id> sAccountToRecalculate = new set<Id>();

    // Populate the above Set with Account Ids corresponding to certain conditions
    for(Order newOrder : Trigger.New){
        if (
          newOrder.Status == 'Ordered' &&
          newOrder.Status != Trigger.oldMap.get(newOrder.Id).Status
         ) {
        
        sAccountToRecalculate.add(newOrder.AccountId);
        }
    
        // Call the service
    if(sAccountToRecalculate.size() > 0){
        AccountManager.calculateAmount(sAccountToRecalculate);
        }  
    }    
} 