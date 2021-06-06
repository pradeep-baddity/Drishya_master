@isTest
public class OpportunityValidationErrorHandlerTest {
    
    //@testsetup
    public static void opportunityErrorHandlerMethod(){
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name IN ('HC Restricted User','HC Non-Restricted User') LIMIT 1];
        
        Id opportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Healthcare Opportunities').getRecordTypeId();
        Id opportunityRecordTypeId1 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('EDU Opportunity').getRecordTypeId();
        User usr = new User(LastName = 'Tulo',
                            FirstName='Tapas',
                            Alias = 'Ttest',
                            Email = 'ttulo@huronconsultinggroup.com',
                            Username = 'ttulo@huronconsultinggroup.com.test',
                            ProfileId = profileId.id,
                            TimeZoneSidKey = 'GMT',
                            LanguageLocaleKey = 'en_US',
                            EmailEncodingKey = 'UTF-8',
                            LocaleSidKey = 'en_US'
                           );
        insert usr;
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.industry = 'Education';
        acc.ownerid = usr.id;
        insert acc;
        
        Contact con = new Contact();
        con.FirstName='Test';
        con.LastName='Test';
        con.Accountid= acc.id;
        con.Job_Function__c='Admissions';
        con.Job_Level__c='Dean';
        insert con;
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
        //pbe3.Pricebook2Id = Test.getStandardPricebookId();
        pbe3.Product2Id = svc2.id;
        pbe3.IsActive = true;
        pbe3.CurrencyIsoCode  = 'USD';
        pbe3.UnitPrice = 1;
        //insert pbe3;
        pbe3.Pricebook2Id =    pb2.id;
        insert pbe3;
        
        PriceBookEntry pbe4 = [select id,Pricebook2Id from PriceBookEntry where id = : pbe3.id];
        system.debug('pbe4'+pbe4);
        system.debug('pb2'+pb2.id);
        Opportunity newOpp =  new Opportunity();
        newOpp.recordtypeid = opportunityRecordTypeId;
        newOpp.Name = 'Google';
        newOpp.Pricebook2Id=pb2.id;
        newOpp.AccountId = acc.id;
        newOpp.ES_A_BDM_Role__c = 'Change Order' ;
        newOpp.EPM_Sales_Lead__c = con.Id ;
        newOpp.CurrencyIsoCode = 'USD';
        newOpp.Competitor__c = acc.id;
        newOpp.closeDate = system.today()+5;
        newOpp.Estimated_Start_Date__c   = system.today()+10;
        newOpp.Estimated_Duration__c  = 3;
        newOpp.Oppty_Product_schedule_created__c = false;
        newOpp.Industry__c = 'Agriculture';
        newOpp.EPM_Region__c = 'Higher Ed';
        newOpp.Pricing_Review_Status__c = 'Not Submitted';
        newOpp.StageName = 'Prospect (0-14%)';
        newOpp.ownerid = usr.id;
        newOpp.amount = 5000;
        newOpp.Secondary_Reasons_Lost__c  = 'Other';
        newOpp.Secondary_Reasons_Won__c = 'Other';
        newOpp.Other_Reason__c = 'Other reasons';
        newOpp.Reason_Lost__c = 'Other';
        insert newopp;
        
        
        Opportunity newOpp1 =  new Opportunity();
        newOpp1.recordtypeid = opportunityRecordTypeId1;
        newOpp1.Name = 'Google1';
        newOpp1.type = 'Renewal Opportunity';
        newOpp1.Pricebook2Id=pb2.id;
        newOpp1.AccountId = acc.id;
        newOpp1.ES_A_BDM_Role__c = 'Change Order' ;
        newOpp1.EPM_Sales_Lead__c = con.Id ;
        newOpp1.CurrencyIsoCode = 'USD';
        newOpp1.closeDate = system.today()+5;
        newOpp1.Estimated_Start_Date__c   = system.today()+5;
        newOpp1.Estimated_Duration__c  = 3;
        newOpp1.Oppty_Product_schedule_created__c = false;
        newOpp1.Industry__c = 'Agriculture';
        newOpp1.competitor__c = acc.id;
        newOpp1.EPM_Region__c = 'Higher Ed';
        newOpp1.Pricing_Review_Status__c = 'Not Submitted';
        newOpp1.StageName = 'Prospect (0-14%)';
        newOpp1.ownerid = usr.id;
        newOpp1.amount = 5000;
        newOpp1.Secondary_Reasons_Lost__c  = 'Other';
        newOpp1.Secondary_Reasons_Won__c = 'Other';
        newOpp1.Reason_Lost__c = 'Other';
        insert newopp1;
        
