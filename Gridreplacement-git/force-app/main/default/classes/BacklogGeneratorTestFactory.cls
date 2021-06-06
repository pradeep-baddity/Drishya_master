@isTest
public class BacklogGeneratorTestFactory {
	
	private static Account priv_staticAccount = null;
	public static Account GetStaticAccount() {
		if (priv_staticAccount == null) {
			Account a = new Account(Name = ':)');
			insert a;
			priv_staticAccount = a;
		}
		return priv_staticAccount;
	}
	
	public static Opportunity InsertOpportunity(Date estStartDate, Integer estDuration, Boolean spreadFees, Decimal amount) {
		Opportunity o = new Opportunity();
		o.Name = 'Opp';
		o.AccountId = GetStaticAccount().Id;
		o.StageName = 'Prospecting';
		o.CloseDate = Date.newInstance(1990, 0, 0);
		
		o.Estimated_Start_Date__c = estStartDate;
		o.Estimated_Duration__c = estDuration;
		o.Spread_Fees_Evenly__c = spreadFees;
		o.Amount = amount;

		insert o;
		return reHydrate(o);
	}
	
	public static Backlog__c InsertAttachedBacklog(Opportunity o) {
		Backlog__c b = new Backlog__c();
		b.Opportunity__c = o.Id;
		insert b;
		return b;
	}

	public static Backlog__c InsertAttachedBacklog(Opportunity o, Date bDate) {
		Backlog__c b = new Backlog__c(Date__c = bDate);
		b.Opportunity__c = o.Id;
		insert b;
		return b;
	}
	public static List<Backlog__c> InsertAttachedBacklog(Opportunity o, Integer numToInsert) {
		List<Backlog__c> blogs = new List<Backlog__c>();
		
		for (Integer i = 0; i < numToInsert; i++) {
			Backlog__c b = new Backlog__c();
			b.Opportunity__c = o.Id;
			blogs.add(b);
		}
		insert blogs;
		return blogs;
	}
	
	public static Opportunity reHydrate(Opportunity o) {
		Opportunity n = [	SELECT Name, StageName, CloseDate, Estimated_Start_Date__c,
									 Estimated_Duration__c, Spread_Fees_Evenly__c, Amount
									,Unified_Amount_for_Backlog_Spreading__c
							FROM Opportunity WHERE Id = :o.Id][0];
		return n;
	}
	public static Backlog__c reHydrate(Backlog__c b) {
		Backlog__c n = [SELECT Id, Opportunity__c, Projected_Amount__c, Actual_Amount__c, 
								Date__c, Has_Actuals__c 
						FROM Backlog__c WHERE Id = :b.Id][0];
		return n;
	}
	
	
}