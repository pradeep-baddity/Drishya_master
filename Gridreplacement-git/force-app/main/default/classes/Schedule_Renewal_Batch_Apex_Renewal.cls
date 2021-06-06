global class Schedule_Renewal_Batch_Apex_Renewal implements Schedulable{
global void execute(SchedulableContext sc) {
    
  ID BatchId = Database.executeBatch(new Renewal_Opportunity_for_Renewal(), 10);
  
}
 
}