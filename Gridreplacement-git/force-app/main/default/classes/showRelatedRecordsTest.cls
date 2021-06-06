@isTest
public class showRelatedRecordsTest {
    
    public static testmethod void FetchData(){
        
       User u = [select id,isActive from User where profile.Name = 'System Administrator'And IsActive=true limit 1];
        
        system.runas(u){
            
        Account acc = new Account(Name ='test Account1', Industry = 'Agriculture');
        insert acc;
            
        Opportunity newOpp1 =  new Opportunity(recordtypeid = '012U0000000Mfhr',AccountId = acc.id,Name = 'Test Opp1',Industry__c = 'Agriculture',StageName = 'Prospect (0-14%)', amount = 5000);
        newOpp1.closeDate = system.today()+5;
        newOpp1.Estimated_Start_Date__c   = system.today()+10;
        insert newopp1;
            
        Account acc2 = new Account(Name ='test Account2', Industry = 'Agriculture',ParentId = acc.id);
        insert acc2;    
        
        Opportunity newOpp2 =  new Opportunity(recordtypeid = '012U0000000Mfhr',AccountId = acc2.id, Name = 'Test Opp2',Industry__c = 'Agriculture',StageName = 'Prospect (0-14%)', amount = 5000);
        newOpp2.closeDate = system.today()+5;
        newOpp2.Estimated_Start_Date__c   = system.today()+10;
        insert newopp2;
            
        Contact Con1 = new Contact(FirstName = 'Contact1',LastName='Test', AccountId = acc.id, Email ='test@test.com', Phone = '123456789',title = 'test');
        Insert Con1;
        Contact Con2 = new Contact(FirstName = 'Contact2',LastName='Test', AccountId = acc2.id, Email ='test@test.com', Phone = '123456789',title = 'test');
        Insert Con2;
            
            
        Huron_Connection__c HuronCon = new Huron_Connection__C(Account__c = acc.id, Contact__c =Con1.id,Relationship__c = 'knows',Connection_Strength__c = 'Strong');
        Insert HuronCon; 
        Huron_Connection__c HuronCon2 = new Huron_Connection__C(Account__c = acc2.id, Contact__c =Con2.id,Relationship__c = 'knows',Connection_Strength__c = 'Strong');
        Insert HuronCon2; 
       
            
        test.startTest();    
        showRelatedRecords.fetchOpportunities(acc2.id);
        showRelatedRecords.fetchContacts(acc2.id);    
        showRelatedRecords.fetchConnections(acc2.id);
        showRelatedRecords.findByName('Test Opp1',acc2.id);    
        showRelatedRecords.findByName('',acc2.id); 
        test.stopTest();
        
        }
        }
    }