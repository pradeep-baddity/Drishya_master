@isTest
public class productMapUpdate_testclass {
    @isTest
    public static void TestScheduleproducts(){
        decimal Count = 0;
        Account acc = new Account(Name = 'Test Account' );
        insert acc;
        system.debug('acc=='+acc);
        string recordtypename = system.label.Product_Recordtype;
        
         Id pricebookId = Test.getStandardPricebookId();
        
        Opportunity Opp = new Opportunity(Name = 'test Class', StageName = 'Design' ,AccountId = acc.Id, Amount = 100, CurrencyIsoCode = 'USD',CloseDate = System.today(), recordtypeId = '0120B000000tBIN');
        insert Opp;
        system.debug('acc1=='+Opp);
        Pricebook2 pb = new Pricebook2(Name = 'Test pricebook');
        insert pb;
        
        Product2 prod = new Product2(Name = 'testName',
            IsActive=true , CanUseRevenueSchedule = true);
        INSERT prod;
        
        PricebookEntry pbe1 = new PricebookEntry(UnitPrice = 100, CurrencyIsoCode = 'USD', Pricebook2id = Test.getStandardPricebookId(),IsActive = true,Product2Id = prod.Id);
         insert pbe1;
        
        PricebookEntry pbe = new PricebookEntry(UnitPrice = 100, CurrencyIsoCode = 'USD', UseStandardPrice = false , IsActive = true,Pricebook2id = pb.Id,Product2Id = prod.Id);
         insert pbe;
        
        OpportunityLineItem oppline = new OpportunityLineItem(Offering_Actual_Revenue_Rollup__c = 200, OpportunityId = Opp.Id,PricebookEntryId = pbe.id, Product2Id = prod.Id);
        insert oppline;
        system.debug('acc11=='+oppline);
        /*
        OpportunityLineItemSchedule oppSchedule = new OpportunityLineItemSchedule(OpportunityLineItemId = oppline.Id ,Revenue = 100, scheduledate = system.today(), type = 'revenue');
        insert oppSchedule;
        system.debug('acc111=='+oppSchedule);
        
        OpportunityLineItemSchedule oppSchedule1 = new OpportunityLineItemSchedule(OpportunityLineItemId = oppline.Id ,Revenue = 100, scheduledate = system.today(), type = 'revenue');
        insert oppSchedule1;
        system.debug('acc111==>'+oppSchedule1);
       
       OpportunityLineItemSchedule oppnewlinesch = new OpportunityLineItemSchedule(Id = oppSchedule.id);
        oppnewlinesch.Actuals__c = 200;
       update oppnewlinesch;
       
       OpportunityLineItemSchedule oppnewlinesch1 = new OpportunityLineItemSchedule(Id = oppSchedule1.id);
        oppnewlinesch1.Actuals__c = 200;
       update oppnewlinesch1;
       */
       
       productMapUpdate obj = new productMapUpdate();
        DataBase.executeBatch(obj);
        
        String sch = '0 0 * * * ?';
            productMapScheudleclass sqrb = new productMapScheudleclass();      
            system.schedule('schedule12', sch, sqrb);
        
    }
}