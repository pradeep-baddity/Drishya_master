global class productMapUpdate implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext bc) {
         string labelname = system.label.Product_Recordtype;
         system.debug('label--'+labelname);
         return database.getQueryLocator([select id, Opp_recordtype__c from opportunitylineitem where  Opp_recordtype__c != 'ELS'  ]);
    }
    global void execute(Database.BatchableContext bc, List<opportunitylineitem> op){
        list<id> listopp = new list<id>();
        for(opportunitylineitem opnew : op)
        {
            listopp.add(opnew.id);
        }
        if(listopp.size() >0 )
        {
            ProductMapAssignment.autoMapProduct(listopp);
        }
    }
    global void finish(Database.BatchableContext bc){
        
    }
}