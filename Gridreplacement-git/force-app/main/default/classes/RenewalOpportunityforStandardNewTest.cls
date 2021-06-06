@isTest(seealldata=false)
public class RenewalOpportunityforStandardNewTest {
    public static testmethod void Insert_data() {
                     Profile profile_Id = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
           Id opportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Healthcare Software').getRecordTypeId();
      
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
                                                                                     StageName = 'Closed Won (100%)',
                                                                                     Type ='Standard Opportunity',
                                                                                     AutoCreateRenewal__c = True,
                                                                                     RenewalCreated__c = false),
                                                                     'CRM_TestFactory.OpportunityDefaults');
        INSERT opp;
          OpportunityLineItem oli = (OpportunityLineItem)CRM_TestFactory.createSobject(new OpportunityLineItem(OpportunityId = opp.Id,
                                                                                                             Offering__c = 'Software',
                                                                                                             Product2Id = prod.Id,
                                                                                                             Renew__c=True,
                                                                                                            Service__c='Change Management and Leadership',
                                                                                                            Offering_Lost__c=False),
                                                                                     'CRM_TestFactory.OpportunityLineItemDefaults');
        INSERT oli;
        update oli;
      
         
 OpportunityContactRole orole=(OpportunityContactRole)CRM_TestFactory.createSobject(new OpportunityContactRole(ContactId = con.Id,OpportunityId = opp.Id),'CRM_TestFactory.OpportunityContactRoleDefaults');	         
         
        insert orole;
             user usr=(user)CRM_TestFactory.createSObject(new user(ProfileId=profile_Id.id),'CRM_TestFactory.UserDefaults');
        insert usr;
        System.debug('User'+usr);
        
          Test.startTest();
   RenewalOpportunityforStandardNew obj = new RenewalOpportunityforStandardNew();
     
   Database.executeBatch(obj);
Test.stopTest();
        
         
     }


}