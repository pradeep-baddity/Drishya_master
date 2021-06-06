global class Renewal_Opportunity_for_Standard implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext bc) 
    {
        
         Id HcId = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('Healthcare Opportunities').getRecordTypeId();
         Id HcsId = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('Healthcare Software').getRecordTypeId();
       
         return database.getQueryLocator([select id,
                                         AutoCreateRenewal__c,
                                         RenewalCreated__c,
                                         AddOnUpSaleEndDate__c,
                                         Effective_Date__c,
                                         AccountId,
                                         StageName,
                                         Pricebook2Id,
                                         recordtypeId,
                                         Renewal_opportunity_Date__c,
                                         (select id,PricebookEntryId,CurrencyIsoCode,
                                          Elite_Department_ID__c,Product2Id,Offering__c,
                                          unitprice,Practice__c,OpportunityId,Service_Line_or_Product__c,
                                          Start_Date__c,Opp_recordtype__c,Opportunity_Stage__c,Geography__c,
                                          Estimated_Duration__c,Elite_Service_Line__c,Elite_Service_Line_ID__c,Renew__c,
                                          Elite_Department__c,Module_or_Accelerator2__c,Offering_Lost__c,Amount__c,Default_Cost_Center__c,Default_Project_Hierarchy__c
                                          from opportunitylineitems
                                          where (Renew__c=True) AND (Service__c IN ('Performance Improvement Technology'))AND(Offering_Lost__c=False)
                                          ) from opportunity 
                                         where StageName = 'Closed Won (100%)' AND Type ='Standard Opportunity' AND RenewalCreated__c = false AND AutoCreateRenewal__c = True AND (Renewal_opportunity_Date__c!= Null) AND (recordtypeId =: HcId OR recordtypeId =: HcsId)]);
   
    }global void execute(Database.BatchableContext bc, List<opportunity> oppline)
    {
        
        System.debug('oppline'+oppline);
        set<Id> setOpId = new set<Id>();
        list<Opportunity> newOpr = new list<Opportunity>();
        list<Opportunity> newOprupdate = new list<Opportunity>();
        list<Opportunity> newOprupdateNew = new list<Opportunity>();
        map<Id, list<opportunitylineitem>> newMap= new map<Id, list<opportunitylineitem>>();
        map<Id, opportunity> newMapRenewal= new map<Id, opportunity>();
        map<Id, list<OpportunityContactRole>> contactRole= new map<Id, list<OpportunityContactRole>>();
        map<Id, list<OpportunityTeamMember>> teamMember= new map<Id, list<OpportunityTeamMember>>();
        List<opportunityLineItem> opLineList = new List<opportunityLineItem>();
        List<opportunityContactRole> cRole = new List<opportunityContactRole>();
        List<OpportunityTeamMember> Tmember = new List<OpportunityTeamMember>();
        list<opportunitylineitem> newlineitem = new list<opportunitylineitem>();
        
      List<Account> acclist=  [select id,name from Account where name='NONE (Do Not Edit)'];
        
        for(opportunity op : oppline)
        {
            setOpId.add(op.Id);
            system.debug('setOpId-->'+setOpId);
            date mydate = system.today();
            mydate=mydate.addDays(534);
            
            system.debug('mydate-->'+mydate);
            
            //Decimal es_duration= op.Estimated_Duration__c;
             //Date est_date = (op.Estimated_Start_Date__c).addMonths(12);
                                 
            if(op.Renewal_opportunity_Date__c<= mydate )
            {
                //newMap.put(op.Id,opportunitylineitems);
                for(opportunitylineitem opplinenew : op.opportunitylineitems)
                {
                    newMap.put(opplinenew.OpportunityId,op.opportunitylineitems);
                }
            }
            
        }
        system.debug('newMap-->'+newMap);
        
        for(opportunity opportunityContactRole :[select id,(select Id,ContactId,opportunityId,role from OpportunityContactRoles) from opportunity where Id in : setOpId])
        {
            contactRole.put( opportunityContactRole.Id, opportunityContactRole.OpportunityContactRoles);
        }
        system.debug('contactRole-->'+contactRole);
        
        for(opportunity opportunityTeamMember :[select id,(SELECT Id,Name,OpportunityAccessLevel,OpportunityId,TeamMemberRole,Title,UserId FROM OpportunityTeamMembers) from opportunity where Id in : setOpId])
        {
            teamMember.put( opportunityTeamMember.Id, opportunityTeamMember.OpportunityTeamMembers);
        }
        system.debug('teamMember-->'+teamMember);
        
        if(newMap.values().size() > 0)
        {
            
            for(opportunity opptynew : [select id,Stagename,
                                        name,ownerId,accountId,
                                        HC_Region__c,recordtypeId,
                                        NextStep,Type,Effective_Date__c,currencyIsoCode,Pricebook2Id,
                                        AddOnUpSaleEndDate__c, AddOnUpSaleEngagementNumber__c,
                                        AutoCreateRenewal__c,CloseDate,Amount,Estimated_Duration__c,Competitor__c,
                                        LeadSource,Estimated_Start_Date__c from opportunity where Id In : newmap.keyset()])
            {
                date myDate1 = system.today();
                integer newyear = mydate1.year();
                system.debug('newyear-->'+newyear);
                opportunity newOpp = new opportunity();
                newOpp.recordtypeId = opptynew.recordtypeId;
                newOpp.ownerId      = '005U0000003qa9U';
                
                newOpp.Related_Opportunity__c = opptynew.Id;
                newOpp.SABER_Original_Opportunity_ID__c= opptynew.Id;
                //newOpp.name         = opptynew.name + ' - Auto';
                string oppName;
                oppName = opptynew.name + ' - Auto';
                Integer maxSize = 120;
                system.debug('oppName--'+oppName); 
                if(oppName.length() > maxSize ){
                oppName = oppName.substring(0, maxSize);}
                newOpp.name         = oppName;
                newOpp.AccountId    = opptynew.accountId;
                newOpp.HC_Region__c = opptynew.HC_Region__c;
                newOpp.Type         = 'Renewal Opportunity';
                newOpp.AutoCreateRenewal__c = true;
                newOpp.Amount = opptynew.Amount;
                newOpp.Estimated_Duration__c = 12;
                newOpp.LeadSource = 'Established Client';
                newOpp.Reason_Won__c = 'Existing Client';
               // newOpp.Competitor__c=opptynew.Competitor__c;
               // 
               if(acclist.size()>0)
               {
                  newOpp.Competitor__c=acclist[0].id; 
               }
                
                //newOpp.leadSource = opptynew.leadSource
                newOpp.StageName = 'Prospect (0-14%)';
                newOpp.pricebook2Id = opptyNew.pricebook2Id;
                newOpp.currencyIsoCode = opptynew.currencyIsoCode;
                newOpp.AutoCreateRenewal__c = True;
               // date newDate = (opptynew.Estimated_Start_Date__c).addMonths((Integer)opptynew.Estimated_Duration__c);
               date newDate = (opptynew.Estimated_Start_Date__c).addMonths(12);
                newOpp.CloseDate = newDate;
                //date newStartDate = newDateModification(newOpp.CloseDate);
                //date newStartDate = (opptynew.Effective_Date__c).addDays((Integer)opptynew.Estimated_Duration__c);
              //  newOpp.Estimated_Start_Date__c = datemodification(newOpp.CloseDate); AddOnUpSaleEndDate__c
                  newOpp.Estimated_Start_Date__c = (opptynew.Estimated_Start_Date__c).addMonths(12);
                //date newEffectiveDate = (opptynew.AddOnUpSaleEndDate__c).addDays(1);
                newOpp.Effective_Date__c = (opptynew.Estimated_Start_Date__c).addMonths(12);
                date newEndDate = ((opptynew.Estimated_Start_Date__c).addMonths(24)).addDays(-1); 
                newOpp.AddOnUpSaleEndDate__c =  newEndDate;
                newOpr.add(newOpp);
                newMapRenewal.put(opptynew.Id,newOpp);
            }
            system.debug('newMapRenewal-->'+newMapRenewal);
        }
        if(newOpr != Null && newOpr.size() > 0 )
        {
            insert newOpr;
        }
        for(opportunity opnew : newOpr)
        {
            for(opportunitylineitem opplineitem : newMap.get(opnew.Related_Opportunity__c))
            {
                opportunitylineitem oplineitemnew = new opportunitylineitem();
                oplineitemnew.geography__c = opplineitem.geography__c;
                oplineitemnew.opportunityId = opnew.id;
                //oplineitemnew.CurrencyIsoCode =opplineitem.CurrencyIsoCode;
                oplineitemnew.Product2Id= opplineitem.Product2Id;
                oplineitemnew.Elite_Department_ID__c = opplineitem.Elite_Department_ID__c;
                oplineitemnew.Offering__c = opplineitem.Offering__c;
                oplineitemnew.Practice__c = opplineitem.Practice__c;
                oplineitemnew.Is_Undefined__c= true;
                oplineitemnew.Renew__c=true;
                oplineitemnew.Service_Line_or_Product__c = opplineitem.Service_Line_or_Product__c;
                oplineitemnew.Elite_Service_Line__c = opplineitem.Elite_Service_Line__c;
                oplineitemnew.Elite_Service_Line_ID__c = opplineitem.Elite_Service_Line_ID__c;
                oplineitemnew.Elite_Department__c = opplineitem.Elite_Department__c;
                oplineitemnew.Module_or_Accelerator2__c = opplineitem.Module_or_Accelerator2__c;
                oplineitemnew.Offering_Lost__c = opplineitem.Offering_Lost__c;
                oplineitemnew.Amount__c = opplineitem.Amount__c;
                oplineitemnew.unitprice= opplineitem.unitprice;
                oplineitemnew.PricebookEntryId = opplineitem.PricebookEntryId;
                oplineitemnew.Default_Project_Hierarchy__c= opplineitem.Default_Project_Hierarchy__c;
                oplineitemnew.Default_Cost_Center__c =  opplineitem.Default_Cost_Center__c;
                //countryPriceBookMap.get(opnew.CurrencyIsoCode);
                system.debug('PricebookEntryId-->'+oplineitemnew.PricebookEntryId);
                //'01u3F000004ka4jQAA';
                newlineitem.add(oplineitemnew);
            }
            system.debug('newlineitem-->'+newlineitem);
        }
        if(newlineitem != Null && newlineitem.size() > 0)
        {
            insert newlineitem;
        }
        
        for(opportunity opnew : newOpr)
        {
            for(opportunitycontactrole contactrolenew : contactRole.get(opnew.Related_Opportunity__c))
            {
                opportunitycontactrole opportunitycontactroleNew = new opportunitycontactrole();
                opportunitycontactroleNew.ContactId = contactrolenew.contactId;
                opportunitycontactroleNew.role = contactrolenew.role;
                opportunitycontactroleNew.opportunityId = opnew.id;
                cROle.add(opportunitycontactroleNew);
            }
            system.debug('cROle-->'+cROle);
        }   
        if(cROle != Null && cROle.size() > 0)
        {
            insert cROle;
        }
        system.debug('cROle-->'+cROle);
        for(opportunity opnew : newOpr)
        {
            for(opportunityteammember teammemberNew : teamMember.get(opnew.Related_Opportunity__c))
            {
                opportunityteammember opportunityteamMemberNew = new opportunityteammember();
                //opportunityteamMemberNew.Name = teammemberNew.Name;
                opportunityteamMemberNew.OpportunityAccessLevel = teammemberNew.OpportunityAccessLevel;
                opportunityteamMemberNew.OpportunityId = opnew.id;
                opportunityteamMemberNew.TeamMemberRole = teammemberNew.TeamMemberRole;
                // opportunityteamMemberNew.Title = teammemberNew.Title;
                opportunityteamMemberNew.UserId  = teammemberNew.UserId ;
                Tmember.add(opportunityteamMemberNew);
            }
            system.debug('Tmember-->'+Tmember);
        }   
        if(Tmember != Null && Tmember.size() > 0)
        {
            insert Tmember;
        }
        system.debug('Tmember-->'+Tmember);
        
        system.debug('Tmember-->'+Tmember);
        for(opportunity opnewupdate : newmapRenewal.values() )
        {
            if(opnewupdate.related_opportunity__c != Null)
            {
                opnewupdate.stageName = 'Propose (50-84%)';
                opnewupdate.Probability= 75;
                opnewupdate.related_opportunity__c = NULL;
                opnewupdate.CountOpportunityContactRole__c= cRole.size();
                                
                newOprupdateNew.add(opnewupdate);
            }
        }
        update newOprupdateNew;
        system.debug('newOprupdateNew-->'+newOprupdateNew);
        
        for(opportunity opp : oppline)
        {
            if(newMapRenewal.containsKey(opp.Id)){
                opp.RenewalCreated__c = true;
                newOprupdate.add(opp);
            }
        } 
        update newOprupdate;
        
        OpportunitySchedule.OpportunityScheduleCreation(newOprupdateNew);
    }
   /* public static date datemodification(date closeDate)
    {
        date mydate;
        if(closeDate != null && closeDate.day() <= 10)
        {
            mydate = closedate.addDays(1);
            return mydate;
        }
        else if(closeDate.day() > 11){
            mydate = closeDate.toStartOfMonth().addMonths(1);
            return mydate;
        }
        return closeDate;
        
        
        
    }*/
   global void finish(Database.BatchableContext bc){
        
    } 
    
    
}