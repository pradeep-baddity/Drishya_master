@istest(seealldata=false)
public class CreateContactTask_Test 
{
    public TestMethod static void CreateTaskMethod()
    {
        Set<id> ids = new Set<id>();
        Contact con = New Contact();
        	con.lastname ='test last name';
        	con.FirstName='test first name';
        	con.DemandWaterfallStage__c='Opportunity';
        ids.add(con.id);
        insert con;
        System.debug('Contact size=======>'+ids.size());
        Task tsk = new Task();
        	tsk.WhoId=con.id;
        	tsk.Subject = 'Follow up with Contact';
        insert tsk;
        Test.startTest();
        CreateContactTask.create_contact_Task(ids);
        Test.stopTest();
    }
}