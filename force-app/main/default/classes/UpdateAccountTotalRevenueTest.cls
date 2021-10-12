@isTest
private class UpdateAccountTotalRevenueTest {
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
}