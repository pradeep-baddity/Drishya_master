global class LeadProcessor implements    Database.Batchable<Sobject>
// Implements logic provided by marketing to move data from reachforce fields to standard fields on leads
// Author Ruben Estrada restrada@huronconsultinggroup.com
// 2/1/2016
{
    global Database.QueryLocator start(Database.BatchableContext bc) 
    {
        return Database.getQueryLocator([SELECT Id, 
                                         Street,City, State, Country, AnnualRevenue,Company,Fax,
                                         Industry,MobilePhone,NumberOfEmployees,Phone,PostalCode,
                                         RF_CDM_MatchGrade__c,RF_CDM_MatchScore__c,RF_CDM_ModifiedDate__c,
                                         RF_SITE_Addr1__c,RF_SITE_AnnualRev__c,RF_SITE_City__c,RF_SITE_Company__c,
                                         RF_SITE_Country__c,RF_SITE_CustomIndustry__c,RF_SITE_EmployeesTotal__c,
                                         RF_SITE_Phone__c,RF_SITE_State__c,RF_SITE_URL__c,RF_SITE_Zip__c,Website 
                                         FROM Lead WHERE RF_CDM_MatchScore__c >= 162 and (StreetCompare__c = 'true' or CityCompare__c = 'true'
                                         or StateCompare__c = 'true' or CountryCompare__c = 'true' or RevenueCompare__c = 'true' or CompanyCompare__c = 'true'
                                         or IndustryCompare__c = 'true' or EmployeesCompare__c = 'true' or PhoneCompare__c = 'true' or ZipCompare__c = 'true'
                                         or WebsiteCompare__c = 'true') and (RF_SITE_Addr1__c <> null or RF_SITE_City__c <> null
                                         or RF_SITE_State__c <> null or RF_SITE_Country__c <> null or RF_SITE_AnnualRev__c <> null
                                         or RF_SITE_Company__c <> null or RF_SITE_CustomIndustry__c <> null or RF_SITE_EmployeesTotal__c <> null
                                         or RF_SITE_Phone__c <> null or RF_SITE_Zip__c <> null or RF_SITE_URL__c <> null)]);
    }
global void execute(Database.BatchableContext bc, List<Lead> scope)
    {
            for (Lead Leads : scope) 
            {
                //Moves data for records where score between 162 and 184
                If (Leads.RF_CDM_MatchScore__c  <185) {
                    If (Leads.Website==null){
                        Leads.Website = Leads.RF_SITE_URL__c;}
                    If (Leads.Street == null){
                        Leads.Street=Leads.RF_SITE_Addr1__c;}
                    If (Leads.City==null){
                        Leads.City = Leads.RF_SITE_City__c;}
                    If (Leads.State==null && Leads.RF_SITE_Country__c <> Null && Leads.RF_SITE_Country__c.Contains ('United States: Australia')){
                        Leads.State = Leads.RF_SITE_State__c;}
                    If (Leads.Country==null){
                        Leads.Country = Leads.RF_SITE_Country__c;}
                    If (Leads.AnnualRevenue==null){
                        Leads.AnnualRevenue = Leads.RF_SITE_AnnualRev__c;}
                    If (Leads.Company==null){
                        Leads.Company = Leads.RF_SITE_Company__c;}
                    If (Leads.Industry==null) {
                        Leads.Industry = Leads.RF_SITE_CustomIndustry__c;}
                    If (Leads.Phone==null) {
                        Leads.Phone = Leads.RF_SITE_Phone__c;}
                    If (Leads.PostalCode==null){
                        Leads.PostalCode = Leads.RF_SITE_Zip__c;}
                    If (Leads.NumberOfEmployees==Null){
                        Leads.NumberOfEmployees = Integer.valueOf(Leads.RF_SITE_EmployeesTotal__c);}
                }
                
                //Moves data for records where score greater or equal to 185
                If (Leads.RF_CDM_MatchScore__c  > 184) {
                    If (Leads.RF_SITE_URL__c <> null) {
                        Leads.Website = Leads.RF_SITE_URL__c;}
                    If (Leads.RF_SITE_Addr1__c <> null) {
                        Leads.Street=Leads.RF_SITE_Addr1__c;}
                    If (Leads.RF_SITE_City__c <> null) {
                        Leads.City = Leads.RF_SITE_City__c;}
                    If (Leads.RF_SITE_State__c <> null && Leads.RF_SITE_Country__c <> Null && Leads.RF_SITE_Country__c.Contains ('United States')) {
                        Leads.State = Leads.RF_SITE_State__c;}
                    If (Leads.RF_SITE_Country__c <> null) {
                        Leads.Country = Leads.RF_SITE_Country__c;}
                    If (Leads.RF_SITE_AnnualRev__c <> null) {
                        Leads.AnnualRevenue = Leads.RF_SITE_AnnualRev__c;}
                    If (Leads.RF_SITE_Company__c <> Null) {
                        Leads.Company = Leads.RF_SITE_Company__c;}
                    If (Leads.RF_SITE_CustomIndustry__c <> Null) {
                        Leads.Industry = Leads.RF_SITE_CustomIndustry__c;}
                    If (Leads.RF_SITE_Phone__c <> Null && Leads.Phone ==Null) {
                        Leads.Phone = Leads.RF_SITE_Phone__c;}
                    If (Leads.RF_SITE_Phone__c <> Null && Leads.phone <> Null && Leads.Phone.Contains('NV')) {
                        Leads.Phone = Leads.RF_SITE_Phone__c;}
                    If (Leads.RF_SITE_Zip__c <> Null) {
                        Leads.PostalCode = Leads.RF_SITE_Zip__c;}
                    If (Leads.RF_SITE_EmployeesTotal__c <> Null) {
                        Leads.NumberOfEmployees = Integer.valueOf(Leads.RF_SITE_EmployeesTotal__c);}
                }
                
                
            }
        update scope;
    }    
global void finish(Database.BatchableContext bc){   }    
}