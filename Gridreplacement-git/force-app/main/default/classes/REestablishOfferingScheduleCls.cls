public class REestablishOfferingScheduleCls {
    
    @AuraEnabled
    public static Boolean estimatedFieldsCheckOnOpty(Id opportunityrecordId){
        Id eduOptyId = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('EDU Opportunity').getRecordTypeId();
        Opportunity oppty = [select id,name,Probability,RecordTypeId,stageName,RecordType.Name,Estimated_Duration__c,Old_Estimated_Duration__c,Old_Estimated_Engagement_Start_Date__c,Estimated_Start_Date__c,OpportunityLineItemOfferingLostCount__c from Opportunity where Id = : opportunityrecordId LIMIT 1];
        if( oppty.OpportunityLineItemOfferingLostCount__c <> 0 && oppty.StageName !='Closed Won (100%)' && oppty.StageName !='Closed Lost' && oppty.Estimated_Duration__c != null && oppty.Estimated_Duration__c != 0 &&((oppty.Old_Estimated_Duration__c != null) || (oppty.Old_Estimated_Engagement_Start_Date__c != null)) )
        {
            System.debug('-=-=-first if=-=-=-');
            if(oppty.Old_Estimated_Duration__c != oppty.Estimated_Duration__c || oppty.Old_Estimated_Engagement_Start_Date__c != oppty.Estimated_Start_Date__c){
                System.debug('-=-=-second if=-=-=-');  
                return true;                
            }
        }
        return false;
    }
    
    @AuraEnabled
    public static void updateOptyOldValues(Id opportunityrecordId){
        system.debug(opportunityrecordId);
        Opportunity oppty = [select id,name,Estimated_Duration__c,Old_Estimated_Duration__c,Old_Estimated_Engagement_Start_Date__c,Estimated_Start_Date__c from Opportunity where Id = : opportunityrecordId LIMIT 1];
        oppty.Old_Estimated_Duration__c = oppty.Estimated_Duration__c;
        oppty.Old_Estimated_Engagement_Start_Date__c = oppty.Estimated_Start_Date__c;
        update oppty;
    }
    
    @AuraEnabled
    public static list<OpportunityLineItemSchedule> clickYes(Id opportunityLineitemrecordId){
        
        List<OpportunityLineItemSchedule> newScheduleObjects = new List<OpportunityLineItemSchedule>();
        List<OpportunityLineItem> opline = new List<OpportunityLineItem>();
        
        list<Opportunitylineitemschedule> oppdel = [select id from Opportunitylineitemschedule where OpportunityLineItemId =: opportunityLineitemrecordId];
        
        //database.delete(opp, false);
        
        system.debug('oppdel before-->'+oppdel);
        
        delete oppdel;
        
        OpportunityLineItem opp = [select id,opp_recordtype__c ,amount__c,opportunity_probability__c,Offering_Actual_Revenue_Rollup__c,Start_Date__c,quantity,Estimated_Duration__c,Offering_Lost__c from OpportunityLineItem where Offering_Lost__c = false AND Id = : opportunityLineitemrecordId];
        
        system.debug('opp===>'+opp);
        
        for(integer i=0; i< opp.Estimated_Duration__c ; i++)
            
        {
            system.debug('inside-->');
            
            OpportunityLineItemschedule s = new OpportunityLineItemschedule();
            
            s.Revenue = ((opp.amount__c)*(opp.quantity))/(opp.Estimated_Duration__c);
            
            s.ScheduleDate =  datemodificationnew(opp.Start_Date__c,i);
            
            system.debug('date-->'+s.ScheduleDate);
            
            s.OpportunityLineItemId = opp.id;
            
            s.Type = 'Revenue';
            
            newScheduleObjects.add(s);
            
        }
        
        opportunitylineitem  oplinenew =  new opportunitylineitem(Id = opp.id);
                                        oplinenew.Offering_Actual_Revenue_Rollup__c = opp.Amount__c;
                                        opline.add(oplinenew);    
        
        if(newScheduleObjects.size() >0 ){
            
            system.debug('schedule1-->'+newScheduleObjects);
            
            insert newScheduleObjects;
            
            system.debug('schedule2-->'+newScheduleObjects);
            
        }
        system.debug('opline11-->'+opline);
        if(opline != null && opline.size() > 0)
        {
        update opline;
        }
          system.debug('opline22-->'+opline);
        return newScheduleObjects;
        
    }
    
    @AuraEnabled
    public static list<OpportunityLineItemSchedule> ScheduleRecreation(Id opportunityrecordId){
        Integer i,j;
        List<OpportunityLineItem> opline = new List<OpportunityLineItem>();
        List<OpportunityLineItemSchedule> newScheduleObjectsNew = new List<OpportunityLineItemSchedule>();        
        list<Opportunitylineitemschedule> oppdelnew = [select id,OpportunityLineitemId, OpportunityLineitem.opportunityid from OpportunityLineItemSchedule where OpportunityLineitem.opportunityid =: opportunityrecordId];
        //database.delete(opp, false);
        system.debug('oppdel before-->'+oppdelnew);
        
        for(Opportunity opp : [select id, name, StageName, Estimated_Start_Date__c, Estimated_Duration__c, Amount, Product_Count__c
                               ,(select id, product2id, opportunityid ,quantity, unitprice , amount__c, Offering_Lost__c ,Product_Schedule_Created__c
                                 from OpportunityLineItems where Offering_Lost__c = false)
                               from Opportunity where id = : opportunityrecordId])
        {
            system.debug('opp--->'+opp);
            
            for(OpportunityLineItem opl : opp.OpportunityLineItems){
                
                for(j=0; j< opp.Estimated_Duration__c ; j++)
                    
                {                    
                    system.debug('Inside for schedule');                    
                    OpportunityLineItemschedule s = new OpportunityLineItemschedule();                  
                    s.Revenue = ((opl.unitprice)*(opl.quantity))/(opp.Estimated_Duration__c);                    
                    system.debug('revenue-->'+s.Revenue);                    
                    s.ScheduleDate =  datemodificationnew(opp.Estimated_Start_Date__c,j);                    
                    system.debug('date-->'+s.ScheduleDate);                    
                    s.OpportunityLineItemId = opl.id;
                    
                    s.Type = 'Revenue';
                    
                    newScheduleObjectsnew.add(s);
                    
                }
                
                opportunitylineitem  oplinenew =  new opportunitylineitem(Id = opl.id);
                                        oplinenew.Offering_Actual_Revenue_Rollup__c = opl.Amount__c;
                                        opline.add(oplinenew);    
                
            }       
            
        }
        if(newScheduleObjectsNew.size() >0 ){
            
            system.debug('schedule1-->'+newScheduleObjectsNew);
            
            insert newScheduleObjectsNew;
            
            system.debug('schedule2-->'+newScheduleObjectsNew);
            
        }
        
        
        delete oppdelnew;
        
        update opline;
        
        return newScheduleObjectsnew;
        
        
        
    }
    
    public static date datemodificationnew(date startdate,Integer i){
        
        date next;
        
        Date mydate;
        
        if (startdate != null) {
            
            mydate = startdate.toStartOfMonth();
            
            system.debug('mydate-->'+mydate);
            
            next = mydate.addMonths(i);
            
        }
        
        return next;
        
    }
    
    
    
    //// *************************For Offering Level reestablishment   
    @AuraEnabled
    public static Boolean salesAmountChangeCheck(Id offeringRecID){
        Id eduOptyId = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('EDU Opportunity').getRecordTypeId();        
        OpportunityLineItem opptyLine = [select id,name,Amount__c,Old_Amount__c,Opportunity.RecordTypeId,OpportunityId,Opportunity.Probability from OpportunityLineItem where id=:offeringRecID LIMIT 1];
        system.debug(opptyLine);
        if(opptyLine.Opportunity.Probability == 100 && opptyLine.Opportunity.RecordTypeId==eduOptyId && opptyLine.Amount__c != opptyLine.Old_Amount__c )
        {
            system.debug('Amount changed-->');
            return true;
        }
        return false;
    }
    
    @AuraEnabled
    public static void updateOfferingOldValue(Id offeringRecID){
        system.debug(offeringRecID);
        OpportunityLineItem opptyLine = [select id,name,Amount__c,Old_Amount__c,OpportunityId,Opportunity.Probability from OpportunityLineItem where id=:offeringRecID LIMIT 1];
        opptyLine.Old_Amount__c = opptyLine.Amount__c;        
        update opptyLine;
        
    }
    
    @AuraEnabled
    public static list<OpportunityLineItemSchedule> ScheduleRecreationOfOffering(Id offeringRecID){
        Integer i,j;
        List<OpportunityLineItemSchedule> newScheduleObjectsNew = new List<OpportunityLineItemSchedule>();
        list<opportunitylineitem> opline = new list<opportunitylineitem>();
        list<Opportunitylineitemschedule> oppdelnew = [select id,OpportunityLineitemId, OpportunityLineitem.opportunityid from OpportunityLineItemSchedule where OpportunityLineItemId =: offeringRecID];
        //database.delete(opp, false);
        system.debug('oppdel before-->'+oppdelnew);
        delete oppdelnew;       
        for(OpportunityLineItem opl :  [select id, product2id, opportunityid ,Amount__c,Start_Date__c,Estimated_Duration__c,quantity, unitprice , Offering_Lost__c ,Product_Schedule_Created__c
                                        from OpportunityLineItem where Offering_Lost__c = false and id =:offeringRecID]){
                                            
                                            for(j=0; j< opl.Estimated_Duration__c ; j++){
                                                system.debug('Inside for schedule');
                                                OpportunityLineItemschedule s = new OpportunityLineItemschedule();
                                                s.Revenue = ((opl.Amount__c)*(opl.quantity))/(opl.Estimated_Duration__c);
                                                s.ScheduleDate =  datemodificationnew(opl.Start_Date__c,j);
                                                s.OpportunityLineItemId = opl.id;
                                                s.Type = 'Revenue';
                                                newScheduleObjectsnew.add(s);
                                            }
                                            
                                        opportunitylineitem  oplinenew =  new opportunitylineitem(Id = opl.id);
                                        oplinenew.Offering_Actual_Revenue_Rollup__c = opl.unitprice;
                                        opline.add(oplinenew);    
                                        }                                      
        
        if(newScheduleObjectsNew.size() >0 ){
            system.debug('schedule1-->'+newScheduleObjectsNew);
            insert newScheduleObjectsNew;
            system.debug('schedule2-->'+newScheduleObjectsNew);
            
        }
        system.debug('opline11-->'+opline);
        if(opline != null && opline.size() > 0)
        {
        //update opline;
        }
          system.debug('opline22-->'+opline);
        
        return newScheduleObjectsnew; 
        
    }
    
}