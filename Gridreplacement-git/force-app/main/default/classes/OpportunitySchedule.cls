public with sharing class OpportunitySchedule {
    
    public static void OpportunityScheduleCreation(List<Opportunity> Oppty) {
        //try{   
        
        Integer i,j;
        List<OpportunityLineItemSchedule> newScheduleObjects = new List<OpportunityLineItemSchedule>();
        List<Opportunity> oppor = new List<Opportunity>();
        List<Id> lineitemId = new List<Id>();
        set<id> oppId =  new set<id>(); 
        List<OpportunityLineItem> opportunitylineitemids = new List<OpportunityLineItem>();
        System.debug(' ---Oppty   StageName---  '+oppty);
        Id EDUId = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('EDU Opportunity').getRecordTypeId();
        Id HbaId = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('HBA').getRecordTypeId();
        Id HuronId = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('Huron').getRecordTypeId();
        Id EsaId = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('ES&A Single Service Line').getRecordTypeId();
        Id HcId = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('Healthcare Opportunities').getRecordTypeId();
        Id HcsId = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('Healthcare Software').getRecordTypeId();
        
        list<opportunitylineitem> opline = new list<opportunitylineitem>();
          for(Opportunity  op : Oppty)
        {
            
            //if(((op.StageName =='Propose (50-84%)' ||  op.StageName =='Commit (85-99%)') || (op.StageName =='Design (30-49%)' && (op.recordtypeID == HbaId || op.recordtypeID == HcId ||  op.recordtypeID == HcsId || op.recordtypeID == EDUId) ) ) /* && (op.Oppty_Product_schedule_created__c == false)*/) 
            //{
            
            oppId.add(op.id);
            
            //}
            system.debug('opportunity stage-->'+op.StageName);
            system.debug('opportunity recordId-->'+op.recordtypeID);
            system.debug('oppties-->'+oppId);
        }
        for(Opportunity opp : [select id
                               , name 
                               , StageName
                               , Estimated_Start_Date__c
                               , Estimated_Duration__c 
                               , Amount
                               , Product_Count__c
                               ,(select id, product2id, opportunityid ,quantity, unitprice , Offering_Lost__c ,Product_Schedule_Created__c,amount__c
                                 from OpportunityLineItems where Offering_Lost__c = false and Product_Schedule_Created__c = false and is_undefined__c = false)
                               from Opportunity where id IN : oppId])
        {
            System.debug('opp--->'+opp);
            for(OpportunityLineItem opl : opp.OpportunityLineItems)
            {
                for(j=0; j< opp.Estimated_Duration__c ; j++)
                {
                    system.debug('Inside for schedule');
                    OpportunityLineItemschedule s = new OpportunityLineItemschedule();
                    s.Revenue = ((opl.unitprice)*(opl.quantity))/(opp.Estimated_Duration__c);
                    system.debug('revenue-->'+s.Revenue);
                    s.ScheduleDate =  datemodification(opp.Estimated_Start_Date__c,j);
                    system.debug('date-->'+s.ScheduleDate);
                    s.OpportunityLineItemId = opl.id;
                    opportunitylineitemids.add(opl);
                    s.Type = 'Revenue';
                    newScheduleObjects.add(s);
                }
                system.debug('newScheduleObjects'+newScheduleObjects);
                
                opportunitylineitem  oplinenew =  new opportunitylineitem(Id = opl.id);
                oplinenew.Offering_Actual_Revenue_Rollup__c = opl.unitprice;
                opline.add(oplinenew);
                
            }        
        }
        
        if(newScheduleObjects.size() >0 ){
            system.debug('schedule1-->'+newScheduleObjects);
            insert newScheduleObjects;
            system.debug('schedule2-->'+newScheduleObjects);
        }
        
        if(opline.size() > 0)
        {
            update opline;
        }
        
        
        for(Opportunity op : [select id , stageName,Oppty_Product_schedule_created__c ,recordtype.developerName from opportunity where Id in : oppty])
        {
            if(((op.StageName =='Propose (50-84%)' ||  op.StageName =='Commit (85-99%)') || (op.StageName =='Design (30-49%)' && (op.recordtypeID == HbaId || op.recordtypeID == HcId || op.recordtypeID == HcsId || op.recordtypeID == EDUId) ))) {
                //if(((op.StageName =='Commit (85-99%)') ||  ((op.StageName =='Propose (50-84%)') && (op.recordtypeID == EsaId ||  op.recordtypeID == HuronId || op.recordtypeID == HbaId )  ) || (op.StageName =='Design (30-49%)' && op.recordtypeID == HbaId ))){
                System.debug('rec type::'+op.recordtypeID);
                op.Oppty_Product_schedule_created__c = true;
                oppor.add(op);
            }
        }
        //update oppor;
       if(opportunitylineitemids.size()>0)
       {
            list<Opportunitylineitemschedule> oppdelnew = [select id,OpportunityLineitemId, OpportunityLineitem.opportunityid from OpportunityLineItemSchedule where OpportunityLineitem.opportunityid =: Oppty[0].id];
        
    
        delete oppdelnew;
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
    //This method added by pradeep baddity on 5/4/2021 for user story  23356
    public static void StandardOpportunityScheduleCreation(List<Opportunity> Oppty)
    {
        Integer i,j;
        List<OpportunityLineItemSchedule> newScheduleObjectsNew = new List<OpportunityLineItemSchedule>();  
        List<OpportunityLineItemSchedule> newScheduleObjectsNew1 = new List<OpportunityLineItemSchedule>();  
        
        List<OpportunityLineItem> opportunitylineitemids = new List<OpportunityLineItem>();
        List<OpportunityLineItem> opportunitylineitemids1 = new List<OpportunityLineItem>();
        
        
        for(Opportunity opp : [select id, name, StageName, Estimated_Start_Date__c, Estimated_Duration__c, Amount, Product_Count__c
                               ,(select id, product2id, opportunityid ,quantity, unitprice , amount__c, Offering_Lost__c ,Product_Schedule_Created__c,Re_spread_Schedules__c
                                 from OpportunityLineItems where Offering_Lost__c = false and is_undefined__c = false)
                               from Opportunity where id IN: Oppty])
        {
            if(opp.estimated_start_Date__c.day()>=1 && opp.estimated_start_Date__c.day()<=9 )
            {
                for(OpportunityLineItem opl : opp.OpportunityLineItems)
                {
                    
                    for(j=0; j< opp.Estimated_Duration__c ; j++)
                    {                    
                        system.debug('Inside for schedule----1---9');                    
                        OpportunityLineItemschedule s = new OpportunityLineItemschedule();                  
                        s.Revenue =(opl.amount__c )/(opp.Estimated_Duration__c);            
                        system.debug('revenue-->'+s.Revenue);                    
                        s.ScheduleDate =  datemodification(opp.Estimated_Start_Date__c,j);  
                        s.OpportunityLineItemId = opl.id;
                        s.Type = 'Revenue';
                        if(opl.Re_spread_Schedules__c==false)
                        {
                            System.debug('is this executing');
                            opportunitylineitemids.add(opl);
                        }
                        if(opl.Re_spread_Schedules__c==false)
                        {
                            newScheduleObjectsnew.add(s);
                        }
                    }
                    
                }
                
            }
            else
            {
                if(opp.estimated_start_Date__c.day()>=10 && opp.estimated_start_Date__c.day()<=20 )
                {
                    for(OpportunityLineItem opl : opp.OpportunityLineItems)
                    {
                        
                        for(j=0; j< opp.Estimated_Duration__c ; j++)
                            
                        {    
                            if(j==0)
                            {
                                
                                OpportunityLineItemschedule s = new OpportunityLineItemschedule();                  
                                s.Revenue =(opl.amount__c )/(opp.Estimated_Duration__c)*0.5;            
                                system.debug('revenue-->'+s.Revenue);                    
                                s.ScheduleDate =  datemodification(opp.Estimated_Start_Date__c,j);                    
                                system.debug('date-->'+s.ScheduleDate);                    
                                s.OpportunityLineItemId = opl.id;
                                s.Type = 'Revenue';
                                if(opl.Re_spread_Schedules__c==false)
                                {
                                    System.debug('is this executing');
                                    opportunitylineitemids.add(opl);
                                }
                                if(opl.Re_spread_Schedules__c==false)
                                {
                                    newScheduleObjectsnew.add(s);
                                }
                                
                                
                            }
                            if(j>0 && j<= opp.Estimated_Duration__c)
                            {
                                
                                OpportunityLineItemschedule s = new OpportunityLineItemschedule();                  
                                //  s.Revenue = ((opl.unitprice)*(opl.quantity))/(opp.Estimated_Duration__c); 
                                s.Revenue =(opl.amount__c )/(opp.Estimated_Duration__c);            
                                system.debug('revenue-->'+s.Revenue);                    
                                s.ScheduleDate =  datemodification(opp.Estimated_Start_Date__c,j);                    
                                system.debug('date-->'+s.ScheduleDate);                    
                                s.OpportunityLineItemId = opl.id;
                                
                                s.Type = 'Revenue';
                                if(opl.Re_spread_Schedules__c==false)
                                {
                                    System.debug('is this executing');
                                    opportunitylineitemids.add(opl);
                                }
                                if(opl.Re_spread_Schedules__c==false)
                                {
                                    newScheduleObjectsnew.add(s);
                                }
                            }
                            
                            
                            
                        }
                        
                        
                        
                        OpportunityLineItemschedule s = new OpportunityLineItemschedule();                  
                        //  s.Revenue = ((opl.unitprice)*(opl.quantity))/(opp.Estimated_Duration__c); 
                        s.Revenue =(opl.amount__c )/(opp.Estimated_Duration__c)*0.5;            
                        system.debug('revenue-->'+s.Revenue);                    
                        s.ScheduleDate =  datemodification(opp.Estimated_Start_Date__c,j);                    
                        system.debug('date-->'+s.ScheduleDate);                    
                        s.OpportunityLineItemId = opl.id;
                        
                        s.Type = 'Revenue';
                        if(opl.Re_spread_Schedules__c==false)
                        {
                            System.debug('is this executing');
                            opportunitylineitemids.add(opl);
                        }
                        if(opl.Re_spread_Schedules__c==false)
                        {
                            newScheduleObjectsnew.add(s);
                        }
                        
                    }   
                    
                    
                }
                
                else{
                    if(opp.estimated_start_Date__c.day()>=21 && opp.estimated_start_Date__c.day()<=31 )
                    {
                        for(OpportunityLineItem opl : opp.OpportunityLineItems)
                        {
                            
                            for(j=0; j< opp.Estimated_Duration__c+1 ; j++)
                                
                            {   
                                if(j==0)
                                {
                                    //to skip 1st shedule 
                                }
                                if(j>0)
                                { 
                                    
                                    OpportunityLineItemschedule s = new OpportunityLineItemschedule();                  
                                    //s.Revenue = ((opl.unitprice)*(opl.quantity))/(opp.Estimated_Duration__c); 
                                    s.Revenue =(opl.amount__c )/(opp.Estimated_Duration__c);          
                                    system.debug('revenue-->'+s.Revenue);                    
                                    s.ScheduleDate =  datemodification(opp.Estimated_Start_Date__c,j);                    
                                    system.debug('date-->'+s.ScheduleDate);                    
                                    s.OpportunityLineItemId = opl.id;
                                    
                                    s.Type = 'Revenue';
                                    if(opl.Re_spread_Schedules__c==false)
                                    {
                                        System.debug('is this executing');
                                        opportunitylineitemids.add(opl);
                                    }
                                    if(opl.Re_spread_Schedules__c==false)
                                    {
                                        newScheduleObjectsnew.add(s);
                                    }
                                    
                                }  
                            }
                            
                        }   
                    }
                    
                }
            }
            
            
        }
        if(opportunitylineitemids.size()>0)
        {
            list<Opportunitylineitemschedule> oppdelnew = [select id,OpportunityLineitemId, OpportunityLineitem.opportunityid from OpportunityLineItemSchedule where OpportunityLineitemId  IN : opportunitylineitemids];
            System.debug('Deleting--->'+oppdelnew);
            delete oppdelnew; 
        }
        if(opportunitylineitemids1.size()>0)
        {
            list<Opportunitylineitemschedule> oppdelnew = [select id,OpportunityLineitemId, OpportunityLineitem.opportunityid from OpportunityLineItemSchedule where OpportunityLineitemId  IN : opportunitylineitemids1];
            System.debug('is this executing--->'+oppdelnew);
            delete oppdelnew; 
        }
        
        
        
        if(newScheduleObjectsNew.size() >0 ){
            
            system.debug('Inserting new-->'+newScheduleObjectsNew);
            
            insert newScheduleObjectsNew;
            
            system.debug('schedule2-->'+newScheduleObjectsNew);
            
        }
        if(newScheduleObjectsNew1.size() >0 ){
            
            system.debug('schedule1-->'+newScheduleObjectsNew);
            
            // insert newScheduleObjectsNew;
            
            system.debug('schedule2-->'+newScheduleObjectsNew);
            
        }
        
    }
    
    public static void delete_Schedules(List<OpportunityLineItemschedule> Oppty)
    {
        list<Opportunitylineitemschedule> oppdelnew = [select id,OpportunityLineitemId, OpportunityLineitem.opportunityid from OpportunityLineItemSchedule where OpportunityLineitem.opportunityid =: Oppty[0].id];
        delete oppdelnew;
    }
    
    
    
}