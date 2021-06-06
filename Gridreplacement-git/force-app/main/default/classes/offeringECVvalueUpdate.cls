public with sharing class offeringECVvalueUpdate {
    public static void ECVvalueUpdate(List<Opportunity> Oppty)
    {   
         system.debug('Oppty-->'+Oppty);
        set<id> setId = new set<id>();
        list<opportunitylineitem> lineitem = new list<opportunitylineitem>();
        if(Oppty != NULL || Oppty.size() >0)
        {
            for(opportunity opline : Oppty)
            {
                setId.add(opline.Id);
            }
        }
        system.debug('setId-->'+setid);
        if(setId != NULL)
        {
            for(opportunitylineitem opplineitem : [select Id, unitprice,Offering_Estimated_Contract_Value_ECV__c,opportunityid from opportunitylineitem where opportunityid IN : setId])
            {
                opplineitem.Offering_Estimated_Contract_Value_ECV__c = opplineitem.unitprice;
                lineitem.add(opplineitem);
            }
        }
        system.debug('lineitem-->'+lineitem);
        if(lineitem != NULL || lineitem.size() >0)
        {
            update lineitem;
            system.debug('lineitem-->'+lineitem);
        }
    }
}