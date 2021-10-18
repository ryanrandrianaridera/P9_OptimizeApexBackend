@isTest
private class UpdateAccountTotalRevenueTest {
   
    @TestSetup

    //Create data from TestDataFactory for One account and 500 orders
  static void setup(){
     Account acc = TestDataFactory.createAccount('AccountTest');
      List <Order> ordersList = TestDataFactory.createAccountWithOrders(500, acc.Id);  
  }
 
@isTest
  static void NetAmountOfOneAccountWithSeveralOrders(){
     
    List <Order> ordersList = [SELECT AccountId, ShipmentCost__c,TotalAmount,NetAmount__c FROM Order WHERE Account.Name = 'AccountTest'];
      
                  Decimal total =0; 
               Decimal netToTest =0;
                 Decimal netShip = 0;       
      
      for(Order ord : ordersList) {
               ord.Status = 'Ordered';
              ord.ShipmentCost__c= 10;           
                                   
             system.debug('shipcost'+ ord.ShipmentCost__c);
      // Get the total amount of the ShipmentCost for all orders
        
                   total += ord.TotalAmount;
                  netShip += ord.ShipmentCost__c ; 
                     netToTest = total - netShip;
     }
      
     Test.startTest();
   update ordersList; 
   Test.stopTest();  
            
 //  (500 orders * 100 unitprice)- 500*10 = 45000
   
     System.assertEquals(50000, total) ; 
     System.assertEquals(5000, netShip) ;
     System.assertEquals(45000 ,netToTest);  
  } 

   /*
    @isTest
    static void testAccountTotalRevenueOnOrderUpdate() {
        // Initialize variables
        Set<Id> orderIds = new Set<Id>();
        Integer numbOrders = 200;
        Integer totalRevenueExpected =
            numbOrders *
            TestDataFactory.ITEM_QUANTITY *
            TestDataFactory.UNIT_PRICE;
        // Create one account with  more then 100 orders by calling an utility method
        TestDataFactory.insertTestData(1, numbOrders);
        // Get Order records to update
        Order[] orders = [SELECT id FROM Order];
        // Set new order status for each record
        for (Order order : orders) {
            order.Status = TestDataFactory.FINAL_ORDER_STATUS;
        }
        //Perform test
        Test.startTest();
        Database.SaveResult[] results = Database.update(orders, false);
        Test.stopTest();

        // For each record, verify that the update was successful
        for (Database.SaveResult result : results) {
            System.assert(result.isSuccess());
            orderIds.add(result.getId());
        }
        // Find all accounts with updated orders
        List<Account> accounts = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN (SELECT AccountId FROM Order WHERE id IN :orderIds) ];
        // Verify that Total Revenue of each Account corresponds to the expected value
        for (Account account : accounts) {
            System.assertEquals(
                totalRevenueExpected,
                account.Chiffre_d_affaire__c,
                'Incorrect value of Account Total Revenue'
            );
        }
    }
    */
}