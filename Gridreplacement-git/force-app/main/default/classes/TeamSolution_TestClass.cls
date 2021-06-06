/***************************************************************************************
Class Name        : TeamSolution_TestClass
Description       : This is the test class coverage for the helper class teamSolutioncreation and updateAmountonTeamsolution
Created By        : Arif Hussain
Created Date      : 08-June-2019
Last Modified By  : Arif Hussain
****************************************************************************************/
@isTest
public class TeamSolution_TestClass{
    public static list<opportunity> listopp =  new list<opportunity>();
    public static List<OpportunityLineItem> lineitem = new List<OpportunityLineItem>();
    public static List<OpportunityLineItem> lineitemnew = new List<OpportunityLineItem>();
    public static List<OpportunityLineItem> lineitemnewone = new List<OpportunityLineItem>();
    
    
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
            
            insert newopp;
            test.starttest();
            OpportunityLineItem  oli = new OpportunityLineItem();
            
            oli.PricebookEntryId = pbe3.Id;
            oli.OpportunityId = newopp.id;
            oli.product2Id = svc2.Id;
            oli.Quantity = 1;
            oli.UnitPrice = 1;
            oli.Expertise__c ='Business Operations' ;
            oli.Practice__c = 'Healthcare';
            //oli.offering__c = 'Performance Improvement';
            //oli.Service_Line_or_Product__c = 'Core PI Implementation';
            oli.Product_Schedule_Created__c = false;
            oli.Capability_new__c = 'Care';
            //oli.product2.Name = 'Performance Improvement';
            oli.Service__c = 'Sustained Performance Services';
            insert oli;
            system.debug('oli--->'+oli);
            
            Team_Solution__c ts = new Team_Solution__c();
          ts.Name = oli.product2.Name + ' - Team Solution';
            ts.Opportunity__c= newopp.id;
            ts.Capability__c = oli.Capability_new__c;
            ts.Service__c = oli.Service__c;
            ts.price__c = oli.UnitPrice;
            //ts.ServiceLine_or_product__c = oli.Service_Line_or_Product__c;
            insert ts;
            system.debug('ts-->'+ts);
            test.stoptest();
        }
    }
    
}