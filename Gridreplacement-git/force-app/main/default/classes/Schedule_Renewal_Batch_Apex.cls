global class Schedule_Renewal_Batch_Apex  implements Schedulable{
    
    

global void execute(SchedulableContext sc) {
    
  ID BatchId = Database.executeBatch(new Renewal_Opportunity_for_Standard(), 10);
  
}
 
    
Public static void SchedulerMethod() {
   // integer timeinterval = '0 0/15 0 1/1 0 ? 0';
    //String timeinterval = '0 */10 * ? * *';
  //  String timeinterval = '0 15 * * * ?';
    //String timeinterval = '* 0 * * * ?';
  // System.schedule('Every15mins',timeinterval, new Schedule_Renewal_Batch_Apex());
    
	datetime thisTime = system.now().addMinutes(15); 
	integer minute = thisTime.minute(); 
	integer second = thisTime.second(); 
	integer hour = thisTime.hour(); 
	integer year = thisTime.year(); 
	integer month = thisTime.month(); 
	integer day = thisTime.day(); 

	String timeinterval = second + ' ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ? ' + year; 
	//String jobName = 'Renewal_Opportunity_for_Standard'; 

    //Renewal_Opportunity_for_Standard p = new Renewal_Opportunity_for_Standard(); 
	system.schedule('Schedule_Renewal_Batch_Apex', timeinterval,new Schedule_Renewal_Batch_Apex()); 

  }
}