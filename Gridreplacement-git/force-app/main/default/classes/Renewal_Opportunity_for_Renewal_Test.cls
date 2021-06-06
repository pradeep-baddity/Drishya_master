@isTest(seealldata=false)
public class Renewal_Opportunity_for_Renewal_Test {
    
    
   public static testmethod void Insert_data() {
        
        Id opportunityRecordTypeId = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('Healthcare Software').getRecordTypeId();
       Profile profile_Id = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
     Account acc = (Account)CRM_TestFactory.createSObject(new Account(),'CRM_TestFactory.AccountDefaults');
        INSERT acc;
        
        Contact con = (Contact)CRM_TestFactory.createSObject(new Contact(AccountId = acc.Id),'CRM_TestFactory.ContactDefaults');
        INSERT con;
        
        Id pricebookId = Test.getStandardPricebookId();
       
         // Create a custom price book
       // Pricebook2 customPB = new Pricebook2(Name='Huron 2021', isActive=true);
        //insert customPB;
        
        Product2 prod = (Product2)CRM_TestFactory.createSObject(new Product2(),'CRM_TestFactory.Product2Defaults');
        INSERT prod;
        
       PricebookEntry pbe = (PricebookEntry)CRM_TestFactory.createSObject(new PricebookEntry(Pricebook2Id = pricebookId, 
                                                                                              Product2Id = prod.Id),
                                                                           'CRM_TestFactory.PricebookEntryDefaults');
        INSERT pbe;
       
       /* PricebookEntry pbe = (PricebookEntry)CRM_TestFactory.createSObject(new PricebookEntry(Pricebook2Id = customPB.id, 
                                                                                              Product2Id = prod.Id),
                                                                           'CRM_TestFactory.PricebookEntryDefaults');
        INSERT pbe;*/
       
       

        // 2. Insert a price book entry with a custom price.
       /* PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = prod.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice;*/

        
        //For RenewalOpportunityforStandardStuderMYR Class - Start
        Opportunity opp = (Opportunity)CRM_TestFactory.createSObject(new Opportunity(Pricebook2Id = pricebookId,
                                                                                     recordtypeid = opportunityRecordTypeId,
                                                                                     AccountId = acc.Id,
                                                                                     
                                                                                     EPM_Sales_Lead__c = con.Id,
                                                                                     StageName = 'Prospect (0-14%)',
                                                                                     Type ='Renewal Opportunity',
                                                                                     AutoCreateRenewal__c = True,
                                                                                     RenewalCreated__c = false
                                                                                   ),
                                                                     'CRM_TestFactory.OpportunityDefaults');
        INSERT opp;
        OpportunityLineItem oli4 = (OpportunityLineItem)CRM_TestFactory.createSobject(new OpportunityLineItem(OpportunityId = opp.Id,
                                                                                                              Product2Id = prod.Id,
                                                                                                             PricebookEntryId=pbe.id,
                                                                                                             Service__c='Performance Improvement Technology',
                                                                                                            Renew__c=True,
                                                                                                            Offering_Lost__c=False),
                                                                                                            
                                                                                      'CRM_TestFactory.OpportunityLineItemDefaults');
        INSERT oli4;
      // update oli4;
 
     OpportunityContactRole orole=(OpportunityContactRole)CRM_TestFactory.createSobject(new OpportunityContactRole(ContactId = con.Id,OpportunityId = opp.Id),'CRM_TestFactory.OpportunityContactRoleDefaults');	         
         
        insert orole;
        
        user usr=(user)CRM_TestFactory.createSObject(new user(ProfileId=profile_Id.id),'CRM_TestFactory.UserDefaults');
        insert usr;
        System.debug('User'+usr);
        
 
    
        Test.startTest();
      
        Renewal_Opportunity_for_Renewal obj3 = new Renewal_Opportunity_for_Renewal();
        DataBase.executeBatch(obj3);
       Test.stopTest();
        
}
}