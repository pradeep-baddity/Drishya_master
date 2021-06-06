@isTest(SeeAllData=false)
public class ExtensionOpportunityCreation_Test{
    Public static String accRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('NonClient').getRecordTypeId();
    Public static String healthCareRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('HC_Single_or_Child').getRecordTypeId();
    
    /*Test setup method to create required data for below test methods.
    https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_testing_testsetup_using.htm
    */
    @testSetup static void setup() {
    
        test.starttest();
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        system.debug('Account -->'+acc);
        
        Contact con = new Contact();
        con.FirstName='Test';
        con.LastName='Test';
        con.Accountid= acc.id;
        con.Job_Function__c='Admissions';
        con.Job_Level__c='Dean';
        
        insert con;   
        Id pricebookId = Test.getStandardPricebookId();
        Pricebook2 pb2 = new Pricebook2();
        pb2.name = 'Business A Price Book';
        pb2.IsActive = true;
        insert pb2;
        
        Product2 svc2 = new Product2();
        svc2.name = 'Analytics - Core';
        svc2.IsActive = true;
        svc2.CanUseRevenueSchedule = true;
        insert svc2;
        
        //*Standard pricebook entry
        PricebookEntry pbe2 = new PricebookEntry();
        pbe2.Pricebook2Id = Test.getStandardPricebookId(); 
        pbe2.Product2Id = svc2.id;
        pbe2.UnitPrice = 1;
        pbe2.CurrencyIsoCode  = 'USD';
        pbe2.IsActive = true;
        insert pbe2;
        
        PricebookEntry pbe3 = new PricebookEntry();
        //*Standard forecasting pricebook entry
        pbe3.Pricebook2Id = pb2.id;
        pbe3.Product2Id = svc2.id;
        pbe3.IsActive = true;
        pbe3.CurrencyIsoCode  = 'USD';
        pbe3.UnitPrice = 1;
        insert pbe3;
        
        Opportunity opp = new Opportunity(); //creating 1st Opp
        opp.AccountId = acc.Id;
        opp.Name = 'Test 1Opp';
        opp.recordtypeId = healthCareRecTypeId;
        opp.Type = 'Extension Opportunity';
        opp.AutoCreateRenewal__c = True;
        opp.Amount = 2000;
        opp.Estimated_Duration__c = 2;
        opp.LeadSource = 'Demo Request';
        opp.StageName = 'Prospect (0-14%)';
        opp.CloseDate = system.today();
        //opp.Pricebook2Id = priceBookId;
        opp.Estimated_Start_Date__c = system.today();
        
        if(opp !=null){
        insert opp;
        }
        
        
        OpportunityLineItem  oli = new OpportunityLineItem();
        
        oli.PricebookEntryId = pbe3.Id;
        //oli.Product2Id = svc2.Id;
        oli.OpportunityId = opp.id;
        oli.Quantity = 1;
        oli.UnitPrice = 1;
        oli.Product_Schedule_Created__c = false;
        oli.Offering_Lost__c = false;
        insert oli;
        
        Test.stopTest();
    
        
    }//test setup method END
    
    @isTest static void insertOppsLineItemsConRoles(){
        
        Product2 svc2 = new Product2();
        svc2.name = 'Strategy';
        svc2.IsActive = true;
        svc2.CanUseRevenueSchedule = true;
        insert svc2;
        Id priceBookId = Test.getStandardPricebookId();
        PricebookEntry pbe2 = new PricebookEntry();
        pbe2.Pricebook2Id = priceBookId; 
        pbe2.Product2Id = svc2.id;
        pbe2.UnitPrice = 1;
        pbe2.CurrencyIsoCode  = 'USD';
        pbe2.IsActive = true;
        insert pbe2;
        
        Account acc = new Account();
        acc.RecordTypeId = accRecTypeId;
        acc.Name = 'Test Acc';
        insert acc;
        
        Opportunity oppNew = new Opportunity();
        oppNew.AccountId = acc.Id;
        oppNew.Name = 'Auto Extension';
        oppNew.recordtypeId = healthCareRecTypeId;
        oppNew.Type = 'AddOn/UpSell';
        oppNew.AutoCreateRenewal__c = False;
        oppNew.Amount = 2000;
        oppNew.Estimated_Duration__c = 2;
        oppNew.LeadSource = 'Demo Request';
        oppNew.StageName = 'Prospect (0-14%)';
        oppNew.CloseDate = system.today();
        oppNew.Pricebook2Id = priceBookId;
        oppNew.Estimated_Start_Date__c = system.today();
        insert oppNew;
        
        
         PricebookEntry pbe3 = new PricebookEntry();
        //*Standard forecasting pricebook entry
        pbe3.Pricebook2Id = pbe2.id;
        pbe3.Product2Id = svc2.id;
        pbe3.IsActive = true;
        pbe3.CurrencyIsoCode  = 'USD';
        pbe3.UnitPrice = 1;
        //insert pbe3;
        
        
        OpportunityLineItem  oli = new OpportunityLineItem();
        oli.PricebookEntryId = pbe2.Id;
        oli.OpportunityId = oppNew.id;
        oli.Quantity = 1;
        oli.UnitPrice = 1;
        oli.Product_Schedule_Created__c = false;
        oli.Offering_Lost__c = false;
        oli.Elite_Department_ID__c = '1458';
        oli.Offering__c = 'Strategy';
        oli.Service_Line_or_Product__c = 'Commercial Strategy';
        insert oli; 
        
        Contact con = new Contact();
        con.FirstName='Test';
        con.LastName='Test';
        con.Accountid= acc.id;
        con.Job_Function__c = 'Operations';
        con.Job_Level__c = 'Professor';
        insert con; 
        
        OpportunityContactRole opportunityContactRoleNew = new OpportunityContactRole();
        opportunityContactRoleNew.ContactId = con.Id;
        opportunityContactRoleNew.role = 'Analyst';
        opportunitycontactroleNew.opportunityId = oppNew.Id;
        insert opportunitycontactroleNew;
        
        Opportunity oppUpdate = new Opportunity(Id = oppNew.Id);
        oppUpdate.stageName = 'Explore (15-29%)';
        oppUpdate.AutoCreateRenewal__c = true;
        update oppUpdate;
    }
}