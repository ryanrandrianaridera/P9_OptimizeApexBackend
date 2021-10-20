@isTest
private class AccountProcessorBatchTest {
    
    //Set up the data from TestDataFactory class
    @TestSetup
    static void setup(){
        
        Account acc1 = TestDataFactory.createAccount('AccountTest');
        List <Order> ordersList = TestDataFactory.createAccountWithOrders(40, acc1.Id);
        // Set up the order status to 'Ordered'
        for( Order order : ordersList){
            order.Status = 'Ordered';
            update order;  
        }
        Account acc2 = TestDataFactory.createAccount('TestAccount');
        List <Order> ordersList2 = TestDataFactory.createAccountWithOrders(20, acc2.Id);
        // Set up the order status to 'Ordered'
        for( Order order : ordersList2){
            order.Status = 'Ordered';
            update order;  
        }
        
        system.debug('list2'+ordersList2);
        system.debug('list1'+ordersList);
    }
    
    @isTest 
    static void UpdateAllAccountsBatchTest() {
        
        //Test the batch using the data defined in the previous set up  
        
        Test.startTest();
        List<Account> accs =[SELECT Id, Chiffre_d_affaire__c, (SELECT Id, Status, TotalAmount FROM Orders 
                                                               WHERE Status = 'Ordered') FROM Account 
                             WHERE Id IN (SELECT AccountId FROM Order WHERE Status = 'Ordered')];
        
        AccountProcessorBatch upAccs = new AccountProcessorBatch();
        Id batchId = Database.executeBatch(upAccs);
        
        // Check New Acc CA
        List<Account> batchList = [SELECT ID, Chiffre_d_affaire__c FROM Account WHERE ID IN (SELECT AccountID FROM Order WHERE Status = 'Ordered')];
        
        Test.stopTest();
        
        
        //acc1 :  40 orders *100 unitPrice  = 4000
        //acc1 :  20 orders *100 unitPrice  = 2000
        System.assertEquals(4000, batchList[0].Chiffre_d_affaire__c);
        System.assertEquals(2000, batchList[1].Chiffre_d_affaire__c);
        
    } 
}