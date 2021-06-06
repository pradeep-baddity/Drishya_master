@isTest
private class OpportunityParentChildSyncUtilTest {
    
    static testMethod void test_method_one() {
        //Create and insert a new Opp that will be the parent
        Opportunity p = new Opportunity();

        p.Name = 'Parent';
        p.CloseDate = Date.today();
        p.StageName = 'Prospecting';
        p.Engagement_Close_Date__c = Date.today();
        p.Probability = 33;
        p.RecordTypeID = '012U0000000MXbG';
        p.Estimated_Start_Date__c = Date.today() + 2;

        insert p;
        //Create and insert a child opp
        Opportunity c =  new Opportunity();
        c.Name = 'Child';
        c.CloseDate = Date.today() + 10;
        c.StageName = 'Qualification';
        c.Engagement_Close_Date__c = Date.today() + 10;
        c.Estimated_Start_Date__c = Date.today() + 10;
        c.Related_Opportunity__c = p.id;
        c.Probability = 44;
        c.RecordTypeID = '012U0000000Mfhr';

        insert c;
        //Query the parent opp and update it's fields
        Opportunity updateParent = [SELECT id, name,Estimated_Start_Date__c, CloseDate,StageName,Engagement_Close_Date__c,Probability, Related_Opportunity__c FROM Opportunity WHERE id =: p.id];

        updateParent.CloseDate = Date.today() + 15;
        updateParent.StageName = 'Needs Analysis';
        updateParent.Engagement_Close_Date__c = Date.today() + 15;
        updateParent.Estimated_Start_Date__c = Date.today() + 16;
        updateParent.Probability = 55;

        update updateParent;

        //Query and update the child fields
        Opportunity updateChild = [SELECT id, name, Estimated_Start_Date__c, CloseDate,StageName,Engagement_Close_Date__c,Probability, Related_Opportunity__c FROM Opportunity WHERE id =: c.id];
        
    }
}