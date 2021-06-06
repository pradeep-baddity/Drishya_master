public class deleteUndefinedOfferings {
    public static void deleteOfferings(list<opportunitylineitem> lineitem){
        system.debug('lineitem-->'+lineitem);
        set<Id> setId = new set<Id>();
        for(opportunitylineitem opline : [select id, opportunity_probability__c, opportunityid from opportunitylineitem where Id In : lineitem])
        {
            setId.add(opline.opportunityid);
        }
        system.debug('setid-->'+setid);
        
    }
}