Global class SCemail implements Schedulable{
List<Id> targetObjectIds = new List<Id>();
List <User> targetObjects = new List <User> ();
    
Group g = [SELECT (select userOrGroupId from groupMembers) FROM group WHERE name = 'SC Test'];
    {for (GroupMember gm : g.groupMembers) 
  {
   targetObjectIds.add(gm.userOrGroupId);
  }}
    
global void execute (SchedulableContext SC){
 {   
 Messaging.MassEmailMessage  mail = new Messaging.MassEmailMessage ();
  mail.setTargetObjectIds(targetObjectIds); //email recipient id
  //mail.setTargetObjectIds(ID[] '00XJ0000000OpdI');
  mail.setTemplateId('00XU000000167la'); //email template id
 // String[] bccaddress = new String[]{'estradare@gmail.com'};
  //mail.setBccAddresses(bccaddress);
  //mail.setWhatID('0015000000KJImA'); //account id (show cases for this account)
 mail.setReplyTo('salesforcesupport@huronconsultinggroup.com');
 mail.setSenderDisplayName('SalesForce Support');
 mail.setSaveAsActivity(false);
 Messaging.sendEmail(new Messaging.MassEmailMessage [] { mail });
}
}
}