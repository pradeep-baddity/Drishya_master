public with sharing class ExtensionOpportunityCreation{
    public static void createExtensionOpportunity(List<Opportunity> lstNewOpps, Map<Id,Opportunity> mapOfNewOpps, Map<Id,Opportunity> mapOfOldOpps){
        set<Id> setOfOppIds = new set<Id>();
        Id HealthCareId = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('Healthcare Opportunities').getRecordTypeId();
        Id HealthCareSoftwareId = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('Healthcare Software').getRecordTypeId();
        List<Opportunity> lstOfOpps = new List<Opportunity>();
        for(Opportunity opp : lstNewOpps){
            if(opp.AutoCreateRenewal__c && opp.StageName != 'Closed Lost' && (opp.RecordTypeId == HealthCareId || opp.RecordTypeId == HealthCareSoftwareId) &&  opp.AutoCreateRenewal__c != mapOfOldOpps.get(opp.Id).AutoCreateRenewal__c){
                setOfOppIds.add(opp.Id);
            }
        }
        if(!setOfOppIds.isEmpty() && setOfOppIds.size() > 0){
            for(Opportunity opp : [select Id,
                                          Name,
                                          AccountId,
                                          RecordTypeId,
                                          AutoCreateRenewal__c,
                                          StageName,
                                          ownerId,
                                          Type,
                                          CloseDate,
                                          Estimated_Duration__c,
                                          Amount,
                                          Estimated_Start_Date__c,
                                          LeadSource,
                                          AddOnUpSaleEngagementNumber__c,
                                          (select id,
                                                    PricebookEntryId,
                                                    CurrencyIsoCode ,
                                                    Elite_Department_ID__c,
                                                    Product2Id,
                                                    Offering__c,
                                                    unitprice,
                                                    Practice__c,
                                                    OpportunityId,
                                                    Service_Line_or_Product__c,
                                                    Start_Date__c,
                                                    Opp_recordtype__c,
                                                    Opportunity_Stage__c,
                                                    Geography__c, 
                                                    Estimated_Duration__c,
                                                    Elite_Service_Line__c,
                                                    Elite_Service_Line_ID__c,
                                                    Elite_Department__c,
                                                    Module_or_Accelerator2__c,
                                                    Offering_Lost__c,Amount__c 
                                                    from opportunitylineitems where Elite_Department_ID__c = '1458'),
                                         (select Id,
                                                 ContactId,
                                                 opportunityId,
                                                 role 
                                                 from OpportunityContactRoles) 
                                         from Opportunity where Id IN: setOfOppIds limit 50000]){
                lstOfOpps.add(opp);      
            }   
        }
        if(lstOfOpps != null && lstOfOpps.size() > 0){
            createNewOpputunities(lstOfOpps, mapOfNewOpps);
        }
    }
    
    public static void createNewOpputunities(List<Opportunity> lstOfOpps, Map<Id,Opportunity> mapOfNewOpps){
        List<Opportunity> lstOFNewOpps = new List<Opportunity>();
        Opportunity oppNew;
        Opportunity oppAddError;
        Map<Id,List<OpportunityLineItem>> mapOfOppLineItems = new Map<Id,List<OpportunityLineItem>>();
        Map<Id,List<OpportunityContactRole>> mapOfContactRole = new Map<Id,List<OpportunityContactRole>>();
        List<OpportunityLineItem> lstOppLineItems;
        List<OpportunityContactRole> lstOppContactRoles;
        for(Opportunity opp : lstOfOpps){
            if(opp.opportunitylineitems != null && opp.opportunitylineitems.size() > 0){
                if(opp.stageName == 'Prospect (0-14%)' && (opp.OpportunityContactRoles == null || String.isBlank(opp.LeadSource) || String.isBlank(opp.Type))){
                    oppAddError = mapOfNewOpps.get(opp.Id);
                    oppAddError.addError('Please provide values for Lead Source,Type,Estimated Duration,Contact Roles for creating the Extension Opportunity.');
                }else{
                    oppNew = new Opportunity();
                    oppNew.Opportunity_Id__c = opp.Id;
                    oppNew.AccountId = opp.AccountId;
                    oppNew.Name = opp.Name+' - Auto Extension';
                    oppNew.recordtypeId = opp.recordtypeId;
                    oppNew.ownerId = opp.ownerId;
                    oppNew.Type = 'Extension Opportunity';
                    oppNew.AutoCreateRenewal__c = False;
                    oppNew.Amount = opp.Amount;
                    oppNew.Estimated_Duration__c = opp.Estimated_Duration__c;
                    oppNew.LeadSource = opp.LeadSource;
                    oppNew.StageName = 'Prospect (0-14%)';
                    oppNew.Do_Not_Validate__c = true;
                    oppNew.SABER_Original_Opportunity_ID__c = opp.Id;
                    
                    if(opp.OpportunityContactRoles != null && opp.OpportunityContactRoles.size() > 0){
                        oppNew.CountOpportunityContactRole__c = opp.OpportunityContactRoles.size();
                    }
                    if(opp.CloseDate != null && opp.Estimated_Duration__c != null){
                        oppNew.CloseDate = opp.CloseDate.addMonths(Integer.valueOf(opp.Estimated_Duration__c));
                        oppNew.Effective_Date__c = oppNew.CloseDate;
                        oppNew.AddOnUpSaleEndDate__c = oppNew.CloseDate;
                        oppNew.Estimated_Start_Date__c = oppNew.CloseDate;
                    }
                    if(opp.AddOnUpSaleEngagementNumber__c != null){
                        oppNew.AddOnUpSaleEngagementNumber__c = opp.AddOnUpSaleEngagementNumber__c;
                    }
                    lstOppLineItems = new List<OpportunityLineItem>();
                    lstOppLineItems.addAll(opp.opportunitylineitems);
                    mapOfOppLineItems.put(opp.Id,lstOppLineItems);
                    if(opp.OpportunityContactRoles != null && opp.OpportunityContactRoles.size() > 0){
                        lstOppContactRoles = new List<OpportunityContactRole>();
                        lstOppContactRoles.addAll(opp.OpportunityContactRoles);
                        mapOfContactRole.put(opp.Id,lstOppContactRoles);
                    }
                    lstOFNewOpps.add(oppNew);   
                }
            }
        }
        if(lstOFNewOpps != null && lstOFNewOpps.size() > 0){
            Database.insert(lstOFNewOpps);
            createOppLineItemsContactRoles(lstOFNewOpps,mapOfOppLineItems,mapOfContactRole);
        }
    }
    
    public static void createOppLineItemsContactRoles(List<Opportunity> lstOfOpps, Map<Id,List<OpportunityLineItem>> mapOfOppLineItems, Map<Id,List<OpportunityContactRole>> mapOfContactRoles){
        OpportunityContactRole opportunityContactRoleNew;
        OpportunityLineItem oppLineItemNew;
        Opportunity oppUpdate;
        List<sObject> lstOfConRolesOppLineItems = new List<sObject>();
        List<Opportunity> lstOfUpdatedOpps = new List<Opportunity>();
        for(Opportunity opp : lstOfOpps){
            if(mapOfOppLineItems.keyset().contains(opp.Opportunity_Id__c) && mapOfOppLineItems.get(opp.Opportunity_Id__c) != null){
                for(OpportunityLineItem oppLineItem : mapOfOppLineItems.get(opp.Opportunity_Id__c)){
                    oppLineItemNew = new OpportunityLineItem();
                    oppLineItemNew.geography__c = oppLineItem.geography__c;
                    oppLineItemNew.opportunityId = opp.Id;
                    oppLineItemNew.Product2Id= oppLineItem.Product2Id;
                    oppLineItemNew.Elite_Department_ID__c = oppLineItem.Elite_Department_ID__c;
                    oppLineItemNew.Offering__c = oppLineItem.Offering__c;
                    oppLineItemNew.Practice__c = oppLineItem.Practice__c;
                    oppLineItemNew.Service_Line_or_Product__c = oppLineItem.Service_Line_or_Product__c;
                    oppLineItemNew.Elite_Service_Line__c = oppLineItem.Elite_Service_Line__c;
                    oppLineItemNew.Elite_Service_Line_ID__c = oppLineItem.Elite_Service_Line_ID__c;
                    oppLineItemNew.Elite_Department__c = oppLineItem.Elite_Department__c;
                    oppLineItemNew.Module_or_Accelerator2__c = oppLineItem.Module_or_Accelerator2__c;
                    oppLineItemNew.Offering_Lost__c = oppLineItem.Offering_Lost__c;
                    oppLineItemNew.Amount__c = oppLineItem.Amount__c;
                    oppLineItemNew.unitprice= oppLineItem.unitprice;
                    oppLineItemNew.PricebookEntryId = oppLineItem.PricebookEntryId;
                    lstOfConRolesOppLineItems.add(oppLineItemNew);
                }
            }
            if(mapOfContactRoles.keyset().contains(opp.Opportunity_Id__c) && mapOfContactRoles.get(opp.Opportunity_Id__c) != null){
                for(OpportunityContactRole oppConRole : mapOfContactRoles.get(opp.Opportunity_Id__c)){
                    opportunityContactRoleNew = new OpportunityContactRole();
                    opportunityContactRoleNew.ContactId = oppConRole.contactId;
                    opportunityContactRoleNew.role = oppConRole.role;
                    opportunitycontactroleNew.opportunityId = opp.Id;
                    lstOfConRolesOppLineItems.add(opportunityContactRoleNew);
                }
            }
            oppUpdate = new Opportunity(Id = opp.Id);
            oppUpdate.stageName = 'Explore (15-29%)';
            lstOfUpdatedOpps.add(oppUpdate);
        }
        if(lstOfConRolesOppLineItems != null && lstOfConRolesOppLineItems.size() > 0){
            Database.insert(lstOfConRolesOppLineItems); 
        }
        if(lstOfUpdatedOpps != null && lstOfUpdatedOpps.size() > 0){
            Database.update(lstOfUpdatedOpps);
        }
    }
}