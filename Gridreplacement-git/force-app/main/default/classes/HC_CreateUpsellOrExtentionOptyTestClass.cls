@isTest
public class HC_CreateUpsellOrExtentionOptyTestClass {
    static testmethod void OpportunityRecordInsert() {
        Id opportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Healthcare Opportunities').getRecordTypeId();
        
        Account acc = (Account)CRM_TestFactory.createSObject(new Account(),'CRM_TestFactory.AccountDefaults');
        INSERT acc;
        
        Contact con = (Contact)CRM_TestFactory.createSObject(new Contact(AccountId = acc.Id),'CRM_TestFactory.ContactDefaults');
        INSERT con;
        
        Id pricebookId = Test.getStandardPricebookId();
        system.debug('@@pricebookId'+pricebookId);
        
        Product2 prod = (Product2)CRM_TestFactory.createSObject(new Product2(),'CRM_TestFactory.Product2Defaults');
        system.debug('@@prod'+prod);
        INSERT prod;
        
        PricebookEntry pbe = (PricebookEntry)CRM_TestFactory.createSObject(new PricebookEntry(Pricebook2Id = pricebookId, 
                                                                                              Product2Id = prod.Id 
                                                                                             ),
                                                                           'CRM_TestFactory.PricebookEntryDefaults');
        INSERT pbe;
        
        Id pbId = [SELECT Pricebook2Id FROM PricebookEntry WHERE Id = :pbe.Id].Pricebook2Id;
        System.debug('--pbId--'+pbId);
        Opportunity opp = (Opportunity)CRM_TestFactory.createSObject(new Opportunity(Pricebook2Id = pbId,
                                                                                     recordtypeid = opportunityRecordTypeId,
                                                                                     AccountId = acc.Id,
                                                                                     
                                                                                     EPM_Sales_Lead__c = con.Id,
                                                                                     StageName = 'Prospect (0-14%)',
                                                                                     Type ='Renewal Opportunity',
                                                                                     Initiate_Renewal__c=date.today(),
                                                                                     AutoCreateRenewal__c = True,
                                                                                     CountOpportunityContactRole__c	=1,
                                                                                     RenewalCreated__c = false),
                                                                     'CRM_TestFactory.OpportunityDefaults');
        test.starttest();
        INSERT opp;
        test.stoptest();
        
        OpportunityLineItem oli = (OpportunityLineItem)CRM_TestFactory.createSobject(new OpportunityLineItem(OpportunityId = opp.Id,
                                                                                                             quantity=1,
                                                                                                             offering_lost__c = false,
                                                                                                             Product2Id = prod.Id,
                                                                                                            Expertise__c='Business Operations',
                                                                                                             //ProductName__c='Technology - CRM';
                                                                                                             Capability__c='',
                                                                                                             Service__c='Advisory Services',
                                                                                                             Technology_Vendor__c='Jaggaer',
                                                                                                             Technology_Capability__c='E-Business Suite',
                                                                                                             Technology_Module__c='Test 1',
                                                                                                             UnitPrice= 45,
                                                                                                             PricebookEntryId= pbe.Id),
                                                                                     'CRM_TestFactory.OpportunityLineItemDefaults');
        
        Opportunity tmp = [Select PriceBook2Id from Opportunity Where Id = :opp.id];
        System.debug('---pricebookId---'+pricebookId);
        //System.debug('----tmp'+tmp);
        INSERT oli;
        System.debug('oli---'+oli);
        List<String> selectedOli = new List<String>();
        selectedOli.add(oli.Id);
        
        OpportunityContactRole oppContactRole = (OpportunityContactRole)CRM_TestFactory.createSobject(new OpportunityContactRole
                                                                                                      (ContactId = con.Id,
                                                                                                       OpportunityId = opp.Id),
                                                                                                      'CRM_TestFactory.OpportunityContactRoleDefaults');
        INSERT oppContactRole;
        
        List<sales_credit__c> salcred1 = new  List<sales_credit__c>{
            new sales_credit__c(Name='test',Opportunity__c= opp.id)
                
                };
                    insert salcred1 ;
        
        List<sales_credit_employee__c> salcred = new  List<sales_credit_employee__c>{
            new sales_credit_employee__c(Role__c= 'Business Developer',Split__c =10 ,Name='Test',Sales_Credit__c= salcred1[0].ID)
                
                };
                    insert salcred ;
        
        Decimal tempDuration=5;
        Decimal tempSalesPrice = 700;
        date tempDate= system.today();
        decimal num = 5;
        
        
        OfferingWrapper testwrap = new OfferingWrapper(oli.ProductName__c ,
                                              oli.Expertise__c, oli.Capability__c,oli.Service__c,
                                                         oli.Technology_Vendor__c, oli.Technology_Capability__c, oli.Technology_Module__c,oli, 
                                                         oli.Estimated_Duration__c ,
                                                         oli.UnitPrice);
        List<OfferingWrapper> wrapperList = new  List<OfferingWrapper>();
        wrapperList.add(testwrap);
        string offeringlist = JSON.serialize(wrapperList);
        
       HC_CreateUpsellOrExtentionOpty tempConstructor = new HC_CreateUpsellOrExtentionOpty();
        HC_CreateUpsellOrExtentionOpty.getOppLines(opp.id);
        //string recordId,String optyType, Date estdDate , List<string> selectedOLI , decimal duration ,Date InitiateRenewal,Date EOCD,String opportunityName , String offeringsList){
      system.debug('opp-------'+opp);
        system.debug('tempDate----'+tempDate);
        system.debug('selectedOli===='+selectedOli);
        system.debug('num========='+num);
        system.debug('tempDate-----'+tempDate);
        system.debug('offeringlist-------'+offeringlist);
        HC_CreateUpsellOrExtentionOpty.createOpportunity(opp.Id,'Renewal Opportunity',tempDate,selectedOli,num, tempDate, tempDate, 'Test-OpportunityRec', offeringlist );
        
        HC_CreateUpsellOrExtentionOpty.mapSalesCreditNew(opp,salcred1);
        HC_CreateUpsellOrExtentionOpty.mapSalesCreditEmployeeNew(opp, salcred, salcred1);
        HC_CreateUpsellOrExtentionOpty.mapNewOppToOppLines(opp,wrapperList);
        HC_CreateUpsellOrExtentionOpty.datemodificationnew(tempDate, 20);
      	
    }
    
}