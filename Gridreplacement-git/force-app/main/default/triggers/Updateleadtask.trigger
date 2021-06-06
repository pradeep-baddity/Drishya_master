trigger Updateleadtask on Lead (after update) {
     Set<ID> ids = Trigger.newMap.keySet();
    List<Lead> led = [SELECT Id,Status From Lead where ((Id in :ids) AND (Status in('Rejected','Sales Qualified Opportunity')))];
    List<Lead> ledtask = new List<Lead>();
        List<Task> ledTasks = [SELECT id,whoid,Status,subject FROM Task WHERE Whoid in: led];
    List<Task> updateTasks = new List<Task>();
    if(ledTasks.size()>0)
    {
        for(Task itr_Lead_task :ledTasks)
        {
            itr_Lead_task.Status='Completed';
            updateTasks.add(itr_Lead_task);
        }
     update updateTasks;
    }

}