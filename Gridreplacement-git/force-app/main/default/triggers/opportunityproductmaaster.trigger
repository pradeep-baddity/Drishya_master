trigger opportunityproductmaaster on OpportunityLineItem (before Insert,before update , after insert ,after update,after delete) {
    
    Boolean isTriggerOff=false;
 
    set<id> opptyids = new set<id>();
    Trigger_Deactivation__c toff = Trigger_Deactivation__c.getInstance(userInfo.getProfileId());
    if(UserInfo.getName() != 'Data Mart'){
        system.debug('inside trigger');
        if( toff != null){
            isTriggerOff = toff.Trigger_Off__c;
        }
        if(!isTriggerOff){
            if(trigger.isinsert && trigger.isafter)
            {
                
               system.debug('inside trigger karisma');
               for(OpportunityLineItem opp: Trigger.new)
                {
                    opptyids.add(opp.id);
                    System.debug('opp.id----->k'+opp.id);
                }
                if(opptyids.size()>0)
                {
                    
                  //  teamSolutioncreation.teamsolution(opptyids);
                }
                //AggregateTCVRollup.TCVRollup(trigger.new);
            }
            if((trigger.isinsert || trigger.isupdate) && trigger.isbefore)
            {
                if(recursiveTriggerhandler.toStopProductCount ){
                    recursiveTriggerhandler.toStopProductCount  = false;
                    //ProductMapAssignment.autoMapProduct(trigger.new);
                }
                //opportunityproductdepartment.departmentupdateonproduct(trigger.new); 
            } 
            

            
            if(trigger.IsUpdate && trigger.IsBefore)
            {
                
                
                updateAmountonTeamsolution.amountupdate(trigger.new);
                set<id> lineId = new set<Id>();
                //if(recursiveTriggerhandler.isFirstTime){
                //recursiveTriggerhandler.isFirstTime = false;
                 for(opportunitylineItem opline : trigger.new)
                {
                    lineId.add(opline.Id);
                }
                list<opportunityLineItemSchedule> opschedule = [select id , opportunitylineitemId from opportunityLineItemSchedule where opportunitylineitemId In : lineId];
                list<opportunityLineItem> opLinelist = [select id , opportunityId from opportunityLineItem where opportunityId In : lineId];
              
                
                
                if(opschedule.size() > 0)
                {
                    system.debug('Size-->'+opschedule.size());
                    for(opportunitylineItem opp : trigger.new)
                    {
                        
                       // opp.Product_Schedule_Created__c = True;
                        system.debug('product schedule-->'+opp.Product_Schedule_Created__c);
                    }
                }
                else if(opschedule.size() <= 0)
                {
                    for(opportunitylineItem opp : trigger.new)
                    {
                     //   opp.Product_Schedule_Created__c = false;
                        system.debug('product schedule-->'+opp.Product_Schedule_Created__c);
                    }
                }
                //recursiveTriggerhandler.isFirstTime = false;
                String pricebookValue = System.Label.PriceBookId;
                for(opportunitylineItem oplinenew : trigger.new)
                {
                    system.debug('inside for loop'+oplinenew.Amount__c);
                    if((oplinenew.opportunity.Estimated_Start_Date__c == NULL || oplinenew.opportunity.Estimated_Duration__c == NULL) && oplinenew.offering_lost__c == false)
                    {
                        system.debug('Amount-->'+oplinenew.Amount__c);
                        oplinenew.unitPrice = oplinenew.Amount__c;
                        system.debug('Amount==>'+oplinenew.Amount__c);
                    }
                }
                
                
            }
            if(trigger.isupdate && trigger.isAfter)
            {    
                system.debug('Isfter-->');
                list<opportunitylineitem> offeringAmount = new list<opportunitylineitem>();
                list<opportunitylineitem> oOpportunityline = new list<opportunitylineitem>();
                list<opportunitylineitem> lostofferingfalse = new list<opportunitylineitem>();
                list<opportunitylineitem> offeringECV = new list<opportunitylineitem>();
                system.debug('recursive count'+recursiveTriggerhandler.isFirstTime);
                List<id> opportunityids = new List<id>();
                List<Opportunitylineitem> standardopportunitylineitems = new List<Opportunitylineitem>();
                List<Opportunitylineitem>  standardopportunitylineitems1 = new List<Opportunitylineitem>();
                List<Opportunitylineitem>  standardopportunitylineitems2 = new List<Opportunitylineitem>();
                if(recursiveTriggerhandler.isFirstTime){
                    recursiveTriggerhandler.isFirstTime = false;
                    for(opportunitylineitem opptynew : trigger.new)
                    { 
                        
                        opportunityids.add(opptynew.OpportunityId);
                    }
                    List<opportunity> opplist= [Select id,stageName,Estimated_Duration__c,Estimated_Start_Date__c,type from opportunity where id =:opportunityids];
                    System.debug('opportunity type---->'+opplist[0].type);
                    for(opportunitylineitem opptynew : trigger.new){ 
                        
                       
                        system.debug('startdate-->'+opptynew.Start_Date__c);
                        system.debug('duration-->'+opptynew.Estimated_Duration__c);
                        if((opptynew.Amount__c != trigger.OldMap.get(opptynew.Id).Amount__c) && opptynew.offering_lost__c== False && opptynew.Start_Date__c != NULL && opptynew.Estimated_Duration__c != NULL && opptynew.is_undefined__c == false)
                        {
                            system.debug('inside amount');
                            offeringAmount.add(opptynew);
                            
                        }
                        
                        if(opptynew.offering_lost__c == true && ((opptynew.offering_lost__c != trigger.OldMap.get(opptynew.Id).offering_lost__c)))
                        {
                            oOpportunityline.add(opptynew);
                        }
                        
                        if((opptynew.offering_lost__c != trigger.OldMap.get(opptynew.Id).offering_lost__c) && opptynew.offering_lost__c == false )
                        {
                            lostofferingfalse.add(opptynew);
                        }
                          //This if condition added by pradeep baddity on 5/4/2021 for user story  23356
                         
                        
                        if((opplist[0].Estimated_Duration__c!=null && opplist[0].Estimated_Start_Date__c!=null ) && (opptynew.Amount__c != trigger.OldMap.get(opptynew.Id).Amount__c) && opplist[0].type=='Standard Opportunity'  )
                        {
                            System.debug('ABC');
                            standardopportunitylineitems.add(opptynew);
                         }
                        if((opplist[0].Estimated_Duration__c!=null && opplist[0].Estimated_Start_Date__c!=null ) && opptynew.Re_spread_Schedules__c==false  && opplist[0].type=='Standard Opportunity' )
                        {
                            System.debug('DEF');
                            standardopportunitylineitems1.add(opptynew);
                            
                        }
                       
                    }//closing of for
                      
                    if(standardopportunitylineitems.size()>0)
                    {
                           list<opportunitylineitemschedule> dellistAmount=opportunityproductupdateammount.StandardOpportunityScheduleCreation(standardopportunitylineitems);
                           delete dellistAmount;
                     }
                   if(standardopportunitylineitems1.size()>0)
                   {
                        OpportunitySchedule.StandardOpportunityScheduleCreation(opplist);
                   }
                    
                /*    List<opportunityLineItem> opl_re_shedules = new List<opportunityLineItem>();
                    list<opportunityLineItem> opl_list = [select id , opportunityId,re_spread_schedules__c from opportunityLineItem where opportunityId In : opportunityids];
                    for(opportunityLineItem  opl : opl_list)
                    {
                        opl_re_shedules.add(opl);
                        
                    }
                    if(opl_re_shedules[0].re_spread_schedules__c==true)
                    {
                         system.debug('amount class--');
                        list<opportunitylineitemschedule> dellistAmount = opportunityproductupdateammount.OpportunityScheduleCreation(offeringAmount);
                        delete dellistAmount;
                    }*/

                    //code opplist[0].type!='Standard Opportunity' added by pradeep baddity on 5/4/2021 for user story  23356
                    if((offeringAmount != null && offeringAmount.size() >0 && opplist[0].type!='Standard Opportunity'))
                    {
                        system.debug('amount class--');
                        list<opportunitylineitemschedule> dellistAmount = opportunityproductupdateammount.OpportunityScheduleCreation(offeringAmount);
                        delete dellistAmount;
                    }
                    else if(oOpportunityline != null && oOpportunityline.size() > 0){
                        list<opportunitylineitemschedule> dellistlost = lostOpportunityOffering.lostOffering(oOpportunityline);
                        delete dellistlost;
                    }
                    else if(lostofferingfalse!=null && lostofferingfalse.size() > 0){
                        lostofferingwon.lostOffering(lostofferingfalse);
                    }
                    else{}
                }
                for(opportunitylineitem opptynew : trigger.new)
                {
                    system.debug('after update11111::'+opptynew.Offering_Estimated_Contract_Value_ECV__c);
                    system.debug('after update22222::'+trigger.OldMap.get(opptynew.Id).Offering_Estimated_Contract_Value_ECV__c);
                    if(opptynew.Offering_Estimated_Contract_Value_ECV__c != trigger.OldMap.get(opptynew.Id).Offering_Estimated_Contract_Value_ECV__c)
                    {
                        offeringECV.add(opptynew); 
                    }
                }
                
                if(offeringECV!=null && offeringECV.size() > 0){
                    AggregateTCVRollup.TCVRollup(offeringECV);
                }
            }
            teamSolutioncreation.teamsolution(trigger.new);
            
            if(trigger.isdelete && trigger.isAfter)
            {    
                AggregateTCVRollup.TCVRollup(trigger.old);
            }
        }
    }
    
}