public class AggregateTCVRollup {
    
    public static void TCVRollup(list<opportunitylineitem> oppline)
    {  
        set<id> setId =  new set<id>();
        for(opportunitylineitem op : oppline)
        {
            setId.add(op.opportunityId);
        }
        
        AggregateResult[] groupedResults = [SELECT SUM(Offering_Estimated_Contract_Value_ECV__c) ecvAmt  from opportunitylineitem where opportunityId IN : setId ];
        //integer total = groupedResults[0].get('ecvAmt');
        double avg = double.valueOf(groupedResults[0].get('ecvAmt'));
        
        system.debug('avg'+avg);
        list<opportunity> oplist = new list<opportunity>();
        for(opportunity op : [select id from opportunity where id IN : setId])
        {
            opportunity oppor = new opportunity();
            oppor.Id = op.id;
            //oppor.Total_Contract_Value__c = avg;
            oplist.add(oppor);
        }
        
        if(oplist != NULL && oplist.size() >0){
            //update oplist;
        }
        
    }
}