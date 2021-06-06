/***************************************************************************************
Class Name        : opportunityscheduleTest
Description       : This is the test class coverage for the helper class Opportunityschedule
Created By        : Arif Hussain
Created Date      : Nov-12-2018
Last Modified By  : Arif Hussain
****************************************************************************************/
@isTest
public class OpportunityTestforpricebook{
    public static list<opportunity> listopp =  new list<opportunity>();
    //system.runAs(u){
        
    public static testmethod void insertrecords(){
        //User u = [select id,isActive from User where profile.Name = 'System Administrator'And IsActive=true limit 1];
        test.starttest();
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;

        system.debug('Account -->'+acc);

        Contact con = new Contact();
        con.FirstName='Test';
        con.LastName='Test';
        con.Accountid= acc.id;

        insert con;   
        system.debug('Contact -->'+con);
        Id pricebookId = Test.getStandardPricebookId();
        system.debug('pricebookId -->'+pricebookId);
        
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
        pbe2.Pricebook2Id = '01sU0000000NKbMIAW'; 
        pbe2.Product2Id = svc2.id;
        pbe2.UnitPrice = 1;
        pbe2.CurrencyIsoCode  = 'USD';
        pbe2.IsActive = true;
        insert pbe2;

        PricebookEntry pbe3 = new PricebookEntry();
        //*Standard forecasting pricebook entry
        pbe3.Pricebook2Id = '01s0B000000sOct';
        pbe3.Product2Id = svc2.id;
        pbe3.IsActive = true;
        pbe3.CurrencyIsoCode  = 'USD';
        pbe3.UnitPrice = 1;
        insert pbe3;

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
        newOpp.Pricebook2Id = Test.getStandardPricebookId();
      
        insert newopp;

        OpportunityLineItem  oli = new OpportunityLineItem();
    
        oli.PricebookEntryId = pbe2.Id;
        //oli.Product2Id = svc2.Id;
        oli.OpportunityId = newopp.id;
        oli.Quantity = 1;
        oli.UnitPrice = 1;
        //oli.Quantity = 1;
        //oli.totalprice = 100;
        //oli.CurrencyIsoCode = 'USD';
        insert oli;
        
            newOpp.StageName = 'Commit (85-99%)';
            system.debug('new stage-->'+newOpp.StageName);
            system.debug('Product count-->'+newOpp.Product_Count__c);
            Opportunity oppAfterInsert = [Select Product_Count__c from Opportunity where Id= :newOpp.Id];
            //update newopp;
            listopp.add(newOpp);
            //update listopp;
            
            OpportunityLineItemschedule s = new OpportunityLineItemschedule();
            s.Revenue = 500;
            s.ScheduleDate =  system.today()+10;
            s.OpportunityLineItemId = oli.id;
            s.Type = 'Revenue';
            insert s;
            system.debug('schedule-->'+s);
            test.stoptest();
        }
    //}
    
    Public static testmethod void test1(){
        insertrecords();
        OpportunitySchedule.OpportunityScheduleCreation(listopp);
              
        }
}