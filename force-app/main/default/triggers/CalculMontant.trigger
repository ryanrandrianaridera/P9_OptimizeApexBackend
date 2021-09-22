trigger CalculMontant on Order (before update) {
	
	//Order newOrder= trigger.new[0];
	for (Order newOrder: trigger.new) {
		newOrder.NetAmount__c = newOrder.TotalAmount - newOrder.ShipmentCost__c;
	}	
}