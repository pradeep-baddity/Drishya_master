@isTest(seeAllData=true)
public class OpportunityTrigger_TestClass {
static testMethod void ensureCodeCoverage2() {
		Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        /*List<PricebookEntry> pbe = [SELECT id,Name,Pricebook2Id,Product2Id,CurrencyIsoCode
                                      FROM PricebookEntry 
                                     WHERE Product2.Name='Strategy' AND Pricebook2.Name='Huron 2018' AND CurrencyIsoCode ='USD' AND isActive=True];
        */
        Pricebook2 pb2 = new Pricebook2();
        pb2.name = 'Huron 2018';
        pb2.IsActive = true;
        insert pb2;

        Product2 svc2 = new Product2();
        svc2.name = 'Strategy';
        svc2.IsActive = true;
        svc2.CanUseRevenueSchedule = true;
        insert svc2;
        
        PricebookEntry pbeStd = new PricebookEntry();
        pbeStd.Pricebook2Id = Test.getStandardPricebookId(); 
        pbeStd.Product2Id = svc2.id;
        pbeStd.UnitPrice = 1;
        pbeStd.CurrencyIsoCode  = 'USD';
        pbeStd.IsActive = true;
        insert pbeStd;
        
        PricebookEntry pbe2 = new PricebookEntry();
        pbe2.Pricebook2Id = pb2.Id; 
        pbe2.Product2Id = svc2.id;
        pbe2.UnitPrice = 1;
        pbe2.CurrencyIsoCode  = 'USD';
        pbe2.IsActive = true;
        insert pbe2;
        
		List<RecordType> selectedRecordType = [SELECT Id,Name,DeveloperName, Sobjecttype  
                                                 FROM RecordType 
                                                WHERE DeveloperName ='Huron' AND SObjecttype = 'Opportunity' LIMIT 1];
		Opportunity o = new Opportunity(Name = 'Test Opportunity',Amount = 1,AccountId = acc.Id, CloseDate = Date.today(), StageName = 'Prospect (0-14%)',RecordTypeId = selectedRecordType[0].id,CurrencyIsoCode='USD');
		
		insert o;
	}
}