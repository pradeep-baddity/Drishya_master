trigger Scheduleproducts on OpportunityLineItemSchedule (after update) {
    Boolean isTriggerOff=false;
    Trigger_Deactivation__c toff = Trigger_Deactivation__c.getInstance(userInfo.getProfileId());
    if(UserInfo.getName() != 'Data Mart'){
        if( toff != null){
                isTriggerOff = toff.Trigger_Off__c;
        }
            if(!isTriggerOff)
            {
                if(trigger.isafter && trigger.isupdate)
                {
                    set<id> setid = new set<Id>();
                    decimal count = 0;
                    decimal Amountcount = 0;
                    list<opportunitylineitem> opline = new list<opportunitylineitem>();
                    map<id,opportunitylineitem> oppline = new map<id,opportunitylineitem>();
                    map<id,opportunitylineitem> oppline1 = new map<id,opportunitylineitem>();
                      for(OpportunityLineItemSchedule scheduleitem : trigger.new)
                      {
                      setid.add(scheduleitem.OpportunityLineItemId);
                      }    
                    
                      for(OpportunityLineItem oplist : [select id,(select id,Actuals__c,OpportunityLineItemId,Revenue_Total__c,Revenue from OpportunityLineItemSchedules),Offering_Actual_Revenue_Rollup__c  from OpportunityLineItem where Id IN : setid])
                      {
                        system.debug('count--'+count);
                        count =0;
                        for(OpportunityLineItemSchedule op : oplist.OpportunityLineItemSchedules)
                        {
                          if(op.Actuals__c != null)
                          {
                            count = count + op.Actuals__c;
                            system.debug('Actuals---');
                          }
                          else {
                            count = count +op.Revenue;
                            system.debug('revenue---');
                          }
                        }
                        opportunitylineitem  oplinenew =  new opportunitylineitem(Id = oplist.id);
                        oplinenew.Offering_Actual_Revenue_Rollup__c = count;
                        opline.add(oplinenew);
                        oppline.put(oplinenew.id, oplinenew );
                      }
                      
                      for(OpportunityLineItem oplist1 : [select id,(select id,OpportunityLineItemId,Revenue from OpportunityLineItemSchedules),Amount__c  from OpportunityLineItem where Id IN : setid])
                      {
                        Amountcount = 0;
                        for(OpportunityLineItemSchedule op1 : oplist1.OpportunityLineItemSchedules)
                        {
                          //if(op1.revenue != trigger.oldmap.get(op1.id).revenue)
                            //{   
                            Amountcount = Amountcount +op1.Revenue;
                            system.debug('revenue---');
                            //}
                          
                        }
                        
                        opportunitylineitem  oplinenew1 =  new opportunitylineitem(Id = oplist1.id);
                        oplinenew1.Amount__c = Amountcount;
                        opline.add(oplinenew1);
                        oppline1.put(oplinenew1.id, oplinenew1 );
                      }
                      
                      update oppline.values();
                      update oppline1.values();
                        if(opline != null && opline.size() > 0)
                        {
                          //update opline;
                        }
                }
                
                
            }
   }
}