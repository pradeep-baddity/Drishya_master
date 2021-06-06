public class AccountHierachyController 
{
     @AuraEnabled 
      public static String getAccount(id aid)
    {
                List<Account> accList1 = [SELECT Id,Reviewed_by__c,Owner.Name,lastmodifieddate from Account where Id =: aid limit 1];
            System.debug('Account List---->'+accList1[0].Reviewed_by__c);
          return accList1[0].Reviewed_by__c;   
        //test in vs code- changes to child branch
    }
    
    
    @AuraEnabled        
    public static String UpdateAccount(id aid)
    {
        System.debug('Account id---->'+aid);
        List<Account> update_Acc_list =new List<Account>();
        List<Account> accList = [SELECT Id,Reviewed_by__c,Review_Date__c from Account where Id =: aid limit 1];
       if(accList[0].Reviewed_by__c==null)
       {
           
           for(Account itr_acclist : accList)
           {
               
               itr_acclist.Reviewed_by__c=Userinfo.getName();
               itr_acclist.Review_Date__c=System.today();
               update_Acc_list.add(itr_acclist);
              
           }
           if(update_Acc_list.size()>0)
           {
           update update_Acc_list;
               
           }
         

       }
       
        return 'newreview';
              }
    
 }