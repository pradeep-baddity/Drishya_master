public with sharing class CountOpportunityContactRole_HC{
    public static void countRole( map<Id,Opportunity> mapOpportunity){
        system.debug('ran');
        AggregateResult[]  opportunityContactRoleAgg = [select opportunityid, count(id) totalCount from OpportunityContactRole where opportunityid IN:mapOpportunity.keyset() group by opportunityid LIMIT 10];
       
        for(Id oppId : mapOpportunity.keyset()) {
            Integer counter = 0;
            for(AggregateResult tempAggRes : opportunityContactRoleAgg) {
                if((Id)tempAggRes.get('opportunityid') == oppid) {
                    counter = (Integer)tempAggRes.get('totalCount');
                }
            }
            if(counter == 0) {
                mapOpportunity.get(oppId).CountOpportunityContactRole__c = 0;
            } else {
                mapOpportunity.get(oppId).CountOpportunityContactRole__c = counter;
            }
        }
        
        
    }
}