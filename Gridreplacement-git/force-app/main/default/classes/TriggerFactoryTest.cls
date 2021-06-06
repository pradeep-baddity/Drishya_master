@isTest
private class TriggerFactoryTest {
	
	// As more handlers are registered keep changes this to be something that isn't
	static Schema.SObjectType unregisteredType = Account.sObjectType;
	
	static testMethod void testHandlerRetrieval() {
		
		// Test 1: We should retrieve the handler for a registered object
		Schema.SObjectType oppType = Opportunity.sObjectType;
		ITriggerHandler oppHandler = TriggerFactory.getHandler(oppType);
		System.assert(oppHandler != null, 'Handler should not be null');
		
		// Test 2: Unknown types should return null handler
		ITriggerHandler accHandler = TriggerFactory.getHandler(unregisteredType);
		System.assert(accHandler == null, 'Unimplemented handler should be null');
		
	}
	
	static testMethod void testManufactureExceptionThrowingOnUnknownHandler() {
		
		// Test 1: Trying to "manufacture" (ie. the GO method on) an unknown object type should throw a TriggerException
		Error_Log__c[] exList = [SELECT Id, Exception_Type__c FROM Error_Log__c];
		System.assertEquals(0, exList.size());
		
		TriggerFactory.manufacture(unregisteredType);
		
		exList = [SELECT Id, Exception_Type__c FROM Error_Log__c];
		System.assertEquals(1, exList.size());
		System.assertEquals('TriggerFactory.TriggerException', exList[0].Exception_Type__c);
		
	}
	
	static testMethod void ensureCodeCoverage() {
		// Insert opportunity
		Opportunity o = new Opportunity(Name='Test', CloseDate=Date.today(), StageName='Prospecting');
		insert o;
		
		// Update opportunity
		o.CloseDate = Date.today().addDays(-1);
		update o;
		
		// Delete opportunity
		delete o;
		
		// Undelete opportunity
		undelete o;
	}
	
}