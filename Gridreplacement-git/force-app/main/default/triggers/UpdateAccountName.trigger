/***************************************************************************************
Trigger Name      : UpdateAccountName
Description       : This is the trigger on contact object
Created By        : Arif Hussain
Created Date      : 23-Mar-2017
Last Modified By  : Arif Hussain
****************************************************************************************/
trigger UpdateAccountName on Contact (before update,after update) {
//Create a Set to store new contact Id's
  Set<ID> ids = Trigger.newMap.keySet();
// FInd all contacts based on contacts
List<Contact> Con = [SELECT Id, AccountId,(select ID,Account__c,Contact__c from Huron_Connections__r) 
                    FROM Contact 
                    WHERE Id in :ids];
//system.debug('Con-->'+con);
//Create a list for Huron  connections to update childrenToUpdate
List<Huron_Connection__c> childrenToUpdate = new List<Huron_Connection__c>();
//Loop over the contacts
for(Contact c : Con)
 { 
 // Check if the old and new accountId's are same
  String oldvalue = Trigger.oldMap.get(c.ID).AccountID;
  String newValue = Trigger.NewMap.get(c.ID).AccountID;
   if(oldvalue != newValue )
  {
    system.debug('Inside If');
    for(Huron_Connection__c kid: c.Huron_Connections__r) 
     {                      
       kid.Account__c = c.AccountId;
       childrenToUpdate.add(kid);
       system.debug('childrenToUpdate-->'+childrenToUpdate);
     }
  }
}
//UPDATE Huron Connection IF childrenToUpdate IS NOT EMPTY
if( !childrenToUpdate.isEmpty() )
{ 
  update childrenToUpdate;
 }
    //Getting Rejected Contacts  to update Task,below lines are added by pradeep baddity on 1/4/2021
    if(Trigger.isAfter&&Trigger.isupdate)
    {
        CreateContactTask.create_contact_Task(ids);
     }
    }