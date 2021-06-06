@isTest
public class HC_SplitOpportunityTestClass {
    
    @IsTest public static void hcOppRecordInsert() {
        Id opportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Healthcare Opportunities').getRecordTypeId();
        
        Account acc = (Account)CRM_TestFactory.createSObject(new Account(),'CRM_TestFactory.AccountDefaults');
        INSERT acc;
        
        Contact con = (Contact)CRM_TestFactory.createSObject(new Contact(AccountId = acc.Id),'CRM_TestFactory.ContactDefaults');
        INSERT con;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        Product2 prod = (Product2)CRM_TestFactory.createSObject(new Product2(),'CRM_TestFactory.Product2Defaults');
        INSERT prod;
        
        PricebookEntry pbe = (PricebookEntry)CRM_TestFactory.createSObject(new PricebookEntry(pricebook2id = pricebookId, 
                                                                                              Product2Id = prod.Id),
                                                                           'CRM_TestFactory.PricebookEntryDefaults');
        INSERT pbe;


        
        Opportunity opp = (Opportunity)CRM_TestFactory.createSObject(new Opportunity(Pricebook2Id = pricebookId,
                                                                                     recordtypeid = opportunityRecordTypeId,
                                                                                     AccountId = acc.Id,
                                                                                     EPM_Sales_Lead__c = con.Id,
                                                                                     StageName = 'Prospect (0-14%)',
                                                                                    Type ='Standard Opportunity',
                                                                                    AutoCreateRenewal__c = True,
                                                                                    RenewalCreated__c = false),
                                                                     'CRM_TestFactory.OpportunityDefaults');
        test.starttest();
        INSERT opp;
        test.stoptest();
        
        OpportunityLineItem oli = (OpportunityLineItem)CRM_TestFactory.createSobject(new OpportunityLineItem(OpportunityId = opp.Id, 
                                                                                                            Product2Id = prod.Id,
                                                                                                            PricebookEntryId = pbe.Id,
                                                                                                            Service__c='Advisory Services',
                                                                                                             Technology_Vendor__c='Jaggaer',
                                                                                                             Technology_Capability__c='E-Business Suite',
                                                                                                             Expertise__c='Business Operations',
                                                                                                            Elite_Service_Line_ID__c = 'HC103'),
                                                                                     'CRM_TestFactory.OpportunityLineItemDefaults');
        INSERT oli;
        
        List<String> selectedOli = new List<String>();
        selectedOli.add(oli.Id);
        
        OpportunityContactRole oppContactRole = (OpportunityContactRole)CRM_TestFactory.createSobject(new OpportunityContactRole
                                                                                                      (ContactId = con.Id,
                                                                                                            OpportunityId = opp.Id),
                                                                                     'CRM_TestFactory.OpportunityContactRoleDefaults');
        INSERT oppContactRole;
        
        /*OpportunityLineItemSchedule oppLISchedule = (OpportunityLineItemSchedule)CRM_TestFactory.createSobject
            (new OpportunityLineItemSchedule (OpportunityLineItemId = oli.Id, Revenue = oli.Amount__c), 
             'CRM_TestFactory.OpportunityLineItemScheduleDefaults');
        INSERT oppLISchedule;*/
        
        HC_SplitOpportunity.getOppLines(opp.id);
        HC_SplitOpportunity.createOpportunity(opp.id, 'Google', selectedOli);
    }
    
}