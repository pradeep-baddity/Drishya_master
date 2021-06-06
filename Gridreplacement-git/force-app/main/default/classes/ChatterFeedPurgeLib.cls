public class ChatterFeedPurgeLib{
	
	@testVisible private static Chatter_Feed_Purge_Settings__c forceSettingsOverride;
	private static Chatter_Feed_Purge_Settings__c getSettings() {
		Chatter_Feed_Purge_Settings__c retObj = null;
		if (Test.isRunningTest() && forceSettingsOverride != null) {
			retObj = forceSettingsOverride;
		} else {
			retObj = Chatter_Feed_Purge_Settings__c.getOrgDefaults();
		}
		return retObj;
	}
	
	public static Date OPPORTUNITY_CLOSE_DATE_THRESHOLD {
		get {
			Chatter_Feed_Purge_Settings__c settings = getSettings();
			Integer daysAgo = settings.Opportunity_Post_Old_Age_Thresh__c.intValue();
			
			return Date.today().addDays(-daysAgo);
		}
	}
	public static Date NONOPP_CREATE_DATE_THRESHOLD {
		get {
			Chatter_Feed_Purge_Settings__c settings = getSettings();
			Integer daysAgo = settings.Default_Post_Old_Age_Thresh__c.intValue();
			
			return Date.today().addDays(-daysAgo);
		}
	}
	
	// TOP LEVEL METHODS -----------------------/
	
	// Gets combined list of opportunity/other chatter posts meeting purge criteria
	public Set<Id> GetFeedItemIdsToPurge() {
		Set<Id> retObj = new Set<Id>();
		
		// Get opportunity related chatter posts
		Set<Id> oppFI = QueryFeedItemsOnOldOpportunities(OPPORTUNITY_CLOSE_DATE_THRESHOLD);
		retObj.addAll(oppFI);
		
		// Get all other chatter posts
		Set<Id> nonoppFI = QueryNonOppFeedItemsCreatedBeforeDate(NONOPP_CREATE_DATE_THRESHOLD);
		retObj.addAll(nonoppFI);
		
		System.debug(CommonConstants.DEBUG_PREFIX + 'Purging ' + retObj.size() + ' total feed item(s)');
		return retObj;
	}
	// END TOP LEVEL METHODS -----------------------/
	
	// HELPER METHODS --------------------------/	
	public Set<Id> QueryFeedItemsOnOldOpportunities(Date closeDateThreshold) {
		Set<Id> retObj = new Set<Id>();
		
		Map<Id, OpportunityFeed> itemMap = new Map<Id, OpportunityFeed>([	SELECT
																				Id
																				,ParentId
																				,Parent.IsClosed
																				,Parent.Date_Last_Closed__c 
																				,Body
																				,Type
																				,InsertedBy.Name
																			FROM OpportunityFeed
																			WHERE Parent.IsClosed = true
																			AND Parent.Date_Last_Closed__c < :closeDateThreshold]);
		
		
		// For counting purposes
		Set<Id> parentIds = new Set<Id>();
		for (OpportunityFeed oppf : itemMap.values()) { parentIds.add(oppf.ParentId); }
		
		retObj = itemMap.keySet();
		System.debug(CommonConstants.DEBUG_PREFIX + 'Located ' + retObj.size() + ' feed item(s) belonging to ' + parentIds.size() + ' Opportunity record(s) closed before ' + closeDateThreshold.format() + ' threshold (' + closeDateThreshold.daysBetween(Date.today())  + ' days ago)');
		return retObj;
	}


	public Set<Id> QueryNonOppFeedItemsCreatedBeforeDate(Date createDateThreshold) {
		Set<Id> retObj = new Set<Id>();
		
		FeedItem[] items = [SELECT
								Id,
								ParentId,
								Body,
								Type,
								InsertedBy.Name
							FROM FeedItem
							WHERE CreatedDate < :createDateThreshold];
		
		retObj = GetFeedItemsContrainedByParentType(items);
		
		System.debug(CommonConstants.DEBUG_PREFIX + 'Located ' + items.size() + ' feed item(s) created before ' + createDateThreshold.format() + ' threshold' + ' (' + createDateThreshold.daysBetween(Date.today())  + ' days ago)');
		System.debug(CommonConstants.DEBUG_PREFIX + 'Of that, ' + retObj.size() + ' record(s) meet parent type criteria');
		return retObj;
	}
	
	public Set<Id> GetFeedItemsContrainedByParentType(FeedItem[] items) {
		Set<Id> retObj = new Set<Id>();
		
		Set<Schema.SObjectType> parentTypeIgnoreList = new Set<Schema.SObjectType>(new Schema.SObjectType[]{ Schema.Opportunity.SObjectType });
		for (FeedItem item : items) {
			
			Schema.SObjectType parentType = item.ParentId.getSobjectType();
			if (!parentTypeIgnoreList.contains(parentType)) {
				retObj.add(item.Id);
				//System.debug(CommonConstants.DEBUG_PREFIX + 'feed item ' + item.Id + ' has a parent of type ' + parentType + ', which is NOT forbidden');
			} /*else {
				System.debug(CommonConstants.DEBUG_PREFIX + 'feed item ' + item.Id + ' has a parent of type ' + parentType + ', which IS forbidden');
			}*/
			
		}
		return retObj;
	}
	
	// END HELPER METHODS --------------------------/
}