        Opportunity newOpp2 =  new Opportunity();
        newOpp2.recordtypeid = opportunityRecordTypeId1;
        newOpp2.Name = 'Google2';
        newOpp2.Pricebook2Id=pb2.id;
        newOpp2.AccountId = acc.id;
        newOpp2.ES_A_BDM_Role__c = 'Change Order' ;
        newOpp2.EPM_Sales_Lead__c = con.Id ;
        newOpp2.CurrencyIsoCode = 'USD';
        newOpp2.closeDate = system.today()+5;
        newOpp2.Estimated_Start_Date__c   = system.today()+1;
        newOpp2.Estimated_Duration__c  = 3;
        newOpp2.Oppty_Product_schedule_created__c = false;
        newOpp2.Industry__c = 'Agriculture';
        newOpp2.EPM_Region__c = 'Higher Ed';
        newOpp2.Pricing_Review_Status__c = 'Not Submitted';
        newOpp2.StageName = 'Prospect (0-14%)';
        newOpp2.ownerid = usr.id;
        newOpp2.amount = 5000;
        newOpp2.Secondary_Reasons_Lost__c  = 'Other';
        newOpp2.Secondary_Reasons_Won__c = 'Other';
        newOpp2.Reason_Lost__c = 'Other';
        
        insert newopp2;
        
        Opportunity newOpp3 =  new Opportunity();
        newOpp3.recordtypeid = opportunityRecordTypeId;
        newOpp3.Name = 'Google3';
        newOpp3.Pricebook2Id=pb2.id;
        newOpp3.AccountId = acc.id;
        newOpp3.ES_A_BDM_Role__c = 'Change Order' ;
        newOpp3.EPM_Sales_Lead__c = con.Id ;
        newOpp3.CurrencyIsoCode = 'USD';
        newOpp3.closeDate = system.today()+5;
        newOpp3.Estimated_Start_Date__c   = system.today()+1;
        newOpp3.Estimated_Duration__c  = 3;
        newOpp3.Oppty_Product_schedule_created__c = false;
        newOpp3.Industry__c = 'Agriculture';
        newOpp3.EPM_Region__c = 'Higher Ed';
        newOpp3.Pricing_Review_Status__c = 'Not Submitted';
        newOpp3.StageName = 'Prospect (0-14%)';
        newOpp3.ownerid = usr.id;
        newOpp3.amount = 5000;
        newOpp3.Secondary_Reasons_Lost__c  = 'Other';
        newOpp3.Secondary_Reasons_Won__c = 'Other';
        
        newOpp3.Reason_Lost__c = 'Other';
        //newopp.lIsLostStageValidated = false;
        // newopp.lDataValid = false;
        insert newopp3;
        
       
        OpportunityContactRole ocr = new OpportunityContactRole();
        ocr.OpportunityId=newOpp.id;
        ocr.ContactId=con.id;
        ocr.Role='Invoice Contact';
        insert ocr;
        
        system.debug('newop-->'+newopp);
        
        Product2 oProduct= new Product2();
        oProduct.Name='Healthcare';
        oProduct.CurrencyIsoCode='USD';
        Insert oProduct;
        
        OpportunityLineItem oLI = new OpportunityLineItem();
        oLI.OpportunityId=newOpp.id;
        oLI.PricebookEntryId=pbe3.id; 
        oLI.Amount__c=2000;
        oLI.Service_Line_or_Product__c='CA: Care Access';
        oLI.UnitPrice=3000.25;
        oLI.Offering__c='Software';
        oLI.Product2Id = oProduct.Id;
        insert oLI;
        system.debug('oli-->'+oli);
       
        newOpp.StageName='Closed Won (100%)';
        newOpp.Reason_Won__c= 'Other';
        newOpp.Other_Reason__c = 'OTHER';
        update newopp;
        system.debug('newopp updated-->'+newopp.Id);
        
        newOpp1.StageName='Closed Won (100%)';
        newOpp1.Reason_Won__c= 'Other';
        //newOpp1.Other_Reason__c = 'OTHER';
        //newOpp1.type = 'Renewal Opportunity';
        update newopp1;
        system.debug('newopp updated new-->'+newopp1.Id);
        
        newOpp3.StageName='Closed Won (100%)';
        newOpp3.Reason_Won__c= 'Other';
        newOpp3.Other_Reason__c = 'OTHER';
        newOpp3.type = 'Extension Opportunity';
        update newopp3;
        system.debug('newopp updated new-->'+newopp3.Id);
        
