global class EduOpportunityRenewalScheduler implements Schedulable {
    global void execute(SchedulableContext ctx) {
        Id batchId = database.executeBatch(new EduOpportunityRenewal(),2000);
        
    }
    
}