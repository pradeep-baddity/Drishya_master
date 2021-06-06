/***************************************************************************************
Class Name        : contactTest
Description       : This is the test class coverage for the ContactTrigger
Created By        : Arif Hussain
Created Date      : 27-Mar-2017
Last Modified By  : Arif Hussain
****************************************************************************************/
@isTest
public class contactTest{

        public static Account Acc{set; get;}
        public static Account Acc1{set; get;}
        public static Contact con{set; get;}
        public static Huron_Connection__c HC{set; get;}
        
        public static void insertrecords(){
        
           acc = new Account();
           acc.Name = 'Test Account';
           //acc.CurrencyIsoCode ='USD - U.S.Dollar';
           insert acc;
           system.debug('Account -->'+acc);
           
           acc1 = new Account();
           acc1.Name = 'Test Account1';
           //acc.CurrencyIsoCode ='USD - U.S.Dollar';
           insert acc1;
           system.debug('Account1 -->'+acc1);
           
           con = new Contact();
           con.FirstName='Test';
           con.LastName='Test';
           con.Accountid= acc.id;
           insert con;
           system.debug('Contact -->'+con);

           HC =  new Huron_Connection__c();
           HC.name= 'Test HC';
           HC.Contact__c = con.id;
           HC.Account__c = acc.id;
           insert HC;
           system.debug('Huron Connection -->'+HC);         
           
           
        }
        
        public static void insertrecordsnew(){
        
          con.AccountId = acc1.Id;
          update con;
          HC.Account__c = acc1.id;
          update HC;
          //system.debug('parent opportunityId'+newOpp.Related_Opportunity__c);
        }
        
        Public static testmethod void test1(){
        
        insertrecords();
        insertrecordsnew();
        }
}