@isTest
public class ChatterFeedPurgeTestFactory {
	
	public static void InsertCustomSettings(Integer oppOldAgeDays, Integer defaultOldAgeDays) {
		insert GetCustomSettings(oppOldAgeDays, defaultOldAgeDays);
	}
	public static Chatter_Feed_Purge_Settings__c GetCustomSettings(Integer oppOldAgeDays, Integer defaultOldAgeDays) {
		
		Chatter_Feed_Purge_Settings__c settings = new Chatter_Feed_Purge_Settings__c();
		settings.SetupOwnerId = UserInfo.getOrganizationId();
		settings.Default_Post_Old_Age_Thresh__c = defaultOldAgeDays;
		settings.Opportunity_Post_Old_Age_Thresh__c = oppOldAgeDays;
		
		return settings;
	}
	

	public static Account InsertAccountEmpty() {
		Account a = new Account(Name = 'Matt Kinni');
		insert a;
		return a;
	}
	
	
	// OPPORTUNITY RELATED METHODS -----------------------------/
	public static Opportunity InsertOpportunityEmpty(Boolean isClosed) {
		
		Opportunity o = new Opportunity();
		o.Name = 'Test Opportunity';
		o.CloseDate = Date.Today();
		o.Do_Not_Run_WF__c = true;
		o.Do_Not_Validate__c = true;
		
		if (isClosed == true) {
			o.StageName = 'Closed Won';
			o.Probability = 100;
			o.Date_Last_Closed__c = Date.today();
		} else {
			o.StageName = 'Prospecting';
			o.Probability = 10;
		}
		
		insert o;
		o = RehydrateOpportunity(o);
		
		return o;
	}
	public static Opportunity RehydrateOpportunity(Opportunity opp) {
		
		Opportunity o = [SELECT Id, Name, StageName, Probability, CloseDate, Date_Last_Closed__c, isClosed, isWon
						FROM  Opportunity WHERE Id = :opp.Id][0]; 
		return o;
	}
	public static Opportunity OpenOpportunity(Opportunity opp) {
		opp.StageName = 'Prospecting';
		update opp;
		return RehydrateOpportunity(opp);
	}
	public static Opportunity CloseOpportunity(Opportunity opp, Date closeDateOverride) {
		opp.StageName = 'Closed Won';
		update opp;
		
		if (closeDateOverride != null) {
			opp.Date_Last_Closed__c = closeDateOverride;
			update opp;
		}
		return RehydrateOpportunity(opp);
	}
	// END OPPORTUNITY RELATED METHODS -------------------------/
	
	public static FeedItem InsertFeedItem(Id opportunityId) {
		FeedItem fi = new FeedItem();
		fi.Type = 'TextPost';
		fi.Body = 'Test comment';
		
		if (opportunityId != null) {
			fi.ParentId = opportunityId;

		} else {
			// If no opportunity id specified, associate to unrelated object
			Account a = InsertAccountEmpty();
			fi.ParentId = a.Id;
		}
		
		insert fi;
		fi = RehydrateFeedItem(fi);
		
		return fi;
	}
	public static FeedItem RehydrateFeedItem(FeedItem item) {
		FeedItem fi = [SELECT Id, ParentId, Type, Body, CreatedDate FROM FeedItem WHERE Id = :item.Id][0];
		return fi;
	}
	
	// Overriding the createdate can only happen in memory
	public static FeedItem GetCustomCreatedOnFeedItem(Id opportunityId, Date createdDateOverride) {
		
		Id parentId = null;
		if (opportunityId != null) {
			parentId = opportunityId;
			
		} else {
			// If no opportunity id specified, associate to unrelated object
			Account a = InsertAccountEmpty();
			parentId = a.Id;
		}
		
		String createdDateStr = null;//2014-12-23T17:47:19.000+0000
		if (createdDateOverride != null) {
			createdDateStr = JSON.serialize(Datetime.newInstanceGMT(Date.today(), Time.newInstance(0,0,0,0)));
			
		} else {
			createdDateStr = JSON.serialize(Datetime.now());
		}
		
		// Note: get jsonStr example by calling JSON.serialize() on an example object
		String jsonStr = '{"attributes":{"type":"FeedItem","url":"/services/data/v32.0/sobjects/FeedItem/0D5q00000019o8TCAQ"},"Body":"Test comment","ParentId":"' + parentId + '","Type":"TextPost","CreatedDate":"' + createdDateStr + '","Id":"0D5q00000019o8TCAQ"}';
		FeedItem item = (FeedItem)JSON.deserialize(jsonStr, FeedItem.class);
		
		return item;
	}
	
}