public interface ITriggerHandler{
	
	void OnBeforeInsert(SObject[] newList);
	void OnAfterInsert(Map<Id, SObject> newMap);
	
	void OnBeforeUpdate(Map<Id, SObject> oldMap, Map<Id, SObject> newMap);
	void OnAfterUpdate(Map<Id, SObject> oldMap, Map<Id, SObject> newMap);
	
	void OnBeforeDelete(Map<Id, SObject> oldMap);
	void OnAfterDelete(Map<Id, SObject> oldMap);
	
	void OnUndelete(SObject[] newList);
}