/***************************************************************************************
Class Name        : OpportunityContactRole_TestClass
Description       : This is the test class coverage for the helper class OpportunityContactRole_TestClass
Created By        : Arif Hussain
Created Date      : 08-June-2019
Last Modified By  : Arif Hussain
****************************************************************************************/
@isTest
public class OpportunityContactRole_TestClass {
        public static testmethod void insertrecords(){
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
            
        Contact con = new Contact();
        con.FirstName='Test';
        con.LastName='Test';
        con.Accountid= acc.id;
        con.Job_Function__c = 'Administration';
        con.Job_Level__c = 'Professor';
        insert con; 
            
            Pricebook2 pb2 = new Pricebook2();
        pb2.name = 'Business A Price Book';
        pb2.IsActive = true;
        insert pb2;
        
        Product2 svc2 = new Product2();
        svc2.name = 'Performance Improvement';
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
        //test.starttest();
        //system.runAs(u){
        Opportunity newOpp =  new Opportunity();
        newOpp.recordtypeid = '012U0000000Mfhr';
        newOpp.Name = 'Google';
        newOpp.AccountId = acc.id;
        //newOpp.ES_A_BDM_Role__c = 'Change Order' ;
        newOpp.EPM_Sales_Lead__c = con.Id ;
        //newOpp.CurrencyIsoCode = 'USD';
        newOpp.closeDate = system.today()+5;
        newOpp.Estimated_Start_Date__c   = system.today()+10;
        newOpp.Estimated_Duration__c  = 3;
        newOpp.Oppty_Product_schedule_created__c = false;
        newOpp.Industry__c = 'Agriculture';
        newOpp.EPM_Region__c = 'Higher Ed';
        newOpp.Pricing_Review_Status__c = 'Not Submitted';
        newOpp.StageName = 'Prospect (0-14%)';
        newOpp.ownerid = '0050B000007vgOS';
        newOpp.amount = 5000;
        //newOpp.Pricebook2Id = Test.getStandardPricebookId();
        // if(newopp!= null){
        insert newopp;
          
            opportunitycontactrole oc = new opportunitycontactrole();
            oc.ContactId = con.id;
            oc.OpportunityId = newOpp.id;
            oc.Role = 'Coach';
            insert oc;
        //    AggregateResult[]  opportunityContactRoleAgg = [select opportunityid, count(id) totalCount from OpportunityContactRole 
        //                                                    where opportunityid IN:= oc.OpportunityId group by opportunityid LIMIT 10];
            
        }
}