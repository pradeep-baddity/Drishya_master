@isTest
private class CommonLoggingUtilsTest {
	
	static testMethod void testGenericException() {
		
		CommonLoggingUtils log = CommonLoggingUtils.getInstance();
		System.assertEquals(0, log.exCount);
		
		try {
			Integer lolmath = 1/0;
		} catch (Exception e) {
			log.LogApexException(e, 'Math is fun!');
			log.LogApexException(e);
			
			// Test 1: Our counter variable has registered there are two exceptions in the buffer
			System.assertEquals(2, log.exCount);
			
		} finally {
			log.Flush();
			
			// Test 2: Our counter variable has been reset
			System.assertEquals(0, log.exCount);
			
			// Test 3: Our ApplicationException records have actually been logged
			Error_Log__c[] ex = [SELECT Id FROM Error_Log__c];
			System.assertEquals(2, ex.size());
		}
	}
	
	static testMethod void testDatabaseErrorLogger() {
		
		CommonLoggingUtils log = CommonLoggingUtils.getInstance();
		System.assertEquals(0, log.exCount);
		
		// Insert an opportunity without the required fields. (allOrNothing = false)
		Opportunity o = new Opportunity();
		Database.SaveResult[] results = Database.insert(new Opportunity[]{o}, false);
		
		for (Database.SaveResult result : results) {
			if (!result.isSuccess()) {
				String exMsg = 'Failed to insert Opportunity Id=' + result.getId();
				log.LogDatabaseError(result.getErrors(), exMsg);
			}
		}
		
		// Test 1: Counter variable has registered the exception
		System.assertEquals(1, log.exCount);
		   
		log.Flush();	
		
		// Test 2: Counter variable has been cleared
		System.assertEquals(0, log.exCount);
		
		// Test 3: Exception has been recorded
		Error_Log__c[] ex = [SELECT Id FROM Error_Log__c];
		System.assertEquals(1, ex.size());
		
	}
	
	static testMethod void testDatabaseErrorLoggerPreformattedMsg() {
		
		CommonLoggingUtils log = CommonLoggingUtils.getInstance();
		System.assertEquals(0, log.exCount);
		
		// Call the logging method with a message
		log.LogDatabaseError('Here is an already formatted error');
		
		// Call the logging method with a message and additional message
		log.LogDatabaseError('Here is an already formatted error', 'My additional info');
		
		// Test 1: Counter variable has registered the exception
		System.assertEquals(2, log.exCount);
		   
		log.Flush();	
		
		// Test 2: Counter variable has been cleared
		System.assertEquals(0, log.exCount);
		
		// Test 3: Exception has been recorded
		Error_Log__c[] ex = [SELECT Id FROM Error_Log__c];
		System.assertEquals(2, ex.size());
		
	}
	
	static testMethod void testDatabaseExceptionLogger() {
		
		CommonLoggingUtils log = CommonLoggingUtils.getInstance();
		System.assertEquals(0, log.exCount);
		
		// Insert an opportunity without the required fields. (allOrNothing = true)
		Opportunity o = new Opportunity();
		SObject[] objects = new SObject[]{o};
		
		try {
			Database.SaveResult[] results = Database.insert(objects, true);
			
		} catch (DmlException e) {
			log.LogDatabaseException('insert', objects, e);
			
			// Retrieve error messages for code coverage
			CommonLoggingUtils.GetDmlErrorMessages('insert', objects, e);
			
			// Test 1: Counter variable has registered the exception
			System.assertEquals(1, log.exCount);
			
		} finally {
			log.Flush();
			
			// Test 2: Counter variable has been cleared
			System.assertEquals(0, log.exCount);
		}
		
		// Test 3: Exception has been recorded
		Error_Log__c[] ex = [SELECT Id FROM Error_Log__c];
		System.assertEquals(1, ex.size());
		
	}
	
	static testMethod void testAdditionalInfoOverride() {
		CommonLoggingUtils log = CommonLoggingUtils.getInstance();
		
		String overrideStr = 'my override string';
		String regularAdditionalInfo = 'my regular additional info';
		
		// Test 1: Additional info is consumed by default
		try {
			Integer lolmath = 1/0;
		} catch (Exception e) {
			log.LogApexException(e, regularAdditionalInfo);
			log.Flush();
			
			Error_Log__c ex = [SELECT Id, Additional_Info__c FROM Error_Log__c][0];
			System.assertEquals(regularAdditionalInfo, ex.Additional_Info__c);
		}
		
		delete [select Id from Error_log__c];
		
		// Test 2: Setting an override works
		log.SetAdditionalInfoOverride(overrideStr);
		try {
			Integer lolmath = 1/0;
		} catch (Exception e) {
			log.LogApexException(e, regularAdditionalInfo);
			log.Flush();
			
			Error_Log__c ex = [SELECT Id, Additional_Info__c FROM Error_Log__c][0];
			System.assertEquals(overrideStr, ex.Additional_Info__c);
		}
		
		delete [select Id from Error_log__c];
		
		// Test 3: Clearing the override reverts to user entered string
		log.ClearAdditionalInfoOverride();
		try {
			Integer lolmath = 1/0;
		} catch (Exception e) {
			log.LogApexException(e, regularAdditionalInfo);
			log.Flush();
			
			Error_Log__c ex = [SELECT Id, Additional_Info__c FROM Error_Log__c][0];
			System.assertEquals(regularAdditionalInfo, ex.Additional_Info__c);
		}
		
	}
	
	static testMethod void ensureCodeCoverage() {
		CommonLoggingUtils log = CommonLoggingUtils.getInstance();
		CommonLoggingUtils.GenerateStackTrace(false);
		try {
			Integer lolmath = 1/0;
		} catch (Exception e) {
			CommonLoggingUtils.ConvertExceptionToPageMessage(e);
		}
		
	}
	
	
}