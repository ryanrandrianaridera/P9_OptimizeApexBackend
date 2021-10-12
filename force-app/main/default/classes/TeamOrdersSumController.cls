public without sharing class TeamOrdersSumController {
    // Declare a variable of list <AggregateResult> type
    public List<AggregateResult> details { get; set; }
    // Use class constructor to initialize and populate the above variable
    public TeamOrdersSumController() {
        details = new List<AggregateResult>();
        // Populate the list using SOQL query to retrieve data
        // about orders sum ('ordered' orders only) for each Order Owner
        details = [
            SELECT Owner.Name name, SUM(TotalAmount) total
            FROM Order
            WHERE Status = 'Ordered'
            GROUP BY Owner.Name
        ];
    }
    // Get sum of all team orders Total Amount by summarizing the total values
    // cumulated in the variable of list
    public Decimal ordersSum {
        get {
            Decimal ordersSum = 0;
            if (details != null && details.size() > 0) {
                for (AggregateResult result : details) {
                    ordersSum += (Decimal) result.get('total');
                }
            }
            return ordersSum;
        }
        set;
    }
}