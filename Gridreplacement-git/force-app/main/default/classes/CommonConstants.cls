public class CommonConstants{
	
	public static final String DEBUG_PREFIX = '************************************** ';
	public static Boolean IS_SANDBOX {
		get {
			if (IS_SANDBOX == null) {
				Organization o = [SELECT Id, IsSandbox FROM Organization LIMIT 1];
				IS_SANDBOX = o.IsSandbox;
			}
			return IS_SANDBOX;
		}
	}
	
	public static Boolean FIRST_RUN = true;
	


}