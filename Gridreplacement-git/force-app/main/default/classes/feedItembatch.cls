global class feedItembatch implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
    
    return database.getQueryLocator([SELECT id,parentid,Type FROM FeedItem where createdbyid='0050B000007vnxy' and type ='createrecordevent']);
    }
    global void execute(Database.BatchableContext bc, List<feeditem> feeds){
        database.delete(feeds);
    } 
    global void finish(Database.BatchableContext bc){
        
    } 
    
    

}