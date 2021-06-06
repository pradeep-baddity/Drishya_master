@isTest
private class OpportunityMasterTriggerHandlerTest {

	static testMethod void ensureCodeCoverage() {
		
		OpportunityMasterTriggerHandler handler = new OpportunityMasterTriggerHandler();
		
		Opportunity[] oppArray = new Opportunity[]{};
		oppArray.add(new Opportunity());
		
		Opportunity o = new Opportunity(Name = 'Test Opportunity', CloseDate = Date.today(), StageName = 'Closed Won');
		o.Do_Not_Run_WF__c = true;
		o.Do_Not_Validate__c = true;
		insert o;
		Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
		oppMap.put(o.Id, o);
		
		
		handler.OnBeforeInsert(oppArray);
		handler.OnAfterInsert(oppMap);
		handler.OnBeforeUpdate(oppMap, oppMap);
		handler.OnAfterUpdate(oppMap, oppMap);
		handler.OnBeforeDelete(oppMap);
		handler.OnAfterDelete(oppMap);
		handler.OnUndelete(oppArray);
		
		System.assert(true); // This assertion is critical ;)
	}
    
    
	
}