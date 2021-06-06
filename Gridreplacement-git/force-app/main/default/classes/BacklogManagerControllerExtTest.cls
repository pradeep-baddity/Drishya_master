@isTest
private class BacklogManagerControllerExtTest {
	
/*	static testMethod void ensureCodeCoverage() {
		
		Opportunity o = BacklogGeneratorTestFactory.InsertOpportunity(Date.newInstance(2014,01,01), 2, true, 100);
		
		// Set our page
		PageReference pg = Page.BacklogManager;
		pg.getParameters().put('id', o.id);
		Test.setCurrentPage(pg);
		
		// Instantiate controller normally
		ApexPages.StandardSetController defaultController = new ApexPages.StandardSetController(new Backlog__c[]{});
		BacklogManagerControllerExt controller = new BacklogManagerControllerExt(defaultController);
		
		// Call all getters/setters
		controller.getBacklogSet();
		controller.getFullBacklogSet();
		controller.getProtoBacklog();
		Boolean b1 = controller.RespreadFees;
		Integer i1 = controller.PageNum;
		controller.PageNum = 1;
		Integer i2 = controller.PageSize;
		controller.PageSize = 10;
		Integer i3 = controller.NumRecs;
		
		String s1 = controller.NumRecStr;
		BacklogGeneratorTestFactory.InsertAttachedBacklog(o); controller.BacklogSetController = null;
		String s2 = controller.NumRecStr;
		
		Integer i4 = controller.NumPages;
		Integer i5 = controller.FirstRecOnPage;
		Integer i6 = controller.NumRecsOnPage;
		Integer i7 = controller.LastRecOnPage;
		
		// Call all methods
		controller.GoToFirst();
		controller.GoToPrevious();
		controller.GoToNext();
		controller.GoToLast();
		
		// Call methods on PageMessageBinder
		BacklogManagerControllerExt.PageMessageBinder b = new BacklogManagerControllerExt.PageMessageBinder();
		b.ShowError('test', 'test');
		b.ShowSuccess('test', 'test');
		b.Clear();
		
		// Call all buttons
		controller.DoNothing();
		controller.Regenerate();
		controller.DeleteAll();
		controller.SaveChanges();		
		controller.SyncronizeNewProjections();
		controller.ApplyMassUpdate();
		
		// Throw all exceptions in try/catch blocks
		BacklogManagerControllerExt.doThrowTestExceptions = true;
		controller.Regenerate();
		controller.DeleteAll();
		controller.SaveChanges();
		controller.SyncronizeNewProjections();
		
		// Trigger DML error pathways
		BacklogManagerControllerExt.doThrowTestExceptions = false;
		BacklogManagerControllerExt.doPretendDMLErrors = true;
		controller.Regenerate();
		controller.DeleteAll();
		controller.SaveChanges();
		
	} */
	
	static testMethod void testPaginationStatusBarCalculation_OnePage() {
		// In the bottom left corner of the datatable I mimic Salesforce's "1-5 of 100" 
		// page statistics message.  This unit test ensures those statistics are accurate
		
		// Insert test data
		Opportunity o = BacklogGeneratorTestFactory.InsertOpportunity(Date.newInstance(2014,01,01), 3, true, 100);
		Backlog__c b1 = BacklogGeneratorTestFactory.InsertAttachedBacklog(o);
		Backlog__c b2 = BacklogGeneratorTestFactory.InsertAttachedBacklog(o);
		Backlog__c b3 = BacklogGeneratorTestFactory.InsertAttachedBacklog(o);
		
		// Set our page
		PageReference pg = Page.BacklogManager;
		pg.getParameters().put('id', o.id);
		Test.setCurrentPage(pg);
		
		// Instantiate controller normally
		ApexPages.StandardSetController defaultController = new ApexPages.StandardSetController(new Backlog__c[]{});
		BacklogManagerControllerExt controller = new BacklogManagerControllerExt(defaultController);
		
		// Test 1:  With 3 backlogs, Setting the pagesize to 10 produces
		//			A) one page with three records on it
		//			B) the first record on the page is #1 and the last record is #3
		controller.PageSize = 10;
		
		// A)
		System.assertEquals(1, controller.NumPages);
		System.assertEquals(3, controller.NumRecsOnPage);
		// B)
		System.assertEquals(1, controller.FirstRecOnPage);
		System.assertEquals(3, controller.LastRecOnPage);
	}
	
