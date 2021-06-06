global class EduOpportunityRenewal implements Database.Batchable<sObject> {
   global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('inside start');
        Id EDUId = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('EDU Opportunity').getRecordTypeId();
        
        return database.getQueryLocator([SELECT Id, AutoCreateRenewal__c, RenewalCreated__c, Type, Probability, CloseDate, AddOnUpSaleEndDate__c, LeadSource,Related_Opportunity__c, Industry__c,
                                         MD_of_Record__c, Description, Estimated_Duration__c, Estimated_Start_Date__c, Name, AccountId, StageName, Pricebook2Id, OwnerId, Initiate_Renewal__c, 
                                         recordtypeId, Renewal_opportunity_Date__c, Next_Renewal_Date__c, Effective_Date__c,Annual_Contract_Change__c,SABER_Original_Opportunity_ID__c,CurrencyIsoCode,
                                         (SELECT Id, PricebookEntryId, Industry__c, CurrencyIsoCode, Elite_Department_ID__c, Description, Product2Id, Offering__c,Technology_Module__c,
                                          Unitprice, Practice__c,Software_Sales_Type__c, Elite_Department__c, OpportunityId, Start_Date__c, Opp_recordtype__c,Mod_Picklist_ID__c, 
                                          Opportunity_Stage__c, Task_Code__c, Geography__c, Estimated_Duration__c, Elite_Service_Line__c, Renew__c, Default_Cost_Center__c,
                                          Elite_Service_Line_ID__c, Module_or_Accelerator2__c, Software_Component__c, Offering_Lost__c, Engagement_Number__c, Is_Undefined__c,
                                          Amount__c, EDU_Segment__c, Override_Elite_Department__c, Override_Elite_Service_Line__c, Offering_Actual_Revenue_Rollup__c
                                          FROM OpportunityLineItems WHERE Offering_Lost__c = false AND Practice__c = 'Education' AND Renew__c = true)
                                         FROM Opportunity WHERE StageName = 'Closed Won (100%)'
                                         AND Type ='Renewal Opportunity'
                                         AND RenewalCreated__c = false 
                                         AND AutoCreateRenewal__c = True
                                         AND (recordtypeId =: EDUId)
                                        ]);
        
    }
    
    global void execute(Database.BatchableContext bc, List<Opportunity> oppItems){
        Set<Id> setOpId = new Set<Id>(); //oppId for offerings in it
        List<Opportunity> clonedOppList = new List<Opportunity>(); //List of new Opportunity to be renewed
        List<Opportunity> newOprupdate = new List<Opportunity>();
        List<OpportunityLineItem> oliToUpdateList = new List<OpportunityLineItem>();
        
        Map<Id, List<Sales_Credit_Employee__c>> oppSalesCreditEmployeeMap = new Map<Id, List<Sales_Credit_Employee__c>>();
        Map<Id, Decimal> oppAnnualPercentageMap = new Map<Id, Decimal>(); //Create map of Oppid and AnnualContractCharge to get its correct value in for loop
        Map<Id, Opportunity> oldIdvsNewOpp = new Map<Id, Opportunity>();
        Map<Id, Id> OldvsNewSalesCreditId = new Map<Id, Id>();
        
        List<OpportunityContactRole> clonedConRoleList = new List<OpportunityContactRole>();
        List<Sales_Credit__c> clonedSalesCreditList = new List<Sales_Credit__c>();
        List<Sales_Credit_Employee__c> clonedSalesCreditEmpList = new List<Sales_Credit_Employee__c>();
        List<Opportunitylineitem> clonedOpplineitemList = new List<Opportunitylineitem>();
        
        
        for(Opportunity opp : oppItems) {
            if(opp.OpportunityLineItems.size() > 0 ) {
                setOpId.add(opp.Id);
                
                Opportunity newOpp = opp.clone(false);
                newOpp.Related_Opportunity__c = opp.Id;
                newOpp.OwnerId = opp.OwnerId;
                newOpp.SABER_Original_Opportunity_ID__c = opp.Id;
                newOpp.Type = 'Renewal Opportunity';
                newOpp.AutoCreateRenewal__c = true;
                newOpp.StageName = 'Commit (85-99%)';
                newOpp.Probability = 85;
                newOpp.CloseDate = opp.CloseDate.addyears(1);
                newOpp.Estimated_Start_Date__c = opp.Estimated_Start_Date__c.addyears(1);
                newOpp.Effective_Date__c = opp.Estimated_Start_Date__c.addyears(1);
                newOpp.AddOnUpSaleEndDate__c = opp.Estimated_Start_Date__c.addyears(2).adddays(-1);
                newOpp.Reason_Won__c = 'Existing Customer / Client Relationship';
                newOpp.Competitor__c = System.Label.NoneAccount;
                newOpp.RenewalCreated__c = false;
                newOpp.Initiate_Renewal__c = opp.Estimated_Start_Date__c.addyears(1).addDays(-90);
                newOpp.Annual_Contract_Change__c = null;
                newOpp.pricebook2Id = opp.pricebook2Id;
                
                Datetime saberEffectiveDate = (Datetime)opp.Estimated_Start_Date__c.addyears(1);
                Datetime saberEndDate = (Datetime)opp.Estimated_Start_Date__c.addyears(2).adddays(-1);
                String newName = opp.Name.SubStringBefore('-');
                newName = newName + ' - '+ saberEffectiveDate.format('MM/dd/yyyy') +' '+ saberEndDate.format('MM/dd/yyyy');
                newOpp.Name = newName;
                
                clonedOppList.add(newOpp);
                oppAnnualPercentageMap.put(opp.Id, opp.Annual_Contract_Change__c);
                
            }
        }
        
        System.debug('=-=-setOpId-=='+setOpId);
        
        if(clonedOppList.size() > 0) {
            List<Database.SaveResult> oppSaveResult = database.insert(clonedOppList, false);
            System.debug('clonedOppList : '+JSON.serialize(clonedOppList));
            System.debug('oppSaveResult : '+JSON.serialize(oppSaveResult));
            
            //Try to avoid for loop - TODO
            for(Integer i=0; i<oppSaveResult.size(); i++) {
                if(oppSaveResult[i].isSuccess()){
                    oldIdvsNewOpp.put(clonedOppList[i].Related_Opportunity__c, clonedOppList[i]);
                }
            }
            System.debug('oldIdvsNewOpp : '+JSON.serialize(oldIdvsNewOpp));
        }
        
        for(OpportunityContactRole oppConRole : [SELECT Id, ContactId, OpportunityId, Role FROM OpportunityContactRole WHERE OpportunityId IN : setOpId]) {
            Opportunitycontactrole oppconRoleNew = oppConRole.clone(false);
            oppconRoleNew.opportunityId = oldIdvsNewOpp.get(oppConRole.OpportunityId).Id;
            
            clonedConRoleList.add(oppconRoleNew);
        }
        if(clonedConRoleList.size() > 0) {
            INSERT clonedConRoleList;
        }
        
        List<Sales_Credit__c> salesCreditList = [SELECT Id, Name, Opportunity__c, CurrencyIsoCode, RecordTypeId, HC_Assessment_or_Contract__c, HC_Integrated_Opportunity__c, Meets_Criteria__c, 
                                                 Status__c, Status2__c, Roll_Up_Discovery__c, Roll_Up_Non_MD_Discovery__c, Roll_Up_MD_Sales_Team__c, Roll_Up_Non_MD_Sales_Team__c 
                                                 FROM Sales_Credit__c
                                                 WHERE Status__c IN ('Open','Submitted','Approved')
                                                 AND Opportunity__c IN : setOpId];
        
        System.debug('-=-=-salesCreditList-=-=-'+salesCreditList);
        
        if(!salesCreditList.isEmpty()) {
            for(Sales_Credit__c salesCredits : salesCreditList) {
                Sales_Credit__c salesCreditNew = salesCredits.clone();
                salesCreditNew.Name = 'SalesCredit: '+ oldIdvsNewOpp.get(salesCredits.Opportunity__c).Name;//objsalesCredit.Name;
                salesCreditNew.Status__c = 'Open';
                Integer maxSize = 80;
                if((salesCreditNew.Name).length() > maxSize ){
                    salesCreditNew.Name = (salesCreditNew.Name).substring(0, maxSize);
                }
                salesCreditNew.name   = salesCreditNew.Name;
                salesCreditNew.Opportunity__c = oldIdvsNewOpp.get(salesCredits.Opportunity__c).Id;
                clonedsalesCreditList.add(salesCreditNew);
                
            }
            system.debug('clonedsalesCreditList'+clonedsalesCreditList);
            if(clonedsalesCreditList.size() > 0) {
                List<Database.SaveResult> saveResult = database.insert(clonedsalesCreditList, false);
                system.debug('saveresult'+SaveResult);
                
                for(Integer i=0; i<saveResult.size(); i++) {
                    if(saveResult[i].isSuccess()){
                        OldvsNewSalesCreditId.put(salesCreditList[i].Id, clonedsalesCreditList[i].Id);
                    }
                }
                System.debug('-=OldvsNewSalesCreditId-='+JSON.serialize(OldvsNewSalesCreditId));
            }
        }
        
        for(Sales_Credit_Employee__c salesCreditEmployee : [SELECT Id, Name, Huron_Employee__c, Role__c, Split__c, Split_adjusted_total_amount__c, Finance_Split__c, LegacyID__c, 
                                                            Sales_Credit__c, RecordTypeId, Legacy_Source_System__c FROM Sales_Credit_Employee__c
                                                            WHERE Sales_Credit__c IN :OldvsNewSalesCreditId.keyset()]) 
        {
            Sales_Credit_Employee__c salescreditEmployeeNew = salesCreditEmployee.clone();
            salescreditEmployeeNew.Sales_Credit__c = OldvsNewSalesCreditId.get(salesCreditEmployee.Sales_Credit__c);
            
            clonedSalesCreditEmpList.add(salescreditEmployeeNew);
        }
        if(!clonedSalesCreditEmpList.isEmpty()){
            INSERT clonedSalesCreditEmpList;
        }
        
        Map<Id, List<opportunitylineitem>> oldOppIdvsOLIMap = new Map<Id, List<Opportunitylineitem>>(); //Map of opp Id and Opp Line Items
        for(Opportunity oppListWithOLI :[SELECT Id,(SELECT Id, Geography__c, Unitprice, Product2Id, Elite_Department_ID__c, Task_Code__c, Offering__c, 
                                                    Practice__c, PricebookEntryId, Elite_Service_Line__c, Amount__c, Elite_Service_Line_ID__c, 
                                                    Software_Component__c, Description, Industry__c, CurrencyIsoCode, EDU_Segment__c,Mod_Picklist_ID__c,
                                                    Elite_Department__c, Engagement_Number__c, Override_Elite_Department__c, Override_Elite_Service_Line__c, 
                                                    Offering_Actual_Revenue_Rollup__c, Technology_Module__c, Software_Usage_Level_1__c, Product_Family__c, Service__c,
                                                    Capability_new__c, Expertise__c, Technology_Capability__c, Technology_Vendor__c, Technology_Product__c, 
                                                    Product_Schedule_Created__c, Default_Cost_Center__c, Renew__c, Default_Project_Hierarchy__c, Is_Undefined__c   
                                                    FROM OpportunityLineItems WHERE Offering_Lost__c = false AND Renew__c = true AND Practice__c = 'Education')
                                         FROM Opportunity WHERE Id IN : setOpId]){
                                             oldOppIdvsOLIMap.put( oppListWithOLI.Id, oppListWithOLI.OpportunityLineItems);
                                         }
        System.debug('-=-DefaultCheck=-=--'+Json.serialize(oldOppIdvsOLIMap.values()));
        
        for(Opportunity opp : clonedOppList) {
            for(OpportunityLineItem OppLineItem : oldOppIdvsOLIMap.get(opp.Related_Opportunity__c)) {
                Opportunitylineitem opplineitemnew = OppLineItem.clone();
                Decimal Amount;
                opplineitemnew.OpportunityId = opp.Id;
                opplineitemnew.Software_Sales_Type__c = 'Renewal';
                opplineitemnew.pricebookentryId = OppLineItem.pricebookentryId;
                opplineitemnew.EDURenewalCreated__c = true;
                
                System.debug('-=--DefaultCostCenter-=-=-'+OppLineItem.Default_Cost_Center__c);
                System.debug('-=--TechCapability-=-=-'+OppLineItem.Technology_Capability__c);
                System.debug('-=--isUndefined-=-=-'+OppLineItem.Is_Undefined__c);
                System.debug('-=--Renew-=-=-'+OppLineItem.Renew__c);
                
                opplineitemnew.Default_Cost_Center__c = oppLineItem.Default_Cost_Center__c;
                if(OppLineItem.Amount__c == 1) {
                    Amount = 1;
                } else if(OppLineItem.Amount__c > 1 && oppAnnualPercentageMap.get(opp.Related_Opportunity__c) != null){
                    Amount = OppLineItem.Amount__c * (1 + (oppAnnualPercentageMap.get(opp.Related_Opportunity__c)/100));
                } else {
                    Amount = OppLineItem.Amount__c;
                }
                opplineitemnew.UnitPrice = Amount;
                opplineitemnew.Amount__c = Amount;
                opplineitemnew.Offering_Estimated_Contract_Value_ECV__c = Amount;
                
                clonedOpplineitemList.add(opplineitemnew);
            }
        }
        
        System.debug('-=-=clonedOpplineitemList-=-'+clonedOpplineitemList);
        
        if(!clonedOpplineitemList.isEmpty()) {
            INSERT clonedOpplineitemList;
            
            System.debug('=--=-=clonedOppLineItemListInserted=-==-'+clonedOpplineitemList);
            
            Set<Id> setOLIId = new Set<Id>();
            for(OpportunityLineItem oli : clonedOpplineitemList){
                setOLIId.add(oli.Id);
            }
            
            System.debug('-=-setOLIId=-='+setOLIId);
            
            for(Id oliId : setOLIId) {
                oliToUpdateList.add(new OpportunityLineItem(Id = oliId, EDURenewalCreated__c = false));
            }
            System.debug('=-=-oliToUpdateList-='+oliToUpdateList);
            UPDATE oliToUpdateList;
        }
        
        
        
        OpportunitySchedule.OpportunityScheduleCreation(clonedOppList);
        
        for(Id oppId : setOpId) {
            newOprupdate.add(new Opportunity(Id = oppId, RenewalCreated__c = true));
        } 
        
        if(!newOprupdate.isEmpty()) {
            UPDATE newOprupdate;
        }
        
    }    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }    

}