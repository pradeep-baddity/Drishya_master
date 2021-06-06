public with sharing class opportunityproductupdateammount {
    
    public static list<Opportunitylineitemschedule> OpportunityScheduleCreation(List<Opportunitylineitem> Opptyline)
    { 
        integer i;
        List<OpportunityLineItemSchedule> newScheduleObjects = new List<OpportunityLineItemSchedule>();
        list<opportunitylineitem> opline = new list<opportunitylineitem>();
        set<id> oppid = new set<id>();
        Map<id, Decimal> idToAmountMap = new Map<id,Decimal>();
        for(Opportunitylineitem op : Opptyline)
        {
            
            // if(op.Amount__c > 0 ){
            if(op.Is_Undefined__c == false){
                oppid.add(op.id);
                idToAmountMap.put(op.id,op.Amount__c);
            }
            
        }
        
        system.debug('oppid-->'+oppid);
        list<Opportunitylineitemschedule> oppdel = [select id from Opportunitylineitemschedule where OpportunityLineItemId IN : oppid];
        //database.delete(opp, false);
        system.debug('oppdel before-->'+oppdel);
        //delete oppdel;
        system.debug('oppdel after-->'+oppdel);
        for(Opportunitylineitem opp : [select id, product2id, opportunityid ,quantity, unitprice,amount__c,Estimated_Duration__c, Start_Date__c ,Product_Schedule_Created__c 
                                       from Opportunitylineitem where id IN : oppId and is_undefined__c = false])
        {
            for(i=0 ; i< opp.Estimated_Duration__c ; i++)
            {
                system.debug('inside-->');
                OpportunityLineItemschedule s = new OpportunityLineItemschedule();
                s.Revenue = ((idToAmountMap.get(opp.Id))*(opp.quantity))/(opp.Estimated_Duration__c);
                s.ScheduleDate =  datemodificationnew(opp.Start_Date__c,i);
                system.debug('date-->'+s.ScheduleDate);
                s.OpportunityLineItemId = opp.id;
                s.Type = 'Revenue';
                newScheduleObjects.add(s);
            }
            
            opportunitylineitem  oplinenew =  new opportunitylineitem(Id = opp.id);
            oplinenew.Offering_Actual_Revenue_Rollup__c = opp.Amount__c;
            opline.add(oplinenew);
        }
        
        
        if(opline != null && opline.size() > 0)
        {
            update opline;
        }
        
        if(newScheduleObjects.size() >0 ){
            system.debug('schedule1-->'+newScheduleObjects);
            insert newScheduleObjects;
            system.debug('schedule2-->'+newScheduleObjects);
        }
        return oppdel;
    }
    public static date datemodificationnew(date startdate,Integer i)
    {
        date next;
        Date mydate;
        if (startdate != null) {
            mydate = startdate.toStartOfMonth();
            system.debug('mydate-->'+mydate);
            next = mydate.addMonths(i+1);
        }
        return next;
    }
    public static date datemodificationnew1(date startdate,Integer i)
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
    
    //This method added by pradeep baddity on 5/4/ for user story  23356
    public static list<Opportunitylineitemschedule>  StandardOpportunityScheduleCreation(List<Opportunitylineitem> Opptyline)
    { 
        integer i;
        set<id> oppid = new set<id>();
        Map<id, Decimal> idToAmountMap = new Map<id,Decimal>();
        set<id> opportunityid = new set<id>();
        List<OpportunityLineItemSchedule> newScheduleObjects = new List<OpportunityLineItemSchedule>();
        list<opportunitylineitem> opline = new list<opportunitylineitem>();
        
        for(Opportunitylineitem op : Opptyline)
        {
            
            // if(op.Amount__c > 0 ){
            if(op.Is_Undefined__c == false)
            {
                oppid.add(op.id);
                idToAmountMap.put(op.id,op.Amount__c);
                opportunityid.add(op.OpportunityId);
            }
            
        }
        
        list<Opportunitylineitemschedule> oppdel = [select id from Opportunitylineitemschedule where OpportunityLineItemId IN : oppid];
        
        
        for(Opportunitylineitem opp : [select id, product2id, opportunityid ,quantity, unitprice,amount__c,Estimated_Duration__c, Start_Date__c ,Product_Schedule_Created__c, 
                                       Opportunity.type,opportunity.estimated_start_Date__c from Opportunitylineitem where id IN : oppId and is_undefined__c = false])
        {
            if(opp.opportunity.estimated_start_Date__c.day()>=1 && opp.opportunity.estimated_start_Date__c.day()<=9)
            {
                for(i=0 ; i< opp.Estimated_Duration__c; i++)
                {
                    system.debug('inside-->');
                    System.debug('is this executing----->'+opp.opportunity.estimated_start_Date__c.day());
                    OpportunityLineItemschedule s = new OpportunityLineItemschedule();
                    //  s.Revenue = ((idToAmountMap.get(opp.Id))*(opp.quantity))/(opp.Estimated_Duration__c);
                    s.Revenue =(opp.amount__c )/(opp.Estimated_Duration__c);
                    s.ScheduleDate =  datemodificationnew(opp.Start_Date__c,i);
                    system.debug('date-->'+s.ScheduleDate);
                    s.OpportunityLineItemId = opp.id;
                    s.Type = 'Revenue';
                    newScheduleObjects.add(s);
                }
                  opportunitylineitem  oplinenew =  new opportunitylineitem(Id = opp.id);
           		  oplinenew.Offering_Actual_Revenue_Rollup__c = opp.Amount__c;
            	  opline.add(oplinenew);
            }
            if(opp.opportunity.estimated_start_Date__c.day()>=10 && opp.opportunity.estimated_start_Date__c.day()<=20)
            {
                 for(i=0 ; i< opp.Estimated_Duration__c; i++)
                {
                    if(i==0)
                    {
                           system.debug('inside-->');
                    System.debug('is this executing----->'+opp.opportunity.estimated_start_Date__c.day());
                    OpportunityLineItemschedule s = new OpportunityLineItemschedule();
                    //  s.Revenue = ((idToAmountMap.get(opp.Id))*(opp.quantity))/(opp.Estimated_Duration__c);
                    s.Revenue =(opp.amount__c )/(opp.Estimated_Duration__c)*0.5;
                    s.ScheduleDate =  datemodificationnew(opp.Start_Date__c,i);
                    system.debug('date-->'+s.ScheduleDate);
                    s.OpportunityLineItemId = opp.id;
                    s.Type = 'Revenue';
                    newScheduleObjects.add(s);
                    }
                   if(i>0 && i<= opp.Estimated_Duration__c)
                    {
                    system.debug('inside-->');
                    System.debug('is this executing----->'+opp.opportunity.estimated_start_Date__c.day());
                    OpportunityLineItemschedule s = new OpportunityLineItemschedule();
                    //  s.Revenue = ((idToAmountMap.get(opp.Id))*(opp.quantity))/(opp.Estimated_Duration__c);
                    s.Revenue =(opp.amount__c )/(opp.Estimated_Duration__c);
                    s.ScheduleDate =  datemodificationnew(opp.Start_Date__c,i);
                    system.debug('date-->'+s.ScheduleDate);
                    s.OpportunityLineItemId = opp.id;
                    s.Type = 'Revenue';
                    newScheduleObjects.add(s);
                    }
                   
                } 
                OpportunityLineItemschedule s = new OpportunityLineItemschedule();
                    //  s.Revenue = ((idToAmountMap.get(opp.Id))*(opp.quantity))/(opp.Estimated_Duration__c);
                    s.Revenue =(opp.amount__c )/(opp.Estimated_Duration__c)*0.5;
                    s.ScheduleDate =  datemodificationnew(opp.Start_Date__c,i);
                    system.debug('date-->'+s.ScheduleDate);
                    s.OpportunityLineItemId = opp.id;
                    s.Type = 'Revenue';
                    newScheduleObjects.add(s);
            }
             if(opp.opportunity.estimated_start_Date__c.day()>=21 && opp.opportunity.estimated_start_Date__c.day()<=31)
            {
                 for(i=0 ; i< opp.Estimated_Duration__c+1; i++)
                {
                   if(i==0)
                   {
                   /*   system.debug('inside-->');
                    System.debug('is this executing----->'+opp.opportunity.estimated_start_Date__c.day());
                    OpportunityLineItemschedule s = new OpportunityLineItemschedule();
                    //  s.Revenue = ((idToAmountMap.get(opp.Id))*(opp.quantity))/(opp.Estimated_Duration__c);
                    s.Revenue =0;
                    s.ScheduleDate =  datemodificationnew(opp.Start_Date__c,i);
                    system.debug('date-->'+s.ScheduleDate);
                    s.OpportunityLineItemId = opp.id;
                    s.Type = 'Revenue';
                    newScheduleObjects.add(s);*/
                   }
                    if(i>0)
                    {
                        OpportunityLineItemschedule s = new OpportunityLineItemschedule();
                    //  s.Revenue = ((idToAmountMap.get(opp.Id))*(opp.quantity))/(opp.Estimated_Duration__c);
                    s.Revenue =(opp.amount__c )/(opp.Estimated_Duration__c);
                    s.ScheduleDate =  datemodificationnew(opp.Start_Date__c,i);
                    system.debug('date-->'+s.ScheduleDate);
                    s.OpportunityLineItemId = opp.id;
                    s.Type = 'Revenue';
                    newScheduleObjects.add(s);
                    }
                }
                
            }
            
        }    
        if(opline != null && opline.size() > 0)
        {
            update opline;
        }
        
        if(newScheduleObjects.size() >0 ){
            system.debug('standard schedule1-->'+newScheduleObjects);
            insert newScheduleObjects;
            system.debug('standard schedule2-->'+newScheduleObjects);
        }
        return oppdel;
    }
}