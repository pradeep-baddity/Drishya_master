public class GETOpportunityRelatedCase {
    @AuraEnabled
    public static List<Case> getcas(id Caseid){
        list<id> oppids = new List<id>();
        List<Case> Caselist = new List<Case>();
        list<Case> cas=[Select id,Opportunity__c,RecordType.Name From Case where Id=:Caseid];
        oppids.add(cas[0].Opportunity__c);
        List<Opportunity> opplist =[Select id,(Select id,CaseNumber,Type,Priority from Cases__r where id <> :Caseid) from Opportunity where id=: oppids] ;
        system.debug('oppcases'+opplist); 
        
        for(Opportunity Opp:opplist)
        {
            for(Case C:Opp.Cases__r){
                
                Caselist.add(c);
            }
        }
        
       return Caselist;
    }
}