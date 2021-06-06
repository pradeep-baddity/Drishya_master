global class ChatterFeedPurgeBatchable implements Database.Batchable<Id>, Database.Stateful {
	
	private static CommonLoggingUtils log = CommonLoggingUtils.getInstance();
	private ChatterFeedPurgeLib purger = new ChatterFeedPurgeLib();
	
	@testVisible private static Boolean doThrowTestExceptionStart = false;
	@testVisible private static Boolean doThrowTestExceptionExecute = false;
	@testVisible private static Boolean doThrowTestExceptionFinish = false;
	
	public Integer currentIteration = 1;
	public Integer numSucceeded = 0;
	public Integer numFailed = 0;
	public Integer numRecords { get { return numSucceeded + numFailed; }}
	public String executeSummary = '';
	

	global List<Id> start(Database.BatchableContext info){ 
		
		List<Id> retObj = new List<Id>();
		try {
			if (Test.isRunningTest() && doThrowTestExceptionStart) { Integer lolmath = 1/0; }
			
			Set<Id> feedItemIds = purger.GetFeedItemIdsToPurge();
		
			// In test mode automatically delete one of them prematurely to trigger error later
			if (Test.isRunningTest() && feedItemIds.size() > 0) {
				FeedItem fi = new FeedItem(Id = new List<Id>(feedItemIds)[0]);
				delete fi;
			}

			retObj = new List<Id>(feedItemIds);
			
		} catch (Exception e) {
			String exMsg = 'Apex Batch Job Id=' + info.getJobId();
			log.LogApexException(e, exMsg);
			
		} finally {
			log.Flush();
		}
		
		return retObj;
	}
	
	global void execute(Database.BatchableContext info, List<Id> scope){
		
		try {
			if (Test.isRunningTest() && doThrowTestExceptionExecute) { Integer lolmath = 1/0; }
			
			executeSummary += '\n\n-------------------------------------';
			executeSummary += '\nPROCESSING BATCH #' + currentIteration;
			executeSummary += '\n-------------------------------------\n';
			
			executeSummary += 'IDS IN SCOPE';
			for (Id thisId : scope) {
				executeSummary += '\n\t ' + thisId;
			}
			executeSummary += '\n\nDELETION RESULTS';
			
			log.SetAdditionalInfoOverride('Apex Batch Job Id=' + info.getJobId());
			CommonDMLUtils.DmlResults results = CommonDMLUtils.SafeDatabaseDelete(new Set<Id>(scope), false);
			log.ClearAdditionalInfoOverride();
			
			for (String result : results.GetInterpolatedMessageList()) {
				executeSummary += '\n\t* ' + result;
			}
			numSucceeded += results.numSuccess;
			numFailed += results.numFail;

			
		} catch (Exception e) {
			log.LogApexException(e);
			
		} finally {
			log.Flush();
			currentIteration++;
			
		}
		
	}    
	
	global void finish(Database.BatchableContext info){
		
		try {
			if (Test.isRunningTest() && doThrowTestExceptionFinish) { Integer lolmath = 1/0; }
			
			if (CommonConstants.IS_SANDBOX || Test.isRunningTest()) {
				DispatchDebugSummary(info);
			}
		} catch (Exception e) {
			String exMsg = 'Apex Batch Job Id=' + info.getJobId();
			log.LogApexException(e, exMsg);
		} finally {
			log.Flush();
		}
		
	} 
	
	global void DispatchDebugSummary(Database.BatchableContext info) {
		AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
      						FROM AsyncApexJob WHERE Id = :info.getJobId()];
		
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		mail.setToAddresses(new String[] { a.CreatedBy.Email });
		mail.setSenderDisplayName('Batch Processing Huron Sandbox');
		mail.setSubject('Batch Process Id ' + info.getJobId() + ': ' + a.Status);
		
		
		String message = 'The batch Apex job (' + info.getJobId() + ') processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.';
		message += '\n';
		message += '\nTotal successful FeedItem deletions: ' + numSucceeded;
		message += '\nTotal failed FeedItem deletions: ' + numFailed;
		message += '\nTotal attempted FeedItem deletions: ' + numRecords;
		message += '\n\n------------- ITERATION RESULTS SUMMARY ---------------';

		mail.setPlainTextBody(message + executeSummary);
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	}
}