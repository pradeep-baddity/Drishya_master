@isTest
private class CommonDMLUtilsTest {
		
	static testMethod void testDatabaseUpsert_MultiObj_AllOrNothingFail() {
		Account a1 = new Account();
		Account a2 = new Account();
		Account[] accts = new Account[]{a1, a2};
		
		CommonDMLUtils.SafeDatabaseUpsert(accts, true);
		
		// Test 1: Nothing was inserted
		Integer numAccounts = [SELECT COUNT() FROM Account];
		System.assertEquals(numAccounts, 0);
		
		// Test 2: The failures were recorded to the log buffer
		CommonLoggingUtils log = CommonLoggingUtils.getInstance();
		System.assertEquals(2, log.exCount);
		
	}
	
	static testMethod void testDatabaseUpsert_MultiObj_PartialSuccess() {
		Account a1 = new Account(Name = 'Matt');
		Account a2 = new Account();
		Account[] accts = new Account[]{a1, a2};
		
		CommonDMLUtils.SafeDatabaseUpsert(accts, false);
		
		// Test 1: One account was inserted
		Integer numAccounts = [SELECT COUNT() FROM Account];
		System.assertEquals(numAccounts, 1);
		
		// Test 2: One account was recorded as an error
		CommonLoggingUtils log = CommonLoggingUtils.getInstance();
		System.assertEquals(1, log.exCount);
	}
	
	static testMethod void testDatabaseUpsert_MultiObj_Success() {
		Account a1 = new Account(Name = 'Matt');
		Account a2 = new Account(Name = 'Matt');
		Account[] accts = new Account[]{a1, a2};
		
		CommonDMLUtils.SafeDatabaseUpsert(accts, true);
		
		// Test 1: Two accounts were inserted
		Integer numAccounts = [SELECT COUNT() FROM Account];
		System.assertEquals(numAccounts, 2);
		
		// Test 2: No failures were recorded
		CommonLoggingUtils log = CommonLoggingUtils.getInstance();
		System.assertEquals(0, log.exCount);
		
		// For code coverage, force a generic exception
		CommonDMLUtils.forceTestException = true;
		CommonDMLUtils.SafeDatabaseUpsert(accts, true);
		
	}
	
	static testMethod void testDatabaseDelete_OneObj_AllOrNothingFail() {
		Account a1 = new Account(Name = 'Matt');
		insert a1;
		delete a1;
		
		CommonDMLUtils.SafeDatabaseDelete(a1, true);
		
		// Test 1: Trying to delete an already deleted object causes an exception
		CommonLoggingUtils log = CommonLoggingUtils.getInstance();
		System.assertEquals(1, log.exCount);
		
	}
	
	static testMethod void testDatabaseDelete_OneObj_PartialFail() {
		Account a1 = new Account(Name = 'Matt');
		insert a1;
		delete a1;
		
		CommonDMLUtils.SafeDatabaseDelete(a1, false);
		
		// Test 1: Trying to delete an already deleted object causes error
		CommonLoggingUtils log = CommonLoggingUtils.getInstance();
		System.assertEquals(1, log.exCount);
		
	}
	
	static testMethod void testDatabaseDelete_OneObj_Success() {
		Account a1 = new Account(Name = 'Matt');
		insert a1;
		
		// Test 1: Make sure there is an account ready for deletion
		System.assert(a1.Id != null);
		System.assertEquals(1, [SELECT COUNT() FROM Account]);
		
		CommonDMLUtils.SafeDatabaseDelete(a1, true);
		
		// Test2: Account was successfully deleted
		System.assertEquals(0, [SELECT COUNT() FROM Account]);
		
		// For code coverage, do the same thing but with the Id constructor
		undelete a1;
		CommonDMLUtils.SafeDatabaseDelete(a1.Id, true);
		
		// For code coverage, force a test exception to fire
		undelete a1;
		CommonDMLUtils.forceTestException = true;
		CommonDMLUtils.SafeDatabaseDelete(a1.Id, true);
		
	}
	
	static testMethod void testDatabaseDelete_MultiObj_AllOrNothingFail() {
		Account a1 = new Account(Name = 'Matt');
		Account a2 = new Account(Name = 'Matt');
		Account[] accts = new Account[]{a1, a2};
		insert accts;
		delete accts;
		
		CommonDMLUtils.SafeDatabaseDelete(accts, true);
		
		// Test 1: Trying to delete 2 already deleted accounts causes 2 errors
		CommonLoggingUtils log = CommonLoggingUtils.getInstance();
		System.assertEquals(2, log.exCount);
		
	}
	
	static testMethod void testDatabaseDelete_MultiObj_PartialSuccess() {
		Account a1 = new Account(Name = 'Matt');
		Account a2 = new Account(Name = 'Matt');
		Account[] accts = new Account[]{a1, a2};
		insert accts;
		delete a1;
		
		// Test 1: a2 exists
		System.assertEquals(false, ([SELECT IsDeleted FROM Account WHERE Id = :a2.Id LIMIT 1][0]).IsDeleted);
		
		CommonDMLUtils.DmlResults results = CommonDMLUtils.SafeDatabaseDelete(accts, false);
		
		// Test 2: a2 is now deleted
		System.assertEquals(true, ([SELECT IsDeleted FROM Account WHERE Id = :a2.Id LIMIT 1 ALL ROWS][0]).IsDeleted);
		
		// Test 3: An error was recorded as a result of trying to delete already deleted a1
		CommonLoggingUtils log = CommonLoggingUtils.getInstance();
		System.assertEquals(1, log.exCount);
		
		// Test 4: Results class reports one success and one failure
		System.assertEquals(1, results.numSuccess);
		System.assertEquals(1, results.numFail);
	}
	
	static testMethod void testDatabaseDelete_MultiObj_Success() {
		Account a1 = new Account(Name = 'Matt');
		Account a2 = new Account(Name = 'Matt');
		Account[] accts = new Account[]{a1, a2};
		insert accts;
		
		// Test 1: Make sure there are two accounts ready for deletion
		System.assert(a1.Id != null);
		System.assert(a2.Id != null);
		System.assertEquals(2, [SELECT COUNT() FROM Account]);
		
		CommonDMLUtils.SafeDatabaseDelete(accts, true);
		
		// Test 2: Make sure both accounts were deleted
		System.assertEquals(0, [SELECT COUNT() FROM Account]);
	}
	
	static testMethod void ensureCodeCoverage() {
		
		CommonDMLUtils.DmlResults results = new CommonDMLUtils.DmlResults();
		results.AddSuccessMessage(new String[]{'s1', 's2'});
		results.AddFailMessage('s1');
		results.GetInterpolatedMessageList();
		results.PrintInterpolatedMessageList();
		
	}
	
}