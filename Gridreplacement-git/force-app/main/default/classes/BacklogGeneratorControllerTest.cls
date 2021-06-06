@isTest
private class BacklogGeneratorControllerTest {
	
	static testMethod void testStartDateConverter() {
		
		// Start date converter should always return the first day of the month
		BacklogGeneratorController c = new BacklogGeneratorController();
		
		// Test 1: 12/31/2014 turns into 12/01/2014
		System.assertEquals(Date.newInstance(2014, 12, 1), c.getStartDate(Date.newInstance(2014, 12, 31)));
		
		// Test 2: 05/23/2015 turns into 05/01/2015
		System.assertEquals(Date.newInstance(2015, 05, 01), c.getStartDate(Date.newInstance(2015, 05, 23)));
		
		// Test 3:  No date provided defaults to the start of the current month
		Date today = Date.today();
		System.assertEquals(today.toStartOfMonth(), c.getStartDate((Date)null));
		
	}
	
	static testMethod void testDateListGenerator() {
		
		// Given an input date and "estimated duration", we need to generate a list of dates
		// equal in number to the estimated duration, starting with the first of the input date's
		// month and the first of the each subsequent month
		BacklogGeneratorController c = new BacklogGeneratorController();
		
		/* Test 1:  StartDate=12/31/2014, EstDuration=4 generates:
					12/01/2014, 01/01/2015, 02/01/2015, 03/01/2015 */
		
		Date startDate1 = Date.newInstance(2014, 12, 31);
		Integer duration1 = 4;
		Date[] expectedResult1 = new Date[]{Date.newInstance(2014, 12, 01), Date.newInstance(2015, 01, 01),	Date.newInstance(2015, 02, 01), Date.newInstance(2015, 03, 01)};
		System.assertEquals(expectedResult1, c.getDateList(c.getStartDate(startDate1), duration1));
		
		/* Test 2:  StartDate=05/23/2015, EstDuration=1 generates:
					05/01/2015 */

		Date startDate2 = Date.newInstance(2015, 05, 23);
		Integer duration2 = 1;
		Date[] expectedResult2 = new Date[] {Date.newInstance(2015, 05, 01)};
		System.assertEquals(expectedResult2, c.getDateList(c.getStartDate(startDate2), duration2));

	}
	
	static testMethod void testBacklogGeneration_Test1_NoSpreadFees() {
		
		BacklogGeneratorController c = new BacklogGeneratorController();
		
		// Test 1 Parameters
		Date estStartDate = Date.newInstance(2015, 01, 17);
		Integer estDuration = 2;
		Boolean spreadFees = false;
		Decimal amount = 100;
		Opportunity o = BacklogGeneratorTestFactory.InsertOpportunity(estStartDate, estDuration, spreadFees, amount);
		
		// Test 1:  Backlogs are generated with no amounts
		Backlog__c[] blogs = c.GenerateBacklogs(o.Id);
		System.assertEquals(2, blogs.size());
		System.assertEquals(null, blogs.get(0).Projected_Amount__c);
		System.assertEquals(null, blogs.get(0).Projected_Amount__c);
	}
	
	static testMethod void testBacklogGeneration_Test2_SpreadFeesEvenDivision() {
		
		BacklogGeneratorController c = new BacklogGeneratorController();
		
		// Test 1 Parameters
		Date estStartDate = Date.newInstance(2015, 01, 17);
		Integer estDuration = 2;
		Boolean spreadFees = true;
		Decimal amount = 100;
		Opportunity o = BacklogGeneratorTestFactory.InsertOpportunity(estStartDate, estDuration, spreadFees, amount);
		
		// Test 1:  Backlogs are generated with the proper amounts and dates
		Backlog__c[] blogs = c.GenerateBacklogs(o.Id);
		System.assertEquals(2, blogs.size());
		System.assertEquals(50, blogs.get(0).Projected_Amount__c);
		System.assertEquals(50, blogs.get(1).Projected_Amount__c);
		System.assertEquals(Date.newInstance(2015, 01, 01), blogs.get(0).Date__c);
		System.assertEquals(Date.newInstance(2015, 02, 01), blogs.get(1).Date__c);
	}
	
