global class SceduleRenewalToStandard implements Schedulable{
    global void execute(SchedulableContext sc) {
  ID BatchId = Database.executeBatch(new RenewalOpportunityforStandardNew(), 200);
}
 
  
  

}