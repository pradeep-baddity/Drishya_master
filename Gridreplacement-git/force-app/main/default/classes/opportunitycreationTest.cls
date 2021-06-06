/***************************************************************************************
Class Name        : opportunitycreationTest
Description       : This is the test class coverage for the helper class OpportunityHelper
Created By        : Arif Hussain
Created Date      : Oct-8-2017
Last Modified By  : Arif Hussain
****************************************************************************************/
@isTest
public class opportunitycreationTest{
        public static Opportunity newOpp{set; get;}
        public static Opportunity newOpp1{set; get;}
        public static void insertrecords(){
        
           Account acc = new Account();
           acc.Name = 'Test Account';
           //acc.CurrencyIsoCode ='USD - U.S.Dollar';
           insert acc;
           system.debug('Account -->'+acc);
           
           Contact con = new Contact();
           con.FirstName='Test';
           con.LastName='Test';
           con.Accountid= acc.id;
           insert con;
           system.debug('Contact -->'+con);

          
           newOpp =  new Opportunity();
           newOpp.recordtypeid = '012U0000000Mfhr';
           newOpp.Name = 'Google';
           newOpp.AccountId = acc.id;
           newOpp.EPM_Sub_Solution__c = 'EPM' ;
           newOpp.EPM_Sales_Lead__c = con.Id ;
           newOpp.EPM_Region__c = 'Central';
           newOpp.StageName = 'Building Value';
           //newOpp.CurrencyIsoCode = 'USD - U.S. Dollar';
           newOpp.closeDate = system.today()+5;
           newOpp.EPM_Department__c   = 'BA-ES&A-Salesforce India :6202';
           newOpp.EPM_Service_Line__c  = 'ES&A-Salesforce';
           insert newOpp;
           system.debug('Opportunity -->'+newOpp);
           
           newOpp1 =  new Opportunity();
           newOpp1.recordtypeid = '012U0000000MXbG';
           newOpp1.Name = 'Google';
           newOpp1.AccountId = acc.id;
           newOpp1.EPM_Sub_Solution__c = 'EPM' ;
           newOpp1.EPM_Sales_Lead__c = con.Id ;
           newOpp1.EPM_Region__c = 'Central';
           newOpp1.StageName = 'Building Value';
           //newOpp1.CurrencyIsoCode = 'USD - U.S.Dollar';
           newOpp1.closeDate = system.today()+5;
           newOpp1.EPM_Department__c   = 'BA-ES&A-Salesforce India :6202';
           newOpp1.EPM_Service_Line__c  = 'ES&A-Salesforce';
           insert newOpp1;
           system.debug('Opportunity 1 -->'+newOpp1);
           
        }
        
        public static void insertrecordsnew(){
        
          newOpp.Related_Opportunity__c = newOpp1.Id;
          //update newOpp;
          system.debug('parent opportunityId'+newOpp.Related_Opportunity__c);
        }
        
        Public static testmethod void test1(){
        
        insertrecords();
        //insertrecordsnew();
        }
}