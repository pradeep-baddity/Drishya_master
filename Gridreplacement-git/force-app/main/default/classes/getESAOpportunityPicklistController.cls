/*************************************************************************************************************************************************************
@ Class:          getESAOpportunityPicklistController
@ Version:        1.0
@ Author:         TAPAS TULO
@ Purpose:        This class caters the New button for opportunity related list on Account
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history:  1.11.2018 / TAPAS TULO / Created the class.
**************************************************************************************************************************************************************/
public class getESAOpportunityPicklistController {
    
    /*************************************************************************************************************************************************************
    @ Method:         getPicklistValues
    @ Version:        1.0
    @ Author:         TAPAS TULO
    @ Purpose:        This method get picklist value of Opportunity record.
    @ Arguments:      
    --------------------------------------------------------------------------------------------------------------------------------------------------------------
    @ Change history: 1.11.2018 / TAPAS TULO / Created the method.
    **************************************************************************************************************************************************************/
   /* @AuraEnabled
    public static string getPicklistValues(){
        List<Opportunity_ESAPicklist__mdt> custMeta=[select label,ESAPicklistValue__c from Opportunity_ESAPicklist__mdt];
        
        Map<string,List<string>> picklistFieldWithValueMap = new map<string,List<string>>();
        
        for(Opportunity_ESAPicklist__mdt cMetadata:custMeta ){
            picklistFieldWithValueMap.put(cMetadata.label, cMetadata.ESAPicklistValue__c.split(','));            
        }
        string jsonPickListWithValue = JSON.serialize(picklistFieldWithValueMap);
        return jsonPickListWithValue;
    }*/
    
    /*************************************************************************************************************************************************************
    @ Method:         getAccountName
    @ Version:        1.0
    @ Author:         TAPAS TULO
    @ Purpose:        This method Account record on which related list button is clicked.
    @ Arguments:      Account recordId
    --------------------------------------------------------------------------------------------------------------------------------------------------------------
    @ Change history: 1.11.2018 / TAPAS TULO / Created the method.
    **************************************************************************************************************************************************************/
    @AuraEnabled
    public static Account getAccountName(id recordId){
        account acc= [select id,name,OwnerId,Owner.Name from account where id =:recordId];
        return acc;
    }
    
    /*************************************************************************************************************************************************************
    @ Method:         saveOpportunityRec
    @ Version:        1.0
    @ Author:         TAPAS TULO
    @ Purpose:        This method Saves the opportunity record.
    @ Arguments:      Opportunity record, Account recordID
    --------------------------------------------------------------------------------------------------------------------------------------------------------------
    @ Change history: 1.11.2018 / TAPAS TULO / Created the method.
    **************************************************************************************************************************************************************/
    @AuraEnabled
    public static opportunity saveOpportunityRec(Opportunity opty, Id aAccountRecId , string currencyNew){
        String cur1 = currencyNew;
        String currencyUpdated = cur1.left(3);
        
        id currentLoggedInUser=UserInfo.getUserId() ;
        List<Profile> currentProfile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String loggedInProflieName = currentProfile[0].Name;
        Map<String,String> profileToRecordType = new Map<String, String>();
        profileToRecordType.put('ES&A Non-Restricted User','EPM_Single_Service_Line');
        profileToRecordType.put('ES&A Restricted User','EPM_Single_Service_Line');
        profileToRecordType.put('System Administrator','Huron');
        profileToRecordType.put('Life Sciences Restricted User','Huron');
        profileToRecordType.put('Life Sciences Non-Restricted User','Huron');
        profileToRecordType.put('HBA Non-Restricted User','HBA');
        profileToRecordType.put('HBA Restricted User','HBA');
        profileToRecordType.put('HC Non-Restricted User','HC_Single_or_Child');
        profileToRecordType.put('HC Restricted User','HC_Single_or_Child');
        profileToRecordType.put('HCS Restricted User','Healthcare_Software');
        profileToRecordType.put('EDU Restricted User','ELS');
        profileToRecordType.put('EDU Non-Restricted User','ELS');
        
        List<RecordType> selectedRecordType = [SELECT Id,Name,DeveloperName, Sobjecttype  FROM RecordType WHERE DeveloperName =:profileToRecordType.get(loggedInProflieName) AND SObjecttype = 'Opportunity' LIMIT 1];
        opty.RecordTypeId=selectedRecordType[0].Id;
        system.debug('RecordTypeId'+selectedRecordType[0].Id);
        opty.EPM_Sales_Lead__r=null;
        opty.Referred_Company__r =null;
        opty.Campaign =null;
        opty.Competitor__r =null; 
        opty.EPM_Delivery_Lead__r =null; 
        opty.EPM_Pre_Sales_Resource__r =null;
        opty.AccountId = aAccountRecId;
        opty.OwnerId = currentLoggedInUser;
        opty.StageName = 'Prospect (0-14%)';
        opty.currencyIsoCode = currencyUpdated;
        System.debug('opty  '+opty);
        try{
            if(opty.Amount == null){
                opty = new Opportunity();
            }else{
                //database.insert(opty, false);
                insert opty;
            }
        }
        catch(Exception e){
            System.debug('Exception '+e);
            opty = new Opportunity();
        }
        return opty; 
    }  
    
         @AuraEnabled
        public static List<String> getIndustry(){
                List<String> options = new List<String>();
               Schema.DescribeFieldResult fieldResult = opportunity.currencyIsoCode.getDescribe();
            system.debug('fieldResult--'+fieldResult.getPicklistValues());
                List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
               for (Schema.PicklistEntry p: pList) {
                   options.add(p.getValue() + ' - '+ p.getLabel());
                }
            system.debug('options-->'+options);
                return options;
            }

                     

}