	static testMethod void testPaginationStatusBarCalculation_MultiplePages() {
		
		// Insert test data
		Opportunity o = BacklogGeneratorTestFactory.InsertOpportunity(Date.newInstance(2014,01,01), 10, true, 100);
		BacklogGeneratorTestFactory.InsertAttachedBacklog(o, 10);
		
		// Set our page
		PageReference pg = Page.BacklogManager;
		pg.getParameters().put('id', o.id);
		Test.setCurrentPage(pg);
		
		// Instantiate controller normally
		ApexPages.StandardSetController defaultController = new ApexPages.StandardSetController(new Backlog__c[]{});
		BacklogManagerControllerExt controller = new BacklogManagerControllerExt(defaultController);
		
		// Test 1:  With 10 backlogs, Setting the pagesize to 3 produces
		//			A) 4 pages total, with three records on each except for the last page which has one record only
		//			B) On page 1, the first record is #1 and the last record is #3
		//			C) On page 2, the first record is #4 and the last record is #6
		//			D) On page 3, the first record is #7 and the last record is #9
		//			E) On page 4, the only record is #10
		controller.PageSize = 3;
		
		// A)
		System.assertEquals(4, controller.NumPages);
		System.assertEquals(10, controller.NumRecs);
		System.assertEquals('10 records', controller.NumRecStr); // This is more for code coverage
		
		controller.GoToFirst();
		System.assertEquals(3, controller.NumRecsOnPage);
		
		controller.GoToNext();
		System.assertEquals(3, controller.NumRecsOnPage);
		
		controller.GoToNext();
		System.assertEquals(3, controller.NumRecsOnPage);
		
		controller.GoToNext();
		System.assertEquals(1, controller.NumRecsOnPage);
		
		// B)
		controller.GoToFirst();
		System.assertEquals(1, controller.FirstRecOnPage);
		System.assertEquals(3, controller.LastRecOnPage);
		
		// C)
		controller.GoToNext();
		System.assertEquals(4, controller.FirstRecOnPage);
		System.assertEquals(6, controller.LastRecOnPage);
		
		// D)
		controller.GoToNext();
		System.assertEquals(7, controller.FirstRecOnPage);
		System.assertEquals(9, controller.LastRecOnPage);
		
		// E)
		controller.GoToLast();
		System.assertEquals(10, controller.FirstRecOnPage);
		System.assertEquals(10, controller.LastRecOnPage);
	}
	
	static testMethod void testFullRecordsetCollection_OnePage() {
		
		// Insert test data
		Opportunity o = BacklogGeneratorTestFactory.InsertOpportunity(Date.newInstance(2014,01,01), 3, true, 100);
		Backlog__c b1 = BacklogGeneratorTestFactory.InsertAttachedBacklog(o);
		Backlog__c b2 = BacklogGeneratorTestFactory.InsertAttachedBacklog(o);
		Backlog__c b3 = BacklogGeneratorTestFactory.InsertAttachedBacklog(o);
		
		// Helper set of inserted testdata ids
		Set<Id> referenceSetIds = (new Map<Id, Backlog__c>(new Backlog__c[]{b1, b2, b3})).keySet();
		
		// Set our page
		PageReference pg = Page.BacklogManager;
		pg.getParameters().put('id', o.id);
		Test.setCurrentPage(pg);
		
		// Instantiate controller normally
		ApexPages.StandardSetController defaultController = new ApexPages.StandardSetController(new Backlog__c[]{});
		BacklogManagerControllerExt controller = new BacklogManagerControllerExt(defaultController);
		controller.PageSize = 10;
		
		// Helper sets of queried ids from the two getBacklog methods
		Set<Id> getBacklogSetIds = (new Map<Id, Backlog__c>(controller.getBacklogSet())).keySet();
		Set<Id> getFullBacklogSetIds = (new Map<Id, Backlog__c>(controller.getFullBacklogSet())).keySet();
		
		// Test 1: With a pagesize sufficient for all records, both getBacklog methods reproduce them
		System.assertEquals(1, controller.NumPages);
		System.assertEquals(true, getBacklogSetIds.containsAll(referenceSetIds));
		System.assertEquals(true, getFullBacklogSetIds.containsAll(referenceSetIds));
		System.assertEquals(getBacklogSetIds.containsAll(getFullBacklogSetIds), getFullBacklogSetIds.containsAll(getBacklogSetIds));

	}
	
