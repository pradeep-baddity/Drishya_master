global class RenewalOpportunityforRenewalMYRSchedule implements Schedulable {
    global void execute(SchedulableContext ctx) {
        Id batchId = database.executeBatch(new RenewalOpportunityforRenewalStuderMYR(),2000);
        
    }
    
}