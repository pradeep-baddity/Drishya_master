public class lostOpportunityOffering{
    
    public static list<Opportunitylineitemschedule> lostOffering(list<opportunitylineitem> oppty)
    {
        set<Id> lineId = new set<id>();
        list<opportunitylineitem> listtoupdate = new list<opportunitylineitem>();
        for(opportunitylineitem opptyNew : oppty)
        {
            if(opptyNew.offering_lost__c == True)
            {
                lineId.add(opptyNew.Id);        
            }
        }
        system.debug('lineId-->'+lineId);
        list<Opportunitylineitemschedule> oppdel = [select id from Opportunitylineitemschedule where OpportunityLineItemId IN : lineId];
        
        for(Opportunitylineitem opp : [select id, offering_lost__c, opportunityid ,quantity, unitprice,amount__c,Offering_Actual_Revenue_Rollup__c 
                                       from Opportunitylineitem where id IN : lineId])
        {
        opp.Amount__c = opp.unitprice;
        system.debug('opp.Amount__c-->'+opp.Amount__c);
        opp.unitprice = 0;
        opp.Offering_Actual_Revenue_Rollup__c = 0;
        listtoupdate.add(opp);
        system.debug('opp.unitprice-->'+opp.unitprice);
        }
        recursiveTriggerhandler.toStopBeforeUpdate = false;
        update listtoupdate; 
        system.debug('listtoupdate-->'+listtoupdate);   
    return oppdel;
    }
}