	static testMethod void testFullRecordsetCollection_MultiplePages() {
		
		// Insert test data
		Opportunity o = BacklogGeneratorTestFactory.InsertOpportunity(Date.newInstance(2014,01,01), 10, true, 100);
		Backlog__c[] blogs = BacklogGeneratorTestFactory.InsertAttachedBacklog(o, 10);
		
		// Helper set of inserted testdata ids
		Set<Id> referenceSetIds = (new Map<Id, Backlog__c>(blogs)).keySet();
		
		// Set our page
		PageReference pg = Page.BacklogManager;
		pg.getParameters().put('id', o.id);
		Test.setCurrentPage(pg);
		
		// Instantiate controller normally
		ApexPages.StandardSetController defaultController = new ApexPages.StandardSetController(new Backlog__c[]{});
		BacklogManagerControllerExt controller = new BacklogManagerControllerExt(defaultController);
		controller.PageSize = 3;
		
		// Test 1: The getBacklogSet method is only able to retrieve records on the current page,
		//		   and since our records are spread across 4 pages, it always only finds a subset
		controller.GoToFirst();
		Set<Id> getBacklogSetIds = (new Map<Id, Backlog__c>(controller.getBacklogSet())).keySet();
		System.assertEquals(3, getBacklogSetIds.size());
		
		controller.GoToLast();
		getBacklogSetIds = (new Map<Id, Backlog__c>(controller.getBacklogSet())).keySet();
		System.assertEquals(1, getBacklogSetIds.size());

		// Test 2: The getFullBacklogSet method is able to
		//			A) Collect all records across all pages
		//			B) Maintain the selected pagesize/pagenumber after it's finished
		
		// A)
		Set<Id> getFullBacklogSetIds = (new Map<Id, Backlog__c>(controller.getFullBacklogSet())).keySet();
		System.assertEquals(true, getFullBacklogSetIds.containsAll(referenceSetIds));
		
		// B)
		controller.GoToLast(); controller.getFullBacklogSet();
		System.assertEquals(4, controller.PageNum);
		
		controller.PageNum = 3; controller.getFullBacklogSet();
		System.assertEquals(3, controller.PageNum);
	}
	
	static testMethod void testButton_Regenerate() {
		// Note: the underlying logic is performed in the BacklogGenerator class and the proper behavior
		// 		 is asserted in unit tests there; this is just a sanity test
		
		// Insert test data
		Opportunity o = BacklogGeneratorTestFactory.InsertOpportunity(Date.newInstance(2014,01,01), 4, true, 100);
		
		// Set our page
		PageReference pg = Page.BacklogManager;
		pg.getParameters().put('id', o.id);
		Test.setCurrentPage(pg);
		
		// Instantiate controller normally
		ApexPages.StandardSetController defaultController = new ApexPages.StandardSetController(new Backlog__c[]{});
		BacklogManagerControllerExt controller = new BacklogManagerControllerExt(defaultController);
		
		// Test 1: There are currently no backlogs
		System.assertEquals(0, [SELECT COUNT() FROM Backlog__c]);
		
		// Test 2: Calling the Regenerate method inserts 4 backlogs
		controller.Regenerate();
		System.assertEquals(4, [SELECT COUNT() FROM Backlog__c]);
		System.assertEquals(4, controller.NumRecs);
		
	}
	
