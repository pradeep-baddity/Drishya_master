public without sharing class Covid19CaresActController {
    @AuraEnabled
    public static String getMetadataHeadings(){
        Map<String, COVID_19_Cares_Act_Heading__mdt> headings = new Map<String, COVID_19_Cares_Act_Heading__mdt>();
        for(COVID_19_Cares_Act_Heading__mdt heading : [SELECT Id, DeveloperName, Heading__c FROM COVID_19_Cares_Act_Heading__mdt]){
            headings.put(heading.DeveloperName, heading);
        }
        return JSON.serialize(headings);
    }
    @AuraEnabled
    public static String getMetadataHelpText(){
        Map<String, Map<String, String>> helpTextMap = new Map<String, Map<String, String>>();
        for(COVID_19_Field_Help_Text__mdt helpText : [SELECT Id, Object__r.QualifiedApiName, Field__r.QualifiedApiName, Help_Text__c FROM COVID_19_Field_Help_Text__mdt]){
            if(!helpTextMap.containsKey(helpText.Object__r.QualifiedApiName)){
                helpTextMap.put(helpText.Object__r.QualifiedApiName, new Map<String, String>());
            }
            helpTextMap.get(helpText.Object__r.QualifiedApiName).put(helpText.Field__r.QualifiedApiName, helpText.Help_Text__c);
        }
        return JSON.serialize(helpTextMap);
    }
    @AuraEnabled
    public static String getFieldSets(){
        Map<String, List<FieldSetMember>> fieldSetMap = new Map<String, List<FieldSetMember>>();
        fieldSetMap.put('reliefItems', SObjectType.COVID_19_Relief_Item__c.FieldSets.COVID_19_Results.getFields());
        fieldSetMap.put('moreInfo', SObjectType.COVID_19_Relief_Item__c.FieldSets.COVID_19_More_Information.getFields());
        fieldSetMap.put('submission', SObjectType.COVID_19_Submission__c.FieldSets.COVID_19_Submission.getFields());
        fieldSetMap.put('lead', SObjectType.Lead.FieldSets.COVID_19_Lead.getFields());
        return JSON.serialize(fieldSetMap);
    }
    @AuraEnabled
    public static String getCheckExistingLead(String email){
        String leadId;
        List<Lead> existingLeads = [SELECT Id FROM Lead WHERE Legacy_Source_System__c = 'COVID Form' AND Email = :email ORDER BY CreatedDate DESC LIMIT 1];
        Set<String> submissionFields = new Set<String>();
        for(FieldSetMember fsm : SObjectType.COVID_19_Submission__c.FieldSets.COVID_19_Submission.getFields()){
            submissionFields.add(fsm.getFieldPath());
        } 

        COVID_19_Submission__c submission;
        if(existingLeads.size() > 0){
            leadId = existingLeads[0].Id;
            List<COVID_19_Submission__c> submissions = (List<COVID_19_Submission__c>)database.query('SELECT '+ String.join(new List<String>(submissionFields), ',') +' FROM COVID_19_Submission__c WHERE Lead__c = :leadId ORDER BY CreatedDate DESC LIMIT 1');
            if(submissions.size() > 0){
                submission = submissions[0];
            }
        }
        Map<String, Object> returnMap = new Map<String, Object>{'leadId'=>leadId, 'submission'=>submission};
        return JSON.serialize(returnMap);
    }
    @AuraEnabled
    public static String updateLead(String leadParams, String hash){
        Map<String, List<Covid_19_Cares_Act_Object_Handler__mdt>> objectHandlers = new Map<String, List<Covid_19_Cares_Act_Object_Handler__mdt>>();
        for(Covid_19_Cares_Act_Object_Handler__mdt handler : [SELECT Field__r.QualifiedApiName, Object__r.QualifiedApiName, Value__c FROM Covid_19_Cares_Act_Object_Handler__mdt]){
            if(!objectHandlers.containsKey(handler.Object__r.QualifiedApiName)){
                objectHandlers.put(handler.Object__r.QualifiedApiName, new List<Covid_19_Cares_Act_Object_Handler__mdt>());
            }
            objectHandlers.get(handler.Object__r.QualifiedApiName).add(handler);
        }
        Map<String, Object> returnMap = new Map<String, Object>();
        Lead lead = (Lead)JSON.deserialize(leadParams, Lead.class);
        if(objectHandlers.containsKey('Lead')){
            for(Covid_19_Cares_Act_Object_Handler__mdt handler : objectHandlers.get('Lead')){
                if(handler.Field__r.QualifiedApiName == 'OwnerId'){
                    for(Group grp : [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = :handler.Value__c]){
                        lead.OwnerId = grp.Id;
                    }
                }else{
                    lead.put(handler.Field__r.QualifiedApiName, handler.Value__c);
                }
            }
        }
        Campaign covidCampaign;
        if(objectHandlers.containsKey('Campaign')){
            for(Covid_19_Cares_Act_Object_Handler__mdt handler : objectHandlers.get('Campaign')){
                if(handler.Field__r.QualifiedApiName == 'Name'){
                    for(Campaign camp : [SELECT Id FROM Campaign WHERE Name = :handler.Value__c LIMIT 1]){
                        covidCampaign = camp;
                    }
                    break;
                }
            }
        }
        
        if(String.isBlank(hash)){
            returnMap.put('hash', EncodingUtil.base64Encode(Crypto.generateAesKey(256)).right(50));
        }else{
            returnMap.put('hash', hash);
        }
        Boolean validHash = false;
        Boolean isDuplicateLead = false;
        if(lead.Id != null){
            List<Lead> leadList = [SELECT Id, COVID_19_Form_Hash__c FROM Lead WHERE Id = :lead.Id AND Legacy_Source_System__c = 'COVID Form' LIMIT 1];
            if(leadList.size() > 0 && leadList[0].COVID_19_Form_Hash__c == returnMap.get('hash')){
                validHash = true;
            }
        }else{
            validHash = true;
            List<Lead> leadList = [SELECT Id FROM Lead WHERE LastName=:lead.LastName AND Email=:lead.Email AND Legacy_Source_System__c = 'COVID Form' LIMIT 1];
            if(leadList.size() > 0){
                Lead l = leadList[0];
                lead.id = l.Id;
                isDuplicateLead = true;
            }
        }
        returnMap.put('duplicateLead', isDuplicateLead);
        if(validHash){
            try{
                lead.COVID_19_Form_Hash__c = (String)returnMap.get('hash');
                Boolean createCM = lead.Id == null;
                upsert lead;
                returnMap.put('leadId', lead.Id);
                if(covidCampaign != null && createCM == true){
                    CampaignMember cMember = new CampaignMember();
                    cMember.LeadId = lead.Id;
                    cMember.CampaignId = covidCampaign.Id;
                    if(objectHandlers.containsKey('CampaignMember')){
                        for(Covid_19_Cares_Act_Object_Handler__mdt handler : objectHandlers.get('CampaignMember')){
                            cMember.put(handler.Field__r.QualifiedApiName, handler.Value__c);
                        }
                    }
                    insert cMember;
                }
            }catch(Exception e){
                returnMap.put('error', e.getMessage());
            }
        }else{
            returnMap.put('error', 'Provided hash is not valid');
        }
        return JSON.serialize(returnMap);
    }
    @AuraEnabled
    public static String getSaveReliefItems(String inputParams){
        List<Covid_19_Relief_Item__c> reliefItems = new List<Covid_19_Relief_Item__c>();
        Covid_19_Submission__c submission;
        try{
            submission = (Covid_19_Submission__c)JSON.deserialize(inputParams, Covid_19_Submission__c.class);
        }catch(Exception e){}
        if(submission != null){
            List<String> organizationTypes = new List<String>();
            if(String.isNotBlank(submission.Organization_Type__c)){
                organizationTypes = submission.Organization_Type__c.split(';');
            }
            if(submission.Id != null){
                delete [SELECT Id FROM COVID_19_Result__c WHERE Covid_19_Submission__c = :submission.Id];
            }
            Set<String> fields = new Set<String>();
            for(FieldSetMember fsm : SObjectType.COVID_19_Relief_Item__c.FieldSets.COVID_19_Results.getFields()){
                fields.add(fsm.getFieldPath());
            }
            for(FieldSetMember fsm : SObjectType.COVID_19_Relief_Item__c.FieldSets.COVID_19_More_Information.getFields()){
                fields.add(fsm.getFieldPath());
            }
            fields.add('Huron_Internal_Reference_Number__c');
            List<Covid_19_Relief_Item__c> allReliefItems = Database.query('SELECT Id, '+ String.join(new List<String>(fields), ',') +' FROM Covid_19_Relief_Item__c WHERE (Industry__c = NULL '+(String.isNotBlank(submission.Industry__c) ? 'OR Industry__c = \''+String.escapeSingleQuotes(submission.Industry__c)+'\'' : '')+') AND (Organization_Type__c = NULL '+(String.isNotBlank(submission.Organization_Type__c) ? 'OR Organization_Type__c IN (\''+String.join(String.escapeSingleQuotes(submission.Organization_Type__c).split(';'),'\',\'')+'\')' : '')+') AND (Organization_Size__c = NULL '+(String.isNotBlank(submission.Organization_Size__c) ? 'OR Organization_Size__c = \''+String.escapeSingleQuotes(submission.Organization_Size__c)+'\'' : '')+') ORDER BY Type__c, Maximum_Funding_Amount__c, Title__c, Subtitle__c');
            List<Covid_19_Result__c> results = new List<Covid_19_Result__c>();
            Set<String> referenceNumbers = new Set<String>();
            for(Covid_19_Relief_Item__c reliefItem : allReliefItems){
                if(!referenceNumbers.contains(reliefItem.Huron_Internal_Reference_Number__c)){
                    referenceNumbers.add(reliefItem.Huron_Internal_Reference_Number__c);
                    reliefItems.add(reliefItem);
                }
                results.add(new Covid_19_Result__c(Covid_19_Relief_Item__c = reliefItem.Id, Covid_19_Submission__c = submission.Id));
            }
            if(submission.Id != null)
            insert results;
        }
        return JSON.serialize(reliefItems);
    }
}