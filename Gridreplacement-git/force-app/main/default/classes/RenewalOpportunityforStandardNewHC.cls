global class RenewalOpportunityforStandardNewHC implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        Id HcId = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('Healthcare Opportunities').getRecordTypeId();
        Id HcsId = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('Healthcare Software').getRecordTypeId();
        
        return database.getQueryLocator([select id,
                                         AutoCreateRenewal__c,
                                         RenewalCreated__c,
                                         AddOnUpSaleEndDate__c,
                                         Effective_Date__c,
                                         AccountId,
                                         StageName,
                                         OwnerId,Estimated_Start_Date__c,
                                         Pricebook2Id,
                                         recordtypeId,
                                         Renewal_opportunity_Date__c,
                                         (select id,PricebookEntryId,CurrencyIsoCode,
                                          Elite_Department_ID__c,Product2Id,Offering__c,
                                          unitprice,Practice__c,OpportunityId,Service_Line_or_Product__c,
                                          Start_Date__c,Opp_recordtype__c,Opportunity_Stage__c,Geography__c,
                                          Estimated_Duration__c,Elite_Service_Line__c,Elite_Service_Line_ID__c,
                                          Elite_Department__c,Offering_Lost__c,Amount__c,
                                          Is_Undefined__c,Renew__c,Default_Cost_Center__c,
                                          Expertise__c,Service__c,Capability_new__c,Technology_Vendor__c,Technology_Capability__c,
                                          Default_Project_Hierarchy__c,Technology_Product__c
                                          from opportunitylineitems
                                          where 
                                          //(Elite_Department_ID__c IN ('1323','1542','1566'))  
                                          //(Module_or_Accelerator2__c != 'Buy-up') 
                                          (Service__c = 'COEx Assessments'OR Service__c ='COEx Delivery' OR Service__c = 'COEx Leadership Academy' OR Service__c = 'COEx Software') 
                                          AND Offering_Lost__c = False AND Renew__c = True) from opportunity 
                                         where StageName = 'Closed Won (100%)' AND Type ='Standard Opportunity' AND RenewalCreated__c = false AND AutoCreateRenewal__c = True AND (Renewal_opportunity_Date__c!= Null) AND (recordtypeId =: HcId OR recordtypeId =: HcsId)]);
    }
    global void execute(Database.BatchableContext bc, List<opportunity> oppline){
        system.debug('oppline-->'+oppline);
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
            set<id> newOppId= new set<id>();

        
        for(opportunity op : oppline)
        {
            setOpId.add(op.Id);
            system.debug('setOpId-->'+setOpId);
            date mydate = system.today();
            mydate=mydate.addDays(549);
            system.debug('mydate-->'+mydate);
            if(op.Renewal_opportunity_Date__c<= mydate)
                
            {
                system.debug('inside----');
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
                                        HC_Region__c,recordtypeId,Competitor__c,
                                        NextStep,Type,Effective_Date__c,currencyIsoCode,Pricebook2Id,
                                        AddOnUpSaleEndDate__c, AddOnUpSaleEngagementNumber__c,
                                        AutoCreateRenewal__c,CloseDate,Amount,Estimated_Duration__c,
                                        LeadSource,Probability,CountOpportunityContactRole__c,Estimated_Start_Date__c from opportunity where Id In : newmap.keyset()])
            {
                date myDate1 = system.today();
                integer newyear = mydate1.year();
                system.debug('newyear-->'+newyear);
                opportunity newOpp = new opportunity();
                newOpp.recordtypeId = opptynew.recordtypeId;
                newOpp.ownerId      = '0050B000006ED3L';
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
                newOpp.Probability  = 30;
                newOpp.RenewalCreated__c = false;
                newOpp.AutoCreateRenewal__c = true;
                newOpp.Amount = opptynew.Amount;
                newOpp.CountOpportunityContactRole__c = opptynew.CountOpportunityContactRole__c;
                newOpp.Estimated_Duration__c = opptynew.Estimated_Duration__c;
                newOpp.LeadSource = 'Established Client';
                newOpp.Reason_Won__c = 'Existing Client';
                
                if(acclist.size()>0)
               {
                  newOpp.Competitor__c=acclist[0].id; 
               }

                // newOpp.Competitor__c = opptynew.Competitor__c;
                //newOpp.leadSource = opptynew.leadSource
                newOpp.StageName = 'Design (30-49%)';
                newOpp.pricebook2Id = opptyNew.pricebook2Id;
                newOpp.currencyIsoCode = opptynew.currencyIsoCode;     
                
                // date newDate = (opptynew.Estimated_Start_Date__c).addMonths((Integer)opptynew.Estimated_Duration__c);
                date newDate = (opptynew.Estimated_Start_Date__c).addMonths((Integer)opptynew.Estimated_Duration__c);
                newOpp.CloseDate = newDate;
                //date newStartDate = newDateModification(newOpp.CloseDate);
                //date newStartDate = (opptynew.Effective_Date__c).addDays((Integer)opptynew.Estimated_Duration__c);
                //  newOpp.Estimated_Start_Date__c = datemodification(newOpp.CloseDate); AddOnUpSaleEndDate__c
                // newOpp.Estimated_Start_Date__c = (opptynew.Estimated_Start_Date__c).addMonths(12);
                //date newEffectiveDate = (opptynew.AddOnUpSaleEndDate__c).addDays(1);
                
                // newOpp.Effective_Date__c = (opptynew.Estimated_Start_Date__c).addMonths(12);
                newOpp.Estimated_Start_Date__c = newDate;
                
                newOpp.Effective_Date__c = newDate;
                
                Integer newBudgetYear	= ((opptynew.Estimated_Start_Date__c).addMonths((Integer)opptynew.Estimated_Duration__c)).year();
                
                newOpp.Budget_Year__c = string.valueof(newBudgetYear);
                system.debug('Budegt Year'+newOpp.Budget_Year__c);
                
                date newEndDate = ((opptynew.Estimated_Start_Date__c).addMonths((Integer)opptynew.Estimated_Duration__c)).addDays(-1); 
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
                // oplineitemnew.geography__c = opplineitem.geography__c;
                oplineitemnew.opportunityId = opnew.id;
                //oplineitemnew.CurrencyIsoCode =opplineitem.CurrencyIsoCode;
                oplineitemnew.Product2Id= opplineitem.Product2Id;
                // oplineitemnew.Elite_Department_ID__c = opplineitem.Elite_Department_ID__c;
                oplineitemnew.Offering__c = opplineitem.Offering__c;
                oplineitemnew.Practice__c = opplineitem.Practice__c;
                oplineitemnew.Service__c = opplineitem.Service__c;
                //oplineitemnew.Service_Line_or_Product__c = opplineitem.Service_Line_or_Product__c;
                //oplineitemnew.Elite_Service_Line__c = opplineitem.Elite_Service_Line__c;
                //oplineitemnew.Elite_Service_Line_ID__c = opplineitem.Elite_Service_Line_ID__c;
                //oplineitemnew.Elite_Department__c = opplineitem.Elite_Department__c;
                 //oplineitemnew.Module_or_Accelerator2__c = opplineitem.Module_or_Accelerator2__c;
                oplineitemnew.Offering_Lost__c = opplineitem.Offering_Lost__c;
                oplineitemnew.Amount__c = opplineitem.Amount__c;
                oplineitemnew.unitprice= opplineitem.unitprice;
                oplineitemnew.Is_Undefined__c= opplineitem.Is_Undefined__c; 
                oplineitemnew.Renew__c= opplineitem.Renew__c;
                oplineitemnew.Expertise__c= opplineitem.Expertise__c;
                oplineitemnew.Capability_new__c= opplineitem.Capability_new__c;
                oplineitemnew.Technology_Vendor__c= opplineitem.Technology_Vendor__c;
                oplineitemnew.Technology_Capability__c= opplineitem.Technology_Capability__c;
                oplineitemnew.Technology_Product__c= opplineitem.Technology_Product__c;
                oplineitemnew.Default_Project_Hierarchy__c= opplineitem.Default_Project_Hierarchy__c;
                oplineitemnew.Default_Cost_Center__c =  opplineitem.Default_Cost_Center__c;
                oplineitemnew.PricebookEntryId = opplineitem.PricebookEntryId;
                
                
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
                Tmember .add(opportunityteamMemberNew);
            }
            system.debug('Tmember-->'+Tmember);
        }   
        if(Tmember != Null && Tmember.size() > 0)
        {
            insert Tmember;
        }
        system.debug('Tmember-->'+Tmember);
        
        system.debug('Tmember-->'+Tmember);
        for(opportunity opnewupdate : newmapRenewal.values()){
        newOppId.add(opnewupdate.id);

        }
   for(opportunity opnewupdate : [select Id,stageName,  Probability, Estimated_Duration__c,RecordTypeId,BudgetAmountTCV__c,related_opportunity__c,Budget_Amount_ACV__c, CountOpportunityContactRole__c, Amount from opportunity where Id IN :  newOppId ])

        {
            if(opnewupdate.related_opportunity__c != Null)
            {
                opnewupdate.stageName = 'Design (30-49%)';
                opnewupdate.Probability= 30;
                opnewupdate.related_opportunity__c = NULL;
               opnewupdate.BudgetAmountTCV__c = opnewupdate.Amount;
           		opnewupdate.Budget_Amount_ACV__c = (opnewupdate.Amount)/ ((opnewupdate.Estimated_Duration__c)*12);
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
    public static date datemodification(date closeDate)
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
    }          
    
    
    global void finish(Database.BatchableContext bc){
        
    } 
    
    
    
}