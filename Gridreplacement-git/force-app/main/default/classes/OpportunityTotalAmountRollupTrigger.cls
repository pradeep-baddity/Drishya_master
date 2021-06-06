public class OpportunityTotalAmountRollupTrigger{
    
    private static CommonLoggingUtils log = CommonLoggingUtils.getInstance();
    private static CurrencyConverterLib converter = CurrencyConverterLib.getInstance();
    
    @testVisible private static Boolean doThrowTestException = false;
    @testVisible private static Boolean doPretendDMLError = false;
    
    // Invoked in OnAfterUpdate
    public void RecalculateTotalAmountRollupFieldOnParents(Map<Id, Opportunity> oldMap, Map<Id,Opportunity> newMap) {
        
        try {
            if (Test.isRunningTest() && doThrowTestException) { Integer lolmath = 1/0; }
            
            Set<Id> oppParentIdsChangingCurrency = new Set<Id>();
            Opportunity[] oppChildren = new Opportunity[]{};
            
            for (Id id : oldMap.keySet()) {
                Opportunity oldOpp = oldMap.get(id);
                Opportunity newOpp = newMap.get(id);
                
                // Collect opportunity children that are having their amounts updated or currency changed in this context
                if (newOpp.Related_Opportunity__c != null) {
                    if (    oldOpp.Total_Opportunity_Amount__c != newOpp.Total_Opportunity_Amount__c 
                            || oldOpp.Amount != newOpp.Amount
                            || oldOpp.CurrencyIsoCode != newOpp.CurrencyIsoCode
                        	|| oldOpp.StageName != newOpp.StageName
                        	//&& (newOpp.IsClosed == False || newOpp.IsWon == True)
                       		)

                    oppChildren.add(newOpp);
                    
                } else {
                    // Also collect parents changing their currency code or amount
                    if (oldOpp.CurrencyIsoCode != newOpp.CurrencyIsoCode
                        || oldOpp.Amount != newOpp.Amount) {
                        oppParentIdsChangingCurrency.add(newOpp.Id);
                    }
                }
                
                
            }
            
            RecalculateTotalAmountRollupFieldOnParents(oppChildren, oppParentIdsChangingCurrency);
        
        } catch (Exception e) {
            log.LogApexException(e);
        } finally {
            log.Flush();
        }
    }
    
    // Invoked in OnAfterInsert and OnAfterDelete
    public void RecalculateTotalAmountRollupFieldOnParents(Opportunity[] oppChildren, Set<Id> oppParentsIdsChangingCurrency) {
        
        try {
            if (Test.isRunningTest() && doThrowTestException) { Integer lolmath = 1/0; }
            
            Set<Id> parentOps = CollectParentOpportunityIds(oppChildren);
            if (oppParentsIdsChangingCurrency != null) parentOps.addAll(oppParentsIdsChangingCurrency);
            
            Map<Id, RollupStats> statsMap = GetRollupStatsByParentIdMap(parentOps);
            
            List<Opportunity> parentOpsToUpdate = new List<Opportunity>();
            for (Id oppId : statsMap.keySet()) {
                Opportunity o = new Opportunity();
                o.Id = oppId;
                o.Total_Opportunity_Amount__c = statsMap.get(oppId).SumTotalAmount;
                o.No_of_Child_Opportunities__c = statsMap.get(oppId).NumChildren;
                parentOpsToUpdate.add(o);
            }
            
            Database.SaveResult[] results = Database.update(parentOpsToUpdate);
            for(Database.SaveResult result : results) {
                if (result.isSuccess() && !(Test.isRunningTest() && doPretendDMLError)) {
                    System.debug(CommonConstants.DEBUG_PREFIX + 'Successfully update Opportunity: Id=' + result.getId() + ', TotalAmount = ' + statsMap.get(result.getId()).SumTotalAmount);
                
                } else {
                    String exMsg = 'Failed to update Opportunity: Id=' + result.getId();
                    System.debug(CommonConstants.DEBUG_PREFIX + exMsg);
                    
                    log.LogDatabaseError(result.getErrors(), exMsg);
                }  
            }
        
        } catch (Exception e) {
            log.LogApexException(e);
        } finally {
            log.Flush();
        }
    }

    public Set<Id> CollectParentOpportunityIds(Opportunity[] opp) {
        Set<Id> retObj = new Set<Id>();
        for (Opportunity o : opp) {
            if (o.Related_Opportunity__c != null) {
                retObj.add(o.Related_Opportunity__c);
            }
        }
        System.debug(CommonConstants.DEBUG_PREFIX + 'Discovered ' + retObj.size() + ' distinct parent(s) from the ' + opp.size() + ' opportunity child record(s)');
        return retObj;
    }
    
    public Map<Id, RollupStats> GetRollupStatsByParentIdMap(Set<Id> parentIds) {
        Map<Id, RollupStats> retObj = new Map<Id, RollupStats>();
        
        Opportunity[] children = [  SELECT
                                        Id
                                        ,Name
                                        ,Amount
                                        ,CurrencyIsoCode
                                  		,IsClosed
                                  		,IsWon
                                        ,Total_Opportunity_Amount__c
                                        ,Related_Opportunity__c
                                        ,Related_Opportunity__r.Amount
                                        ,Related_Opportunity__r.CurrencyIsoCode
                                        ,Related_Opportunity__r.No_of_Child_Opportunities__c
                                    FROM Opportunity
                                    WHERE Related_Opportunity__c IN :parentIds and (IsClosed = False or IsWon = True)];
        
        for (Id parentId : parentIds) {
            
            Boolean parentCounted = false;
            RollupStats stats = new RollupStats();
            stats.SumTotalAmount = 0;
            stats.NumChildren = 0;
         
            for (Opportunity child : children) {
                if (child.Related_Opportunity__c == parentId && child.Amount != null) {
                    System.debug('>>> Loop1 : ');
                    // Count child
                    stats.NumChildren += 1;
                    
                    // Null protection
                    Double parentAmount = (child.Related_Opportunity__r.Amount != null) ? child.Related_Opportunity__r.Amount : 0;
                    Double childAmount = (child.Amount != null) ? child.Amount : 0;
                 //   Double childSumAmount = (child.Total_Opportunity_Amount__c != null) ? child.Total_Opportunity_Amount__c : 0;

                    if(child.Total_Opportunity_Amount__c != null)
                    {
                    child.Total_Opportunity_Amount__c=0;
                    }
                    Double childSumAmount=child.Total_Opportunity_Amount__c;
                    
                    // Add child's amount
                    if (childSumAmount > 0) {
                    
                    System.debug('>>> Loop2 : ');
                        stats.SumTotalAmount += converter.Convert(childSumAmount, child.CurrencyIsoCode, child.Related_Opportunity__r.CurrencyIsoCode);
                    } else {
                        stats.SumTotalAmount += converter.Convert(childAmount, child.CurrencyIsoCode, child.Related_Opportunity__r.CurrencyIsoCode);
                    }
                    
                    // Add parent's amount
                    if(parentCounted == false) {
                    System.debug('>>> Loop3 : ');
                        stats.SumTotalAmount += parentAmount;
                        parentCounted = true;
                    }
                }
            }
            
            retObj.put(parentId, stats);
        }
        
        return retObj;
    }
    
    public class RollupStats {
        public Integer NumChildren { get; set; }
        public Decimal SumTotalAmount { get; set; }
    }

}