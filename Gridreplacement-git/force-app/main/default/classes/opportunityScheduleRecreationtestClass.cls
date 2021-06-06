@Istest
public class opportunityScheduleRecreationtestClass {
    static testMethod void OpportunityScheduleCreationTest() {
        test.startTest();
        Account acc =  new Account();
        acc.Name = 'Test Acc';
        Insert acc;
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
        
        Opportunity opp = new Opportunity ();
        opp.Name = 'test opp';
        opp.AccountId = acc.Id;
        opp.Amount = 1234;
        opp.StageName = 'Prospect (0-14%)';
        opp.Probability = 0.5;
        opp.CloseDate = System.today()+11;
        opp.Estimated_Start_Date__c  = System.today()+15;
        opp.Estimated_Duration__c =4;
        Insert opp;
        opp.Name = 'test oppty';
        Id recTypeId = [Select Id From RecordType where sobjecttype = 'Opportunity' And Name='Healthcare Software'].Id;
        opp.RecordTypeId = recTypeId;
        Update opp;
        List<Opportunity> oppList = new List<Opportunity>();
        oppList.add(opp);
        OpportunityLineItem opl = new OpportunityLineItem();
        opl.Offering__c = 'Performance Improvement';
        opl.Service_Line_or_Product__c = 'Assessment/Design';
        opl.OpportunityId = opp.Id;
        opl.Product2Id = svc2.Id;
        opl.Amount__c = 12334;
        opl.PricebookEntryId = pbe3.Id;
        Insert opl;
        opl.Amount__c = 12346;
        update opl;
        opportunityScheduleRecreation.OpportunityScheduleCreation(oppList);
        test.stopTest();
    }
    static testMethod void datemodificationnewTest() {
        test.startTest();
        opportunityScheduleRecreation.datemodification(System.today(),1);
        test.stopTest();
    }
}