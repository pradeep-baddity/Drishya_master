@isTest
private class ChatterFeedPurgeLibTest {
	
	// Makes sure I built the test factory properly
	static testMethod void testOpportunityFactoryMethods() {
		
		//  w.r.t InsertOpportunityEmpty: true = closed, false = open
		Opportunity o = ChatterFeedPurgeTestFactory.InsertOpportunityEmpty(false);
		System.assertEquals(false, o.IsClosed);
		
		o = ChatterFeedPurgeTestFactory.InsertOpportunityEmpty(true);
		System.assertEquals(true, o.IsClosed);
		
		o = ChatterFeedPurgeTestFactory.OpenOpportunity(o);
		System.assertEquals(false, o.IsClosed);
		
		o = ChatterFeedPurgeTestFactory.CloseOpportunity(o, null);
		System.assertEquals(true, o.IsClosed);
		
	}
	
	static testMethod void testPostsOnOpportunityFinder() {
		
		ChatterFeedPurgeLib c = new ChatterFeedPurgeLib();
		
		// Test 1: Valid closed opportunity without chatter posts finds no FeedItems
		Opportunity o = ChatterFeedPurgeTestFactory.InsertOpportunityEmpty(true);
		Set<Id> feedItems = c.QueryFeedItemsOnOldOpportunities(Date.today().addDays(1));
		System.assertEquals(0, feedItems.size());
		
		// Test 2: Adding chatter posts to our closed opportunity gets detected
		ChatterFeedPurgeTestFactory.InsertFeedItem(o.Id);
		feedItems = c.QueryFeedItemsOnOldOpportunities(Date.today().addDays(1));
		System.assertEquals(1, feedItems.size());
		
		ChatterFeedPurgeTestFactory.InsertFeedItem(o.Id);
		feedItems = c.QueryFeedItemsOnOldOpportunities(Date.today().addDays(1));
		System.assertEquals(2, feedItems.size());
		
		// Test 3: But unrelated chatter posts are not detected
		ChatterFeedPurgeTestFactory.InsertFeedItem(null);
		feedItems = c.QueryFeedItemsOnOldOpportunities(Date.today().addDays(1));
		System.assertEquals(2, feedItems.size());
		
	}
	
	static testMethod void testNonOpportunityPostsFinder() {
		
		ChatterFeedPurgeLib c = new ChatterFeedPurgeLib();
		
		// Test 1: Non opportunity related chatter posts created AFTER threshold NOT found
		FeedItem fi1 = ChatterFeedPurgeTestFactory.InsertFeedItem(null);
		System.debug('************************* ' + fi1);
		Set<Id> items = c.QueryNonOppFeedItemsCreatedBeforeDate(Datetime.now().dateGMT().addDays(-1));
		System.assertEquals(0, items.size());

		// Test 2: Non opportunity related chatter posts created BEFORE threshold ARE found
		items = c.QueryNonOppFeedItemsCreatedBeforeDate(Datetime.now().dateGMT().addDays(1));
		System.assertEquals(1, items.size());
		System.assertEquals(true, items.contains(fi1.Id));
		
		// Test 3: Opportunity related chatter posts created before threshold are STILL disqualified based on type
		Opportunity o = ChatterFeedPurgeTestFactory.InsertOpportunityEmpty(false);
		FeedItem fi2 = ChatterFeedPurgeTestFactory.InsertFeedItem(o.Id);
		items = c.QueryNonOppFeedItemsCreatedBeforeDate(Datetime.now().dateGMT().addDays(1));
		
		System.assertEquals(1, items.size());
		System.assertEquals(false, items.contains(fi2.Id));
		// Note there are 2 items now, so asserting size is still 1 tests disqualification is happening
		
	}
		
	static testMethod void testCustomSettingsRetrieval() {
		
		// Insert the org default custom setting
		Date TenDaysAgo_oppThreshold = Date.today().addDays(-10);
		Date NinetyDaysAgo_defaultThreshold = Date.today().addDays(-90);
		
		ChatterFeedPurgeLib.forceSettingsOverride = ChatterFeedPurgeTestFactory.GetCustomSettings(10, 90);
		
		// Test 1:  Assert that retrieved dates are what we expect
		System.assertEquals(TenDaysAgo_oppThreshold, ChatterFeedPurgeLib.OPPORTUNITY_CLOSE_DATE_THRESHOLD);
		System.assertEquals(NinetyDaysAgo_defaultThreshold, ChatterFeedPurgeLib.NONOPP_CREATE_DATE_THRESHOLD);
		
	}
	
	static testMethod void ensureCodeCoverage() {
		
		ChatterFeedPurgeLib c = new ChatterFeedPurgeLib();
		
		// Insert CustomSettings and run through top level method
		ChatterFeedPurgeLib.forceSettingsOverride = ChatterFeedPurgeTestFactory.GetCustomSettings(-1, -1);
		c.GetFeedItemIdsToPurge();

	}
}