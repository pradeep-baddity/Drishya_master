global class ScheduleContactProcessor implements Schedulable {
   global void execute(SchedulableContext SC) {
      ContactProcessor C = new Contactprocessor(); 
      database.executebatch(C);
   }
}