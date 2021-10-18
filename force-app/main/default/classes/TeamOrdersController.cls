public with sharing class TeamOrdersController {
    public List<AggregateResult> groupedResults{get;set;}
    public TeamOrdersController() {
        groupedResults = new List<AggregateResult>();
          groupedResults = [SELECT COUNT(id) orderCount, SUM(TotalAmount) sumOrders, owner.Name orderName, AVG(TotalAmount) orderAvg FROM Order WHERE Status ='Ordered' GROUP BY owner.Name];
          for(AggregateResult ar : groupedResults){
              System.debug('Nombre de commandes' + ar.get('orderCount'));
              System.debug('Montant total des commandes ' + ar.get('sumOrders'));
              System.debug('Nom du propriétaire ' +  ar.get('orderName'));
              System.debug('Montant moyen d\'une commande ' + ar.get('orderAvg'));
            }

    }
}
