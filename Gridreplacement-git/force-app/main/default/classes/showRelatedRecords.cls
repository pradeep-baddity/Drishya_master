public class showRelatedRecords {
    @AuraEnabled        
    public static List<opportunity> fetchOpportunities(id accid) {
        string parentAccount;
        List<Account> accList = [SELECT Id, Parent_Account_Name_Rollup__c, Type from Account where Id =: accid limit 1];
        parentAccount = accList[0].Parent_Account_Name_Rollup__c;
        list<opportunity> opps = [select id ,name, account.name ,AccountId,StageName, Amount , Total_Contract_Value__c, recordtypeId,CurrencyIsoCode,convertCurrency(Total_Contract_Value__c) TCV, FORMAT(Total_Contract_Value__c) Amt,
                                  CloseDate, Owner.name,Practice__c from opportunity where (account.Parent_Account_Name_Rollup__c =:parentAccount and Practice__c!= 'Targets')];
        system.debug('opps-->'+opps);       
        return opps;
    }
    @AuraEnabled
    public static List<Contact> fetchContacts(id aAccId){
        string parentAccount;
        List<Account> accList1 = [SELECT Id, Parent_Account_Name_Rollup__c, Type from Account where Id =: aAccId limit 1];
        parentAccount = accList1[0].Parent_Account_Name_Rollup__c;
        list<Contact> cons = [SELECT Id, AccountId, account.Name,Title,Name, Email, Phone FROM Contact where account.Parent_Account_Name_Rollup__c =:parentAccount ];
        return cons;
    }
    
        @AuraEnabled
    public static List<Huron_Connection__c> fetchConnections(id aAccId){
        string parentAccount;
        List<Account> accList2 = [SELECT Id, Parent_Account_Name_Rollup__c, Type from Account where Id =: aAccId limit 1];
        parentAccount = accList2[0].Parent_Account_Name_Rollup__c;
        list<Huron_Connection__c> connections = [SELECT Id,Account__c, Account__r.Name, Contact__c, Contact__r.Name,Relationship__c,CreatedDate, Owner.Name, Connection_Strength__c, Name FROM Huron_Connection__c where Account__r.Parent_Account_Name_Rollup__c  =:parentAccount ];
        return connections;
    }
    
    @AuraEnabled
    public static List<opportunity> findByName(String searchKey, id Accountid) {
        String name = + searchKey ;
        string parentAccount;
        Id targetId= Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('Targets').getRecordTypeId();
        List<Account> accList = [SELECT Id, Parent_Account_Name_Rollup__c, Type from Account where Id =: Accountid limit 1];
        parentAccount = accList[0].Parent_Account_Name_Rollup__c;
        if(String.isNotBlank(name))
        {
        list<opportunity> opps = [select id ,name, account.name ,AccountId,StageName, Amount , account.type ,account.Industry,recordtypeId, Total_Contract_Value__c,CurrencyIsoCode,
                                  CloseDate,Date_Last_Closed__c, Owner.name,Practice__c from opportunity WHERE (stage__c LIKE :name) AND account.Parent_Account_Name_Rollup__c =:parentAccount and Practice__c!= 'Targets'];
        system.debug('opps2-->'+opps);       
        return opps;
        }
        else {
        list<opportunity> opps = [select id ,name, account.name ,StageName, Amount , account.type ,account.Industry,recordtype.Developername, Total_Contract_Value__c,CurrencyIsoCode,
                                  CloseDate,Date_Last_Closed__c, Owner.name,Practice__c from opportunity WHERE account.Parent_Account_Name_Rollup__c =:parentAccount and Practice__c!= 'Targets'];
        system.debug('opps2-->'+opps);       
        return opps;
        }
    }
}