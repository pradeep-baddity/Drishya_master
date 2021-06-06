@istest
public class getESAOpportunityPicklistControllerTest {
    public static Opportunity newOpp{set; get;}
    public static Opportunity newOpp1{set; get;}
    public static Account acc{set; get;}
    public static void insertrecords(){
        
           acc = new Account();
           acc.Name = 'Test Account';
            acc.industry = 'Education';
            acc.ownerid = '0050B000007vgOS';
           insert acc;
        
           Contact con = new Contact();
           con.FirstName='Test';
           con.LastName='Test';
           con.Accountid= acc.id;
           con.Job_Function__c = 'Administration';
           con.Job_Level__c = 'Professor';
           insert con;
        
            newOpp =  new Opportunity();
            newOpp.recordtypeid = '012U0000000Mfhr';
            newOpp.Name = 'Google';
            newOpp.AccountId = acc.id;
            newOpp.ES_A_BDM_Role__c = 'Change Order' ;
            newOpp.EPM_Sales_Lead__c = con.Id ;
            newOpp.CurrencyIsoCode = 'USD';
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
            insert newopp;
        
            newOpp1 =  new Opportunity();
            newOpp1.recordtypeid = '012U0000000Mfhr';
            newOpp1.Name = 'Google';
            newOpp1.AccountId = acc.id;
            newOpp1.ES_A_BDM_Role__c = 'Change Order' ;
            newOpp1.EPM_Sales_Lead__c = con.Id ;
            newOpp1.CurrencyIsoCode = 'USD';
            newOpp1.closeDate = system.today()+5;
            newOpp1.Estimated_Start_Date__c   = system.today()+10;
            newOpp1.Estimated_Duration__c  = 3;
            newOpp1.Oppty_Product_schedule_created__c = false;
            newOpp1.Industry__c = 'Agriculture';
            newOpp1.EPM_Region__c = 'Higher Ed';
            newOpp1.Pricing_Review_Status__c = 'Not Submitted';
            newOpp1.StageName = 'Prospect (0-14%)';
            newOpp1.ownerid = '0050B000007vgOS';
            newOpp1.amount = 0;
            insert newopp1;
            
    }
    Public static testmethod void test1(){
        
        insertrecords();
        getESAOpportunityPicklistController.getAccountName(acc.id);
        getESAOpportunityPicklistController.saveOpportunityRec(newopp,acc.id,'INR');
        getESAOpportunityPicklistController.getIndustry();
        }
    
    Public static testmethod void test2(){
        
        insertrecords();
        getESAOpportunityPicklistController.getAccountName(acc.id);
        getESAOpportunityPicklistController.saveOpportunityRec(newopp1,acc.id,'INR');
        getESAOpportunityPicklistController.getIndustry();
        }
}