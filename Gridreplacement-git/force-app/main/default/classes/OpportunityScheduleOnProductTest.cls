/***************************************************************************************
Class Name        : opportunityscheduleTest
Description       : This is the test class coverage for the helper class OpportunityScheduleOnProduct
Created By        : Arif Hussain
Created Date      : Dec-04-2018
Last Modified By  : Arif Hussain
****************************************************************************************/
@isTest
public class OpportunityScheduleOnProductTest{
    public static list<opportunity> listopp =  new list<opportunity>();
    public static List<OpportunityLineItem> lineitem = new List<OpportunityLineItem>();
    public static List<OpportunityLineItem> lineitemnew = new List<OpportunityLineItem>();
    public static List<OpportunityLineItem> lineitemnewone = new List<OpportunityLineItem>();
    public static List<OpportunityLineItemSchedule> schedules = new List<OpportunityLineItemSchedule>();   
        
        public static testmethod void insertrecords(){
        User u = [select id,isActive from User where profile.Name = 'System Administrator'And IsActive=true limit 1];
        
        system.runas(u){
        
       
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        system.debug('Account -->'+acc);
        
        Contact con = new Contact();
        con.FirstName='Test';
        con.LastName='Test';
        con.Accountid= acc.id;
        con.Job_Function__c = 'Administration';
        con.Job_Level__c = 'Professor';
        
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
        
        insert newopp;
        //test.starttest();
        OpportunityLineItem  oli = new OpportunityLineItem();
        
        oli.PricebookEntryId = pbe3.Id;
        oli.OpportunityId = newopp.id;
        oli.Quantity = 1;
        oli.UnitPrice = 1;
        oli.Product_Schedule_Created__c = false;
        insert oli;
        
        opportunity oppnewline = new Opportunity(Id = newOpp.id);
        oppnewline.StageName = 'Commit (85-99%)';
        
        update oppnewline;
        //test.stoptest();
        system.debug('new stage-->'+oppnewline);
        system.debug('Product count-->'+newOpp.Product_Count__c);
        Opportunity oppAfterInsert = [Select Product_Count__c from Opportunity where Id= :newOpp.Id];
        system.debug('Product count new-->'+newOpp.Product_Count__c);
        Opportunitylineitem oppproductAfterInsert = [Select Id,Product_Schedule_Created__c, Opportunity_Stage__c ,opportunityid from Opportunitylineitem where Id = :oli.Id];
        listopp.add(newOpp);
        
        
        system.debug('oppproductAfterInsert-->'+oppproductAfterInsert);
        
        
        OpportunityLineItem  olli = new OpportunityLineItem();
        olli.PricebookEntryId = pbe3.Id;
        olli.OpportunityId = newopp.id;
        olli.Quantity = 1;
        olli.UnitPrice = 1;
        olli.Amount__c = 1;
        olli.Product_Schedule_Created__c = false;
        
            insert olli;
        system.debug('olli-->'+olli);
        //lineitem.add(olli);
        system.debug('lineitem-->'+lineitem);
        Opportunitylineitem oppproductAfterInsertnew = [Select Id,Product_Schedule_Created__c, Opportunity_Stage__c ,offering_lost__c,UnitPrice,opportunityid from Opportunitylineitem where Id = :olli.Id];
        system.debug('oppproductAfterInsertnew-->'+oppproductAfterInsertnew);
        recursiveTriggerhandler.isFirstTime = true;
        test.starttest();
        olli.Amount__c = 10;
        update olli;
        lineitemnew.add(olli);
        olli.offering_lost__c = true;
        update olli;
        test.stoptest();
        lineitemnewone.add(olli);
        system.debug('olli new -->'+lineitemnew);
        recursiveTriggerhandler.isFirstTime = false;
        OpportunityLineItemschedule s = new OpportunityLineItemschedule();
        s.Revenue = 500;
        s.ScheduleDate =  system.today()+10;
        s.OpportunityLineItemId = oppproductAfterInsertnew.id;
        s.Type = 'Revenue';
        insert s;
        system.debug('schedule-->'+s);
        
        schedules.add(s);
        
         
        }
        
        
       // }
    }
    
    
    Public static testmethod void test1(){
        insertrecords();
        //test.starttest();
        
        OpportunityScheduleonproduct.OpportunityScheduleCreation(lineitem);
        //test.stoptest();
    }
    Public static testmethod void test2(){
        insertrecords();
        //test.starttest();
        //insertrecords();
        opportunityproductupdateammount.OpportunityScheduleCreation(lineitemnew);
        //test.stoptest();
    }
    Public static testmethod void test3(){
        insertrecords();
        //test.starttest();
        //insertrecords();
        lostOpportunityOffering.lostOffering(lineitemnewone);  
        //test.stoptest();
    }
    
    Public static testmethod void test4(){
        insertrecords();
        //test.starttest();
        //insertrecords();
        lostofferingwon.lostOffering(lineitemnewone);  
        //test.stoptest();
    }
    
    Public static testmethod void test5(){
        insertrecords();
        //test.starttest();
        //insertrecords();
        OpportunitySchedule.OpportunityScheduleCreation(listopp);
        //test.stoptest();
    }
    
    
}