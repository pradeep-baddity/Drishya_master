public class OpportunityParentChildSyncUtil {
    
    private static CommonLoggingUtils log = CommonLoggingUtils.getInstance();

    private Set<Id> allowedTypes {

        get { 
            if (allowedTypes == null) {
                allowedTypes = getAllowedRecordTypeIds();
            }
            return allowedTypes; 
        }
        set;
        
    }

    private Set<Id> getAllowedRecordTypeIds() {
        RecordType[] types = [SELECT Id,name FROM RecordType WHERE sObjectType = 'Opportunity' AND Name IN ('ES&A Single Service Line'
                                       ,'ES&A Multi-Service Line')];
        Set<Id> typeIds = new Set<Id>();
        for (RecordType rt : types)
            typeIds.add(rt.Id);
        system.debug('typeIds-->'+typeIds);
        return typeIds;
        
    }
    
    public void ComapreAndUpdateChildAndParentFields(Map<Id, Opportunity> oldMap, Map<Id,Opportunity> newMap){
        
        try {
            

            Map<Id, Opportunity> oppParentsMap = new Map<Id, Opportunity>();

            for(Id id : oldMap.keySet()){
                Opportunity oldOpp = oldMap.get(id);
                Opportunity newOpp = newMap.get(id);

                if(newOpp.Related_Opportunity__c == null && allowedTypes.contains(newOpp.RecordTypeId) ){
                    
                    if( oldOpp.Estimated_Start_Date__c != newOpp.Estimated_Start_Date__c
                        || oldOpp.CloseDate != newOpp.CloseDate
                        || oldOpp.StageName != newOpp.StageName
                        || oldOpp.Probability != newOpp.Probability
                        || oldOpp.Estimated_Duration__c != newOpp.Estimated_Duration__c
                        || oldOpp.EPM_Region__c !=newOpp.EPM_Region__c
                        || oldOpp.ES_A_BDM_Role__c != newOpp.ES_A_BDM_Role__c
                        || oldOpp.Reason_Lost__c != newOpp.Reason_Lost__c
                        || oldOpp.Lost_to_Competitor__c != newOpp.Lost_to_Competitor__c
                        || oldOpp.type != newOpp.type
                        || oldOpp.Referred_Company__c != newOpp.Referred_Company__c
                        || oldOpp.Date_Last_Closed__c != newOpp.Date_Last_Closed__c
                        || oldOpp.ES_A_Eng_Setup_CM__c != newOpp.ES_A_Eng_Setup_CM__c
                        || oldOpp.EPM_Contribution_Margin__c != newOpp.EPM_Contribution_Margin__c)

                    oppParentsMap.put(newOpp.id, newOpp);
                    system.debug('oppParentsMap-->'+oppParentsMap);

                }
            }
            
            Opportunity[] children = [Select Id , name,Lost_to_Competitor__c,Estimated_Duration__c, Date_Last_Closed__c,Referred_Company__c,Estimated_Start_Date__c, Related_Opportunity__c ,CloseDate ,StageName,Probability, EPM_Region__c, ES_A_BDM_Role__c,Reason_Lost__c,type,
            ES_A_Eng_Setup_CM__c,EPM_Contribution_Margin__c FROM Opportunity Where Related_Opportunity__c IN: oppParentsMap.keySet()];
            
            for(Opportunity child : children){
                for(Opportunity parent : oppParentsMap.values()){
                    if (child.Related_Opportunity__c == parent.id){
                            child.Estimated_Start_Date__c = parent.Estimated_Start_Date__c;
                            child.CloseDate = parent.CloseDate;
                            child.StageName = parent.StageName;
                            child.Probability = parent.Probability;
                            child.Estimated_Duration__c = parent.Estimated_Duration__c;
                            child.EPM_Region__c = parent.EPM_Region__c;
                            child.ES_A_BDM_Role__c = parent.ES_A_BDM_Role__c;
                            child.Reason_Lost__c = parent.Reason_Lost__c;
                            child.Lost_to_Competitor__c = parent.Lost_to_Competitor__c; 
                            child.type = parent.type; 
                            child.Referred_Company__c = parent.Referred_Company__c;
                            child.Date_Last_Closed__c = parent.Date_Last_Closed__c;
                            child.ES_A_Eng_Setup_CM__c = parent.ES_A_Eng_Setup_CM__c;
                            child.EPM_Contribution_Margin__c = parent.EPM_Contribution_Margin__c;
                            
                    }
                }
            }

            CommonDMLUtils.SafeDatabaseUpsert(children, true);
        
        } catch (Exception e) {
            log.LogApexException(e);
        } finally {
            log.Flush();
        }
    }

    public void UpdateChildFieldsOnInsert(Opportunity[] newList){

        try {
            
            Map<Id, Opportunity> childOppMap = new Map<Id, Opportunity>();
            Set<Id> parentIds = new Set<Id>();
            for(Opportunity newOpp : newList){
                if (newOpp.Related_Opportunity__c != null && allowedTypes.contains(newOpp.RecordTypeId)) {
                    childOppMap.put(newOpp.id, newOpp);
                    parentIds.add(newOpp.Related_Opportunity__c);
                }
            }

            Opportunity[] parents = [Select Id,name ,Estimated_Duration__c,Date_Last_Closed__c,Referred_Company__c,Estimated_Start_Date__c ,Related_Opportunity__c,CloseDate,StageName,ES_A_Eng_Setup_CM__c,EPM_Contribution_Margin__c,
                                              Probability, EPM_Region__c, ES_A_BDM_Role__c,Reason_Lost__c,Lost_to_Competitor__c,type FROM Opportunity Where Id IN: parentIds];

            for(Opportunity child : childOppMap.values()){
                for(Opportunity parent : parents){
                    if (child.Related_Opportunity__c == parent.id){
                            child.Estimated_Start_Date__c = parent.Estimated_Start_Date__c;
                            child.CloseDate = parent.CloseDate;
                            child.StageName = parent.StageName;
                            child.Probability = parent.Probability;
                            child.Estimated_Duration__c = parent.Estimated_Duration__c;
                            child.EPM_Region__c = parent.EPM_Region__c;
                            child.ES_A_BDM_Role__c = parent.ES_A_BDM_Role__c;
                            child.Reason_Lost__c = parent.Reason_Lost__c;
                            child.Lost_to_Competitor__c = parent.Lost_to_Competitor__c;
                            child.type = parent.type; 
                            child.Referred_Company__c = parent.Referred_Company__c;
                            child.Date_Last_Closed__c = parent.Date_Last_Closed__c;
                            child.ES_A_Eng_Setup_CM__c = parent.ES_A_Eng_Setup_CM__c;
                            child.EPM_Contribution_Margin__c = parent.EPM_Contribution_Margin__c;
                    }
                }
            }
        
        } catch (Exception e) {
            log.LogApexException(e);
        } finally {
            log.Flush();
        }

    }
}