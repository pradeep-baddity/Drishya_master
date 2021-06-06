@isTest
public class AggregateTCVRollup_Test {
    
    @IsTest public static void TCVRollupTest() {
        
        List<OpportunityLineItem> oppItemList = new List<OpportunityLineItem>();
        List<Opportunity> oppList = new List<Opportunity>();
        Id opportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Healthcare Opportunities').getRecordTypeId();
        
        Account acc = (Account)CRM_TestFactory.createSObject(new Account(),'CRM_TestFactory.AccountDefaults');
        INSERT acc;
        
        Contact con = (Contact)CRM_TestFactory.createSObject(new Contact(AccountId = acc.Id),'CRM_TestFactory.ContactDefaults');
        INSERT con;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        Product2 prod = (Product2)CRM_TestFactory.createSObject(new Product2(),'CRM_TestFactory.Product2Defaults');
        INSERT prod;
        
        PricebookEntry pbe = (PricebookEntry)CRM_TestFactory.createSObject(new PricebookEntry(Pricebook2Id = pricebookId, 
                                                                                              Product2Id = prod.Id),
                                                                           'CRM_TestFactory.PricebookEntryDefaults');
        INSERT pbe;
        
        //For RenewalOpportunityforStandardStuderMYR Class - Start
        Opportunity opp = (Opportunity)CRM_TestFactory.createSObject(new Opportunity(Pricebook2Id = pricebookId,
                                                                                     recordtypeid = opportunityRecordTypeId,
                                                                                     AccountId = acc.Id,
                                                                                     EPM_Sales_Lead__c = con.Id,
                                                                                     StageName = 'Prospect (0-14%)',
                                                                                     Type ='Standard Opportunity',
                                                                                     AutoCreateRenewal__c = True,
                                                                                     RenewalCreated__c = false),
                                                                     'CRM_TestFactory.OpportunityDefaults');
        INSERT opp;
        oppList.add(opp);
        
        
        OpportunityLineItem oli = (OpportunityLineItem)CRM_TestFactory.createSobject(new OpportunityLineItem(OpportunityId = opp.Id,
                                                                                                             Offering__c = 'Leadership Academy',
                                                                                                             Product2Id = prod.Id,
                                                                                                             Elite_Service_Line_ID__c = 'HC180',
                                                                                                             Service_Line_or_Product__c = 'Conferences'),
                                                                                     'CRM_TestFactory.OpportunityLineItemDefaults');
        INSERT oli;
        
        oppItemList.add(oli);
        AggregateTCVRollup.TCVRollup(oppItemList);
        //opportunityTCVUpdate.TCVvalueUpdate(oppList);
    }
    
}