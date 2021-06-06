@IsTest public class opportunitylineItemfetchTestClass {
    @IsTest public static void OpportunityRecordInsert() {
        Profile profileId = [SELECT Id,Name FROM Profile WHERE Name IN ('Non-Restricted','System Administrator') LIMIT 1];
        
        Id opportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Healthcare Opportunities').getRecordTypeId();
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
        system.debug('usr--'+usr);
        system.runas(usr)
        {
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
        //  test.starttest();
        INSERT opp;
        //test.stoptest();
        
        OpportunityLineItem oli = (OpportunityLineItem)CRM_TestFactory.createSobject(new OpportunityLineItem(OpportunityId = opp.Id,
                                                                                                             unitPrice = 500,
                                                                                                             Offering_Actual_Revenue_Rollup__c=500,
                                                                                                             offering_lost__c = false,
                                                                                                             Offering__c = 'Leadership Academy',
                                                                                                             Product2Id = prod.Id,
                                                                                                             is_Non_Restricted_User__c  = false,
                                                                                                             PricebookEntryId= pbe.Id,
                                                                                                             Elite_Service_Line_ID__c = 'HC103',
                                                                                                             Service_Line_or_Product__c = 'Conferences'),
                                                                                     'CRM_TestFactory.OpportunityLineItemDefaults');
        
        Opportunity tmp = [Select PriceBook2Id from Opportunity Where Id = :opp.id];
        System.debug('---pricebookId---'+pricebookId);
        System.debug('----tmp'+tmp);
        INSERT oli;
        OpportunityLineItem tempOLI= new OpportunityLineItem(id=oli.Id);
        tempOLI.Offering_Actual_Revenue_Rollup__c = 500;
        tempOLI.Amount__c=500;
        update tempOLI;
        System.debug('tempOLI---'+tempOLI);
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
        date tempDate = system.today();
        double tempRev = 300;
        integer tempDuemonths= 2;
        id stringid = profileId.id;
      //  opportunitylineItemfetch.fetchopportunitylineitem(oli.id);
        opportunitylineItemfetch.offeringReadOnlyRecords(oli.id);
        opportunitylineItemfetch.getscheduleinformation(oli.id);
        
        
        Test.startTest();
        
        
        //Methods called
        try
        {
            List<opportunitylineitem> errorRelease1 =  opportunitylineItemfetch.fetchopportunitylineitem(oli.id);

            
        }
        catch(exception e)
        {
        }  
        //Methods called
        try
        {
           
            List<OpportunityLineItemSchedule> errorRelease = opportunitylineItemfetch.recreateSchedules(oli.id, tempDate, tempRev, tempDuemonths);
        }
        catch(exception e)
        {
        }

opportunitylineItemfetch.deleteopportunitylineitemId(oli.id, opp.id);       
        Test.stopTest();
        
        }
        
        
    }    
    
}