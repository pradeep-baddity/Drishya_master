@isTest
public class ContactProcessorTest
{
    static testMethod void testMethod1() 
    {
        List<Contact> lstContact = new List<Contact>();
        for(Integer i=0 ;i <200;i++)
        {
            Contact Con = new Contact();
            Con.FirstName ='FirstName'+i;
            Con.LastName ='LastName'+i;
            Con.RF_SITE_Addr1__c = '1St Street'+i;
            Con.RF_SITE_City__c = 'New City' +i;
            Con.RF_SITE_State__c = 'New York';
            Con.RF_SITE_Country__c = 'United States';
            Con.RF_SITE_Phone__c = '777-444-5566' +i;
            Con.RF_SITE_Zip__c = '60606' +i;
            Con.RF_CDM_MatchScore__c = 150 + i;
            lstContact.add(Con);
        }
        
        insert lstContact;
        
        Test.startTest();
ContactProcessor obj = new ContactProcessor();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
}