	static testMethod void testBacklogGeneration_Test3_SpreadFees66AndSixSevenths() {
		
		BacklogGeneratorController c = new BacklogGeneratorController();
		
		// Test 2 Parameters
		Date estStartDate = Date.newInstance(2015, 04, 05);
		Integer estDuration = 6;
		Boolean spreadFees = true;
		Decimal amount = 400;
		Opportunity o = BacklogGeneratorTestFactory.InsertOpportunity(estStartDate, estDuration, spreadFees, amount);
		
		// Test 2:  Backlogs are generated with the proper amounts and dates
		Backlog__c[] blogs = c.GenerateBacklogs(o.Id);
		System.assertEquals(6, blogs.size());
		System.assertEquals(66.67, blogs.get(0).Projected_Amount__c);
		System.assertEquals(66.67, blogs.get(1).Projected_Amount__c);
		System.assertEquals(66.67, blogs.get(2).Projected_Amount__c);
		System.assertEquals(66.67, blogs.get(3).Projected_Amount__c);
		System.assertEquals(66.67, blogs.get(4).Projected_Amount__c);
		System.assertEquals(66.67, blogs.get(5).Projected_Amount__c);
		System.assertEquals(Date.newInstance(2015, 04, 01), blogs.get(0).Date__c);
		System.assertEquals(Date.newInstance(2015, 05, 01), blogs.get(1).Date__c);
		System.assertEquals(Date.newInstance(2015, 06, 01), blogs.get(2).Date__c);
		System.assertEquals(Date.newInstance(2015, 07, 01), blogs.get(3).Date__c);
		System.assertEquals(Date.newInstance(2015, 08, 01), blogs.get(4).Date__c);
		System.assertEquals(Date.newInstance(2015, 09, 01), blogs.get(5).Date__c);
	}
	
	static testMethod void testBacklogSyncronizer_Test1_SmallMonthShift() {
		
		BacklogGeneratorController c = new BacklogGeneratorController();
		
		// The backlog "syncronizer" compares a list of existing backlogs with the new
		// list of backlogs that would be generated given an input opportunity, and returns a map
		// of backlogs that should be upserted and backlogs that need to be deleted in order to syncronize
		// the existing set into the new set
		
		Date estStartDate = Date.newInstance(2015, 01, 17);
		Integer estDuration = 2;
		Boolean spreadFees = false;
		Decimal amount = 100;
		
		Opportunity o = BacklogGeneratorTestFactory.InsertOpportunity(estStartDate, estDuration, spreadFees, amount);
		Backlog__c[] blogs = c.GenerateBacklogs(o.Id);
		insert blogs;
		
		/* Test 1: Shifting the date by 1 month forward with respread fees=true causes 
					A) Backlog #1 from the original set ends up in the deletion list
					B) Backlog #2 from the original set ends up in the upsert list
					C) A new backlog is created (ie sans id) and added to the upsert list
					D) Backlogs in upsert list both have amount=50 due to respread fees
		*/
		
		o.Estimated_Start_Date__c = o.Estimated_Start_Date__c.addMonths(1);
		Map<Backlog__c[], Backlog__c[]> syncMap = c.GenerateSyncronizedBacklogs(blogs, o, true);
		Backlog__c[] upsertList = new List<Backlog__c[]>(syncMap.keySet())[0];
		Backlog__c[] deleteList = syncMap.values()[0];
		
		// A)
		System.assertEquals(blogs.get(0).Id, deleteList.get(0).Id);
		// B)
		System.assertEquals(blogs.get(1).Id, upsertList.get(0).Id);
		// C)
		System.assertEquals(2, upsertList.size());
		System.assertEquals(null, upsertList.get(1).Id);
		// D)
		System.assertEquals(50, upsertList.get(0).Projected_Amount__c);
		System.assertEquals(50, upsertList.get(1).Projected_Amount__c);
	
	}
	
	static testMethod void testBacklogSyncronizer_Test2_BigMonthShift() {
		
		BacklogGeneratorController c = new BacklogGeneratorController();
		
		Date estStartDate = Date.newInstance(2015, 01, 17);
		Integer estDuration = 2;
		Boolean spreadFees = false;
		Decimal amount = 100;
		
		Opportunity o = BacklogGeneratorTestFactory.InsertOpportunity(estStartDate, estDuration, spreadFees, amount);
		Backlog__c[] blogs = c.GenerateBacklogs(o.Id);
		insert blogs;
		
		/* Test 2: Shifting the date by 5 month forward with respread fees=true causes
					A) All backlogs in the original list are now in the deletion list
					B) Upsert list has 2 new backlogs in it with amount=50
		*/
		
		o.Estimated_Start_Date__c = o.Estimated_Start_Date__c.addMonths(5);
		Map<Backlog__c[], Backlog__c[]> syncMap = c.GenerateSyncronizedBacklogs(blogs, o, true);
		Backlog__c[] upsertList = new List<Backlog__c[]>(syncMap.keySet())[0];
		Map<Id, Backlog__c> deleteList = new Map<Id, Backlog__c>(syncMap.values()[0]);
		
		// A)
		System.assertEquals(true, deleteList.containsKey(blogs.get(0).Id));
		System.assertEquals(true, deleteList.containsKey(blogs.get(1).Id));
		// B)
		System.assertEquals(2, upsertList.size());
		System.assertEquals(null, upsertList.get(0).Id);
		System.assertEquals(null, upsertList.get(1).Id);
		System.assertEquals(50, upsertList.get(0).Projected_Amount__c);
		System.assertEquals(50, upsertList.get(1).Projected_Amount__c);
	}
	
