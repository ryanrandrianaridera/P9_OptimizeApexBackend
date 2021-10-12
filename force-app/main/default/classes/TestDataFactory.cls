@isTest
public with sharing class TestDataFactory {
    public static final String INITIAL_ORDER_STATUS = 'Draft';
    public static final String FINAL_ORDER_STATUS = 'Ordered';
    public static final Id STANDARD_PRICEBOOK_ID = Test.getStandardPricebookId();
    public static final Integer UNIT_PRICE = 100;
    public static final Integer ITEM_QUANTITY = 10;

    // Construct a list of Account records for unit tests
    public static List<Account> createAccounts(Integer numAccounts) {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < numAccounts; i++) {
            Account acct = new Account();
            acct.Name = 'Test Account ' + i;
            accounts.add(acct);
        }
        return accounts;
    }

    // Construct a Product2 record for unit tests
    public static Product2 createProduct() {
        Product2 product = new Product2();
        product.Name = 'Chemise Verte longue XYX';
        product.Family = 'Chemise';
        return product;
    }

    // Construct a PricebookEntry record for unit tests
    public static PriceBookEntry createPricebookEntry(Product2 product) {
        PricebookEntry entry = new PricebookEntry();
        entry.Pricebook2Id = STANDARD_PRICEBOOK_ID;
        entry.Product2Id = product.Id;
        entry.UnitPrice = UNIT_PRICE;
        entry.IsActive = true;
        return entry;
    }

    // Construct a list of Order records for unit tests
    public static List<Order> createOrders(
        Integer numOrders,
        List<Account> accounts
    ) {
        List<Order> orders = new List<Order>();
        for (Account account : accounts) {
            for (Integer i = 0; i < numOrders; i++) {
                Order order = new Order();
                order.AccountId = account.Id;
                order.EffectiveDate = Date.Today();
                order.Status = INITIAL_ORDER_STATUS;
                order.Pricebook2Id = STANDARD_PRICEBOOK_ID;
                orders.add(order);
            }
        }
        return orders;
    }

    // Construct a list of OrderItem records for unit tests
    public static List<OrderItem> createOrderItems(
        Pricebookentry entry,
        List<Order> orders
    ) {
        List<OrderItem> orderItems = new List<OrderItem>();
        for (Order order : orders) {
            OrderItem item = new OrderItem();
            item.OrderId = order.Id;
            item.PriceBookEntryId = entry.Id;
            item.Quantity = ITEM_QUANTITY;
            item.UnitPrice = entry.UnitPrice;
            orderItems.add(item);
        }
        return orderItems;
    }

    // Insert all previously created data
    public static void insertTestData(Integer numAccounts, Integer numOrders) {
        List<Account> accounts = createAccounts(numAccounts);
        insert accounts;

        Product2 product = createProduct();
        insert product;

        PriceBookEntry entry = createPricebookEntry(product);
        insert entry;

        List<Order> orders = createOrders(numOrders, accounts);
        insert orders;

        List<OrderItem> items = createOrderItems(entry, orders);
        insert items;
    }
}