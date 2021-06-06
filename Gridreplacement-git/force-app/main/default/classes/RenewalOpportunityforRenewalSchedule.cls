global class RenewalOpportunityforRenewalSchedule implements Schedulable {
    global void execute(SchedulableContext ctx) {
        Id batchId = database.executeBatch(new RenewalOpportunityforRenewal(),2000);
        
    }
    
}