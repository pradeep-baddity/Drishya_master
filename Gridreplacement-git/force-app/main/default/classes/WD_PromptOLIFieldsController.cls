public class WD_PromptOLIFieldsController {
    @AuraEnabled 
    public Static List<opportunityLineItem> fetchOpportunityProducts(String aRecordID){
        Map<id,opportunityLineItem> mapOfIdtoOLI = new Map<id,opportunityLineItem>() ;
        List<opportunityLineItem> lOLI =[Select Id,name,ProductName__c,ApexProductName__c,Technology_Module__c,Software_Usage_Level__c,OpportunityId from opportunityLineItem WHERE 
                                         (Technology_Module__c = NULL OR Software_Usage_Level__c= NULL )
                                         AND WD_Additional_Info_Prompt__c =TRUE AND
                                         OpportunityId =: aRecordID ];
        System.debug('opportunityLineItem ***>'+lOLI );
        try{
        if(lOLI.size() >0){
            return lOLI;
        }
        else
            return null;
        }catch(Exception e){
            return null;
        }
    }
}