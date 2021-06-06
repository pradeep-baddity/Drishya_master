@isTest
public class OpportunityTotalAmountTestFactory {
	
	public static Opportunity InsertOpportunityEmpty(Decimal amount) {
		return InsertOpportunityEmpty(amount, null);
	}
	public static Opportunity InsertOpportunityEmpty(Decimal amount, Id relatedOppId) {

		Opportunity o = new Opportunity();
		o.Name = 'My Opportunity';
		o.StageName = 'Prospecting';
		o.CloseDate = Date.today();
		if (relatedOppId != null) {
			o.Related_Opportunity__c = relatedOppId;
		}
		o.Amount = amount;
		
		insert o;
		return RehydrateOpportunity(o);
		
	}
	
	public static Opportunity RehydrateOpportunity(Opportunity o) {
		Opportunity n = [	SELECT 
								Id
								,Name
								,StageName
								,CloseDate
								,Amount
								,Related_Opportunity__c
								,No_of_Child_Opportunities__c
								,Total_Opportunity_Amount__c
							FROM Opportunity WHERE Id = :o.Id][0];
		return n;
	}
}