public class CommonLoggingUtils{

	private String additionalInfoOverride;
	private static String SOURCE_SYSTEM = 'Salesforce';
	private List<Error_Log__c> exList;
	public Integer exCount {
		get {
			return (exList == null) ? 0 : exList.size();
		}
	}
	
	private CommonLoggingUtils() {
		exList = new List<Error_Log__c>();
	}
	private static CommonLoggingUtils instance = null;
	public static CommonLoggingUtils getInstance() {
		if (instance == null) {	instance = new CommonLoggingUtils(); }
		return instance;
	}
	
	public void Flush() {
		insert exList;
		exList.clear();
	}
	
	// LOGGING METHODS ------------------------------/
	public void LogApexException(Exception e) {
		LogApexException(e, null);
	}
	public void LogApexException(Exception e, String additionalMsg) {
		Error_Log__c elog 		= new Error_Log__c();
		elog.Source_System__c 	= SOURCE_SYSTEM;
		elog.Exception_Type__c 	= e.getTypeName();
		elog.Message__c 		= e.getMessage();
		elog.Additional_Info__c = (additionalInfoOverride != null) ? additionalInfoOverride : additionalMsg;
		elog.Stack_Trace__c 	= e.getStackTraceString();
		
		exList.add(elog);
	}
	public void LogDatabaseError(Database.Error[] errors, String additionalMsg) {
		
		for (Database.Error err : errors) {
			Error_Log__c elog	 	= new Error_Log__c();
			elog.Source_System__c 	= SOURCE_SYSTEM;
			elog.Exception_Type__c 	= 'System.DmlException';
			elog.Additional_Info__c = (additionalInfoOverride != null) ? additionalInfoOverride : additionalMsg;
			elog.Stack_Trace__c 	= GenerateStackTrace(true);
			elog.Message__c 		= GetPrettyDatabaseErrorString(err);
			
			exList.add(elog);
		}
	}
	
	public void LogDatabaseError(String message) { LogDatabaseError(message, null); }
	public void LogDatabaseError(String message, String additionalMsg) {
		Error_Log__c elog	 	= new Error_Log__c();
		elog.Source_System__c 	= SOURCE_SYSTEM;
		elog.Exception_Type__c 	= 'System.DmlException';
		elog.Additional_Info__c = additionalMsg;
		elog.Stack_Trace__c 	= GenerateStackTrace(true);
		elog.Message__c 		= message;
		elog.Additional_Info__c = (additionalInfoOverride != null) ? additionalInfoOverride : null;
		
		exList.add(elog);
	}
	
	public void LogDatabaseException(String doingWhat, SObject[] dmlRecords, DmlException e) {
		
		for (Integer i = 0; i < e.getNumDml(); i++) {
			SObject record = dmlRecords.get(i);
			
			Error_Log__c elog 		= new Error_Log__c();
			elog.Source_System__c 	= SOURCE_SYSTEM;
			elog.Exception_Type__c 	= e.getTypeName();
			elog.Stack_Trace__c		= e.getStackTraceString();
			elog.Message__c			= FormatDmlErrorMessage(doingWhat, e, record, i);
			elog.Additional_Info__c = (additionalInfoOverride != null) ? additionalInfoOverride : null;

			exList.add(elog);
		}
		
	}
	
	
	
	// HELPER METHODS ----------------------------------/
	public void SetAdditionalInfoOverride(String message) { this.additionalInfoOverride = message; }
	public void ClearAdditionalInfoOverride() { this.additionalInfoOverride = null; }
	
	public static String GenerateStackTrace(Boolean inLogger) {
		String retObj = '';
		
		try	{
            throw new LoggerException();
			
        } catch (LoggerException e){
			
            String stackTrace = e.getStackTraceString();
            List<String> stackLines = stackTrace.split('\n');

			Integer j;
			if (inLogger) {
				// We need to skip 2 lines if this method is being called from another method in this class
				j = 2;
			} else {
				j = 1;
			}
			for (Integer i = j; i < stackLines.size(); i++) {
				String line = stackLines.get(i);
				retObj += line;
				if (i < (stackLines.size()-1)) { retObj += '\n'; }
			}
        }
		System.debug(retObj);
		return retObj;
	}
	
	public static String GetPrettyDatabaseErrorString(Database.Error dberror) {
		String retObj = null;
		retObj = dberror.getStatusCode().name() + ': ' + dberror.getMessage();
		return retObj;
	}
	
	public static String FormatDmlErrorMessage(String doingWhat, DmlException e, SObject record, Integer recordIndex) {
		String retObj = '';

		String dmlFieldNames 	= String.join(e.getDmlFieldNames(recordIndex), ', ');
		String dmlId 			= e.getDmlId(recordIndex);
		Integer dmlIndex 		= e.getDmlIndex(recordIndex);
		String dmlMessage 		= e.getDmlMessage(recordIndex);
		String dmlType 			= e.getDmlType(recordIndex).name();
		
		String objName 			= record.getSObjectType().getDescribe().getName();
		String parenInfo 		= '(Index=' + dmlIndex + ', Id=' + dmlId + ', Fields=[' +  + '])';
		
		retObj += 'Failed to ' + doingWhat + ' ' + objName + ' ' + parenInfo + ' - ' + dmlType + ' - ' + dmlMessage;
		return retObj;
	}
	
	public static String[] GetDmlErrorMessages(String doingWhat, SObject[] dmlRecords, DmlException e) {
		String[] retObj = new String[]{};
		
		for (Integer i = 0; i < e.getNumDml(); i++) {
			SObject record = dmlRecords.get(i);
			
			String msg = FormatDmlErrorMessage(doingWhat, e, record, i);
			retObj.add(msg);
		}
		return retObj;
	}
	
	public static ApexPages.Message ConvertExceptionToPageMessage(Exception e) {
		String msg = '<strong>' + e.getTypeName() + ': ' + e.getMessage() + '</strong>';
		msg += '<br />';
		msg += e.getStackTraceString().replace('\n', '<br/>');
		
		return new ApexPages.message(ApexPages.severity.ERROR, msg);
	}
	
	// Custom exception used to generate stacktrace
	public class LoggerException extends Exception{}
}