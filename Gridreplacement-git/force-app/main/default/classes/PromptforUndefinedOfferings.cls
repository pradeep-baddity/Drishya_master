public class PromptforUndefinedOfferings {
    @AuraEnabled
    public static Boolean checkforundefined(Id opportunityrecordId){
        boolean flag = false;
        Opportunity oppty = [select id,name,Probability,RecordTypeId,stageName,RecordType.Name,Stage_Prior_value__c,Undefined_offerings__c from Opportunity where Id = : opportunityrecordId LIMIT 1];
        if( (oppty.Probability >=30) && (oppty.StageName <> oppty.Stage_Prior_value__c) && (oppty.Undefined_offerings__c > 0))
        {
            system.debug('check inside--'); 
            flag = true;               
        }
        
        return flag;
    }
    
    @AuraEnabled
    public static void clickNo(Id opportunityrecordId){
        system.debug(opportunityrecordId);
        Opportunity oppty = [select id,name,stageName, Stage_Prior_value__c,Undefined_offerings__c from Opportunity where Id = : opportunityrecordId LIMIT 1];
        oppty.stageName = oppty.Stage_Prior_value__c;
        oppty.Stage_Prior_value__c = '';
        update oppty;
    }
}