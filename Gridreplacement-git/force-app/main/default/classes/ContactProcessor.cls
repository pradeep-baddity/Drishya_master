global class ContactProcessor implements    Database.Batchable<Sobject>
// Implements logic provided by marketing to move data from reachforce fields to standard fields on Contacts
// Author Ruben Estrada restrada@huronconsultinggroup.com
// 2/1/2016
{
    global Database.QueryLocator start(Database.BatchableContext bc) 
    {
        return Database.getQueryLocator([SELECT Id, 
                                         MailingStreet,MailingCity, MailingState, MailingCountry, MailingPostalCode,Phone,
                                         RF_CDM_MatchGrade__c,RF_CDM_MatchScore__c,RF_CDM_ModifiedDate__c,
                                         RF_SITE_Addr1__c,RF_SITE_AnnualRev__c,RF_SITE_City__c,RF_SITE_Company__c,
                                         RF_SITE_Country__c,RF_SITE_CustomIndustry__c,RF_SITE_EmployeesTotal__c,
                                         RF_SITE_Phone__c,RF_SITE_State__c,RF_SITE_URL__c,RF_SITE_Zip__c 
                                         FROM Contact WHERE RF_CDM_MatchScore__c >= 162 and (StreetCompare__c = 'true' or
                                         CityCompare__c = 'true' or StateCompare__c = 'true' or CountryCompare__c = 'true'
                                         or PhoneCompare__c = 'true' or ZipCompare__c = 'true') and (MailingStreet = null or
                                         MailingCity = null or MailingState = null or MailingCountry = null or Phone = null or
                                         MailingPostalCode = null)]);
    }
global void execute(Database.BatchableContext bc, List<Contact> scope)
    {
            for (Contact Contacts : scope) 
            {
                
                    If (Contacts.MailingStreet == null){
                        Contacts.MailingStreet=Contacts.RF_SITE_Addr1__c;}
                    If (Contacts.MailingCity==null){
                        Contacts.MailingCity = Contacts.RF_SITE_City__c;}
                    If (Contacts.MailingState==null && Contacts.RF_SITE_Country__c <> Null && Contacts.RF_SITE_Country__c.Contains ('United States')){
                        Contacts.MailingState = Contacts.RF_SITE_State__c;}
                    If (Contacts.MailingCountry==null){
                        Contacts.MailingCountry = Contacts.RF_SITE_Country__c;}
                    If (Contacts.Phone==null) {
                        Contacts.Phone = Contacts.RF_SITE_Phone__c;}
                    If (Contacts.MailingPostalCode==null){
                        Contacts.MailingPostalCode = Contacts.RF_SITE_Zip__c;}
                }
                
        update scope;
    }    
global void finish(Database.BatchableContext bc){   }    
}