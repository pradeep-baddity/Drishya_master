public with sharing class OpportunityScheduleonproduct {
    public static void OpportunityScheduleCreation(List<Opportunitylineitem> Oppty)
    {
        integer i;
        set<id> oppId =  new set<id>(); 
        List<OpportunityLineItemSchedule> newScheduleObjects = new List<OpportunityLineItemSchedule>();
        for(Opportunitylineitem  op : Oppty)
        {
              //if(((op.Opportunity_Stage__c =='Commit (85-99%)') ||  ((op.Opportunity_Stage__c =='Propose (50-84%)') && (op.Opp_recordtype__c == 'EPM_Single_Service_Line' ||  op.Opp_recordtype__c == 'Huron' || op.Opp_recordtype__c == 'HBA' )  ) || (op.Opportunity_Stage__c =='Design (30-49%)' && op.Opp_recordtype__c == 'HBA' )) && op.Product_Schedule_Created__c == false && op.Offering_Lost__c == false) 
            if(((op.Opportunity_Stage__c =='Propose (50-84%)' ||  op.Opportunity_Stage__c =='Commit (85-99%)') || (op.Opportunity_Stage__c =='Design (30-49%)' && (op.Opp_recordtype__c == 'HBA' || op.Opp_recordtype__c == 'HC_Single_or_Child' || op.Opp_recordtype__c == 'Healthcare Software') )) && op.Product_Schedule_Created__c == false && op.Offering_Lost__c == false) 
                {
                    oppId.add(op.id);
                }
                system.debug('oppties-->'+oppId);
        }
        for(Opportunitylineitem opp : [select id, product2id, opportunityid ,quantity, unitprice,Amount__c,Estimated_Duration__c, Start_Date__c ,Product_Schedule_Created__c 
                                                 from OpportunityLineItem where id IN : oppId])
        {
            for(i=0 ; i< opp.Estimated_Duration__c ; i++)
            {
            OpportunityLineItemschedule s = new OpportunityLineItemschedule();
                                    s.Revenue = ((opp.unitprice)*(opp.quantity))/(opp.Estimated_Duration__c);
                                    if(opp.Start_Date__c != null)
                                    s.ScheduleDate =  datemodification(opp.Start_Date__c,i);
                                    system.debug('date-->'+s.ScheduleDate);
                                    s.OpportunityLineItemId = opp.id;
                                    s.Type = 'Revenue';
                                    newScheduleObjects.add(s);
            }
        }
         if(newScheduleObjects.size() >0 &&  newScheduleObjects != null){
                system.debug('schedule1-->'+newScheduleObjects);
            insert newScheduleObjects;
            system.debug('schedule2-->'+newScheduleObjects);
            }
        
    }
    public static date datemodification(date startdate,Integer i)
    {
        date next;
        Date mydate;
        if (startdate != null) {
            mydate = startdate.toStartOfMonth();
            system.debug('mydate-->'+mydate);
            next = mydate.addMonths(i);
        }
    return next;
    }
}