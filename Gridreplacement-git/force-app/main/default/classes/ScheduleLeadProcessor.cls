global class ScheduleLeadProcessor implements Schedulable{
   global void execute(SchedulableContext SC) {
      LeadProcessor M = new Leadprocessor(); 
      database.executebatch(M);
   }
}