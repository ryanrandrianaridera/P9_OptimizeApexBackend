@isTest 
public with sharing class AccountManagerTest {
    @isTest     
   static void updateChiffreAffaireForAccountWhenStatusOrdered() {  
           
        Account acc = TestDataFactory.createAccount('CATest');
        Product2 product = TestDataFactory.createProduct();
        PricebookEntry priceBookEntry = TestDataFactory.createPriceBookEntry(product.Id, 100);
        Contract contract = TestDataFactory.createContract(acc.id);
        Order order = TestDataFactory.createOrder(acc.Id, contract.Id); //createOrder(acc.Id, priceBookEntry);
        OrderItem orderItem = TestDataFactory.createOrderItem(order.Id, product.Id, 3 , 1000, priceBookEntry.Id);
      
       Test.startTest();
        order.Status = 'Ordered';
        update order;
        Test.stopTest();
       
        Account accCA = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id ];
       
//3000 = 3 orders * 1000 UnitPrice
        System.assertEquals(accCA.Chiffre_d_affaire__c, 3000);
    }
}
