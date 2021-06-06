public class OpportunityStuderParentChildSyncUtil {
 
   
    
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
        RecordType[] types = [SELECT Id,name FROM RecordType WHERE sObjectType = 'Opportunity' AND Name IN ('HC Integrated/Multi'
                                       ,'HC Single or Child')];
        Set<Id> typeIds = new Set<Id>();
        for (RecordType rt : types)
            typeIds.add(rt.Id);
 
        return typeIds;
    }
   
    public void CompareAndUpdateChildAndParentFields(Map<Id, Opportunity> oldMap, Map<Id,Opportunity> newMap){
       
        
        try {
           
 
            Map<Id, Opportunity> oppParentsMap = new Map<Id, Opportunity>();
            system.debug ('Syncing starting catch studer');
 
            for(Id id : oldMap.keySet()){
                Opportunity oldOpp = oldMap.get(id);
                Opportunity newOpp = newMap.get(id);
 
                if(newOpp.Related_Opportunity__c == null && allowedTypes.contains(newOpp.RecordTypeId) && (newOpp.Healthcare_Solutions2__c =='Healthcare-Studer Group :1459'||newOpp.Healthcare_Solutions2__c=='Healthcare-Studer Group Canada :7124')){
                    system.debug ('Syncing starting catch select studer');
                    if( oldOpp.Estimated_Start_Date__c != newOpp.Estimated_Start_Date__c
                        || oldOpp.CloseDate != newOpp.CloseDate
                        || oldOpp.StageName != newOpp.StageName
                        || oldOpp.Probability != newOpp.Probability
                        //|| oldOpp.Estimated_Duration__c != newOpp.Estimated_Duration__c
                        || oldOpp.OwnerId != newOpp.OwnerId
                        || oldOpp.NextStep != newOpp.NextStep
                        || oldOpp.LeadSource != newOpp.LeadSource
                        || oldOpp.RSType__c != newOpp.RSType__c
                        || oldOpp.PDProspected__c != newOpp.PDProspected__c
                        || oldOpp.RFP_Required__c != newOpp.RFP_Required__c
                        || oldOpp.FinalDecisionMaker__c != newOpp.FinalDecisionMaker__c
                        || oldOpp.Proforma_Submission__c != newOpp.Proforma_Submission__c
                        || oldOpp.ApproachReview__c != newOpp.ApproachReview__c
                        || oldOpp.CampaignId != newOpp.CampaignId
                        || oldOpp.EventSource__c != newOpp.EventSource__c
                        || oldOpp.HC_Business_Advisor__c != newOpp.HC_Business_Advisor__c
                        || oldOpp.Reason_Won__c != newOpp.Reason_Won__c
                        || oldOpp.Other_Reasons_Won__c != newOpp.Other_Reasons_Won__c
                        || oldOpp.Description != newOpp.Description
                        || oldOpp.Referred_By_Person__c != newOpp.Referred_By_Person__c
                        || oldOpp.Referral_Account_Stamp__c != newOpp.Referral_Account_Stamp__c
                        || oldOpp.Referred_Company__c != newOpp.Referred_Company__c
                        || oldOpp.EventCity__c != newOpp.EventCity__c
                        || oldOpp.EventState__c != newOpp.EventState__c
                        || oldOpp.Event_End_Date__c != newOpp.Event_End_Date__c
                        || oldOpp.CoachLeaderII__c != newOpp.CoachLeaderII__c
                        || oldOpp.PDSpecialist__c != newOpp.PDSpecialist__c
                        || oldOpp.Attendee_List_Received__c != newOpp.Attendee_List_Received__c
                        || oldOpp.Lead_Gen_Potential__c != newOpp.Lead_Gen_Potential__c
                        || oldOpp.Senior_Leader_DM_in_Audience__c != newOpp.Senior_Leader_DM_in_Audience__c
                        || oldOpp.Attendee_List_Available__c != newOpp.Attendee_List_Available__c
                        || oldOpp.PD_Allowed_Onsite__c != newOpp.PD_Allowed_Onsite__c
                        || oldOpp.Reason_Declined__c != newOpp.Reason_Declined__c
                        || oldOpp.RD_Attendance_Status__c != newOpp.RD_Attendance_Status__c
                        || oldOpp.Actual_Open_Date__c != newOpp.Actual_Open_Date__c
                        || oldOpp.Previous_Agreement_Number__c != newOpp.Previous_Agreement_Number__c
                        || oldOpp.Previous_Contract_TCV__c != newOpp.Previous_Contract_TCV__c
                        || oldOpp.PreviousContractACV__c != newOpp.PreviousContractACV__c
                        || oldOpp.Contract_Expiration_Date__c != newOpp.Contract_Expiration_Date__c
                        || oldOpp.Budget_Year__c != newOpp.Budget_Year__c
                        || oldOpp.Included_in_Budget__c  != newOpp.Included_in_Budget__c
                        || oldOpp.Budget_Amount_ACV__c != newOpp.Budget_Amount_ACV__c
                        || oldOpp.BudgetAmountTCV__c != newOpp.BudgetAmountTCV__c
                        || OldOpp.Estimated_ACV__c != newOpp.Estimated_ACV__c
                        || oldOpp.SGPDRequestforCSA__c  != newOpp.SGPDRequestforCSA__c
                        || oldOpp.SGCSASenttoRep__c != newOpp.SGCSASenttoRep__c
                        || oldOpp.SGCSADeliveredtoOrg__c != newOpp.SGCSADeliveredtoOrg__c
                        || oldOpp.Signed_Contract__c != newOpp.Signed_Contract__c
                        || oldOpp.Other_Reason_Lost__c != newOpp.Other_Reason_Lost__c
                        || oldOpp.Reason_Lost__c != newOpp.Reason_Lost__c
						|| oldOpp.CurrentAgreementNumber__c != newOpp.CurrentAgreementNumber__c
						|| oldOpp.Competitor__c != newOpp.Competitor__c
                        || oldOpp.Date_Last_Closed__c != newOpp.Date_Last_Closed__c
                      	|| oldOpp.Type != newOpp.Type
                      	|| oldOpp.LeadSourceType__c != newOpp.LeadSourceType__c)
                       
                        system.debug ('Syncing starting');
 
                    oppParentsMap.put(newOpp.id, newOpp);
 
                }
            }
           
            Opportunity[] children = [Select Id , name,Estimated_Duration__c, Estimated_Start_Date__c,Related_Opportunity__c ,
                                      CloseDate ,StageName,Probability, Type 
                                        FROM Opportunity
                                        Where Related_Opportunity__c IN: oppParentsMap.keySet() AND StageName != 'Closed Lost' 
                                        and (Type = 'Bridge Opportunity' or Type = 'New Business'or Type = 'Renewal Opportunity')];
 
            for(Opportunity child : children){
                for(Opportunity parent : oppParentsMap.values()){
                    if (child.Related_Opportunity__c == parent.id){
                            child.Estimated_Start_Date__c = parent.Estimated_Start_Date__c;
                            child.CloseDate = parent.CloseDate;
                            child.StageName = parent.StageName;
                            child.Probability = parent.Probability;
                            //child.Estimated_Duration__c = parent.Estimated_Duration__c;
                            child.OwnerId = parent.OwnerId;
                            child.NextStep = parent.NextStep;
                            child.LeadSource = parent.LeadSource;
                            child.RSType__c = parent.RSType__c;
                            child.PDProspected__c = parent.PDProspected__c;
                            child.RFP_Required__c = parent.RFP_Required__c;
                            child.FinalDecisionMaker__c = parent.FinalDecisionMaker__c;
                            child.Proforma_Submission__c = parent.Proforma_Submission__c;
                            child.ApproachReview__c = parent.ApproachReview__c;
                            child.CampaignId = parent.CampaignId;
                            child.EventSource__c = parent.EventSource__c;
                            child.HC_Business_Advisor__c = parent.HC_Business_Advisor__c;
                            child.Reason_Won__c = parent.Reason_Won__c;
                            child.Other_Reasons_Won__c = parent.Other_Reasons_Won__c;
                            child.Description = parent.Description;
                            child.Referred_By_Person__c = parent.Referred_By_Person__c;
                            child.Referral_Account_Stamp__c = parent.Referral_Account_Stamp__c;
                            child.Referred_Company__c = parent.Referred_Company__c;
                            child.EventCity__c = parent.EventCity__c;
                            child.EventState__c = parent.EventState__c;
                            child.Event_Start_Date__c = parent.Event_Start_Date__c;
                            child.Event_End_Date__c = parent.Event_End_Date__c;
                            child.CoachLeaderII__c = parent.CoachLeaderII__c;
                            child.PDSpecialist__c = parent.PDSpecialist__c;
                            child.Attendee_List_Received__c = parent.Attendee_List_Received__c;
                            child.Lead_Gen_Potential__c = parent.Lead_Gen_Potential__c;
                            child.Senior_Leader_DM_in_Audience__c = parent.Senior_Leader_DM_in_Audience__c;
                            child.Attendee_List_Available__c = parent.Attendee_List_Available__c;
                            child.PD_Allowed_Onsite__c = parent.PD_Allowed_Onsite__c;
                            child.Reason_Declined__c = parent.Reason_Declined__c;
                            child.RD_Attendance_Status__c = parent.RD_Attendance_Status__c;
                            child.Previous_Agreement_Number__c = parent.Previous_Agreement_Number__c;
                            child.Previous_Contract_TCV__c = parent.Previous_Contract_TCV__c;
                            child.Contract_Expiration_Date__c = parent.Contract_Expiration_Date__c;
                            child.Budget_Year__c = parent.Budget_Year__c;
                            child.Included_in_Budget__c = parent.Included_in_Budget__c;
                            child.Budget_Amount_ACV__c = parent.Budget_Amount_ACV__c;
                            child.BudgetAmountTCV__c = parent.BudgetAmountTCV__c;
                            child.Estimated_ACV__c = parent.Estimated_ACV__c;
                            child.SGPDRequestforCSA__c = parent.SGPDRequestforCSA__c;
                            child.SGCSASenttoRep__c = parent.SGCSASenttoRep__c;
                            child.SGCSADeliveredtoOrg__c = parent.SGCSADeliveredtoOrg__c;
                            child.Signed_Contract__c = parent.Signed_Contract__c;
                            child.Other_Reason_Lost__c = parent.Other_Reason_Lost__c;
                            child.Reason_Lost__c = parent.Reason_Lost__c;
							child.CurrentAgreementNumber__c = parent.CurrentAgreementNumber__c;
							child.PreviousContractACV__c = parent.PreviousContractACV__c;
                        	child.Competitor__c = parent.Competitor__c;
                        	child.Date_Last_Closed__c = parent.Date_Last_Closed__c;
                        	child.LeadSourceType__c = parent.LeadSourceType__c;
 
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
                if ( newOpp.Related_Opportunity__c != null && allowedTypes.contains(newOpp.RecordTypeId)&& (newOpp.Healthcare_Solutions2__c =='Healthcare-Studer Group :1459'||newOpp.Healthcare_Solutions2__c=='Healthcare-Studer Group Canada :7124')) {
                    childOppMap.put(newOpp.id, newOpp);
                    parentIds.add(newOpp.Related_Opportunity__c);
                }
            }
 
            Opportunity[] parents = [Select Id,name ,Estimated_Duration__c,Estimated_Start_Date__c ,Related_Opportunity__c,CloseDate,StageName
                                              ,Probability, OwnerId, NextStep, LeadSource, RSType__c, PDProspected__c, RFP_Required__c, FinalDecisionMaker__c
                                            , Proforma_Submission__c, ApproachReview__c, CampaignId, EventSource__c, HC_Business_Advisor__c, Description, Referred_By_Person__c
                                            , Referral_Account_Stamp__c, Referred_Company__c, Type, Previous_Agreement_Number__c,
                                            Previous_Contract_TCV__c, PreviousContractACV__c
                                            , Contract_Expiration_Date__c, Budget_Year__c, Included_in_Budget__c, Budget_Amount_ACV__c, BudgetAmountTCV__c, Estimated_ACV__c,
                                            EventCity__c, EventState__c, Event_Start_Date__c, Event_End_Date__c, CoachLeaderII__c, PDSpecialist__c, Attendee_List_Received__c,
                                            Lead_Gen_Potential__c, SGCSADeliveredtoOrg__c, Signed_Contract__c, SGCSASenttoRep__c, SGPDRequestforCSA__c, Senior_Leader_DM_in_Audience__c, Attendee_List_Available__c, PD_Allowed_Onsite__c, Reason_Declined__c, RD_Attendance_Status__c,
                                     		CurrentAgreementNumber__c, Competitor__c, Date_Last_Closed__c, LeadSourceType__c
                                            FROM Opportunity Where Id IN: parentIds];
 
            for(Opportunity child : childOppMap.values()){
                for(Opportunity parent : parents){
                    if (child.Related_Opportunity__c == parent.id){
                        system.debug('Child data =  ' + child.Previous_Agreement_Number__c + 'Parent data =  ' +parent.Previous_Agreement_Number__c);
                            child.EventCity__c = parent.EventCity__c;
                            child.EventState__c = parent.EventState__c;
                            child.Event_Start_Date__c = parent.Event_Start_Date__c;
                            child.Event_End_Date__c = parent.Event_End_Date__c;
                            child.CoachLeaderII__c = parent.CoachLeaderII__c;
                            child.PDSpecialist__c = parent.PDSpecialist__c;
                            child.Attendee_List_Received__c = parent.Attendee_List_Received__c;
                            child.Lead_Gen_Potential__c = parent.Lead_Gen_Potential__c;
                            child.Senior_Leader_DM_in_Audience__c = parent.Senior_Leader_DM_in_Audience__c;
                            child.Attendee_List_Available__c = parent.Attendee_List_Available__c;
                            child.PD_Allowed_Onsite__c = parent.PD_Allowed_Onsite__c;
                            child.Reason_Declined__c = parent.Reason_Declined__c;
                            child.RD_Attendance_Status__c = parent.RD_Attendance_Status__c;
                            child.Previous_Agreement_Number__c = parent.Previous_Agreement_Number__c;
                            child.Previous_Contract_TCV__c = parent.Previous_Contract_TCV__c;
                            child.PreviousContractACV__c = parent.PreviousContractACV__c;
                            child.Contract_Expiration_Date__c = parent.Contract_Expiration_Date__c;
                            child.Budget_Year__c = parent.Budget_Year__c;
                            child.Included_in_Budget__c = parent.Included_in_Budget__c;
                            child.Budget_Amount_ACV__c = parent.Budget_Amount_ACV__c;
                            child.BudgetAmountTCV__c = parent.BudgetAmountTCV__c;
                            child.Estimated_ACV__c = parent.Estimated_ACV__c;
                            child.Estimated_Start_Date__c = parent.Estimated_Start_Date__c;
                            child.CloseDate = parent.CloseDate;
                            child.StageName = parent.StageName;
                            child.Probability = parent.Probability;
                            //child.Estimated_Duration__c = parent.Estimated_Duration__c;
                            child.OwnerId = parent.OwnerId;
                            child.NextStep = parent.NextStep;
                            child.LeadSource = parent.LeadSource;
                            child.RSType__c = parent.RSType__c;
                            child.PDProspected__c = parent.PDProspected__c;
                            child.RFP_Required__c = parent.RFP_Required__c;
                            child.FinalDecisionMaker__c = parent.FinalDecisionMaker__c;
                            child.Proforma_Submission__c = parent.Proforma_Submission__c;
                            child.ApproachReview__c = parent.ApproachReview__c;
                            child.CampaignId = parent.CampaignId;
                            child.EventSource__c = parent.EventSource__c;
                            child.HC_Business_Advisor__c = parent.HC_Business_Advisor__c;
                            child.Reason_Won__c = parent.Reason_Won__c;
                            child.Other_Reasons_Won__c = parent.Other_Reasons_Won__c;
                            child.Description = parent.Description;
                            child.Referred_By_Person__c = parent.Referred_By_Person__c;
                            child.Referral_Account_Stamp__c = parent.Referral_Account_Stamp__c;
                            child.Referred_Company__c = parent.Referred_Company__c;
                            child.Type = parent.Type;
                            child.SGPDRequestforCSA__c = parent.SGPDRequestforCSA__c;
                            child.SGCSASenttoRep__c = parent.SGCSASenttoRep__c;
                            child.SGCSADeliveredtoOrg__c = parent.SGCSADeliveredtoOrg__c;
                            child.Signed_Contract__c = parent.Signed_Contract__c;
                        	child.CurrentAgreementNumber__c = parent.CurrentAgreementNumber__c;
                        	child.Competitor__c = parent.Competitor__c;
                        	child.Date_Last_Closed__c = parent.Date_Last_Closed__c;
                        	child.LeadSourceType__c = parent.LeadSourceType__c;
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