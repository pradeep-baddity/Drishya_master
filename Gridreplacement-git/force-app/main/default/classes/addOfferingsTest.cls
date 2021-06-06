@istest(seealldata=false)
public class addOfferingsTest {
    public static testmethod void insertData(){
                  Profile profile_Id = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
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
          
        Id opportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Healthcare Software').getRecordTypeId();
      // Id pricebookId = Test.getStandardPricebookId();
        
       Opportunity opp = (Opportunity)CRM_TestFactory.createSObject(new Opportunity(Pricebook2Id = pricebookId,
                                                                                    recordtypeid = opportunityRecordTypeId,
                                                                                     AccountId = acc.Id,
                                                                                     EPM_Sales_Lead__c = con.Id,
                                                                                     StageName = 'Closed Won (100%)',
                                                                                     Type ='Renewal Opportunity',
                                                                                     AutoCreateRenewal__c = True,
                                                                                     RenewalCreated__c = false,
                                                                                   Probability=0),
                                                                     'CRM_TestFactory.OpportunityDefaults');
        INSERT opp;
        
            Opportunity opp1 = (Opportunity)CRM_TestFactory.createSObject(new Opportunity(Pricebook2Id = pricebookId,
                                                                                    recordtypeid = opportunityRecordTypeId,
                                                                                     AccountId = acc.Id,
                                                                                     EPM_Sales_Lead__c = con.Id,
                                                                                     StageName = 'Closed Won (100%)',
                                                                                     Type ='Renewal Opportunity',
                                                                                     AutoCreateRenewal__c = True,
                                                                                     RenewalCreated__c = false,
                                                                                   Probability=70),
                                                                     'CRM_TestFactory.OpportunityDefaults');
        INSERT opp1;
        
         
         addOfferings.getOfferinggs(opp.id);
          OpportunityLineItem oli = (OpportunityLineItem)CRM_TestFactory.createSobject(new OpportunityLineItem(OpportunityId = opp.Id,
                                                                                                             Offering__c = 'Software',
                                                                                                             Product2Id = prod.Id,
                                                                                                             Renew__c=True,
                                                                                                            //  PricebookEntryId=pbe.id,
                                                                                                            // Offering_Service__c='Performance Improvement Technology',
                                                                                                            Offering_Lost__c=False
                                                                                                              ),
                                                                                     'CRM_TestFactory.OpportunityLineItemDefaults');
        INSERT oli;
        if(opp.Probability>=30)
        {
             addOfferings.getOfferinggs(opp.id);

        }
        if(opp.Probability<=30)
        {
            addOfferings.getOfferinggs(opp.id);
        }
        
         addOfferings.getOfferinggs(opp.id);
        addOfferings.getOfferinggs(opp1.id);
        addOfferings.searchbyProdname('search', opp.id);
        addOfferings.searchbyProdname(' ', opp.id);
       // String jsonInput = '{"email":"are02@gmail.com","LastName":"ABCD","FirstName":"ACFPY","Suffix":"","Title":"Engineer","Psw":"","PhoneCode":"","Phone":"100-000-000"}';
         
        Test.startTest();
      //  addOfferings.saveOpportunityLiItems(jsonInput);
        
        Test.stopTest();
        
    }

}