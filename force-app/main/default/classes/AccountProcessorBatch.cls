global class AccountProcessorBatch implements Database.Batchable<sObject> {
    // Collect the batches of records to be passed to execute
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // Select accounts having at least one order with 'Ordered' status
        return Database.getQueryLocator(
            [  SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN (SELECT AccountId FROM Order WHERE Status = 'Ordered')]);
    }

    // Process each batch of records
    global void execute(Database.BatchableContext bc, List<Account> scope) {
        Set<Id> sAccountToRecalculate = (new Map<Id, SObject>(scope)).keySet();       
        AccountManager.calculateAmount(sAccountToRecalculate);
    }

    // Execute post-processing operations if any
    global void finish(Database.BatchableContext bc) {
    }
}