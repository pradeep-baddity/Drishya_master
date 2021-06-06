Global class TriggerJobSetupEmail implements Schedulable{
    global void execute (SchedulableContext SC){
        
        List <Opportunity> targetOpps = [Select      Id,
            JobsetupEmailSent__c,
            EffectiveDateReached__c,
            SendJobsetupEmail__c,
            Effective_Date__c
            from Opportunity
            where JobsetupEmailSent__c = False and EffectiveDateReached__c = True and Effective_Date__c != Null and Iswon = True
        ];
for (opportunity opp : targetOpps){
    opp.SendJobsetupEmail__c = True;
}
        if (targetOpps.size() > 0){ 
        Update targetOpps;}

    }}