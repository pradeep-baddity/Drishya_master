public class HC_SplitOpportunity {
    
    @auraEnabled
    public static list<opportunityLineItem> getOppLines(String recId){
        List<OpportunityLineItem> oLIlist= new List<OpportunityLineItem>();
        oLIlist=[SELECT id,Name,Product2.Name,Service_Line__c,Product2Id,ProductName__c,opportunityId,UnitPrice,CurrencyIsoCode,Elite_Service_Line__c,
                 PricebookEntryId,Opportunity.StageName,
                 Technology_Vendor__c,Technology_Module__c,Technology_Capability__c,Service__c,Expertise__c,Capability_new__c
                 FROM OpportunityLineItem where opportunityId=:recId AND offering_lost__c = false];
        return oLIlist; 
    }
    
    @auraEnabled
    public static Opportunity createOpportunity(string recordId,String opportunityName,List<string> selectedOLI){
        system.debug('selectedOLI-->'+selectedOLI);
        
        Opportunity oldOpportunity =[SELECT id,Name,StageName,Legacy_Opportunity_ID__c,CloseDate,AccountId,Amount,Type,CurrencyIsoCode,Industry__c,Referred_By_Person__c,
                                     RecordType.Name,Estimated_Duration__c,Estimated_Start_Date__c,Description,Pricing_Review_Status__c,
                                     EPM_Region__c,Oppty_ID_For_Elite__c,Competitor__c,Agreed_Exchange_Rate__c,LeadSource,Pricebook2Id,Lost_To_Competitor_Legal__c,                                      
                                     Probability_Adjusted_del1__c,AddOnUpSaleEndDate__c,Effective_Date__c,AddOnUpSaleEngagementNumber__c,Product_with_Service_or_Product__c,EPM_Sales_Lead__c,probability,MD_of_Record__c
                                     FROM Opportunity WHERE id =:recordId Limit 1 ];
        
        String OpportuniyStageOldValue = oldOpportunity.StageName ;
        Double OpportunityProbabilityOldValue =oldOpportunity.probability;
        system.debug('OpportunityProbabilityOldValue'+OpportunityProbabilityOldValue);
        String Currentopportunityid=oldOpportunity.Id;
        Opportunity newOpportunity = new Opportunity();
        newOpportunity = oldOpportunity;
        newOpportunity.id= null;
        newOpportunity.Legacy_Opportunity_ID__c=Currentopportunityid;
        newOpportunity.RecordType.Name =oldOpportunity.RecordType.Name;
        newOpportunity.StageName ='Prospect (0-14%)';
        newOpportunity.Probability=0;
        newOpportunity.Pricebook2Id =oldOpportunity.Pricebook2Id;
        newOpportunity.CurrencyIsoCode =oldOpportunity.CurrencyIsoCode;
        if(opportunityName != null || opportunityName != '')
        newOpportunity.Name=opportunityName ;
        newOpportunity.Split_opportunity__c = true;
        newOpportunity.Referred_By_Person__c= oldOpportunity.Referred_By_Person__c;
        
        system.debug('newOpportunity->>> :' +newOpportunity.probability); 
        insert newOpportunity; 
        system.debug('newOpportunity-->'+newOpportunity);
        
        /** Looking For OpportunityLineItems **/
        List<OpportunityLineItem> oLIlist= new List<OpportunityLineItem>();
        oLIlist=[SELECT Id, Product2Id, Quantity, Elite_Department_ID__c, Elite_Department__c, Elite_Dept_Formula__c,CurrencyIsoCode,
                 Elite_Service_Line_ID__c, UnitPrice,Discount,ListPrice,Elite_Service_Line__c, Geography__c, Practice__c,ProductCode,
                 Offering__c, Offering_Lost__c,PricebookEntryId,Technology_Vendor__c,
                 Technology_Module__c,Technology_Capability__c,Service__c,Expertise__c,Capability_new__c               
                 FROM OpportunityLineItem where id In :selectedOLI];
        system.debug('oLIlist-->'+oLIlist);
        List<OpportunityLineItem> mapOfOLISToUpdate=mapNewOpp(newOpportunity.Id,oLIlist);
        
        /** Looking For OpportunityContactRole **/
        List<OpportunityContactRole> listOppContactRole = [SELECT Id, OpportunityId, ContactId, Role FROM OpportunityContactRole where OpportunityId =: recordId];
        List<OpportunityContactRole> listOppContactRoleToUpdate = new List<OpportunityContactRole>();
        
        for(OpportunityContactRole oRc:listOppContactRole){
            OpportunityContactRole newORCObj = oRc.clone(false, True, false, false);
            newORCObj.OpportunityId = newOpportunity.Id;
            listOppContactRoleToUpdate.add(newORCObj);
        }
        
        if(listOppContactRoleToUpdate.size()>0){
            insert listOppContactRoleToUpdate ;
        }
        
        Opportunity newOpportunityToUpdate = new Opportunity(Id = newOpportunity.Id,stageName = OpportuniyStageOldValue ,probability=OpportunityProbabilityOldValue, CountOpportunityContactRole__c = listOppContactRoleToUpdate.size());
        system.debug('TapasUpdateOpps' + [SELECT ID ,NAME, probability, StageName,Estimated_Start_Date__c, Closedate, Estimated_Duration__c, Product_Count__c, Product_with_Service_or_Product__c, RecordType.DeveloperName FROM oPPORTUNITY WHERE ID =: newOpportunity.Id]);
        system.debug('newOpportunityToUpdate==>>:'+newOpportunityToUpdate);
        //database.SaveResult[] SaveOpps = database.update(New List<Opportunity>{newOpportunityToUpdate});
        update newOpportunityToUpdate;
        system.debug('newOpportunityToUpdate-->'+newOpportunityToUpdate);
        return newOpportunity;
    }
    /****  Method to clone OLI * **
*   parameters(String recId,OppLineItems)   
*/ 
    public static List<OpportunityLineItem> mapNewOpp(String newOppId,List<OpportunityLineItem> OppLineItems){
        List<OpportunityLineItem> oLIlistToBeInserted= new List<OpportunityLineItem>();
        List<OpportunityLineItem> oLISetToBeDeleted=  new List<OpportunityLineItem>();
        set<id> opportunityLineItemIds = new set<id>();
        Map<Id,Id> oldOlisToNewOlis = new Map<Id,Id>();
        for(OpportunityLineItem oli:OppLineItems){
            OpportunityLineItem newOLiObj = oli.clone(false, True, false, false);
            newOLiObj.OpportunityId = newOppId;
            newOLiObj.PriceBookEntryId= oli.PriceBookEntryId;
            opportunityLineItemIds.add(oli.id);  
            oLIlistToBeInserted.add(newOLiObj);
            oLISetToBeDeleted.add(oli);
        }
        system.debug('oLIlistToBeInserted==>'+oLIlistToBeInserted);
        IF(oLIlistToBeInserted.size()>0){
            insert oLIlistToBeInserted;
        }
        system.debug('oLIlistToBeInserted:'+oLIlistToBeInserted);
        /** OpportunityLineItemSchdule **/
        
        List<OpportunityLineItemSchedule> oLISchduleToBeInserted = new List<OpportunityLineItemSchedule>();
        
        
        for(OpportunityLineItem tempOLI : oLIlistToBeInserted){
            oldOlisToNewOlis.put(tempOLI.getCloneSourceId(),tempOLI.Id); 
        }
        System.debug('Map value OLIS:'+oldOlisToNewOlis);
        
        List<OpportunityLineItemSchedule> oldOLIS =[SELECT Id, OpportunityLineItemId, Type, Revenue, Quantity, ScheduleDate, CurrencyIsoCode FROM OpportunityLineItemSchedule  WHERE OpportunityLineItemId IN:oldOlisToNewOlis.keySet()];
        System.debug('QUERY OLIS==>'+oldOLIS);
        
        for(OpportunityLineItemSchedule olis : oldOLIS){
            OpportunityLineItemSchedule newOLIS = olis.clone(false, True, false, false);
            newOLIS.OpportunityLineItemId=oldOlisToNewOlis.get(olis.OpportunityLineItemId);
            oLISchduleToBeInserted.add(newOLIS);
        }
        
        if(oLISchduleToBeInserted.size()>0){
            system.debug('OLIS--->>'+oLISchduleToBeInserted);
           // insert oLISchduleToBeInserted;
        }
        
        
        
        IF(oLISetToBeDeleted.size()>0){
            Delete oLISetToBeDeleted;
        }
        return OppLineItems;
    }
    
}