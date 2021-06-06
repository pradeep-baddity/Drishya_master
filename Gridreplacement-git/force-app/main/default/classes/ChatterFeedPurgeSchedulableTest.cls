@isTest
private class ChatterFeedPurgeSchedulableTest {
    
    public static String CRON_EXP = '0 0 0 * * ? 2020';
    static testMethod void testSchedulable() {
        
        ChatterFeedPurgeTestFactory.InsertCustomSettings(90,90);
        
        Test.startTest();
        String jobId = System.schedule('myTask', CRON_EXP, new ChatterFeedPurgeSchedulable());
        Test.stopTest();
    }
}