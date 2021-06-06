public class CommonDMLUtils{
	
	private static CommonLoggingUtils log = CommonLoggingUtils.getInstance();
	@testVisible private static Boolean forceTestException = false;
	
	public static DmlResults SafeDatabaseDelete(Id objId, Boolean allOrNothing) { return SafeDatabaseDelete(new Set<Id>(new Id[]{objId}), allOrNothing); }
	public static DmlResults SafeDatabaseDelete(Set<Id> objIds, Boolean allOrNothing) {
		if (objIds == null || (objIds != null && objIds.size() == 0)) { return new DmlResults(); }
		
		SObject[] objects = newObjectsFromIds(objIds);
		return SafeDatabaseDelete(objects, allOrNothing);
	}
	public static DmlResults SafeDatabaseDelete(SObject obj, Boolean allOrNothing) { return SafeDatabaseDelete(new SObject[]{obj}, allOrNothing); }
	public static DmlResults SafeDatabaseDelete(SObject[] objects, Boolean allOrNothing) {
		DmlResults retObj = new DmlResults();
		if (objects == null || (objects != null && objects.size() == 0)) { return retObj; }
		
		try {
			Database.DeleteResult[] results = Database.delete(objects, allOrNothing);

			for (Integer i = 0; i < results.size(); i++) {
				Database.DeleteResult result = results.get(i);
				SObject record = objects.get(i);
				ProcessDeleteResult(result, record, i, retObj);
			}
			
			if (Test.isRunningTest() && forceTestException) {
				Integer lolmath = 1/0;
			}
			
		} catch (DmlException e) {
			log.LogDatabaseException('delete', objects, e);
			retObj.AddFailMessage(CommonLoggingUtils.GetDmlErrorMessages('delete', objects, e));

		} catch (Exception e) {
			log.LogApexException(e);
		}
		
		return retObj;
	}
	
	
	public static DmlResults SafeDatabaseUpsert(SObject[] objects, Boolean allOrNothing) {
		DmlResults retObj = new DmlResults();
		if (objects == null || (objects != null && objects.size() == 0)) { return retObj; }
		
		try {
			Database.UpsertResult[] results = Database.upsert(objects, allOrNothing);
			
			for (Integer i = 0; i < results.size(); i++) {
				Database.UpsertResult result = results.get(i);
				SObject record = objects.get(i);
				ProcessUpsertResult(result, record, i, retObj);	
			}
			
			if (Test.isRunningTest() && forceTestException) {
				Integer lolmath = 1/0;
			}
			
		} catch (DmlException e) {
			log.LogDatabaseException('upsert', objects, e);
			retObj.AddFailMessage(CommonLoggingUtils.GetDmlErrorMessages('upsert', objects, e));

		} catch (Exception e) {
			log.LogApexException(e);
		}
		
		return retObj;
	}
	
	// HELPER METHODS ---------------------------/
	private static SObject[] newObjectsFromIds(Set<Id> objIds) {
		SObject[] retObj = new SObject[]{};
		
		for (Id objId : objIds) {
			Schema.SObjectType token = objId.getSObjectType();
			SObject obj = token.newSObject(objId);
			retObj.add(obj);
		}
		
		return retObj;
	}
	
	private static String CollapseDatabaseErrors(Database.Error[] errors) {
		String retObj = '';
		
		for (Integer j = 0; j < errors.size(); j++) {
			Database.Error error = errors.get(j);
			
			String errorMsg = error.getMessage();
			String errorFields = String.join(error.getFields(), ', ');
			String errorStatus 	= error.getStatusCode().name();
			
			retObj += ' Error #' + (j+1) + ' (Fields=[' + errorFields + '])' + ' - ' +  errorStatus + ' - ' + errorMsg;
		}
		return retObj;
	}
	
	// RESULT PROCESSING METHODS ----------------/
	
	private static void ProcessDeleteResult(Database.DeleteResult result, SObject record, Integer index, DmlResults resultsCallback) {
		Id objId = result.getId();
		String objName = record.getSObjectType().getDescribe().getName();
		String parenInfo = '(Index=' + index +', Id=' + objId + ')';
		
		if (result.isSuccess()) {
			String resultMsg = 'Successfully deleted ' + objName + ' ' + parenInfo;
			resultsCallback.AddSuccessMessage(resultMsg);
			
		} else {
			Database.Error[] errors = result.getErrors();
			String resultMsg = 'Failed to delete ' + objName + ' ' + parenInfo + ':' + CollapseDatabaseErrors(errors);
			
			log.LogDatabaseError(resultMsg);
			resultsCallback.AddFailMessage(resultMsg);
		}
	}
	
	private static void ProcessUpsertResult(Database.UpsertResult result, SObject record, Integer index, DmlResults resultsCallback) {
		Id objId = result.getId();
		String objName = record.getSObjectType().getDescribe().getName();
		String parenInfo = '(Index=' + index +', Id=' + objId + ')';
		
		if (result.isSuccess()) {
			String action = result.isCreated() ? 'insert' : 'update';
			String resultMsg = 'Successfully upserted::' + action + ' ' + objName + ' ' + parenInfo;

			resultsCallback.AddSuccessMessage(resultMsg);
			
		} else {
			Database.Error[] errors = result.getErrors();
			String resultMsg = 'Failed to upsert ' + objName + ' ' + parenInfo + ':' + CollapseDatabaseErrors(errors);
			
			log.LogDatabaseError(resultMsg);
			resultsCallback.AddFailMessage(resultMsg);
		}
	}
	
	// RESULT CLASS DEFINITION -----------------/
	public class DmlResults {
		public Map<Integer, String> successMessages { get; private set; }
		public Map<Integer, String> failMessages { get; private set; }
		
		public Integer numSuccess { get { return successMessages.size(); } }
		public Integer numFail { get { return failMessages.size(); } }
		public Integer numResults { get { return numSuccess + numFail; } }
		
		private Integer messagePosition;
		
		public DmlResults() {
			successMessages = new Map<Integer, String>();
			failMessages = new Map<Integer, String>();
			messagePosition = 0;
		}
		
		public void AddSuccessMessage(String[] messages) {
			for (String message : messages) {
				AddSuccessMessage(message);
			}
		}
		public void AddSuccessMessage(String message) {
			successMessages.put(messagePosition, message);
			messagePosition++;
		}
		public void AddFailMessage(String[] messages) {
			for (String message : messages) {
				AddFailMessage(message);
			}
		}
		public void AddFailMessage(String message) {
			failMessages.put(messagePosition, message);
			messagePosition++;
		}
		
		public List<String> GetInterpolatedMessageList() {
			List<String> retObj = new List<String>();
			
			for (Integer i = 0; i < messagePosition; i++) {
				if (successMessages.containsKey(i)) {
					retObj.add(successMessages.get(i));
					
				} else if (failMessages.containsKey(i)) {
					retObj.add(failMessages.get(i));
				}
			}
			
			return retObj;
		}
		public void PrintInterpolatedMessageList() {
			for (String msg : GetInterpolatedMessageList()) {
				System.debug(CommonConstants.DEBUG_PREFIX + msg);
			}
		}
	}
	
}