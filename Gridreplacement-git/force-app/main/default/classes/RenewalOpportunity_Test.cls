@isTest
public class RenewalOpportunity_Test {
    
    @IsTest public static void accList() {
        
        Id EDUId = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('EDU Opportunity').getRecordTypeId();
        
        Account acc = (Account)CRM_TestFactory.createSObject(new Account(),'CRM_TestFactory.AccountDefaults');
        INSERT acc;
        
        Contact con = (Contact)CRM_TestFactory.createSObject(new Contact(AccountId = acc.Id),'CRM_TestFactory.ContactDefaults');
        INSERT con;
        
        Id pricebookId = Test.getStandardPricebookId();
        System.debug('pricebookId'+pricebookId);
        
        Product2 prod = (Product2)CRM_TestFactory.createSObject(new Product2(),'CRM_TestFactory.Product2Defaults');
        INSERT prod;
        
        PricebookEntry pbe = (PricebookEntry)CRM_TestFactory.createSObject(new PricebookEntry(Pricebook2Id = pricebookId, 
                                                                                              Product2Id = prod.Id),
                                                                           'CRM_TestFactory.PricebookEntryDefaults');
        INSERT pbe;
        
        //For EduOpportunityRenewal Class - Start
        
        Opportunity opp = (Opportunity)CRM_TestFactory.createSObject(new Opportunity(Pricebook2Id = pricebookId,
                                                                                      recordtypeid = EDUId,
                                                                                      AccountId = acc.Id,
                                                                                      EPM_Sales_Lead__c = con.Id,
                                                                                      StageName = 'Closed Won (100%)',
                                                                                      Type ='Renewal Opportunity',
                                                                                      closeDate = System.today(),
                                                                                      AutoCreateRenewal__c = True,
                                                                                      Effective_Date__c = System.today() + 10,
                                                                                      AddOnUpSaleEndDate__c = System.today() + 20,
                                                                                      Contract_Expiration_Date__c = System.today() + 30,
                                                                                      RenewalCreated__c = false),
                                                                      'CRM_TestFactory.OpportunityDefaults');
        INSERT opp;    
        
        OpportunityLineItem oli = (OpportunityLineItem)CRM_TestFactory.createSobject(new OpportunityLineItem(OpportunityId = opp.Id,
                                                                                                              Offering__c = 'Software',
                                                                                                              Product2Id = prod.Id,
                                                                                                              Offering_Lost__c = false,
                                                                                                              Renew__c = true,
                                                                                                              Practice__c = 'Education',
                                                                                                              Service_Line_or_Product__c = 'HuRo: HuronRounding'),
                                                                                      'CRM_TestFactory.OpportunityLineItemDefaults');
        INSERT oli;
        
        OpportunityContactRole oppConRole = (OpportunityContactRole)CRM_TestFactory.createSobject(new OpportunityContactRole(ContactId = con.Id,
                                                                                                                             OpportunityId = opp.Id),
                                                                                                  'CRM_TestFactory.OpportunityContactRoleDefaults');
        INSERT oppConRole;
        
        Sales_Credit__c sc1 = new Sales_Credit__c(Opportunity__c = opp.Id, Status__c = 'Open');
        INSERT sc1;
        
        Sales_Credit_Employee__c sce = new Sales_Credit_Employee__c(Sales_Credit__c = sc1.Id);
        INSERT sce;
        
        Opportunity renewedOpp = (Opportunity)CRM_TestFactory.createSObject(new Opportunity(Pricebook2Id = opp.Pricebook2Id,
                                                                                      recordtypeid = EDUId,
                                                                                      AccountId = acc.Id,
                                                                                      EPM_Sales_Lead__c = con.Id,
                                                                                      StageName = 'Commit (85-99%)',
                                                                                      Probability = 85,
                                                                                      Related_Opportunity__c = opp.Id,
                                                                                      SABER_Original_Opportunity_ID__c = opp.Id,
                                                                                      Type ='Renewal Opportunity',
                                                                                      CloseDate = opp.CloseDate.addyears(1),
                                                                                      Estimated_Start_Date__c = opp.Estimated_Start_Date__c.addyears(1),
                                                                                      AutoCreateRenewal__c = True,
                                                                                      Effective_Date__c = opp.Estimated_Start_Date__c.addyears(1),
                                                                                      AddOnUpSaleEndDate__c = opp.Estimated_Start_Date__c.addyears(2).adddays(-1),
                                                                                      Reason_Won__c = 'Existing Customer / Client Relationship',
                                                                                      Competitor__c = System.Label.NoneAccount,
                                                                                      Contract_Expiration_Date__c = System.today() + 30,
                                                                                      Initiate_Renewal__c = opp.Estimated_Start_Date__c.addyears(1).addDays(-90),
                                                                                      Annual_Contract_Change__c = null,
                                                                                      RenewalCreated__c = false),
                                                                      'CRM_TestFactory.OpportunityDefaults');
        INSERT renewedOpp;
        
        
        EduOpportunityRenewal obj = new EduOpportunityRenewal();
        Database.executeBatch(obj);
        
        String sch1 = '0 0 * * * ?';
        EduOpportunityRenewalScheduler eduRenewal = new EduOpportunityRenewalScheduler(); 
        system.schedule('EDU Renewal', sch1, eduRenewal);
        
    }
}