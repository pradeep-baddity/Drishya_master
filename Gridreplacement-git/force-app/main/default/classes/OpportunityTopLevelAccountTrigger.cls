public class OpportunityTopLevelAccountTrigger{
	
	@testVisible private static Integer MAX_ITERATION_COUNT = 2;
	private Integer CurrentInteration = 0;
	
	public void PopulateTopLevelAccountLookupField(Map<Id, Opportunity> opportunities) {
		
		Map<Id, Id> oppToTopAccountMap = QueryTopLevelOpportunityMap(opportunities.keySet());
		
		Opportunity[] oppsToUpsert = new Opportunity[]{};
		for (Id oppId : oppToTopAccountMap.keySet()) {
			Opportunity o = new Opportunity(Id = oppId, Top_Level_Opportunity_Account__c = oppToTopAccountMap.get(oppId));
			oppsToUpsert.add(o);
		}
		CommonDMLUtils.SafeDatabaseUpsert(oppsToUpsert, true);
	}
	
	// Map of OpportunityId to top level opportunity AccountId
	public Map<Id, Id> QueryTopLevelOpportunityMap(Set<Id> oppIds) {
		Map<Id, Id> retObj = new Map<Id, Id>();
		CurrentInteration += 1;
		
		Opportunity[] opps = [	SELECT
									Id
									,AccountId
									,Related_Opportunity__r.Id
									,Related_Opportunity__r.AccountId
									,Related_Opportunity__r.Related_Opportunity__r.Id
									,Related_Opportunity__r.Related_Opportunity__r.AccountId
									,Related_Opportunity__r.Related_Opportunity__r.Related_Opportunity__r.Id
									,Related_Opportunity__r.Related_Opportunity__r.Related_Opportunity__r.AccountId
									,Related_Opportunity__r.Related_Opportunity__r.Related_Opportunity__r.Related_Opportunity__r.Id
									,Related_Opportunity__r.Related_Opportunity__r.Related_Opportunity__r.Related_Opportunity__r.AccountId
									,Related_Opportunity__r.Related_Opportunity__r.Related_Opportunity__r.Related_Opportunity__r.Related_Opportunity__r.Id
									,Related_Opportunity__r.Related_Opportunity__r.Related_Opportunity__r.Related_Opportunity__r.Related_Opportunity__r.AccountId
									,Related_Opportunity__r.Related_Opportunity__r.Related_Opportunity__r.Related_Opportunity__r.Related_Opportunity__r.Is_Child_Opportunity__c
								FROM Opportunity
								WHERE Id IN :oppIds];
		
		// Map of opportunity id, to the highest parent Id we can query (LEV5), 
		// which itself is still a child and needs a recusive lookup
		Map<Id, Id> oppToHighestParentStillChildMap = new Map<Id, Id>();
		
		for (Opportunity LEV0 : opps) {
			//System.debug(DEBUG_PREFIX + 'Found LEV0: ' + LEV0);
			Id TopLevelAccountId = LEV0.AccountId;
			
			if (LEV0.Related_Opportunity__r != null) {
				
				Opportunity LEV1 = LEV0.Related_Opportunity__r;
				TopLevelAccountId = LEV1.AccountId;
				//System.debug(DEBUG_PREFIX + 'Found LEV1: ' + LEV1);
				
				
				if (LEV1.Related_Opportunity__r != null) {
					
					Opportunity LEV2 = LEV1.Related_Opportunity__r;
					TopLevelAccountId = LEV2.AccountId;
					//System.debug(DEBUG_PREFIX + 'Found LEV2: ' + LEV2);
					
					if (LEV2.Related_Opportunity__r != null) {
						
						Opportunity LEV3 = LEV2.Related_Opportunity__r;
						TopLevelAccountId = LEV3.AccountId;
						//System.debug(DEBUG_PREFIX + 'Found LEV3: ' + LEV3);
						
						if (LEV3.Related_Opportunity__r != null) {
							
							Opportunity LEV4 = LEV3.Related_Opportunity__r;
							TopLevelAccountId = LEV4.AccountId;
							//System.debug(DEBUG_PREFIX + Found LEV4: ' + LEV4);
							
							if (LEV4.Related_Opportunity__r != null) {
								
								Opportunity LEV5 = LEV4.Related_Opportunity__r;
								TopLevelAccountId = LEV5.AccountId;
								//System.debug(DEBUG_PREFIX + 'Found LEV5: ' + LEV5);
								
								if (LEV5.Is_Child_Opportunity__c) {
									//System.debug(DEBUG_PREFIX + 'Deepest level is still a child! Adding to recursive Map: ' + LEV5.Id + ' for root ' + LEV0.Id);
									if (MAX_ITERATION_COUNT > CurrentInteration) {
										oppToHighestParentStillChildMap.put(LEV0.Id, LEV5.Id);
									} else {
										//System.debug(DEBUG_PREFIX + 'Unable to recurse, hit max iteration count of ' + MAX_ITERATION_COUNT);
										TopLevelAccountId = null;
									}
									
								}
							}
						}
					}
				}
			}// </ IF>
			
			retObj.put(LEV0.Id, TopLevelAccountId);
			//System.debug(DEBUG_PREFIX + 'Top Level AccountId: ' + TopLevelAccountId);

		}// </ FOR LOOP>
		
		// Perform recursive lookup if necessary
		if (oppToHighestParentStillChildMap.size() > 0) {
			
			Map<Id, Id> recursedParentToTopAccountMap = QueryTopLevelOpportunityMap(new Set<Id>(oppToHighestParentStillChildMap.values()));
			
			for (Id rootOppId : oppToHighestParentStillChildMap.keySet()) {
				
				Id recursedParentId = oppToHighestParentStillChildMap.get(rootOppId);
				Id recursedParentTopAccountId = recursedParentToTopAccountMap.get(recursedParentId);
				//System.debug(DEBUG_PREFIX + 'Root opp ' + rootOppId + 'with 5th level parent ' + recursedParentId + ' found 5th level parent top Account: ' + recursedParentTopAccountId);
				
				// Update retObj
				retObj.remove(rootOppId);
				retObj.put(rootOppId, recursedParentTopAccountId);
			}

		} // </Recursive Lookup>
		
		return retObj;
	}


}