	static testMethod void testButton_DeleteAll_OnePage() {
		
		// Insert test data
		Opportunity o = BacklogGeneratorTestFactory.InsertOpportunity(Date.newInstance(2014,01,01), 5, true, 100);
		Backlog__c[] blogs = BacklogGeneratorTestFactory.InsertAttachedBacklog(o, 5);
		
		// Set our page
		PageReference pg = Page.BacklogManager;
		pg.getParameters().put('id', o.id);
		Test.setCurrentPage(pg);
		
		// Instantiate controller normally
		ApexPages.StandardSetController defaultController = new ApexPages.StandardSetController(new Backlog__c[]{});
		BacklogManagerControllerExt controller = new BacklogManagerControllerExt(defaultController);
		controller.PageSize = 10;
		
		// Test Setup Test:  We have some backlogs in the system, and they all fit on one page
		System.assert([SELECT COUNT() FROM Backlog__c] > 0, 'Backlogs must exist for the DeleteAll unit test');
		System.assert(controller.PageSize > [SELECT COUNT() FROM Backlog__c], 'Backlogs must fit on one page for DeleteAll_OnePage unit test');
		
		// Test 1: All backlogs are deleted after calling the DeleteAll method
		controller.DeleteAll();
		System.assertEquals(0, [SELECT COUNT() FROM Backlog__c]);
		
	}
	
	static testMethod void testButton_DeleteAll_MultiPage() {
		
		// Insert test data
		Opportunity o = BacklogGeneratorTestFactory.InsertOpportunity(Date.newInstance(2014,01,01), 10, true, 100);
		Backlog__c[] blogs = BacklogGeneratorTestFactory.InsertAttachedBacklog(o, 10);
		
		// Set our page
		PageReference pg = Page.BacklogManager;
		pg.getParameters().put('id', o.id);
		Test.setCurrentPage(pg);
		
		// Instantiate controller normally
		ApexPages.StandardSetController defaultController = new ApexPages.StandardSetController(new Backlog__c[]{});
		BacklogManagerControllerExt controller = new BacklogManagerControllerExt(defaultController);
		controller.PageSize = 3;
		
		// Test Setup Test:  We have some backlogs in the system, and they are spread across multiple pages
		System.assert([SELECT COUNT() FROM Backlog__c] > 0, 'Backlogs must exist for the DeleteAll unit test');
		System.assert(controller.NumPages > 1, 'Backlogs must be spread across multiple pages for DeleteAll_OnePage unit test');
		
		// Test 1: All backlogs are deleted after calling the DeleteAll method, irrespective of page
		controller.GoToFirst();
		controller.DeleteAll();
		System.assertEquals(0, [SELECT COUNT() FROM Backlog__c]);
		
		// Undelete and try a diff page
		undelete blogs;
		controller.GoToLast();
		
		System.assertEquals(true, [SELECT COUNT() FROM Backlog__c] > 0);
		controller.DeleteAll();
		System.assertEquals(0, [SELECT COUNT() FROM Backlog__c]);
		
	}
	
	static testMethod void testButton_SaveChanges() {
		
		// Note: This only works on teh current page of data (by design)
		
		// Insert test data
		Opportunity o = BacklogGeneratorTestFactory.InsertOpportunity(Date.newInstance(2014,01,01), 2, true, 100);
		Backlog__c b1 = BacklogGeneratorTestFactory.InsertAttachedBacklog(o);
		Backlog__c b2 = BacklogGeneratorTestFactory.InsertAttachedBacklog(o);
		
		// Set our page
		PageReference pg = Page.BacklogManager;
		pg.getParameters().put('id', o.id);
		Test.setCurrentPage(pg);
		
		// Instantiate controller normally
		ApexPages.StandardSetController defaultController = new ApexPages.StandardSetController(new Backlog__c[]{});
		BacklogManagerControllerExt controller = new BacklogManagerControllerExt(defaultController);
		
		// Test 1: We are able to save changes to the projected amount field on backlogs
		
		// Set initial amounts
		b1.Projected_Amount__c = 10;
		b2.Projected_Amount__c = 35;
		upsert new Backlog__c[]{b1, b2};
		
		// Make update
		List<Backlog__c> controllerBacklogSet = controller.getBacklogSet();
		for (Backlog__c b : controllerBacklogSet) {
			b.Projected_Amount__c = 999;
		}
		controller.SaveChanges();
		controller.BacklogSetController = null;
		
		System.assertEquals(999, controller.getBacklogSet().get(0).Projected_Amount__c);
		System.assertEquals(999, controller.getBacklogSet().get(1).Projected_Amount__c);

	}
	
