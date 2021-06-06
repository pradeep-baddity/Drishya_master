trigger OpportunityMasterTrigger on Opportunity (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    if(UserInfo.getName() != 'Data Mart'){

       
        if(Trigger.isUpdate && Trigger.isBefore) {
          
             if(recursiveTriggerhandler.toStopContactRoleCount){
                recursiveTriggerhandler.toStopContactRoleCount= false;
                
            CountOpportunityContactRole_HC.countRole(Trigger.newMap);
            }
            set<Id> lineId = new set<Id>();
             for(opportunity opline : trigger.new)
            {  
                //this if condition added by pradeep baddity
                if(opline.RecordTypeId=='012U0000000MXb1IAG' && opline.type=='Standard Opportunity')
                {
                    if(opline.CloseDate!=trigger.OldMap.get(opline.Id).CloseDate){
                        opline.Estimated_Start_Date__c=opline.closedate;
                    }
                    
                      
                }
              
                lineId.add(opline.Id);
            }
            list<opportunityLineItem> opschedule = [select id , opportunityId from opportunityLineItem where opportunityId In : lineId];
              
            
            if(opschedule.size() > 0)
            {
                system.debug('Size-->'+opschedule.size());
                for(opportunity opp : trigger.new)
                {
                    //opp.child_records__c= True;
                    system.debug('child records -->'+opp.child_records__c);
                }
            }
            else if(opschedule.size() <= 0)
            {
                for(opportunity opp : trigger.new)
                {
                   //opp.child_records__c= false;
                    opp.Total_Contract_Value__c = opp.amount;
                    system.debug('child records -->'+opp.child_records__c);
                }
            }
            
        }
        if(Trigger.isUpdate && Trigger.isAfter) {
            Id HcId = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('Healthcare Opportunities').getRecordTypeId();
            Id HcsId = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('Healthcare Software').getRecordTypeId();
            Id EduID = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('EDU Opportunity').getRecordTypeId();
            ExtensionOpportunityCreation.createExtensionOpportunity(Trigger.new, Trigger.newMap, Trigger.oldMap);
            
            list<opportunity> oOpportunityNew = new list<opportunity>();
            list<opportunity> oOpportunity = new list<opportunity>();
            List<opportunity> standardopportunity = new List<opportunity>();
            List<opportunity> standardopportunityNotClosed = new List<opportunity>();
            List<id> notstandardopportunity = new List<id>();
            List<id> oppids = new List<id>();
            
            if(recursiveTriggerhandler.isOpportunityUpdate ){
                recursiveTriggerhandler.isOpportunityUpdate = false;
                List<opportunitylineitem> re_spread_schedules = new List<opportunitylineitem>();
                for(opportunity opptynew : trigger.new){ 
                    oppids.add(opptynew.id);
                  
                    System.debug('re_spread_schedules---->'+re_spread_schedules);
                    system.debug('Stage old-->'+trigger.OldMap.get(opptynew.Id).stageName);
                    //system.debug('Stage old-->'+opptynew.stageName);
                    if(((opptynew.stageName != trigger.OldMap.get(opptynew.Id).stageName) 
                       ||(opptynew.Estimated_Start_Date__c != trigger.OldMap.get(opptynew.Id).Estimated_Start_Date__c) || (opptynew.Estimated_Duration__c != trigger.OldMap.get(opptynew.Id).Estimated_Duration__c)) && opptynew.Estimated_Duration__c != NULL && opptynew.Estimated_Start_Date__c!= NULL)
                    {
                        system.debug('Stage new-->'+opptynew.stageName);
                        oOpportunity.add(opptynew);
                    }
                    
                    if(opptynew.Estimated_Start_Date__c!= trigger.OldMap.get(opptynew.Id).Estimated_Start_Date__c && (opptynew.recordtypeID == HcId ||  opptynew.recordtypeID == HcsId || opptynew.recordtypeID == EduID))
                    {
                         system.debug('Start Date-->');
                         oOpportunityNew.add(opptynew);
                    }
                    if(opptynew.Estimated_Duration__c!= trigger.OldMap.get(opptynew.Id).Estimated_Duration__c&& (opptynew.recordtypeID == HcId ||  opptynew.recordtypeID == HcsId || opptynew.recordtypeID == EduID))
                    {
                         system.debug('Duration-->');
                         oOpportunityNew.add(opptynew);
                    }
                    
                    if(opptynew.stagename != 'Closed Won (100%)' && opptynew.stagename != 'Closed Lost')
                    {
                         system.debug('stage changed-->');
                         //oOpportunityNew.add(opptynew);
                    }
                    //This if condition added by pradeep baddity on 5/4/2021 for user story  23356
                    if(opptynew.StageName=='Closed Won (100%)' && opptynew.Type=='Standard Opportunity')
                    {
             
                    if( ((opptynew.Estimated_Duration__c!= trigger.OldMap.get(opptynew.Id).Estimated_Duration__c) || (opptynew.CloseDate!=trigger.oldmap.get(opptynew.id).CloseDate) || (opptynew.Estimated_Start_Date__c!= trigger.OldMap.get(opptynew.Id).Estimated_Start_Date__c)) &&((opptynew.Type=='Standard Opportunity')))
                    {
                      
                        standardopportunity.add(opptynew);
                    }
                    
                    }
                     
                    if(opptynew.StageName!='Closed Won (100%)'&& opptynew.Estimated_Duration__c!=null && opptynew.Estimated_Start_Date__c!=null && opptynew.type=='Standard Opportunity')
                    {
                     
                         if( ((opptynew.CloseDate!=trigger.oldmap.get(opptynew.id).CloseDate) || (opptynew.Estimated_Duration__c!= trigger.OldMap.get(opptynew.Id).Estimated_Duration__c) || (opptynew.Estimated_Start_Date__c!= trigger.OldMap.get(opptynew.Id).Estimated_Start_Date__c)) &&((opptynew.Type=='Standard Opportunity')))
                    {
                          standardopportunityNotClosed.add(opptynew);
                    }
                       }
                    if((opptynew.type!='Standard Opportunity') && ( opptynew.Estimated_Duration__c!=null && opptynew.Estimated_Start_Date__c!=null )&& (opptynew.Estimated_Duration__c!= trigger.OldMap.get(opptynew.Id).Estimated_Duration__c)||(opptynew.Estimated_Start_Date__c!= trigger.OldMap.get(opptynew.Id).Estimated_Start_Date__c))
                       {
                           notstandardopportunity.add(opptynew.id);
                       }
                     if((opptynew.type!='Standard Opportunity' && opptynew.Estimated_Duration__c!=null && opptynew.Estimated_Start_Date__c!=null ))
                        {
                            notstandardopportunity.add(opptynew.id);
                        }
                }//closing of for
                
                 list<opportunityLineItem> opl_list = [select id , opportunityId,re_spread_schedules__c from opportunityLineItem where opportunityId In : oppids];
                {
                    
                }
                update  opl_list;       
                if((standardopportunity.size()>0))
                {
                    OpportunitySchedule.StandardOpportunityScheduleCreation(standardopportunity);
               
                }
                              
                if((standardopportunityNotClosed.size()>0 ))
                {
                    OpportunitySchedule.StandardOpportunityScheduleCreation(standardopportunityNotClosed);
               
                }
               if(notstandardopportunity.size()>0)
               {
               system.debug('oOpportunity@@'+oOpportunity);
               OpportunitySchedule.OpportunityScheduleCreation(oOpportunity);
               }              
                 //system.debug('oOpportunity@@'+oOpportunity);
                //OpportunitySchedule.OpportunityScheduleCreation(oOpportunity);
                //OpportunitySchedule.StandardOpportunityScheduleCreation(trigger.new);
                opportunityTCVUpdate.TCVvalueUpdate(trigger.new);
              //  OpportunitySchedule.OfferingScheduleCreation(oOpportunity);
                //list<opportunitylineitemschedule> scheduledelete = opportunityScheduleRecreation.OpportunityScheduleCreation(oOpportunityNew);
                //delete scheduledelete;
               //list<opportunitylineitemschedule> offscheduledelete = opportunityScheduleRecreation.OfferingScheduleCreation(oOpportunityNew);
               //delete offscheduledelete;
                //offeringECVvalueUpdate.ECVvalueUpdate(oOpportunityNew);
            }
            //obj.Countopportunitylineitems(Trigger.New,Trigger.OldMap);
        }
        //if ((Trigger.IsDelete || Trigger.IsUndelete) && (Trigger.isAfter) )
     //{
         //obj.CountRecords(Trigger.Old);
    // }
        
        //TriggerFactory.manufacture(Opportunity.sObjectType);
    }
    
   
    
}