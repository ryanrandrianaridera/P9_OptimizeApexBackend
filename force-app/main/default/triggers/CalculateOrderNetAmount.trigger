trigger CalculateOrderNetAmount on Order(before update) {
    //Iterate on each new order
    for (Order newOrder : Trigger.new) {
        // Calculate net amount  and substract or not total amount with shipment cost
        newOrder.NetAmount__c = newOrder.ShipmentCost__c == null ? newOrder.TotalAmount: newOrder.TotalAmount - newOrder.ShipmentCost__c;
    }
}