@isTest
private class OpportunityTopLevelAccountTriggerTest {
	
	private static OpportunityTopLevelAccountTrigger t = new OpportunityTopLevelAccountTrigger();
	
	static testMethod void testLEV1Parent_Found() {
		Account[] accts = Insert10Accounts();
		
		Opportunity topOpp = InsertOpportunityAndAttach(accts.get(0), null);
		Opportunity LEV1 = InsertOpportunityAndAttach(accts.get(1), topOpp);
		
		t.PopulateTopLevelAccountLookupField(new Map<Id, Opportunity>(new Opportunity[]{LEV1}));
		
		// Test 1: Top level account is found
		System.assertEquals(accts.get(0).Id, RehydrateOpp(LEV1).Top_Level_Opportunity_Account__c);
	}
	
	static testMethod void testLEV2Parent_Found() {
		Account[] accts = Insert10Accounts();
		
		Opportunity topOpp = InsertOpportunityAndAttach(accts.get(0), null);
		Opportunity LEV1 = InsertOpportunityAndAttach(accts.get(1), topOpp);
		Opportunity LEV2 = InsertOpportunityAndAttach(accts.get(2), LEV1);
		
		t.PopulateTopLevelAccountLookupField(new Map<Id, Opportunity>(new Opportunity[]{LEV1, LEV2}));
		
		// Test 1: Top level account is found
		System.assertEquals(accts.get(0).Id, RehydrateOpp(LEV2).Top_Level_Opportunity_Account__c);
	}
	
	static testMethod void testLEV3Parent_Found() {
		Account[] accts = Insert10Accounts();
		
		Opportunity topOpp = InsertOpportunityAndAttach(accts.get(0), null);
		Opportunity LEV1 = InsertOpportunityAndAttach(accts.get(1), topOpp);
		Opportunity LEV2 = InsertOpportunityAndAttach(accts.get(2), LEV1);
		Opportunity LEV3 = InsertOpportunityAndAttach(accts.get(3), LEV2);
		
		t.PopulateTopLevelAccountLookupField(new Map<Id, Opportunity>(new Opportunity[]{LEV1, LEV2, LEV3}));
		
		// Test 1: Top level account is found
		System.assertEquals(accts.get(0).Id, RehydrateOpp(LEV3).Top_Level_Opportunity_Account__c);
	}
	
