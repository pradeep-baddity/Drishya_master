global class SceduleRenewalToStandardHC implements Schedulable{
    global void execute(SchedulableContext sc) {
  ID BatchId = Database.executeBatch(new RenewalOpportunityforStandardNewHC(), 200);
}
 Public static void SchedulerMethod() {
  string timeinterval = '0 15 * * * ?';
  System.schedule('Every15mins',timeinterval, new SceduleRenewalToStandardHC());
  }
  
  

}