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
    
}