	static testMethod void testBacklogSyncronizer_Test3_IncreasedDurationWithRespreadFees() {
		
		BacklogGeneratorController c = new BacklogGeneratorController();
		
		Date estStartDate = Date.newInstance(2015, 01, 17);
		Integer estDuration = 2;
		Boolean spreadFees = false;
		Decimal amount = 100;
		
		Opportunity o = BacklogGeneratorTestFactory.InsertOpportunity(estStartDate, estDuration, spreadFees, amount);
		Backlog__c[] blogs = c.GenerateBacklogs(o.Id);
		insert blogs;
		
		/* Test 3: Increasing duration to 4 with respreadFees=TRUE causes
					A) Deletion list is empty
					B) All two original backlogs end up in the upsert list
					C) Two new backlogs end up in the upsert list
					D) All backlogs in the upsert list have amount of 25
		*/
		
		o.Estimated_Duration__c = 4;
		Map<Backlog__c[], Backlog__c[]> syncMap = c.GenerateSyncronizedBacklogs(blogs, o, true);
		Backlog__c[] upsertList = new List<Backlog__c[]>(syncMap.keySet())[0];
		Backlog__c[] deleteList = syncMap.values()[0];
		
		// Helper set
		Set<Id> idsInUpsertList = new Set<Id>();
		Integer numWithoutIdInUpsertList = 0;
		for (Backlog__c bl : upsertList) {
			if (bl.Id != null) {
				idsInUpsertList.add(bl.Id);
			} else {
				numWithoutIdInUpsertList++;
			}
		}
		
		// A)
		System.assertEquals(0, deleteList.size());
		// B)
		System.assertEquals(true, idsInUpsertList.contains(blogs.get(0).Id));
		System.assertEquals(true, idsInUpsertList.contains(blogs.get(1).Id));
		// C)
		System.assertEquals(4, upsertList.size());
		System.assertEquals(2, numWithoutIdInUpsertList);
		// D)
		System.assertEquals(25, upsertList.get(0).Projected_Amount__c);
		System.assertEquals(25, upsertList.get(1).Projected_Amount__c);
		System.assertEquals(25, upsertList.get(2).Projected_Amount__c);
		System.assertEquals(25, upsertList.get(3).Projected_Amount__c);
		
	}
	
	static testMethod void testBacklogSyncronizer_Test4_IncreasedDurationWithoutRespreadFees() {
		
		BacklogGeneratorController c = new BacklogGeneratorController();
		
		Date estStartDate = Date.newInstance(2015, 01, 17);
		Integer estDuration = 2;
		Boolean spreadFees = true;
		Decimal amount = 100;
		
		Opportunity o = BacklogGeneratorTestFactory.InsertOpportunity(estStartDate, estDuration, spreadFees, amount);
		Backlog__c[] blogs = c.GenerateBacklogs(o.Id);
		insert blogs;
		
		/* Test 4: Increasing duration to 4 with respreadFees=FALSE, original spreadFees=TRUE causes
					A) Deletion list is empty
					B) All two original backlogs end up in the upsert list
					C) Two new backlogs end up in the upsert list
					D) The two existing backlogs in the upsertList have their original amounts of 50,
						while the two new ones have an amount of 0
		*/
		
		o.Estimated_Duration__c = 4;
		Map<Backlog__c[], Backlog__c[]> syncMap = c.GenerateSyncronizedBacklogs(blogs, o, false);
		Backlog__c[] upsertList = new List<Backlog__c[]>(syncMap.keySet())[0];
		Backlog__c[] deleteList = syncMap.values()[0];
		
		// Helper set
		Set<Id> idsInUpsertList = new Set<Id>();
		Integer numInUpsertListWithoutID = 0;
		Integer numInUpsertListWithAmount50 = 0;
		Integer numInUpsertListWithAmountEmpty = 0;
		for (Backlog__c bl : upsertList) {
			if (bl.Id != null) {
				idsInUpsertList.add(bl.Id);
			} else {
				numInUpsertListWithoutID++;
			}
			if (bl.Projected_Amount__c == null) {
				numInUpsertListWithAmountEmpty++;
			} else if (bl.Projected_Amount__c == 50) {
				numInUpsertListWithAmount50++;
			}
			System.debug('****************** BLID: ' + bl.Id + ', amount=' + bl.Projected_Amount__c);
		}
		
		// A)
		System.assertEquals(0, deleteList.size());
		// B)
		System.assertEquals(true, idsInUpsertList.contains(blogs.get(0).Id));
		System.assertEquals(true, idsInUpsertList.contains(blogs.get(1).Id));
		// C)
		System.assertEquals(4, upsertList.size());
		System.assertEquals(2, numInUpsertListWithoutID);
		// D)
		System.assertEquals(2, numInUpsertListWithAmount50);
		System.assertEquals(2, numInUpsertListWithAmountEmpty);
	}
	
