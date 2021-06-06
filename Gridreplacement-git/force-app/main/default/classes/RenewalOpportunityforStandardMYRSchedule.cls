global class RenewalOpportunityforStandardMYRSchedule implements Schedulable {
    global void execute(SchedulableContext ctx) {
        Id batchId = database.executeBatch(new RenewalOpportunityforStandardStuderMYR(),2000);
        
    }
    
}