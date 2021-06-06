public class OpportunityMasterTriggerHandler implements ITriggerHandler{
    
    public OpportunityTotalAmountRollupTrigger rollupHandler;
    public OpportunityTopLevelAccountTrigger topAcctHandler;
    //public OpportunityParentChildSyncUtil parentChildSyncUtilHandler;
    //public OpportunityStuderParentChildSyncUtil parentChildStuderSyncUtilHandler;
    public BacklogManagerControllerExt sync;

    
    public OpportunityMasterTriggerHandler() {
        rollupHandler = new OpportunityTotalAmountRollupTrigger();
        topAcctHandler = new OpportunityTopLevelAccountTrigger();
        //parentChildSyncUtilHandler = new OpportunityParentChildSyncUtil();
        //parentChildStuderSyncUtilHandler = new OpportunityStuderParentChildSyncUtil();
    }
    
    // Type converts generic SObject map to Opportunity map
    private Map<Id, Opportunity> castMap(Map<Id, SObject> objMap) {
        return new Map<Id, Opportunity>((List<Opportunity>)objMap.values());
    }
    
    public void OnBeforeInsert(SObject[] newOpps) {

    //Update fields on the child record from the parent record upon insert
    //parentChildSyncUtilHandler.UpdateChildFieldsOnInsert(newOpps);
    //parentChildStuderSyncUtilHandler.UpdateChildFieldsOnInsert(newOpps);

    }
    
    public void OnAfterInsert(Map<Id, SObject> newMap) {
        
        // Update TotalOpportunityAmounts
        rollupHandler.RecalculateTotalAmountRollupFieldOnParents(newMap.values(), null);
        
        // Populate TopLevelOpportunityAccount lookup field
        topAcctHandler.PopulateTopLevelAccountLookupField(castMap(newMap));
        //Auto generate backlogs for HC Single or Child opportunities
      
            
        BacklogGeneratorController c = new BacklogGeneratorController();
        for (Id id : NewMap.keySet()) {
                Opportunity newOpp = newMap.values();
            if (((newOpp.recordTypeID == '012U0000000MdatIAC') && (newOpp.Healthcare_Solutions2__c <> 'Healthcare-Studer Group :1459') && (newOpp.Healthcare_Solutions2__c <> 'Healthcare-Studer Group Canada :7124')) || (newOpp.RecordTypeId == '012U0000000Mfhr') || ((newOpp.RecordTypeId == '012U0000000MXb1IAG') && (newOpp.type =='Renewal Opportunity') && (newOpp.ELS_Solution__c == 'Research Enterprise Solutions (RES)'))){
        Backlog__c[] blogs = c.GenerateBacklogs(newOpp);
                System.debug('Record type  ' + newOpp.recordTypeID + '  Opportunity Name  ' + newOpp.Name);
                insert blogs;   }}

    }
    
    public void OnBeforeUpdate(Map<Id, SObject> oldMap, Map<Id, SObject> newMap) {

        

    }
    
    public void OnAfterUpdate(Map<Id, SObject> oldMap, Map<Id, SObject> newMap) {
        
        // Update TotalOpportunityAmounts
        rollupHandler.RecalculateTotalAmountRollupFieldOnParents(castMap(oldMap), castMap(newMap)); 

        // Update Parent and Child related records
        // 
        //parentChildSyncUtilHandler.ComapreAndUpdateChildAndParentFields(castMap(oldMap), castMap(newMap));
        //system.debug('Studer syncing start');
        //parentChildStuderSyncUtilHandler.CompareAndUpdateChildAndParentFields(castMap(oldMap), castMap(newMap));
        system.debug('Studer syncing end');
        
        //Backlog update
        BacklogGeneratorController c = new BacklogGeneratorController();
        for (Id id : NewMap.keySet()) {
                Opportunity newOpp = newMap.values();
            system.debug('duration = ' + newOpp.Estimated_Duration__c);
            System.debug('Before Record type  ' + newOpp.recordTypeID + '  Opportunity Name  ' + newOpp.Name);
            system.debug('Before check BL = ' + newOpp.Backlog_Fields_Check__c);
           List<Backlog__c> retObj =  [SELECT
                                                                    Id
                                                                    ,Name
                                                                    ,Opportunity__c
                                                                    ,Type__c
                                                                    ,Date__c
                                                                    ,Projected_Amount__c
                                                                    ,Actual_Amount__c
                                                                    ,Has_Actuals__c
                                                        
                                                                FROM Backlog__c 
                                                                WHERE Opportunity__c = :newOpp.Id];
            System.debug('Before Backlog ' + retObj);
            
            if (newOpp.respread__c == False &&   (((newOpp.recordTypeID == '012U0000000MdatIAC') && (newOpp.Healthcare_Solutions2__c <> 'Healthcare-Studer Group :1459') && (newOpp.Healthcare_Solutions2__c <> 'Healthcare-Studer Group Canada :7124')) || (newOpp.RecordTypeId == '012U0000000Mfhr'|| ((newOpp.RecordTypeId == '012U0000000MXb1IAG') && (newOpp.type =='Renewal Opportunity') && (newOpp.ELS_Solution__c == 'Research Enterprise Solutions (RES)')))) &&  newOpp.Backlog_Fields_Check__c == true && newOpp.IsClosed ==False)
            {System.debug('Start');
                Map<Backlog__c[], Backlog__c[]> syncResults = c.GenerateSyncronizedBacklogs(retobj, newOpp, True);
             System.debug('Sync' + syncResults); 
            //delete retobj;
            System.debug('After Record type  ' + newOpp.recordTypeID + '  Opportunity Name  ' + newOpp.Name);
            Backlog__c[] toBeDeleted = syncResults.values()[0];
             Backlog__c[] toBeUpserted = new List<Backlog__c[]>(syncResults.keySet())[0];
            System.debug('After Backlog' + toBeUpserted);
            system.debug ('Before Backlog_Fields_Check__c = ' + newOpp.Backlog_Fields_Check__c);
            upsert toBeupserted;
            delete toBeDeleted;
            //newOpp.Backlog_Fields_Check__c = False;
             system.debug ('after Backlog_Fields_Check__c = ' + newOpp.Backlog_Fields_Check__c);
            //update newOpp;
            }
            if (newOpp.respread__c == False &&   (newOpp.recordTypeID == '012U0000000MdatIAC' || ((newOpp.RecordTypeId == '012U0000000MXb1IAG') && (newOpp.type =='Renewal Opportunity') && (newOpp.ELS_Solution__c == 'Research Enterprise Solutions (RES)')))&& newOpp.Backlog_Fields_Check__c == true && newOpp.IsClosed ==False){
            Backlog__c[] blogs = c.GenerateBacklogs(newOpp);
                System.debug('Record type  ' + newOpp.recordTypeID + '  Opportunity Name  ' + newOpp.Name);
                insert blogs;    
            }
        }
        
        
            
    }
    
    public void OnBeforeDelete(Map<Id, SObject> oldMap) {
        
    }
    
    public void OnAfterDelete(Map<Id, SObject> oldMap) {

        // Update TotalOpportunityAmounts
        rollupHandler.RecalculateTotalAmountRollupFieldOnParents(oldMap.values(), null);
    }
    
    public void OnUndelete(SObject[] newOpps) {

        // Update TotalOpportunityAmounts
        rollupHandler.RecalculateTotalAmountRollupFieldOnParents(newOpps, null);
    }
}