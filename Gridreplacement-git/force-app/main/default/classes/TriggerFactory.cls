public with sharing class TriggerFactory{
	
	@testVisible
	private static CommonLoggingUtils log = CommonLoggingUtils.getInstance();
		
	public static void manufacture(Schema.SObjectType objType) {
		
		try {
			ITriggerHandler handler = getHandler(objType);
			if (handler == null) {
				throw new TriggerException('No Trigger Handler registered for Object Type: ' + objType);
			}
			execute(handler);
			
		} catch (Exception e) {
			log.LogApexException(e);
			
		} finally {
			log.Flush();
		}
		
	}
	
	@testVisible
	private static ITriggerHandler getHandler(Schema.SObjectType objType) {
		
		if (objType == Opportunity.sObjectType) {
			return new OpportunityMasterTriggerHandler();
		}
		return null;
		
	}
	
	private static void execute(ITriggerHandler handler) {

		if(Trigger.isInsert && Trigger.isBefore){
			handler.OnBeforeInsert(Trigger.new);
		}
		else if(Trigger.isInsert && Trigger.isAfter){
			handler.OnAfterInsert(Trigger.newMap);
		}
	    else if(Trigger.isUpdate && Trigger.isBefore){
	        handler.OnBeforeUpdate(Trigger.oldMap, Trigger.newMap);
	    }
	    else if(Trigger.isUpdate && Trigger.isAfter){
	        handler.OnAfterUpdate(Trigger.oldMap, Trigger.newMap);
	    }
		else if(Trigger.isDelete && Trigger.isBefore){
			handler.OnBeforeDelete(Trigger.oldMap);
		}
		else if(Trigger.isDelete && Trigger.isAfter){
			handler.OnAfterDelete(Trigger.oldMap);
		}
		else if(Trigger.isUnDelete){
			handler.OnUndelete(Trigger.new);   
		}

	}

	public class TriggerException extends Exception {}

}