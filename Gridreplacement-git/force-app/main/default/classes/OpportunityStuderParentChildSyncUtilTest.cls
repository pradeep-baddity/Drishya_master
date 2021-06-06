@isTest
private class OpportunityStuderParentChildSyncUtilTest {
    
    static testMethod void test_method_one() {
        //Create and insert a new Opp that will be the parent
        Opportunity ps = new Opportunity();

        ps.Name = 'Parent';
        ps.CloseDate = Date.today();
        ps.StageName = 'Prospecting (0%)';
        ps.Engagement_Close_Date__c = Date.today();
        ps.Probability = 33;
        ps.RecordTypeID = '012U0000000Mdas';
        ps.Estimated_Start_Date__c = Date.today() + 2;
        ps.Healthcare_Solutions2__c = 'Healthcare-Studer Group :1459';
        ps.Type = 'Bridge Opportunity';

        insert ps;
        //Create and insert a child opp
        Opportunity cs =  new Opportunity();
        cs.Name = 'Child';
        cs.CloseDate = Date.today() + 10;
        cs.StageName = 'Exploration (0% - 39%)';
        cs.Engagement_Close_Date__c = Date.today() + 10;
        cs.Estimated_Start_Date__c = Date.today() + 10;
        cs.Related_Opportunity__c = ps.id;
        cs.Probability = 44;
        cs.RecordTypeID = '012U0000000Mdat';
        cs.Healthcare_Solutions2__c = 'Healthcare-Studer Group :1459';
        cs.Type = 'Bridge Opportunity';

        insert cs;
        //Query the parent opp and update it's fields
        Opportunity updateParent = [SELECT id, Type, name,Estimated_Start_Date__c, CloseDate,StageName,Engagement_Close_Date__c,Probability, Related_Opportunity__c FROM Opportunity WHERE id =: ps.id];

        updateParent.CloseDate = Date.today() + 15;
        updateParent.StageName = 'Closing (90% - 100%)';
        updateParent.Engagement_Close_Date__c = Date.today() + 15;
        updateParent.Estimated_Start_Date__c = Date.today() + 16;
        updateParent.Probability = 55;

        update updateParent;

        //Query and update the child fields
        Opportunity updateChild = [SELECT id, name, Type, Estimated_Start_Date__c, CloseDate,StageName,Engagement_Close_Date__c,Probability, Related_Opportunity__c FROM Opportunity WHERE id =: cs.id];
        
    }
}