	static testMethod void testButton_ApplyMassUpdate_OnePage() {
		
		// Insert test data
		Opportunity o = BacklogGeneratorTestFactory.InsertOpportunity(Date.newInstance(2014,01,01), 4, true, 100);
		Backlog__c[] blogs = BacklogGeneratorTestFactory.InsertAttachedBacklog(o, 4);
		
		// Set our page
		PageReference pg = Page.BacklogManager;
		pg.getParameters().put('id', o.id);
		Test.setCurrentPage(pg);
		
		// Instantiate controller normally
		ApexPages.StandardSetController defaultController = new ApexPages.StandardSetController(new Backlog__c[]{});
		BacklogManagerControllerExt controller = new BacklogManagerControllerExt(defaultController);
		System.assertEquals(1, controller.NumPages);
		
		// Test 1: ApplyMassUpdate works with single page record set
		Backlog__c[] proto = controller.getProtoBacklog();
		proto[0].Projected_Amount__c = 233;
		controller.ApplyMassUpdate();
		
		Backlog__c[] results = [SELECT Id, Projected_Amount__c FROM Backlog__c];
		System.assertEquals(233, results[0].Projected_Amount__c);
		System.assertEquals(233, results[1].Projected_Amount__c);
		System.assertEquals(233, results[2].Projected_Amount__c);
		
	}
	
	static testMethod void testButton_ApplyMassUpdate_MultiPage() {
		
		// Insert test data
		Opportunity o = BacklogGeneratorTestFactory.InsertOpportunity(Date.newInstance(2014,01,01), 4, true, 100);
		Backlog__c[] blogs = BacklogGeneratorTestFactory.InsertAttachedBacklog(o, 4);
		
		// Set our page
		PageReference pg = Page.BacklogManager;
		pg.getParameters().put('id', o.id);
		Test.setCurrentPage(pg);
		
		// Instantiate controller normally
		ApexPages.StandardSetController defaultController = new ApexPages.StandardSetController(new Backlog__c[]{});
		BacklogManagerControllerExt controller = new BacklogManagerControllerExt(defaultController);
		controller.PageSize = 2;
		System.assertEquals(2, controller.NumPages);
		
		// Test 1: ApplyMassUpdate works from page 1 on our multipage recordset
		controller.PageNum = 1;
		Backlog__c[] proto = controller.getProtoBacklog();
		proto[0].Projected_Amount__c = 233;
		controller.ApplyMassUpdate();
		
		Backlog__c[] results = [SELECT Id, Projected_Amount__c FROM Backlog__c];
		System.assertEquals(233, results[0].Projected_Amount__c);
		System.assertEquals(233, results[1].Projected_Amount__c);
		System.assertEquals(233, results[2].Projected_Amount__c);
		System.assertEquals(233, results[3].Projected_Amount__c);
		
		// Test 2: ApplyMassUpdate works from page 2 on our multipage recordset
		controller.PageNum = 2;
		proto = controller.getProtoBacklog();
		proto[0].Projected_Amount__c = 1000;
		controller.ApplyMassUpdate();
		
		results = [SELECT Id, Projected_Amount__c FROM Backlog__c];
		System.assertEquals(1000, results[0].Projected_Amount__c);
		System.assertEquals(1000, results[1].Projected_Amount__c);
		System.assertEquals(1000, results[2].Projected_Amount__c);
		System.assertEquals(1000, results[3].Projected_Amount__c);
		
	}
	
