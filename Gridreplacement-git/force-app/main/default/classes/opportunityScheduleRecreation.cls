public with sharing class opportunityScheduleRecreation {
        public static  list<Opportunitylineitemschedule> OpportunityScheduleCreation(List<Opportunity> Oppty)
        {
        integer i,j;
        set<id> oppid = new set<id>();
        List<OpportunityLineItemSchedule> newScheduleObjects = new List<OpportunityLineItemSchedule>();
                list<opportunitylineitem> opline = new list<opportunitylineitem>();
          for(Opportunity op : Oppty)
            {
                //if(op.stageName == 'Prospect (0-14%)' || op.stageName =='Explore (15-29%)' || op.stageName == 'Design (30-49%)')
                //{
                 if( (op.StageName != 'Closed Won (100%)' && op.recordtype.developerName != 'ELS')){
                oppid.add(op.id);
                }
            }
            system.debug('oppid-->');
          list<Opportunitylineitemschedule> oppdel = [select id, opportunitylineitemId, opportunitylineitem.opportunityId from Opportunitylineitemschedule where opportunitylineitem.opportunityId IN: oppid];
              for(Opportunitylineitem opp : [select id, Start_Date__c,Estimated_Duration__c,unitprice,quantity,opportunity.Estimated_Start_Date__c,amount__c from Opportunitylineitem where opportunityId In: oppId])
              {
                  for(i=0 ; i< opp.Estimated_Duration__c ; i++)
                  {
                    system.debug('Inside for schedule');
                    OpportunityLineItemschedule s = new OpportunityLineItemschedule();
                    s.Revenue = ((opp.unitprice)*(opp.quantity))/(opp.Estimated_Duration__c);
                    //s.Actuals__c = 0;
                    system.debug('revenue-->'+s.Revenue);
                    if(opp.opportunity.Estimated_Start_Date__c!=null)
                    s.ScheduleDate =  datemodification(opp.opportunity.Estimated_Start_Date__c,i);
                    system.debug('date-->'+s.ScheduleDate);
                    s.OpportunityLineItemId = opp.id;
                    s.Type = 'Revenue';
                    newScheduleObjects.add(s);
                  }
                  
                  opportunitylineitem  oplinenew =  new opportunitylineitem(Id = opp.id);
        oplinenew.Offering_Actual_Revenue_Rollup__c = opp.unitprice;
        opline.add(oplinenew);
        
              }
            if(newScheduleObjects.size() >0 ){
            system.debug('schedule1-->'+newScheduleObjects);
            insert newScheduleObjects;
            system.debug('schedule2-->'+newScheduleObjects);
            
               
    
        if(opline != null && opline.size() > 0)
        {
        update opline;
        }
            
            
            }
          return oppdel;
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