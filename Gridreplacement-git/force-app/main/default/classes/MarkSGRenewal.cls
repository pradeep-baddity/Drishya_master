Global class MarkSGRenewal implements Schedulable{
    global void execute (SchedulableContext SC){
        
        List <Opportunity> targetOpps = [Select      Id,
            CreateSGRenewal__c,
            Contract_Expiration_Date__c,
            StuderRenewalReady__c
            from Opportunity
            where StuderRenewalReady__c = True and CreateSGRenewal__c = False and 
            (((Healthcare_Solutions2__c = 'Healthcare-Studer Group :1459' or Healthcare_Solutions2__c = 'Healthcare-Studer Group Canada :7124')) or ((Healthcare_Solutions2__c = 'Healthcare-ECS Functional :1326' or Healthcare_Solutions2__c = 'Healthcare-ECS Technical :1323') and AutoCreateRenewal__c = True))
        ];
for (opportunity opp : targetOpps){
    opp.CreateSGRenewal__c = True;
}
        if (targetOpps.size() > 0){ 
        Update targetOpps;}

    }}