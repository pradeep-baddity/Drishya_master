@isTest 
public class feedItemBatchTest 
{
    static testMethod void testMethod1() 
    {
        List<feeditem> lstFeed= new List<feeditem>();
        list<User> u = [select Id from user where id = '0050B000007vnxy'];

        Account acc = new Account();
        acc.name = 'Test Account';
        acc.recordtypeId = '012U0000000MZ5A';
        insert acc;
        
        Opportunity newOpp = new Opportunity();
        newOpp.Name = 'test opp';
        newOpp.AccountId = acc.id;
        newOpp.closeDate = system.today();
        newOpp.StageName = 'Prospecting';
        newOpp.recordtypeId = '012U0000000MZDE';
        insert newOpp;
        
        Campaign cam = new Campaign(name = 'Test campaign');
        insert cam;
        
        LeanData__Temporary_Marketing_Touch__c tempMark = new LeanData__Temporary_Marketing_Touch__c();
        tempMark.LeanData__Campaign__c = cam.id;
        tempMark.LeanData__Opportunity__c = newOpp.id;
        insert tempMark;
                                   
        for(Integer i=0 ;i <200;i++)
        {
            feeditem feed = new feeditem();
            feed.body ='Name'+i;
            feed.ParentId = acc.Id;
            feed.type = 'createrecordevent';
            feed.createdbyId = '0050B000007vnxy';
            lstFeed.add(feed);
        }
        
        insert lstFeed;
        
        Test.startTest();

            feedItemBatch obj = new feedItemBatch();
            DataBase.executeBatch(obj); 
            
            String sch = '0 0 * * * ?';
            feeditemschedule sqrb = new feeditemschedule();
            system.schedule('Feed item to remove Marketing touches', sch, sqrb);

            
        Test.stopTest();
    }
}