@isTest
private class AccountProcessorBatchTest {
    @isTest
    static void testAccountTotalRevenueUpdate() {
        // Initialize variables
        Integer numbAccounts = 50;
        Integer numbOrders = 2;
        Integer totalRevenueExpected = numbOrders * TestDataFactory.ITEM_QUANTITY * TestDataFactory.UNIT_PRICE;
        // Load test data
        TestDataFactory.insertTestData(numbAccounts, numbOrders);
        // Get Order records to update
        Order[] orders = [SELECT id FROM Order];
        // Set new order status for each record
        for (Order order : orders) {
            order.Status = TestDataFactory.FINAL_ORDER_STATUS;
        }
        update orders;

        // Perform the test
        Test.startTest();
        AccountProcessorBatch processor = new AccountProcessorBatch();
        Id batchId = Database.executeBatch(processor);
        Test.stopTest();

        // Assert records were updated properly
        List<Account> updatedAccounts = [
            SELECT Id, Chiffre_d_affaire__c
            FROM Account
            WHERE Id IN (SELECT AccountId FROM Order WHERE Status = 'Ordered')
        ];
        System.assertEquals(
            numbAccounts,
            updatedAccounts.size(),
            'ERROR: At least 1 Account record not updated correctly'
        );
        // Verify that Total Revenue of each account corresponds to the expected value
        for (Account account : updatedAccounts) {
            System.assertEquals(
                totalRevenueExpected,
                account.Chiffre_d_affaire__c,
                'Incorrect value of Account Total Revenue'
            );
        }
    }
}