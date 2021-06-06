public class lostofferingwon {

    public static void lostOffering(list<opportunitylineitem> oppty)
    {
        integer i,j;
        set<Id> lineId = new set<id>();
        List<OpportunityLineItemSchedule> newScheduleObjects = new List<OpportunityLineItemSchedule>();
                list<opportunitylineitem> opline = new list<opportunitylineitem>();
        for(opportunitylineitem opptyNew : oppty)
        {
           lineId.add(opptyNew.Id);        
        }
        system.debug('lineId-->'+lineId);
        for(opportunitylineitem offwon : [select id, product2id, opportunityid ,quantity, unitprice,Amount__c,Estimated_Duration__c, Start_Date__c ,Product_Schedule_Created__c 
                                         from OpportunityLineItem where Id IN : lineId and is_undefined__c = false])
        {
           for(i=0 ; i< offwon.Estimated_Duration__c ; i++)
            {
            OpportunityLineItemschedule s = new OpportunityLineItemschedule();
                                    s.Revenue = ((offwon.Amount__c)*(offwon.quantity))/(offwon.Estimated_Duration__c);
                                    s.ScheduleDate =  datemodification(offwon.Start_Date__c,i);
                                    system.debug('date-->'+s.ScheduleDate);
                                    s.OpportunityLineItemId = offwon.id;
                                    s.Type = 'Revenue';
                                    newScheduleObjects.add(s);
            }
           opportunitylineitem  oplinenew =  new opportunitylineitem(Id = offwon.id);
        oplinenew.Offering_Actual_Revenue_Rollup__c = offwon.Amount__c;
        opline.add(oplinenew); 
            
        }
        
         if(opline != null && opline.size() > 0)
        {
        update opline;
        }
        
        if(newScheduleObjects != null && newScheduleObjects.size() >0 ){
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