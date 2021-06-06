global class scheduleupdate implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext bc) {
         
         return database.getQueryLocator([select id, opportunitylineitemID,Description , OpportunityLineItem.Opp_recordtype__c from opportunitylineitemschedule]);
    }
    global void execute(Database.BatchableContext bc, List<opportunitylineitemschedule> opplineschedule){
        list<opportunitylineitemschedule> listopp = new list<opportunitylineitemschedule>();
        for(opportunitylineitemschedule op : opplineschedule)
        {
            listopp.add(op);
        }
        if(listopp.size() >0 )
        {
            update listopp;
        }
    }
    global void finish(Database.BatchableContext bc){
        
    }
}