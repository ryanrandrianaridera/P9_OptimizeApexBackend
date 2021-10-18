@isTest
private class CalculateOrderNetAmountTest {

    @TestSetup
    //Set up from TestDataFactorry the data for one account and one order
    static void setup() {
        Account acc = TestDataFactory.createAccount('AccountTestTrigger');
        Product2 product2 = TestDataFactory.createProduct();
        PricebookEntry priceBookEntry = TestDataFactory.createPriceBookEntry(product2.Id, 100);
        Contract contract = TestDataFactory.createContract(acc.id);
        contract.Status = 'Activated';
        update contract;
        Order order = TestDataFactory.createOrder(acc.Id, contract.Id);
        OrderItem orderItem = TestDataFactory.createOrderItem(order.Id, product2.Id, 1, 1000, priceBookEntry.Id);
    }

    @isTest
    static void NetAmountForOneAccountOneOrderTest() {

        Account acc = [SELECT Id FROM Account WHERE Account.Name = 'AccountTestTrigger'];
        Order order = [SELECT Id, ShipmentCost__c, TotalAmount,NetAmount__c FROM Order WHERE Account.Name = 'AccountTestTrigger'];

        order.shipmentCost__c = 100;
        decimal netToTest = order.TotalAmount - order.shipmentCost__c;

        Test.startTest();
        update(order);
        Test.stopTest();
        
//900 = 1 Order * 1000 UnitPrice - 100 shipmentCost
        Order netCalculated = [SELECT NetAmount__c FROM Order];
        System.assertEquals(netCalculated.NetAmount__c, netToTest);
    }

    /*
    // Declare common test variables
    static Integer shipmentAmount;
    static Integer netAmountExpected;
    // Declare method for variables initialization
    static void setup() {
        shipmentAmount = 50;
        netAmountExpected =
            TestDataFactory.ITEM_QUANTITY * TestDataFactory.UNIT_PRICE -
            shipmentAmount;
    }
    @isTest
    static void testNetAmountOnUpdateSingleOrder() {
        // Use the setup method to assign values to common test variables
        setup();
        // Create one account with one order by calling an utility method
        TestDataFactory.insertTestData(1, 1);

        // Get Order record to update
        Order order = [SELECT id FROM Order LIMIT 1];

        // Set Order Shipment Cost value
        order.ShipmentCost__c = shipmentAmount;

        // Perform test
        Test.startTest();
        Database.SaveResult result = Database.update(order, false);
        Test.stopTest();

        // Verify that the update was successful and
        // that the Net Amount corresponds to the expected value
        System.assert(result.isSuccess());
        order = [SELECT id, NetAmount__c FROM Order WHERE id = :result.getId()];
        System.assertEquals(
            netAmountExpected,
            order.NetAmount__c,
            'NetAmount incorrect'
        );
    }
    @isTest
    static void testNetAmountOnUpdateBulkOrders() {
        // Initialize local varibles
        Set<Id> orderIds = new Set<Id>();
        // Use the setup method to assign values to common test variables
        setup();

        // Create several accounts with orders by calling an utility method
        TestDataFactory.insertTestData(5, 2);

        // Get Order records to update
        Order[] orders = [SELECT id FROM Order];

        // Set Order Shipment Cost value for each record
        for (Order order : orders) {
            order.ShipmentCost__c = shipmentAmount;
        }

        // Perform test
        Test.startTest();
        Database.SaveResult[] results = Database.update(orders, false);
        Test.stopTest();

        // For each record, verify that the update was successful
        for (Database.SaveResult result : results) {
            System.assert(result.isSuccess());
            orderIds.add(result.getId());
        }
        // Verify that the Net Amount of each Order corresponds to the expected value
        for (Order order : [
            SELECT id, NetAmount__c
            FROM Order
            WHERE id IN :orderIds
        ]) {
            System.assertEquals(
                netAmountExpected,
                order.NetAmount__c,
                'NetAmount incorrect'
            );
        }
    }
    */
}