	static testMethod void testButton_ApplyMassUpdate_ValidateExcludeRecordsWithActuals() {
		
		// Insert test data
		Opportunity o = BacklogGeneratorTestFactory.InsertOpportunity(Date.newInstance(2014,01,01), 2, true, 100);
		Backlog__c b1 = BacklogGeneratorTestFactory.InsertAttachedBacklog(o, Date.newInstance(2014,01,01));
		Backlog__c b2 = BacklogGeneratorTestFactory.InsertAttachedBacklog(o, Date.newInstance(2014,02,01));
		
		// Give b1 a projected amount
		b1.Projected_Amount__c = 10;
		update b1;

		// Give b2 a projected amount and actual
		b2.Projected_Amount__c = 45;
		b2.Actual_Amount__c = 50;
		update b2;
		
		// Set our page
		PageReference pg = Page.BacklogManager;
		pg.getParameters().put('id', o.id);
		Test.setCurrentPage(pg);
		
		// Instantiate controller normally
		ApexPages.StandardSetController defaultController = new ApexPages.StandardSetController(new Backlog__c[]{});
		BacklogManagerControllerExt controller = new BacklogManagerControllerExt(defaultController);
		
		// Test 1: ApplyMassUpdate ignores the ProjectedAmount on the backlog that has actuals
		Backlog__c[] proto = controller.getProtoBacklog();
		proto[0].Projected_Amount__c = 100;
		controller.ApplyMassUpdate();
		
		Map<Id, Backlog__c> resultMap = new Map<Id, Backlog__c>([SELECT Id, Projected_Amount__c FROM Backlog__c]);
		System.assertEquals(100, resultMap.get(b1.Id).Projected_Amount__c);
		System.assertEquals(45, resultMap.get(b2.Id).Projected_Amount__c);
		
	}
	
	static testMethod void testButton_Syncronization_ValidateActualsCannotBeDeleted() {
		
		// Insert test data
		Opportunity o = BacklogGeneratorTestFactory.InsertOpportunity(Date.newInstance(2014,01,01), 2, true, 100);
		Backlog__c b1 = BacklogGeneratorTestFactory.InsertAttachedBacklog(o, Date.newInstance(2014,01,01));
		Backlog__c b2 = BacklogGeneratorTestFactory.InsertAttachedBacklog(o, Date.newInstance(2014,02,01));

		// Give b2 an actual
		b2.Actual_Amount__c = 50;
		update b2;
		
		// Set our page
		PageReference pg = Page.BacklogManager;
		pg.getParameters().put('id', o.id);
		Test.setCurrentPage(pg);
		
		// Instantiate controller normally
		ApexPages.StandardSetController defaultController = new ApexPages.StandardSetController(new Backlog__c[]{});
		BacklogManagerControllerExt controller = new BacklogManagerControllerExt(defaultController);
		
		// Test 1: We can perform syncronization if b2 ends up in the result set
		System.assertEquals(2, [SELECT COUNT() FROM Backlog__c]);
		controller.Opportunity.Estimated_Duration__c = 5;
		controller.SyncronizeNewProjections();
		System.assertEquals(5, [SELECT COUNT() FROM Backlog__c]);
		
		// Test 2: Syncronization fails if b2 would end up being deleted, and everything gets reverted
		controller.Opportunity.Estimated_Duration__c = 1;
		controller.SyncronizeNewProjections();
		
		System.assertEquals(5, BacklogGeneratorTestFactory.reHydrate(o).Estimated_Duration__c);
		System.assertEquals(5, [SELECT COUNT() FROM Backlog__c]);

	}
	
