@isTest 
public class LeadProcessorTest 
{
    static testMethod void testMethod1() 
    {
        List<Lead> lstLead = new List<Lead>();
        for(Integer i=0 ;i <200;i++)
        {
            Lead led = new Lead();
            led.FirstName ='FirstName'+i;
            led.LastName ='LastName'+i;
            led.Company ='demo'+i;
            led.Street = '1st Ave'+i;
            led.City = 'City'+i;
            led.State = 'Illinois';
            led.Country = 'United States';
            led.AnnualRevenue = 50000 + i;
            led.Industry = 'Industry' +i;
            led.NumberOfEmployees = 100 +i;
            led.Phone = '123-456-7890' +i;
            led.PostalCode = '10001' +i;
            led.Website = 'www.website.com' +i;
            led.RF_CDM_MatchScore__c = 150 +i;
            led.RF_SITE_Addr1__c = '1st St' +i;
            led.RF_SITE_City__c = 'New City' +i;
            led.RF_SITE_State__c = 'New York';
            led.RF_SITE_Country__c = 'United States';
            led.RF_SITE_AnnualRev__c = 3000;
            led.RF_SITE_Company__c = 'new demo' +i;
            led.RF_SITE_CustomIndustry__c = 'New Industry'+i;
            led.RF_SITE_EmployeesTotal__c = 200 +i;
            led.RF_SITE_Phone__c = '987-789-0012'+i;
            led.RF_SITE_Zip__c = '22211' +i;
            led.RF_SITE_URL__c = 'www.change.com'+i;
            lstLead.add(led);
        }
        
        insert lstLead;
        
        Test.startTest();
LeadProcessor obj = new LeadProcessor();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
}