public with sharing class TeamOrdersController {
    public List<AggregateResult> groupedResults{get;set;}
    public TeamOrdersController() {
        groupedResults = new List<AggregateResult>();
          groupedResults = [SELECT COUNT(id) orderCount, SUM(TotalAmount) sumOrders, owner.Name orderName, AVG(TotalAmount) orderAvg FROM Order WHERE Status ='Ordered' GROUP BY owner.Name];
          for(AggregateResult ar : groupedResults){
              System.debug('Number of Orders' + ar.get('orderCount'));
              System.debug('Total Amount ' + ar.get('sumOrders'));
              System.debug('Sales Person ' +  ar.get('orderName'));
              System.debug('Average Amount' + ar.get('orderAvg'));
            }

    }
}
