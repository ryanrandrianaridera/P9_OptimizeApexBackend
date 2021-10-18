({
	init : function(component, event, helper) {
		
        component.set("v.columns", [
            {label: 'SalesPerson', fieldName: 'orderName', type: 'text'},
            {label: 'Total Orders', fieldName: 'orderCount'},
            {label: 'Order Average', fieldName: 'orderAvg', type: 'currency', typeAttributes: { currencyCode: 'EUR', maximumSignificantDigits: 7}},
            {label: 'Total Amount', fieldName: 'sumOrders', type: 'currency', typeAttributes: { currencyCode: 'EUR', maximumSignificantDigits: 7}}
        ])
         
        const fetchData = component.get("c.teamSumOrders");
       
        fetchData.setCallback(this, function(response) {
            console.log(response.getReturnValue());
            component.set("v.data", response.getReturnValue());
        });

        $A.enqueueAction(fetchData);
	}
})