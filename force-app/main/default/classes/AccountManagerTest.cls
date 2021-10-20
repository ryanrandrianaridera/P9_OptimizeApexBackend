@isTest 
public with sharing class AccountManagerTest {
    @TestSetup
    //Set up from TestDataFactorry the data for one account and one order
    static void setup() {
        Account acc = TestDataFactory.createAccount('CATest');
        Product2 product = TestDataFactory.createProduct();
        PricebookEntry priceBookEntry = TestDataFactory.createPriceBookEntry(product.Id, 100);
        Contract contract = TestDataFactory.createContract(acc.id);
        contract.Status = 'Activated';
        update(contract);
        Order order = TestDataFactory.createOrder(acc.Id, contract.Id);
        order.Status = 'Draft';
        update(order);   
        OrderItem orderItem = TestDataFactory.createOrderItem(order.Id, product.Id, 5, 1000, priceBookEntry.Id);
    }
    @isTest     
   static void updateChiffreAffaireForAccountWhenStatusOrdered() {
    Account accCA = [SELECT Chiffre_d_affaire__c FROM Account WHERE Account.Name = 'CATest'];
    Order order = [SELECT Id FROM Order WHERE Account.Name = 'CATest'];  

    Test.startTest();
    order.Status = 'Ordered';
    update(order);
    Test.stopTest();
   //3000 = 3 orders * 1000 UnitPrice
   System.assertEquals(accCA.Chiffre_d_affaire__c, 5000);
}
}   