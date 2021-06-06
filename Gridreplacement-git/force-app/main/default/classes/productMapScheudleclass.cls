global class productMapScheudleclass implements Schedulable {
    global void execute(SchedulableContext ctx) {
        Id batchId = database.executeBatch(new productMapUpdate(),400);
        
    }
    
}