@isTest
public class Covid19CaresActControllerTest {
    @testSetup
    public static void testSetup(){
        List<Covid_19_Relief_Item__c> reliefItems = new List<Covid_19_Relief_Item__c>();
        reliefItems.add(new Covid_19_Relief_Item__c(Industry__c='Public Sector', Organization_Type__c='State & Local', Huron_Internal_Reference_Number__c = '1'));
        reliefItems.add(new Covid_19_Relief_Item__c(Huron_Internal_Reference_Number__c = '2'));
        reliefItems.add(new Covid_19_Relief_Item__c(Industry__c='Public Sector', Huron_Internal_Reference_Number__c = '3'));
        reliefItems.add(new Covid_19_Relief_Item__c(Industry__c='Other'));
        insert reliefItems;
        String campaignName;
        for(Covid_19_Cares_Act_Object_Handler__mdt handler : [SELECT Object__r.QualifiedApiName, Field__r.QualifiedApiName, Value__c FROM Covid_19_Cares_Act_Object_Handler__mdt]){
            if(handler.Object__r.QualifiedApiName == 'Campaign' && handler.Field__r.QualifiedApiName == 'Name'){
                campaignName = handler.Value__c;
            }
        }
        if(String.isNotBlank(campaignName)){
            insert new Campaign(Name=campaignName);
        }
    }

    public static TestMethod void misc(){
        Covid19CaresActController.getMetadataHeadings();
        Covid19CaresActController.getFieldSets();
        Covid19CaresActController.getMetadataHelpText();
    }
    public static TestMethod void getSaveReliefItems(){
        Covid_19_Submission__c submission = new Covid_19_Submission__c(Industry__c='Public Sector', Organization_Type__c='State & Local');
        insert submission;
        String reliefItems = Covid19CaresActController.getSaveReliefItems(JSON.serialize(submission));
        List<Covid_19_Relief_Item__c> reliefItemsList = (List<Covid_19_Relief_Item__c>)JSON.deserialize(reliefItems, List<Covid_19_Relief_Item__c>.class);
    }

    public static TestMethod void updateLead(){
        Lead l = new Lead(FirstName='TestFirstNameCovid', LastName='TestLastNameCovid', Company='TestCompany', Email='TestFirstNameCovid.TestLastNameCovid@example.com');
        String result = Covid19CaresActController.updateLead(JSON.serialize(l), '');
        System.assertEquals(1, [SELECT count() FROM Lead]);
        Map<String, Object> resultMap = (Map<String, Object>)JSON.deserializeUntyped(result);
        l.Id = (String)resultMap.get('leadId');
        l.FirstName = 'TestFirstNameCovidUpdate';
        Covid19CaresActController.updateLead(JSON.serialize(l), (String)resultMap.get('hash'));
        System.assertEquals(1, [SELECT count() FROM Lead]);
        System.assertEquals(l.FirstName, [SELECT FirstName FROM Lead].FirstName);
    }
}