	static testMethod void testButton_Syncronization_ensureDMLErrorPathCodeCoverage() {
		
		// Insert test data
		Opportunity o = BacklogGeneratorTestFactory.InsertOpportunity(Date.newInstance(2014,01,01), 2, true, 100);
		Backlog__c b1 = BacklogGeneratorTestFactory.InsertAttachedBacklog(o, Date.newInstance(2014,01,01));
		Backlog__c b2 = BacklogGeneratorTestFactory.InsertAttachedBacklog(o, Date.newInstance(2014,02,01));
		
		// Set our page
		PageReference pg = Page.BacklogManager;
		pg.getParameters().put('id', o.id);
		Test.setCurrentPage(pg);
		
		// Instantiate controller normally
		ApexPages.StandardSetController defaultController = new ApexPages.StandardSetController(new Backlog__c[]{});
		BacklogManagerControllerExt controller = new BacklogManagerControllerExt(defaultController);
		
		// Successively force dml error pathways
		BacklogManagerControllerExt.doForceSyncDMLPath1 = true;
		controller.SyncronizeNewProjections();
		
		BacklogManagerControllerExt.doForceSyncDMLPath1 = false;
		BacklogManagerControllerExt.doForceSyncDMLPath2 = true;
		controller.SyncronizeNewProjections();
		
		BacklogManagerControllerExt.doForceSyncDMLPath2 = false;
		BacklogManagerControllerExt.doForceSyncDMLPath3 = true;
		controller.SyncronizeNewProjections();

	}
	