        newOpp2.StageName='Closed Won (100%)';
        newOpp2.Reason_Won__c= 'Other';
        newOpp2.Other_Reason__c = 'OTHER';
        newOpp2.type = 'AddOn/UpSell';
        update newopp2;
        system.debug('newopp updated new-->'+newopp2.Id);
        
        OpportunityFieldHistory ofh = new OpportunityFieldHistory();
        ofh.field ='StageName';
        ofh.OpportunityId = newopp.id; 
        insert ofh;
        
        OpportunityFieldHistory ofh1 = new OpportunityFieldHistory();
        ofh1.field ='StageName';
        ofh1.OpportunityId = newopp1.id; 
        insert ofh1;
    }
    
    //@isTest
    public static testmethod void testMethod1() {
        Test.startTest();
        opportunityErrorHandlerMethod(); 
        Contact con = [select Id from Contact where Name = 'Test Test'];
        Opportunity newopp = [SELECT Id,Name,Estimated_Duration__c,EPM_Region__c,Industry__c,ES_A_BDM_Role__c,Estimated_Start_Date__c,Reason_Lost__c,Other_Reason_Lost__c,Competitor__c,Other_Reason__c FROM Opportunity WHERE Name = 'Google'];
        String jsFieldFromRecordPage = '';
        Map<String,Object> jsFieldFromRecordPageList = new Map<String,Object>();
        jsFieldFromRecordPageList.put('Estimated_Duration__c',newopp.Estimated_Duration__c);
        jsFieldFromRecordPageList.put('EPM_Region__c',newopp.EPM_Region__c);
        jsFieldFromRecordPageList.put('Industry__c',newopp.Industry__c);
        jsFieldFromRecordPageList.put('Competitor__c',newopp.Competitor__c);
        jsFieldFromRecordPageList.put('ES_A_BDM_Role__c',newopp.ES_A_BDM_Role__c);
        jsFieldFromRecordPageList.put('Estimated_Start_Date__c',newopp.Estimated_Start_Date__c);
        jsFieldFromRecordPageList.put('Reason_Lost__c',newopp.Reason_Lost__c);
        jsFieldFromRecordPageList.put('Other_Reason_Lost__c',newopp.Other_Reason_Lost__c);
        jsFieldFromRecordPageList.put('Other_Reason__c',newopp.Other_Reason__c);
        jsFieldFromRecordPageList.put('Other_Reason_Lost__c',newopp.Other_Reason_Lost__c);
        jsFieldFromRecordPage = JSON.serialize(jsFieldFromRecordPageList);
        OpportunityValidationErrorHandler.getCurrentRecordTypeID(newopp.id);
        OpportunityValidationErrorHandler.checkStageNameFieldHistoryValue(newopp.id);
        OpportunityValidationErrorHandler.validateStartdateCloseDate(newopp.id, jsFieldFromRecordPage);
        OpportunityValidationErrorHandler.validationRuleErrorMethod(newopp.id);
        //TO Test the Exception in Test class
         OpportunityValidationErrorHandler.validationRuleErrorMethod(con.Id);
        Test.stopTest();
    }
    
    public static testmethod void testMethod5() {
        Test.startTest();
        opportunityErrorHandlerMethod(); 
        Contact con = [select Id from Contact where Name = 'Test Test'];
        Opportunity newopp = [SELECT Id,Name,Estimated_Duration__c,EPM_Region__c,Industry__c,ES_A_BDM_Role__c,Estimated_Start_Date__c,Reason_Lost__c,Other_Reason_Lost__c,Competitor__c,Other_Reason__c FROM Opportunity WHERE Name = 'Google'];
        String jsFieldFromRecordPage = '';
        Map<String,Object> jsFieldFromRecordPageList = new Map<String,Object>();
        jsFieldFromRecordPageList.put('Estimated_Duration__c',newopp.Estimated_Duration__c);
        jsFieldFromRecordPageList.put('EPM_Region__c',newopp.EPM_Region__c);
        jsFieldFromRecordPageList.put('Industry__c',newopp.Industry__c);
        //jsFieldFromRecordPageList.put('Competitor__c',newopp.Competitor__c);
        jsFieldFromRecordPageList.put('ES_A_BDM_Role__c',newopp.ES_A_BDM_Role__c);
        jsFieldFromRecordPageList.put('Estimated_Start_Date__c',newopp.Estimated_Start_Date__c);
        jsFieldFromRecordPageList.put('Reason_Lost__c',newopp.Reason_Lost__c);
        jsFieldFromRecordPageList.put('Other_Reason_Lost__c',newopp.Other_Reason_Lost__c);
        jsFieldFromRecordPageList.put('Other_Reason__c',newopp.Other_Reason__c);
        jsFieldFromRecordPageList.put('Other_Reason_Lost__c',newopp.Other_Reason_Lost__c);
        jsFieldFromRecordPage = JSON.serialize(jsFieldFromRecordPageList);
        OpportunityValidationErrorHandler.getCurrentRecordTypeID(newopp.id);
        OpportunityValidationErrorHandler.checkStageNameFieldHistoryValue(newopp.id);
        OpportunityValidationErrorHandler.validateStartdateCloseDate(newopp.id, jsFieldFromRecordPage);
        OpportunityValidationErrorHandler.validationRuleErrorMethod(newopp.id);
        //TO Test the Exception in Test class
         OpportunityValidationErrorHandler.validationRuleErrorMethod(con.Id);
        Test.stopTest();
    }
    public static testmethod void testMethod2() {
        Test.startTest();
        opportunityErrorHandlerMethod(); 
        Contact con = [select Id from Contact where Name = 'Test Test'];
        Opportunity newopp2 = [SELECT Id,Name,Estimated_Duration__c,EPM_Region__c,Industry__c,ES_A_BDM_Role__c,Estimated_Start_Date__c,Reason_Lost__c,Other_Reason_Lost__c,Other_Reason__c,competitor__c,type,SABER_Original_Opportunity_ID__c,AddOnUpSaleEndDate__c ,Effective_Date__c   FROM Opportunity WHERE Name = 'Google1'];
        String jsFieldFromRecordPage = '';
        Map<String,Object> jsFieldFromRecordPageList = new Map<String,Object>();
        jsFieldFromRecordPageList.put('Estimated_Duration__c',newopp2.Estimated_Duration__c);
        jsFieldFromRecordPageList.put('EPM_Region__c',newopp2.EPM_Region__c);
        jsFieldFromRecordPageList.put('Industry__c',newopp2.Industry__c);
        jsFieldFromRecordPageList.put('ES_A_BDM_Role__c',newopp2.ES_A_BDM_Role__c);
        jsFieldFromRecordPageList.put('type',newopp2.type);
        jsFieldFromRecordPageList.put('Estimated_Start_Date__c',newopp2.Estimated_Start_Date__c);
        jsFieldFromRecordPageList.put('Reason_Lost__c',newopp2.Reason_Lost__c);
        jsFieldFromRecordPageList.put('Other_Reason_Lost__c',newopp2.Other_Reason_Lost__c);
        jsFieldFromRecordPageList.put('Other_Reason__c',newopp2.Other_Reason__c);
        jsFieldFromRecordPageList.put('competitor__c',newopp2.competitor__c);
        jsFieldFromRecordPageList.put('SABER_Original_Opportunity_ID__c ',newopp2.SABER_Original_Opportunity_ID__c );
        jsFieldFromRecordPageList.put('AddOnUpSaleEndDate__c ',newopp2.AddOnUpSaleEndDate__c );
        jsFieldFromRecordPageList.put('Effective_Date__c ',newopp2.Effective_Date__c );
        jsFieldFromRecordPageList.put('Other_Reason_Lost__c',newopp2.Other_Reason_Lost__c);
        jsFieldFromRecordPage = JSON.serialize(jsFieldFromRecordPageList);
        OpportunityValidationErrorHandler.getCurrentRecordTypeID(newopp2.id);
        OpportunityValidationErrorHandler.checkStageNameFieldHistoryValue(newopp2.id);
        OpportunityValidationErrorHandler.validateStartdateCloseDate(newopp2.id, jsFieldFromRecordPage);
        OpportunityValidationErrorHandler.validationRuleErrorMethod(newopp2.id);
        //TO Test the Exception in Test class
         OpportunityValidationErrorHandler.validationRuleErrorMethod(con.Id);
        Test.stopTest();
    }
    
    public static testmethod void testMethod3() {
        Test.startTest();
        opportunityErrorHandlerMethod(); 
        Contact con = [select Id from Contact where Name = 'Test Test'];
        Opportunity newopp = [SELECT Id,Name,Estimated_Duration__c,EPM_Region__c,Industry__c,ES_A_BDM_Role__c,Estimated_Start_Date__c,Reason_Lost__c,Other_Reason_Lost__c,Other_Reason__c,SABER_Original_Opportunity_ID__c,AddOnUpSaleEndDate__c ,Effective_Date__c   FROM Opportunity WHERE Name = 'Google2'];
        String jsFieldFromRecordPage = '';
        Map<String,Object> jsFieldFromRecordPageList = new Map<String,Object>();
        jsFieldFromRecordPageList.put('Estimated_Duration__c',newopp.Estimated_Duration__c);
        jsFieldFromRecordPageList.put('EPM_Region__c',newopp.EPM_Region__c);
        jsFieldFromRecordPageList.put('Industry__c',newopp.Industry__c);
        jsFieldFromRecordPageList.put('ES_A_BDM_Role__c',newopp.ES_A_BDM_Role__c);
        jsFieldFromRecordPageList.put('Estimated_Start_Date__c',newopp.Estimated_Start_Date__c);
        jsFieldFromRecordPageList.put('Reason_Lost__c',newopp.Reason_Lost__c);
        jsFieldFromRecordPageList.put('Other_Reason_Lost__c',newopp.Other_Reason_Lost__c);
        jsFieldFromRecordPageList.put('Other_Reason__c',newopp.Other_Reason__c);
        jsFieldFromRecordPageList.put('SABER_Original_Opportunity_ID__c ',newopp.SABER_Original_Opportunity_ID__c );
        jsFieldFromRecordPageList.put('AddOnUpSaleEndDate__c ',newopp.AddOnUpSaleEndDate__c );
        jsFieldFromRecordPageList.put('Effective_Date__c ',newopp.Effective_Date__c );
        jsFieldFromRecordPageList.put('Other_Reason_Lost__c',newopp.Other_Reason_Lost__c);
        jsFieldFromRecordPage = JSON.serialize(jsFieldFromRecordPageList);
        OpportunityValidationErrorHandler.getCurrentRecordTypeID(newopp.id);
        OpportunityValidationErrorHandler.checkStageNameFieldHistoryValue(newopp.id);
        OpportunityValidationErrorHandler.validateStartdateCloseDate(newopp.id, jsFieldFromRecordPage);
        OpportunityValidationErrorHandler.validationRuleErrorMethod(newopp.id);
        //TO Test the Exception in Test class
         OpportunityValidationErrorHandler.validationRuleErrorMethod(con.Id);
        Test.stopTest();
    }
    
    public static testmethod void testMethod4() {
        Test.startTest();
        opportunityErrorHandlerMethod(); 
        Contact con = [select Id from Contact where Name = 'Test Test'];
        Opportunity newopp = [SELECT Id,Name,Estimated_Duration__c,EPM_Region__c,Industry__c,ES_A_BDM_Role__c,Estimated_Start_Date__c,Reason_Lost__c,Other_Reason_Lost__c,Other_Reason__c,SABER_Original_Opportunity_ID__c,AddOnUpSaleEndDate__c ,Effective_Date__c   FROM Opportunity WHERE Name = 'Google3'];
        String jsFieldFromRecordPage = '';
        Map<String,Object> jsFieldFromRecordPageList = new Map<String,Object>();
        jsFieldFromRecordPageList.put('Estimated_Duration__c',newopp.Estimated_Duration__c);
        jsFieldFromRecordPageList.put('EPM_Region__c',newopp.EPM_Region__c);
        jsFieldFromRecordPageList.put('Industry__c',newopp.Industry__c);
        jsFieldFromRecordPageList.put('ES_A_BDM_Role__c',newopp.ES_A_BDM_Role__c);
        jsFieldFromRecordPageList.put('Estimated_Start_Date__c',newopp.Estimated_Start_Date__c);
        jsFieldFromRecordPageList.put('Reason_Lost__c',newopp.Reason_Lost__c);
        jsFieldFromRecordPageList.put('Other_Reason_Lost__c',newopp.Other_Reason_Lost__c);
        jsFieldFromRecordPageList.put('Other_Reason__c',newopp.Other_Reason__c);
        jsFieldFromRecordPageList.put('SABER_Original_Opportunity_ID__c ',newopp.SABER_Original_Opportunity_ID__c );
        jsFieldFromRecordPageList.put('AddOnUpSaleEndDate__c ',newopp.AddOnUpSaleEndDate__c );
        jsFieldFromRecordPageList.put('Effective_Date__c ',newopp.Effective_Date__c );
        jsFieldFromRecordPageList.put('Other_Reason_Lost__c',newopp.Other_Reason_Lost__c);
        jsFieldFromRecordPage = JSON.serialize(jsFieldFromRecordPageList);
        OpportunityValidationErrorHandler.getCurrentRecordTypeID(newopp.id);
        OpportunityValidationErrorHandler.checkStageNameFieldHistoryValue(newopp.id);
        OpportunityValidationErrorHandler.validateStartdateCloseDate(newopp.id, jsFieldFromRecordPage);
        OpportunityValidationErrorHandler.validationRuleErrorMethod(newopp.id);
        //TO Test the Exception in Test class
         OpportunityValidationErrorHandler.validationRuleErrorMethod(con.Id);
        Test.stopTest();
    }
    
    
    
}