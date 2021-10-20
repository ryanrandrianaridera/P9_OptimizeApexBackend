global with sharing class AccountProcessorScheduler implements Schedulable{

  global void execute (SchedulableContext sc) {

    AccountProcessorBatch sAccountToRecalculate = new AccountProcessorBatch();
    Id batchId = database.executeBatch(sAccountToRecalculate);

}
}