global class ChatterFeedPurgeSchedulable implements Schedulable{

	global void execute(SchedulableContext context) {
		
		Id batchId = Database.executeBatch(new ChatterFeedPurgeBatchable());
		
	}
	
}