	/*static testMethod void testLEV4Parent_Found() {
		Account[] accts = Insert10Accounts();
		
		Opportunity topOpp = InsertOpportunityAndAttach(accts.get(0), null);
		Opportunity LEV1 = InsertOpportunityAndAttach(accts.get(1), topOpp);
		Opportunity LEV2 = InsertOpportunityAndAttach(accts.get(2), LEV1);
		Opportunity LEV3 = InsertOpportunityAndAttach(accts.get(3), LEV2);
		Opportunity LEV4 = InsertOpportunityAndAttach(accts.get(4), LEV3);
		
		t.PopulateTopLevelAccountLookupField(new Map<Id, Opportunity>(new Opportunity[]{LEV1, LEV2, LEV3, LEV4}));
		
		// Test 1: Top level account is found
		System.assertEquals(accts.get(0).Id, RehydrateOpp(LEV4).Top_Level_Opportunity_Account__c);
	}
	
	/*static testMethod void testLEV5Parent_Found() {
		Account[] accts = Insert10Accounts();
		
		Opportunity topOpp = InsertOpportunityAndAttach(accts.get(0), null);
		Opportunity LEV1 = InsertOpportunityAndAttach(accts.get(1), topOpp);
		Opportunity LEV2 = InsertOpportunityAndAttach(accts.get(2), LEV1);
		Opportunity LEV3 = InsertOpportunityAndAttach(accts.get(3), LEV2);
		Opportunity LEV4 = InsertOpportunityAndAttach(accts.get(4), LEV3);
		Opportunity LEV5 = InsertOpportunityAndAttach(accts.get(5), LEV4);
		
		t.PopulateTopLevelAccountLookupField(new Map<Id, Opportunity>(new Opportunity[]{LEV1, LEV2, LEV3, LEV4, LEV5}));
		
		// Test 1: Top level account is found
		System.assertEquals(accts.get(0).Id, RehydrateOpp(LEV5).Top_Level_Opportunity_Account__c);
	}
	static testMethod void testLEV6Parent_NotFoundBecauseMaxRecursion() {
		Account[] accts = Insert10Accounts();
		
		Opportunity topOpp = InsertOpportunityAndAttach(accts.get(0), null);
		Opportunity LEV1 = InsertOpportunityAndAttach(accts.get(1), topOpp);
		Opportunity LEV2 = InsertOpportunityAndAttach(accts.get(2), LEV1);
		Opportunity LEV3 = InsertOpportunityAndAttach(accts.get(3), LEV2);
		Opportunity LEV4 = InsertOpportunityAndAttach(accts.get(4), LEV3);
		Opportunity LEV5 = InsertOpportunityAndAttach(accts.get(5), LEV4);
		
		// Set iteration count to 1, even though it would take 2 iterations to found our 6th parent
		OpportunityTopLevelAccountTrigger.MAX_ITERATION_COUNT = 1;
		
		Opportunity LEV6 = InsertOpportunityAndAttach(accts.get(6), LEV5);
		
		t.PopulateTopLevelAccountLookupField(new Map<Id, Opportunity>(new Opportunity[]{LEV1, LEV2, LEV3, LEV4, LEV5, LEV6}));
		
		// Test 1: Top level account is NOT found, because only 5 levels are possible per iteration
		System.assertEquals(null, RehydrateOpp(LEV6).Top_Level_Opportunity_Account__c);
	}
	static testMethod void testLEV6Parent_Found() {
		Account[] accts = Insert10Accounts();
		
		Opportunity topOpp = InsertOpportunityAndAttach(accts.get(0), null);
		Opportunity LEV1 = InsertOpportunityAndAttach(accts.get(1), topOpp);
		Opportunity LEV2 = InsertOpportunityAndAttach(accts.get(2), LEV1);
		Opportunity LEV3 = InsertOpportunityAndAttach(accts.get(3), LEV2);
		Opportunity LEV4 = InsertOpportunityAndAttach(accts.get(4), LEV3);
		Opportunity LEV5 = InsertOpportunityAndAttach(accts.get(5), LEV4);
		
		// Allow a second iteration
		OpportunityTopLevelAccountTrigger.MAX_ITERATION_COUNT = 2;
		
		Opportunity LEV6 = InsertOpportunityAndAttach(accts.get(6), LEV5);
		
		t.PopulateTopLevelAccountLookupField(new Map<Id, Opportunity>(new Opportunity[]{LEV1, LEV2, LEV3, LEV4, LEV5, LEV6}));
	
		// Test 1: Top level account is found
		System.assertEquals(accts.get(0).Id, RehydrateOpp(LEV6).Top_Level_Opportunity_Account__c);
	}*/
	
	// HELPER METHODS
	private static Account[] Insert10Accounts() {
		Account[] accList = new Account[]{};
		accList.add(new Account(Name = 'Top Account'));
		accList.add(new Account(Name = 'LEV1'));
		accList.add(new Account(Name = 'LEV2'));
		accList.add(new Account(Name = 'LEV3'));
		accList.add(new Account(Name = 'LEV4'));
		accList.add(new Account(Name = 'LEV5'));
		accList.add(new Account(Name = 'LEV6'));
		accList.add(new Account(Name = 'LEV7'));
		accList.add(new Account(Name = 'LEV8'));
		accList.add(new Account(Name = 'LEV9'));
		insert accList;
		return accList;
	}
	
	private static Opportunity InsertOpportunityAndAttach(Account a, Opportunity parent) {
		Opportunity o = new Opportunity();
		o.Name = 'Opp';
		o.StageName = 'Prospecting';
		o.CloseDate = Date.today();
		o.AccountId = a.Id;
		if (parent != null) {
			o.Related_Opportunity__c = parent.Id;
		}
		insert o;
		return ReHydrateOpp(o);
	}
	
	private static Opportunity ReHydrateOpp(Opportunity o) {
		Opportunity n = [SELECT Name, StageName, CloseDate, AccountId, Top_Level_Opportunity_Account__c
						FROM Opportunity WHERE Id = :o.Id][0];
		return n;
	}
}