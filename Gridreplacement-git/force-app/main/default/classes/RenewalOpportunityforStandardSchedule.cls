global class RenewalOpportunityforStandardSchedule implements Schedulable {
    global void execute(SchedulableContext ctx) {
        Id batchId = database.executeBatch(new RenewalOpportunityforStandard(),2000);
        
    }
    
}