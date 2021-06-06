@isTest
public class SubmitForApprovalTest{
    static testMethod void myTest() {
        Test.StartTest();
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        
        User usr = new User(LastName = 'LIVESTON',
                           FirstName='JASON',
                           Alias = 'jliv',
                           Email = 'shhussain@huronconsultinggroup.com',
                           Username = 'shhussain@huronconsultinggroup.com.prod.fullsand',
                           ProfileId = profileId.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US');
        insert usr;
        
         Account acc = new Account();
         acc.Name = 'Test Account';
         insert acc;
             
         opportunity opp                   = new opportunity();
         opp.AccountId                     = acc.id;
         opp.MD_of_Record__c               = usr.Id;
         opp.Name                          = 'test';
         opp.ELS_Solution__c               = 'Life Sciences (LS)';
         opp.ELS_Department__c             ='BA-Life Sciences Access US :1445';
         opp.ELS_Service_Line__c           = 'LS-PW-Pricing and MEA :LS012';
         opp.LeadSource                    = 'Other';
         opp.NextStep                      = 'NA';
         opp.StageName                     = 'Prospecting';
         opp.closeDate                     = system.today()+5;
         opp.Amount                        = 500000;
         insert opp;
         system.debug('Opportunity record -->'+opp);
         ApexPages.CurrentPage().getparameters().put('id', opp.id);
        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
        app.setObjectId(opp.Id);
        //Approval.ProcessResult result = Approval.process(app);
        SubmitForApproval sub = new SubmitForApproval();
        sub.submit();
        //Approval.process(app);
        Test.StopTest();
     }
}