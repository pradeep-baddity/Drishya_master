global class Renewal_Opportunity_for_Renewal implements Database.Batchable<sObject>,Database.Stateful{
    
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        Id HcId = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('Healthcare Opportunities').getRecordTypeId();
        Id HcsId = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('Healthcare Software').getRecordTypeId();
        
        //return database.getQueryLocator([SELECT id,parentid,Type FROM FeedItem where createdbyid='0050B000007vnxy' and type ='createrecordevent']);
        return database.getQueryLocator([SELECT Id, AutoCreateRenewal__c, RenewalCreated__c, AddOnUpSaleEndDate__c, Effective_Date__c,
                                         AccountId, StageName, Pricebook2Id, recordtypeId, Renewal_opportunity_Date__c, 
                                         (SELECT Id, PricebookEntryId, CurrencyIsoCode, Elite_Department_ID__c, Product2Id, 
                                          Offering__c, unitprice, Practice__c, OpportunityId, Service_Line_or_Product__c,
                                          Start_Date__c, Opp_recordtype__c, Opportunity_Stage__c, Geography__c, Estimated_Duration__c,
                                          Elite_Service_Line__c, Elite_Service_Line_ID__c, Elite_Department__c,
                                          Module_or_Accelerator2__c, Offering_Lost__c, Amount__c
                                          FROM OpportunityLineItems 
                                          WHERE (Renew__c=True) AND (Service__c IN ('Performance Improvement Technology'))AND(Offering_Lost__c=False)
                                          )  FROM opportunity 
                                         WHERE StageName != 'Closed Lost' AND Type ='Renewal Opportunity' 
                                         AND AutoCreateRenewal__c = True AND RenewalCreated__c = false AND (renewal_opportunity_date__c != Null) 
                                         AND (recordtypeId =: HcId OR recordtypeId =: HcsId )]);
}
    
    
    global void execute(Database.BatchableContext bc, List<Opportunity> oppline){
       System.debug('oppline-->'+oppline);
        Set<Id> setOpId = new Set<Id>();
        List<Opportunity> newOpr = new List<Opportunity>();
        List<Opportunity> newOprupdate = new List<Opportunity>();
        List<Opportunity> newOprupdateNew = new List<Opportunity>();
        Map<Id, List<opportunitylineitem>> newMap = new Map<Id, List<Opportunitylineitem>>();
        Map<Id, Opportunity> newMapRenewal = new Map<Id, Opportunity>();
        Map<Id, List<OpportunityContactRole>> contactRole = new Map<Id, List<OpportunityContactRole>>();
        Map<Id, List<OpportunityTeamMember>> teamMember = new Map<Id, List<OpportunityTeamMember>>();
        List<OpportunityLineItem> opLineList = new List<OpportunityLineItem>();
        List<OpportunityContactRole> cRole = new List<OpportunityContactRole>();
        List<OpportunityTeamMember> Tmember = new List<OpportunityTeamMember>();
        List<Opportunitylineitem> newlineitem = new list<Opportunitylineitem>();
        
          List<Account> acclist=  [select id,name from Account where name='NONE (Do Not Edit)'];
        
        for(Opportunity op : oppline) {
            setOpId.add(op.Id);
            System.debug('setOpId-->'+setOpId);
            Date mydate = system.today();
            mydate = mydate.addDays(549);
            
            System.debug('mydate-->'+mydate);
            if(op.renewal_opportunity_date__c <= mydate ) {
                
                for(OpportunityLineItem opplinenew : op.opportunitylineitems) {
                    
                    newMap.put(opplinenew.OpportunityId,op.opportunitylineitems);
                    System.debug('is executing');
                    
                }
            }
        }
        System.debug('newMap-->'+newMap);
        
        for(Opportunity opportunityContactRole : [SELECT Id, (SELECT Id, ContactId, OpportunityId, Role FROM OpportunityContactRoles) 
                                                  FROM Opportunity WHERE Id IN : setOpId]) {
                                                      contactRole.put( opportunityContactRole.Id, opportunityContactRole.OpportunityContactRoles);
                                                  }
        
        System.debug('contactRole-->'+contactRole);
        
        for(Opportunity opportunityTeamMember : [SELECT Id, (SELECT Id, Name, OpportunityAccessLevel, OpportunityId, TeamMemberRole ,Title, UserId 
                                                             FROM OpportunityTeamMembers) FROM Opportunity WHERE Id IN : setOpId]) {
                                                                 teamMember.put( opportunityTeamMember.Id, opportunityTeamMember.OpportunityTeamMembers);
                                                             }
        System.debug('teamMember-->'+teamMember);
        
        if(newMap.values().size() > 0 ) {
            for(Opportunity opptynew : [SELECT Id, Stagename, Name, OwnerId, AccountId, HC_Region__c, RecordtypeId, NextStep, Type, Effective_Date__c,
                                        CurrencyIsoCode, Pricebook2Id, AddOnUpSaleEndDate__c, AddOnUpSaleEngagementNumber__c, AutoCreateRenewal__c,
                                        CloseDate, Amount, Estimated_Duration__c, LeadSource, Estimated_Start_Date__c FROM Opportunity 
                                        WHERE Id IN : newmap.keyset()]) {
                                            
                                            Date myDate1 = system.today();
                                            Integer newyear = mydate1.year();
                                            
                                            System.debug('newyear-->'+newyear);
                                            
                                            Opportunity newOpp = new opportunity();
                                            newOpp.recordtypeId = opptynew.RecordtypeId;
                                            newOpp.OwnerId = opptynew.OwnerId;
                                            newOpp.SABER_Original_Opportunity_ID__c = opptynew.Id;
                                            //newOpp.Name = opptynew.Name + ' - Auto';
                                            string oppName;
                                            oppName = opptynew.name + ' - Auto';
                                            Integer maxSize = 120;
                                            system.debug('oppName--'+oppName); 
                                            if(oppName.length() > maxSize ){
                                            oppName = oppName.substring(0, maxSize);}
                                            newOpp.name         = oppName;
                                            
                                            newOpp.AccountId = opptynew.AccountId;
                                            newOpp.HC_Region__c = opptynew.HC_Region__c;
                                            newOpp.Related_Opportunity__c = opptynew.Id;
                                            newOpp.Type = 'Renewal Opportunity';
                                            newOpp.AutoCreateRenewal__c = true;
                                            newOpp.Amount = opptynew.Amount;
                                            newOpp.Estimated_Duration__c = opptynew.Estimated_Duration__c;
                                            newOpp.LeadSource = 'Established Client';
                                            newOpp.Reason_Won__c = 'Existing Client';
                                            //newOpp.Competitor__c = '001U000001UKgxv'; //None account in Production
                                             if(acclist.size()>0)
                                              {
                                               newOpp.Competitor__c=acclist[0].id; 
                                                }
              
                                            newOpp.StageName = 'Prospect (0-14%)';
                                            newOpp.Pricebook2Id = opptyNew.Pricebook2Id;
                                            newOpp.CurrencyIsoCode = opptynew.CurrencyIsoCode;
                                            newOpp.AutoCreateRenewal__c = True;
                                            newOpp.AddOnUpSaleEngagementNumber__c = opptynew.AddOnUpSaleEngagementNumber__c;
                                            Date newDate;
                                            if(opptynew.Estimated_Duration__c != null)
                                                newDate = (opptynew.Estimated_Start_Date__c).addMonths((Integer)opptynew.Estimated_Duration__c);
                                            newOpp.CloseDate = newDate;
                                            system.debug('close date --'+newOpp.CloseDate );
                                             newOpp.Estimated_Start_Date__c = newDate;
                                            /**date newStartDate = (opptynew.Effective_Date__c).addDays((Integer)opptynew.Estimated_Duration__c);
                                           
                                            if(newOpp.CloseDate != null)
                                                newOpp.Estimated_Start_Date__c = datemodification(newOpp.CloseDate);**/
                                            Date newEffectiveDate;
                                            //Original Estimated Engagement Start Date + Estimated Duration
                                            if(opptynew.Estimated_Start_Date__c!= null)
                                            //newEffectiveDate = (opptynew.AddOnUpSaleEndDate__c).addDays(1);
                                            newEffectiveDate = (opptynew.Estimated_Start_Date__c).addMonths((Integer)opptynew.Estimated_Duration__c);
                                            system.debug('effective date--'+newEffectiveDate);
                                            newOpp.Effective_Date__c = newEffectiveDate ;
                                            Date newEndDate ;
                                            if(newOpp.Estimated_Duration__c != null)
                                             newEndDate = (opptynew.Estimated_Start_Date__c).addMonths((Integer)opptynew.Estimated_Duration__c * 2 );
                                            newOpp.AddOnUpSaleEndDate__c =  newEndDate;
                                            newOpr.add(newOpp);
                                            newMapRenewal.put(opptynew.Id,newOpp);
                                        }
            System.debug('newMapRenewal-->'+newMapRenewal);
        }
        if(newOpr != null && newOpr.size() > 0) {
            INSERT newOpr;
        }
        
        for(Opportunity opnew : newOpr) {
            for(Opportunitylineitem opplineitem : newMap.get(opnew.Related_Opportunity__c)) {
                Opportunitylineitem oplineitemnew = new opportunitylineitem();
                Oplineitemnew.Geography__c = opplineitem.Geography__c;
                Oplineitemnew.OpportunityId = opnew.Id;
                //oplineitemnew.CurrencyIsoCode =opplineitem.CurrencyIsoCode;
                Oplineitemnew.Product2Id= opplineitem.Product2Id;
                Oplineitemnew.Elite_Department_ID__c = opplineitem.Elite_Department_ID__c;
                Oplineitemnew.Offering__c = opplineitem.Offering__c;
                Oplineitemnew.Practice__c = opplineitem.Practice__c;
                Oplineitemnew.Service_Line_or_Product__c = opplineitem.Service_Line_or_Product__c;
                Oplineitemnew.Elite_Service_Line__c = opplineitem.Elite_Service_Line__c;
                Oplineitemnew.Elite_Service_Line_ID__c = opplineitem.Elite_Service_Line_ID__c;
                Oplineitemnew.Elite_Department__c = opplineitem.Elite_Department__c;
                Oplineitemnew.Module_or_Accelerator2__c = opplineitem.Module_or_Accelerator2__c;
                Oplineitemnew.Offering_Lost__c = opplineitem.Offering_Lost__c;
                Oplineitemnew.Amount__c = opplineitem.Amount__c;
                Oplineitemnew.Unitprice= opplineitem.Unitprice;
                Oplineitemnew.PricebookEntryId = opplineitem.PricebookEntryId;
                //countryPriceBookMap.get(opnew.CurrencyIsoCode);
                System.debug('PricebookEntryId-->'+oplineitemnew.PricebookEntryId);
                //'01u3F000004ka4jQAA';
                newlineitem.add(oplineitemnew);
            }
            System.debug('newlineitem-->'+newlineitem);
        }
        if(newlineitem != Null && newlineitem.size() > 0) {
            INSERT newlineitem;
        }
        
        for(Opportunity opnew : newOpr) {
            for(Opportunitycontactrole contactrolenew : contactRole.get(opnew.Related_Opportunity__c)) {
                Opportunitycontactrole opportunitycontactroleNew = new opportunitycontactrole();
                OpportunitycontactroleNew.ContactId = contactrolenew.contactId;
                OpportunitycontactroleNew.role = contactrolenew.role;
                OpportunitycontactroleNew.opportunityId = opnew.id;
                cROle.add(opportunitycontactroleNew);
            }
            System.debug('cROle-->'+cROle);
        }   
        
        if(cROle != Null && cROle.size() > 0) {
            INSERT cROle;
        }
        
        System.debug('cROle-->'+cROle);
        
        for(Opportunity opnew : newOpr) {
            for(Opportunityteammember teammemberNew : teamMember.get(opnew.Related_Opportunity__c)) {
                Opportunityteammember opportunityteamMemberNew = new Opportunityteammember();
                //opportunityteamMemberNew.Name = teammemberNew.Name;
                OpportunityteamMemberNew.OpportunityAccessLevel = teammemberNew.OpportunityAccessLevel;
                OpportunityteamMemberNew.OpportunityId = opnew.Id;
                OpportunityteamMemberNew.TeamMemberRole = teammemberNew.TeamMemberRole;
                // opportunityteamMemberNew.Title = teammemberNew.Title;
                OpportunityteamMemberNew.UserId  = teammemberNew.UserId ;
                Tmember .add(opportunityteamMemberNew);
            }
            System.debug('Tmember-->'+Tmember);
        }   
        if(Tmember != Null && Tmember.size() > 0) {
            INSERT Tmember;
        }
        
        System.debug('Tmember-->'+Tmember);
        
       
        
        System.debug('Tmember-->'+Tmember);
        
        for(Opportunity opnewupdate : newmapRenewal.values()) {
            if(opnewupdate.related_opportunity__c != Null) {
                opnewupdate.stageName = 'Propose (50-84%)';
                opnewupdate.Probability= 75;
                opnewupdate.related_opportunity__c = NULL;
                opnewupdate.CountOpportunityContactRole__c = cROle.size();
                newOprupdateNew.add(opnewupdate);
            }
        }
        UPDATE newOprupdateNew;
        System.debug('newOprupdateNew-->'+newOprupdateNew);
         for(Opportunity opp : oppline) {
             if(newMapRenewal.containsKey(opp.Id)){
                    opp.RenewalCreated__c = true;
                    newOprupdate.add(opp);
                    }
        } 
        UPDATE newOprupdate;
        OpportunitySchedule.OpportunityScheduleCreation(newOprupdateNew);
    }
    
   /* public static date datemodification(date closeDate) {
        date mydate;
        if(closeDate != null && closeDate.day() <= 10) {
            mydate = closedate.addDays(1);
            return mydate;
        } else if(closeDate.day() > 11) {
            mydate = closeDate.toStartOfMonth().addMonths(1);
            return mydate;
        }
        return closeDate;
    }*/       
    
    global void finish(Database.BatchableContext bc){
        
    }
}