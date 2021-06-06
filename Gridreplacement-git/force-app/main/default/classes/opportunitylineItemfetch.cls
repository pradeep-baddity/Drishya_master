public class opportunitylineItemfetch {
    
    @AuraEnabled
    public static List<opportunitylineitem> fetchopportunitylineitem(Id lineitemId)
    {
        List<opportunitylineitem> opporutnityLineItemList = new List<opportunitylineitem>();
        try{
            Id profileId=userinfo.getProfileId();
            String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
            opportunity opps =[SELECT Id, Name, Pricebook2Id, currencyIsocode FROM opportunity where id =:lineitemId]; 
            List<opportunitylineitem> oppline = [Select ID,convertCurrency(UnitPrice),Amount__c,Product2.Name,Product2Id,Practice__c,Capability_new__c,Expertise__c,is_Non_Restricted_User__c
                                                 from opportunitylineitem where opportunityId = : lineitemId and CurrencyIsoCode =:opps.CurrencyIsoCode ORDER BY CREATEDDATE DESC];
            
            for(opportunitylineitem oppItem: oppline){
            system.debug('profilein--');
                /*if(profileName != null && (profileName.containsIgnoreCase('Non-Restricted') || profileName.containsIgnoreCase('System Administrator'))){
                    oppItem.is_Non_Restricted_User__c = false;
                }else{*/
                    //oppItem.is_Non_Restricted_User__c = true;
                
                opporutnityLineItemList.add(oppItem); 
            }
           /* return[Select ID,Name,Amount__c, Offering__c,Service_Line_or_Product__c,Offering_Lost__c,Geography__c,Module_or_Accelerator2__c
                   from opportunitylineitem where opportunityId = : lineitemId  ORDER BY CREATEDDATE DESC];*/
            
        }catch(Exception ex){
            //throw new AuraHandledException(ex.getDmlMessage(0).replaceFirst(': \\[\\] .*',''));
            throw new AuraHandledException('Something went wrong: '+ ex.getMessage());
        }
        system.debug('opporutnityLineItemList-'+opporutnityLineItemList);
          return opporutnityLineItemList;
    }
    
    @AuraEnabled
    public static List<opportunitylineitem> offeringReadOnlyRecords(Id lineitemId)
    {
        try{
            System.debug('In controller getAccounts method..');
            return [Select ID,Offering__c,Service_Line_or_Product__c,Module_or_Accelerator2__c,amount__c
                    from opportunitylineitem where opportunityId = : lineitemId  ORDER BY CREATEDDATE DESC];
        }catch(Exception ex){
            throw new AuraHandledException(ex.getDmlMessage(0).replaceFirst(': \\[\\] .*',''));
        }
        
    }
    
    @AuraEnabled
    public static OpportunityLineItemSchedule getscheduleinformation(Id lineitemId)
    {
        List<OpportunityLineItemSchedule> lineItemList = new List<OpportunityLineItemSchedule>();
        List<OpportunityLineItemSchedule> lineItemListnew = new List<OpportunityLineItemSchedule>();
        List<OpportunityLineItem> lineItem = new List<OpportunityLineItem>();
        OpportunityLineItemSchedule schedule = new OpportunityLineItemSchedule();
        date mydate;
        try{
            System.debug('In controller getAccounts method 2..');
            //return [Select ID,Name,Amount__c, Offering__c,Service_Line_or_Product__c,Offering_Lost__c,Geography__c,Module_or_Accelerator2__c
            //from opportunitylineitem where opportunityId = : lineitemId  ORDER BY CREATEDDATE DESC LIMIT 10];
            lineItemList = [Select Id,OpportunityLineItemId,ScheduleDate,Revenue,Opportunitylineitem.Start_Date__c,Opportunitylineitem.Estimated_Duration__c,Opportunitylineitem.Offering__c,Opportunitylineitem.unitprice from OpportunityLineItemSchedule where OpportunityLineItemId =:lineitemId  ORDER BY scheduledate ASC LIMIT 1];
            System.debug('lineItemList:'+lineItemList);
            
            if(lineItemList.size() > 0)
            {
                for(OpportunityLineItemSchedule opline : lineItemList)
                {
                    mydate = opline.ScheduleDate;
                    if(mydate != null)
                    {
                        schedule.ScheduleDate = mydate;
                        schedule.Revenue = opline.Opportunitylineitem.unitprice;
                        schedule.Quantity= opline.Opportunitylineitem.Estimated_Duration__c;
                    }/*else{
schedule.ScheduleDate = lineItemList.Opportunitylineitem.Start_Date__c;
schedule.Revenue = opline.Opportunitylineitem.unitprice;
schedule.Quantity= opline.Opportunitylineitem.Estimated_Duration__c;
}*/
                }
            }
            else{
                lineitem = [select id, Start_Date__c,Estimated_Duration__c,unitprice from opportunitylineitem where id = : lineitemId];
                schedule.ScheduleDate = lineItem[0].Start_Date__c;
                schedule.Revenue = lineItem[0].unitprice;
                schedule.Quantity= lineItem[0].Estimated_Duration__c;
                
            }
            //  lineItemListnew.add(schedule);
            //   return lineItemListnew;
            // System.debug('schedule::'+schedule);
            return schedule;
        }catch(Exception ex){
            throw new AuraHandledException(ex.getDmlMessage(0).replaceFirst(': \\[\\] .*',''));
        } 
    }
    
    
    @AuraEnabled
    public static List<opportunitylineitem> deleteopportunitylineitemId(Id lineItemId, Id OpportunityId)
    {
        List<opportunitylineitem> lineItemList = new List<opportunitylineitem>();
        try{
            if(lineItemId != null){
                OpportunityLineItem delAccount=[Select Id from OpportunityLineItem where id=:lineItemId];
                delete delAccount;
            }
            lineItemList = [Select ID,Name,Amount__c,unitprice,Quantity,Offering__c,Service_Line_or_Product__c,Offering_Lost__c,Geography__c,Module_or_Accelerator2__c,OpportunityId from OpportunityLineItem where OpportunityId =:OpportunityId ORDER BY CREATEDDATE DESC];
            
            return lineItemList;
        }
        catch(Exception ex){
            throw new AuraHandledException(ex.getDmlMessage(0).replaceFirst(': \\[\\] .*',''));
        }
    }
    
    @AuraEnabled
    public static List<OpportunityLineItemSchedule> recreateSchedules(Id lineItemId, Date schdate, double rev, Integer duemonths)
    {
        system.debug('Inside for schedule::'+lineItemId);
        List<OpportunityLineItemSchedule> newScheduleObjects = new  List<OpportunityLineItemSchedule>();
        List<OpportunityLineItem> opplinenew = new  List<OpportunityLineItem>();
        try{
            List<OpportunityLineItemSchedule>  oplineitem = [select id from OpportunityLineItemSchedule where OpportunityLineItemId =: lineItemId];
            system.debug('oplineitem-->'+oplineitem);
            database.delete(oplineitem);
            
            system.debug('oplineitem after-->'+oplineitem);
            
            
            for(integer j=0; j< duemonths ; j++){
                OpportunityLineItemschedule s = new OpportunityLineItemschedule();
                s.Revenue = (rev)/(duemonths);
                s.ScheduleDate =  datemodification((schdate),j);
                s.OpportunityLineItemId = lineItemId;
                s.Type = 'Revenue';
                newScheduleObjects.add(s);
            }
            
            if(newScheduleObjects.size() > 0 ){
                system.debug('schedule123-->'+newScheduleObjects);
                insert newScheduleObjects;
            }
            
            for (opportunitylineitem opline : [select id, amount__c, unitprice, Offering_Actual_Revenue_Rollup__c from OpportunityLineItem where Id =: lineItemId] )
            {
                system.debug('in--');
                opline.amount__c = rev;
                opline.Offering_Actual_Revenue_Rollup__c= rev;
                opplinenew.add(opline);
            }
            
            if(opplinenew.size() > 0 ){
                system.debug('amount-->'+opplinenew);
                update opplinenew;
            }
            
            
        }catch(Exception ex){
            throw new AuraHandledException(ex.getDmlMessage(0).replaceFirst(': \\[\\] .*',''));
        }
        return newScheduleObjects;
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