/***************************************************************************************
Class Name        : opportunityscheduleTest
Description       : This is the test class coverage for the helper class Opportunityschedule
Created By        : Arif Hussain
Created Date      : Nov-12-2018
Last Modified By  : Arif Hussain
****************************************************************************************/
@isTest
public class OpportunityscheduleTest{
    public static list<opportunity> listopp =  new list<opportunity>();
    public static List<Opportunity> newList =  new List<Opportunity>();
    public static opportunity newOpp {set;get;}
    public static opportunity oppnewline {set;get;}
    public static List<String> stringIds = new List<String>();
    //String q {set;get;}
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
        con.Job_Function__c='Admissions';
        con.Job_Level__c='Dean';
        
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
        
         newOpp =  new Opportunity();
        newOpp.recordtypeid = '012U0000000Mfhr';
        newOpp.Name = 'Google';
        newOpp.AccountId = acc.id;
        //newOpp.ES_A_BDM_Role__c = 'Change Order' ;
        newOpp.EPM_Sales_Lead__c = con.Id ;
        newOpp.Referred_By_Person__c = con.Id;
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
        
        insert newopp;
        system.debug('newopp-->'+newopp);
        
         oppnewline = new Opportunity(Id = newOpp.id);
        OpportunityLineItem  oli = new OpportunityLineItem();
        
        oli.PricebookEntryId = pbe3.Id;
        //oli.Product2Id = svc2.Id;
        oli.OpportunityId = newopp.id;
        oli.Quantity = 1;
        oli.UnitPrice = 1;
        oli.Product_Schedule_Created__c = false;
        oli.Offering_Lost__c = false;
        insert oli;
        system.debug('oli--->'+oli);
        newOpp.StageName = 'Commit (85-99%)';
        system.debug('new stage-->'+newOpp.StageName);
        system.debug('Product count-->'+newOpp.Product_Count__c);
        Opportunity oppAfterInsert = [Select Product_Count__c from Opportunity where Id= :newOpp.Id];
        system.debug('Product count-->'+newOpp.Product_Count__c);
        listopp.add(newOpp);
        
        update newOpp;
        update listopp;
        
        
        newList.add(newOpp);

        OpportunityLineItemschedule s = new OpportunityLineItemschedule();
        s.Revenue = 500;
        s.ScheduleDate =  system.today()+10;
        s.OpportunityLineItemId = oli.id;
        s.Type = 'Revenue';
        insert s;
        system.debug('schedule-->'+s);
        String q = newOpp.Id; 
        String q2 = newOpp.Name;
        
        //list<String> stringIds = new list<String>();
        for (Opportunitylineitem ocr : [Select Id From opportunityLineItem where Id =:oli.id limit 1])
        
        {
            stringIds.add(ocr.id);
        }
        test.stoptest();
    }
    //}
    
    Public static testmethod void test1(){
        insertrecords();
        OpportunitySchedule.OpportunityScheduleCreation(newList);
        //HC_SplitOpportunity.getOppLines(newOpp.id);
        //HC_SplitOpportunity.createOpportunity(oppnewline.id,'test',stringIds);
        //
    }
}