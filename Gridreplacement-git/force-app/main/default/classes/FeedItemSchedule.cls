global class FeedItemSchedule implements Schedulable {
    global void execute(SchedulableContext ctx) {
        Id batchId = database.executeBatch(new feedItembatch(),2000);
        
    }
    
}