@isTest
private class ChatterFeedPurgeBatchableTest {
	
	static testMethod void testFeedPurge() {
		
		ChatterFeedPurgeLib c = new ChatterFeedPurgeLib();
		
		// Test 1: Insert 2 FeedItems, make sure both of them count
		ChatterFeedPurgeLib.forceSettingsOverride = ChatterFeedPurgeTestFactory.GetCustomSettings(-2, -2);
		FeedItem fi1 = ChatterFeedPurgeTestFactory.InsertFeedItem(null);
		FeedItem fi2 = ChatterFeedPurgeTestFactory.InsertFeedItem(null);
		
		Map<Id, FeedItem> items = new Map<Id, FeedItem>([SELECT Id FROM FeedItem]);
		Set<Id> itemSet = c.GetFeedItemIdsToPurge();
		
		System.assertEquals(2, items.size());
		System.assertEquals(2, itemSet.size());
		System.assertEquals(items.keySet(), itemSet);
		
		// Test 2: Run the batchable and ensure everything was deleted
		Test.startTest();
		ID batchprocessid = Database.executeBatch(new ChatterFeedPurgeBatchable(), 2);
		Test.stopTest();
		
		items =  new Map<Id, FeedItem>([SELECT Id FROM FeedItem]);
		System.assertEquals(0, items.size());
	}
	
	static testMethod void ensureCodeCoverage_StartException() {
		
		FeedItem fi1 = ChatterFeedPurgeTestFactory.InsertFeedItem(null);
		FeedItem fi2 = ChatterFeedPurgeTestFactory.InsertFeedItem(null);
		
		Test.startTest();
		
		ChatterFeedPurgeLib.forceSettingsOverride = ChatterFeedPurgeTestFactory.GetCustomSettings(-2, -2);
		ChatterFeedPurgeBatchable.doThrowTestExceptionStart = true;
		ID jobId = Database.executeBatch(new ChatterFeedPurgeBatchable(), 2);
		
		Test.stopTest();
	}
	
	static testMethod void ensureCodeCoverage_ExecuteException() {
		
		FeedItem fi1 = ChatterFeedPurgeTestFactory.InsertFeedItem(null);
		FeedItem fi2 = ChatterFeedPurgeTestFactory.InsertFeedItem(null);
		
		Test.startTest();
		
		ChatterFeedPurgeLib.forceSettingsOverride = ChatterFeedPurgeTestFactory.GetCustomSettings(-2, -2);
		ChatterFeedPurgeBatchable.doThrowTestExceptionExecute = true;
		ID jobId = Database.executeBatch(new ChatterFeedPurgeBatchable(), 2);
		
		Test.stopTest();
	}
	
	static testMethod void ensureCodeCoverage_FinishException() {
		
		FeedItem fi1 = ChatterFeedPurgeTestFactory.InsertFeedItem(null);
		FeedItem fi2 = ChatterFeedPurgeTestFactory.InsertFeedItem(null);
		
		Test.startTest();
		
		ChatterFeedPurgeLib.forceSettingsOverride = ChatterFeedPurgeTestFactory.GetCustomSettings(-2, -2);
		ChatterFeedPurgeBatchable.doThrowTestExceptionFinish = true;
		ID jobId = Database.executeBatch(new ChatterFeedPurgeBatchable(), 2);
		
		Test.stopTest();
	}
	
}