	static testMethod void testBacklogSyncronizer_Test5_ValidateRecordsWithActualsExcludedFromRespread() {
		
		BacklogGeneratorController c = new BacklogGeneratorController();
		
		Date estStartDate = Date.newInstance(2015, 01, 17);
		Integer estDuration = 4;
		Boolean spreadFees = true;
		Decimal amount = 100;
		
		// Generate test data
		Opportunity o = BacklogGeneratorTestFactory.InsertOpportunity(estStartDate, estDuration, spreadFees, amount);
		Backlog__c[] blogs = c.GenerateBacklogs(o.Id);
		insert blogs;
		
		// Assert test starting conditions
		System.assertEquals(25, blogs[0].Projected_Amount__c);
		System.assertEquals(25, blogs[1].Projected_Amount__c);
		System.assertEquals(25, blogs[2].Projected_Amount__c);
		System.assertEquals(25, blogs[3].Projected_Amount__c);
		
		/* Test 5: Giving one of the backlogs an actual and then respreading the fees results in the fees
				   being redistributed only amongst the remaining backlogs withOUT actuals, while the
				   backlog WITH actuals is left alone 
		*/
		
					
		blogs[0].Actual_Amount__c = 50;
		update blogs[0];
		blogs[0] = BacklogGeneratorTestFactory.reHydrate(blogs[0]);
		
		Map<Backlog__c[], Backlog__c[]> syncMap = c.GenerateSyncronizedBacklogs(blogs, o, true);
		Map<Id, Backlog__c> upsertMap = new Map<Id, Backlog__c>(new List<Backlog__c[]>(syncMap.keySet())[0]);
		
		System.assertEquals(25, upsertMap.get(blogs[0].Id).Projected_Amount__c);
		System.assertEquals(16.67, upsertMap.get(blogs[1].Id).Projected_Amount__c);
		System.assertEquals(16.67, upsertMap.get(blogs[2].Id).Projected_Amount__c);
		System.assertEquals(16.67, upsertMap.get(blogs[3].Id).Projected_Amount__c);
		
	}
	
	static testMethod void testMainPageMethod_VerifyNoExistingBacklogs() {
		
		Opportunity o = BacklogGeneratorTestFactory.InsertOpportunity(Date.newInstance(2014,01,01), 2, true, 100);
		
		BacklogGeneratorController c = new BacklogGeneratorController();
		c.opp = o;
		PageReference resultRef = c.InsertNewBacklogsAndRedirect();
		
		// Test 1:  2 backlogs are inserted and we get redirected to the backlog manager
		System.assertEquals(2, [SELECT COUNT() FROM Backlog__c]);
		System.assertEquals('/apex/backlogmanager?id='+o.Id,resultRef.getUrl());
		
		// Test 2: If we try again, nothing happens and the page reloads to show some error messages
		resultRef = c.InsertNewBacklogsAndRedirect();
		
		System.assertEquals(2, [SELECT COUNT() FROM Backlog__c]);
		System.assertEquals(null, resultRef);
		System.assertEquals(true, ApexPages.hasMessages());
	}
	
	static testMethod void ensureCodeCoverage() {
		
		Opportunity o = BacklogGeneratorTestFactory.InsertOpportunity(Date.newInstance(2014,01,01), 2, true, 100);
		
		// Set our page
		PageReference pg = Page.BacklogGenerator;
		pg.getParameters().put('id', o.id);
		Test.setCurrentPage(pg);
		
		// Instantiate controller normally
		ApexPages.StandardSetController defaultController = new ApexPages.StandardSetController(new Backlog__c[]{});
		BacklogGeneratorController controller = new BacklogGeneratorController(defaultController);
		
		// Call all page buttons
		controller.GoBack();
		controller.GoToBacklogManager();
		controller.InsertNewBacklogsAndRedirect();

		// Throw the test exception
		BacklogGeneratorController.ThrowTestExceptions = true;
		controller.InsertNewBacklogsAndRedirect();
		
		
	}
	
}