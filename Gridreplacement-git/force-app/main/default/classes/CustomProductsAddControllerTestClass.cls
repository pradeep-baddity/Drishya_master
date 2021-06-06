@IsTest public class CustomProductsAddControllerTestClass {
    @IsTest public static void OpportunityRecordInsert() {
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
                                                                                     Type ='Standard Opportunity',
                                                                                     AutoCreateRenewal__c = True,
                                                                                     RenewalCreated__c = false),
                                                                     'CRM_TestFactory.OpportunityDefaults');
        test.starttest();
        INSERT opp;
        test.stoptest();
        
        OpportunityLineItem oli = (OpportunityLineItem)CRM_TestFactory.createSobject(new OpportunityLineItem(OpportunityId = opp.Id,
                                                                                                             offering_lost__c = false,
                                                                                                             Offering__c = 'Leadership Academy',
                                                                                                             Product2Id = prod.Id,
                                                                                                             PricebookEntryId= pbe.Id,
                                                                                                             Elite_Service_Line_ID__c = 'HC103',
                                                                                                             Service_Line_or_Product__c = 'Conferences'),
                                                                                     'CRM_TestFactory.OpportunityLineItemDefaults');
        
        Opportunity tmp = [Select PriceBook2Id from Opportunity Where Id = :opp.id];
        System.debug('---pricebookId---'+pricebookId);
        System.debug('----tmp'+tmp);
        //INSERT oli;
        System.debug('oli---'+oli);
        List<String> selectedOli = new List<String>();
        selectedOli.add(oli.Id);
        
         List<OpportunityLineItem> listOLI = new List<OpportunityLineItem>();
        listOLI.add(oli);
        
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
        
        CustomProductsAddController.getOfferinggs(opp.id, 'Studer');
        CustomProductsAddController.getOfferinggs(opp.id, '');
        CustomProductsAddController.saveOpportunityLiItem(JSON.serialize(listOLI));
        CustomProductsAddController.getListedRows('aRow');
        //selectedWrapper sc = new selectedWrapper();
        CustomProductsAddController.selectedWrapper selectedWrapper1 = new CustomProductsAddController.selectedWrapper('new',80);
        
    }  
}