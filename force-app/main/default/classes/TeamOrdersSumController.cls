public without sharing class TeamOrdersSumController {
    @AuraEnabled
    public static List<AggregateResult> teamSumOrders(){
        // List<AggregateResult> groupedResults = [SELECT Owner.Name, SUM(TotalAmount) sumOrders, COUNT(Id) orderCount FROM Order WHERE Status = 'Ordered' GROUP BY Owner.Name];
        List<AggregateResult> groupedResults =  [SELECT COUNT(id) orderCount, SUM(TotalAmount) sumOrders, owner.Name orderName, AVG(TotalAmount) orderAvg FROM Order WHERE Status ='Ordered' GROUP BY owner.Name];
         return groupedResults;      
        }       
}