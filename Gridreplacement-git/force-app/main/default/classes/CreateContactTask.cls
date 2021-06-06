public class CreateContactTask 
{
    public static void create_contact_Task(Set<id> ids)
    {
   		 List<Contact> Rejected_SQOpp_Contacts  = [SELECT Id,DemandWaterfallStage__c FROM Contact WHERE ((Id in :ids) AND (DemandWaterfallStage__c in('Rejected','Opportunity')))];
    	 List<Contact> contacttasks =new List<Contact>();
    	 List<Task> conTasks = [SELECT id,whoid,subject FROM Task WHERE Whoid in: Rejected_SQOpp_Contacts];
    	 List<Task> updateTasks = new List<Task>();
       	if(conTasks.size()>0)
    	{
        	for(Task itr_Contact_task :conTasks)
        	{
            	itr_Contact_task.Status='Completed';
            	updateTasks.add(itr_Contact_task);
        	}
     		update updateTasks;
    	}
    }
}