	static testMethod void testButton_Syncronization_OnePage() {
		
		// Note: Much of the logic for the syncronization is contained in BacklogGeneratorController, and the proper
		// 		 behavior is asserted in the unit tests there
		
		// Insert test data
		Opportunity o = BacklogGeneratorTestFactory.InsertOpportunity(Date.newInstance(2014,01,01), 2, true, 100);
		Backlog__c b1 = BacklogGeneratorTestFactory.InsertAttachedBacklog(o, Date.newInstance(2014,01,01));
		Backlog__c b2 = BacklogGeneratorTestFactory.InsertAttachedBacklog(o, Date.newInstance(2014,02,01));
				
		// Set our page
		PageReference pg = Page.BacklogManager;
		pg.getParameters().put('id', o.id);
		Test.setCurrentPage(pg);
		
		// Instantiate controller normally
		ApexPages.StandardSetController defaultController = new ApexPages.StandardSetController(new Backlog__c[]{});
		BacklogManagerControllerExt controller = new BacklogManagerControllerExt(defaultController);
		System.assertEquals(1, controller.NumPages);
		
		// Test 1: Syncronize works
		controller.Opportunity.Estimated_Start_Date__c = Date.newInstance(2014,02,01);
		controller.SyncronizeNewProjections();
		
		Map<Id, Backlog__c> resultMap = new Map<Id, Backlog__c>([SELECT Id, Date__c FROM Backlog__c]);
		Set<Date> newDates = new Set<Date>(); for (Backlog__c b : resultMap.values()) { newDates.add(b.Date__c); }
		
		System.assertEquals(false, resultMap.containsKey(b1.Id));
		System.assertEquals(true, resultMap.containsKey(b2.Id));
		System.assertEquals(2, resultMap.size());
		System.assertEquals(true, newDates.contains(Date.newInstance(2014,02,01)));
		System.assertEquals(true, newDates.contains(Date.newInstance(2014,03,01)));
		
	}
	/*static testMethod void testButton_Syncronization_MultiPage() {
		
		// Note: Much of the logic for the syncronization is contained in BacklogGeneratorController, and the proper
		// 		 behavior is asserted in the unit tests there
		
		// Insert test data
		Opportunity o = BacklogGeneratorTestFactory.InsertOpportunity(Date.newInstance(2014,01,01), 4, true, 100);
		Backlog__c b1 = BacklogGeneratorTestFactory.InsertAttachedBacklog(o, Date.newInstance(2014,01,01));
		Backlog__c b2 = BacklogGeneratorTestFactory.InsertAttachedBacklog(o, Date.newInstance(2014,02,01));
		Backlog__c b3 = BacklogGeneratorTestFactory.InsertAttachedBacklog(o, Date.newInstance(2014,03,01));
		Backlog__c b4 = BacklogGeneratorTestFactory.InsertAttachedBacklog(o, Date.newInstance(2014,04,01));
				
		// Set our page
		PageReference pg = Page.BacklogManager;
		pg.getParameters().put('id', o.id);
		Test.setCurrentPage(pg);
		
		// Instantiate controller normally
		ApexPages.StandardSetController defaultController = new ApexPages.StandardSetController(new Backlog__c[]{});
		BacklogManagerControllerExt controller = new BacklogManagerControllerExt(defaultController);
		controller.PageSize = 2;
		System.assertEquals(2, controller.NumPages);
		
		// Test 1: Syncronize works from page 1 of our multipage recordset
		controller.PageNum = 1;
		controller.Opportunity.Estimated_Start_Date__c = Date.newInstance(2014,03,01);
		controller.SyncronizeNewProjections();
		
		Map<Id, Backlog__c> resultMap = new Map<Id, Backlog__c>([SELECT Id, Date__c FROM Backlog__c ORDER BY Date__c ASC]);
		Set<Date> newDates = new Set<Date>(); for (Backlog__c b : resultMap.values()) { newDates.add(b.Date__c); }
		
		System.assertEquals(false, resultMap.containsKey(b1.Id));
		System.assertEquals(false, resultMap.containsKey(b2.Id));
		System.assertEquals(true, resultMap.containsKey(b3.Id));
		System.assertEquals(true, resultMap.containsKey(b4.Id));
		System.assertEquals(4, resultMap.size());
		System.assertEquals(true, newDates.contains(Date.newInstance(2014,03,01)));
		System.assertEquals(true, newDates.contains(Date.newInstance(2014,04,01)));
		System.assertEquals(true, newDates.contains(Date.newInstance(2014,05,01)));
		System.assertEquals(true, newDates.contains(Date.newInstance(2014,06,01)));
		
		// Test 2: Syncronize works from page 2 of our multipage recordset
		controller.PageNum = 2;
		controller.Opportunity.Estimated_Start_Date__c = Date.newInstance(2014,05,01);
		controller.SyncronizeNewProjections();
		
		resultMap = new Map<Id, Backlog__c>([SELECT Id, Date__c FROM Backlog__c ORDER BY Date__c ASC]);
		newDates = new Set<Date>(); for (Backlog__c b : resultMap.values()) { newDates.add(b.Date__c); }
		
		System.assertEquals(false, resultMap.containsKey(b1.Id));
		System.assertEquals(false, resultMap.containsKey(b2.Id));
		System.assertEquals(false, resultMap.containsKey(b3.Id));
		System.assertEquals(false, resultMap.containsKey(b4.Id));
		System.assertEquals(4, resultMap.size());
		System.assertEquals(true, newDates.contains(Date.newInstance(2014,05,01)));
		System.assertEquals(true, newDates.contains(Date.newInstance(2014,06,01)));
		System.assertEquals(true, newDates.contains(Date.newInstance(2014,07,01)));
		System.assertEquals(true, newDates.contains(Date.newInstance(2014,08,01)));
	} /*
	
	/*static testMethod void HowDoesThisWork() {
		Opportunity o = new Opportunity(Name = 'Opp', StageName = 'Prospecting', CloseDate = Date.today());
		insert o;
		
		Backlog__c b1 = new Backlog__c(Opportunity__c = o.Id,  Actual_Amount__c = 5);
		Backlog__c b2 = new Backlog__c(Opportunity__c = o.Id,  Actual_Amount__c = 10);
		Backlog__c[] bArr = new Backlog__c[]{b1, b2};
		insert bArr;
		
		Map<Id, Backlog__c> MrMapp = new Map<Id, Backlog__c>(bArr);
		
		b1.Actual_Amount__c = 555;
		System.assertEquals(555, MrMapp.get(b1.Id).Actual_Amount__c);
		System.assertEquals(555, bArr[0].Actual_Amount__c);
		
		List<Backlog__c> bList = new List<Backlog__c>();
		bList.add(b1);
		
		b1.Actual_Amount__c = 9999;
		System.assertEquals(9999, bList.get(0).Actual_Amount__c);
		
	}*/
	
}