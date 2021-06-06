public class HC_CreateUpsellOrExtentionOpty {
    public HC_CreateUpsellOrExtentionOpty(){
        
    }
    
    @AuraEnabled
    public static LIST<OfferingWrapper> getOppLines(String recId){
        LIST<OfferingWrapper> listOfOfferings = new LIST<OfferingWrapper>();
        
        List<OpportunityLineItem> oLIlist= [SELECT Id, Product2Id,ProductName__c, Quantity, Elite_Department_ID__c, Elite_Department__c, Elite_Dept_Formula__c,CurrencyIsoCode,
                                            Elite_Service_Line_ID__c, UnitPrice,Discount,ListPrice,Elite_Service_Line__c, Geography__c, Module_or_Accelerator2__c,Estimated_Duration__c, Practice__c,ProductCode,
                                            Offering__c, Service_Line_or_Product__c,Service__c, Capability__c,Expertise__c,Technology_Vendor__c, Technology_Capability__c, Technology_Module__c ,Offering_Lost__c,PricebookEntryId,Amount__c  ,EDU_Segment__c               
                                            FROM OpportunityLineItem where opportunityId=:recId AND offering_lost__c = false];
        
        for(OpportunityLineItem each : oLIlist){
            OfferingWrapper newOff = new OfferingWrapper(each.ProductName__c ,
                                              each.Expertise__c, each.Capability__c,each.Service__c,
                                                         each.Technology_Vendor__c, each.Technology_Capability__c, each.Technology_Module__c,each, 
                                                         each.Estimated_Duration__c ,
                                                         each.UnitPrice);
            listOfOfferings.add(newOff);
        }
        system.debug('listOfOfferings###'+listOfOfferings);      
        return listOfOfferings;
    }
    
    @auraEnabled
    public static  Opportunity createOpportunity(string recordId,String optyType, Date estdDate , List<string> selectedOLI , decimal duration ,Date InitiateRenewal,Date EOCD,String opportunityName , String offeringsList){
        system.debug('duration###'+duration);
        system.debug('offeringsList###'+offeringsList);
        List<OfferingWrapper> offList = (List<OfferingWrapper>)JSON.deserialize(offeringsList, List<OfferingWrapper>.class);
        Map<Id, opportunity> newMapopportunity = new map<Id, opportunity>();
        list<opportunity> oppNew = new list<opportunity>();
        system.debug(offList);
        Map<Id, List<Sales_Credit_Employee__c>> salescreditemployee = new Map<Id, List<Sales_Credit_Employee__c>>();
        Map<Id, list<Sales_Credit__c>> salescredit = new Map<Id, list<Sales_Credit__c>>();
        Account Acc = [select id from Account where name  = 'NONE (Do Not Edit)' limit 1];
        Opportunity oldOpportunity =[SELECT id,Name,StageName,Legacy_Opportunity_ID__c,CloseDate,AccountId,Amount,Type,CurrencyIsoCode,Industry__c,
                                     Competitor__c,RecordType.Name,Estimated_Duration__c,Estimated_Start_Date__c,Description,Pricing_Review_Status__c,
                                     EPM_Region__c,Oppty_ID_For_Elite__c,Date_Last_Closed__c,Agreed_Exchange_Rate__c,LeadSource,Pricebook2Id,Lost_To_Competitor_Legal__c,Probability_Adjusted_del1__c,AddOnUpSaleEndDate__c,Effective_Date__c,MD_of_Record__c,AddOnUpSaleEngagementNumber__c,Product_with_Service_or_Product__c,Product_with_Geography__c,Product_with_Practice__c,CountOpportunityContactRole__c,
                                     EPM_Sales_Lead__c,SABER_Original_Opportunity_ID__c , renewalcreated__c
                                     FROM Opportunity WHERE id =:recordId Limit 1 ];
        
        
        
        system.debug('oldOpportunity--'+oldOpportunity);
        
        Opportunity newOpportunity                      = oldOpportunity.clone(false,true);
        newOpportunity.Name                             = opportunityName;
        newOpportunity.Legacy_Opportunity_ID__c         = oldOpportunity.Id;
        
        // newOpportunity.Name                          = oldOpportunity.Name + '-'+ optyType;
        newOpportunity.Type                             = optyType;    
        newOpportunity.LeadSource                       = 'Established Client';  
        newOpportunity.MD_of_Record__c                  = oldOpportunity.MD_of_Record__c ; 
        newOpportunity.Estimated_Duration__c            = duration;
        newOpportunity.CloseDate                        = EOCD;
        newOpportunity.Date_Last_Closed__c              = null ;
        newOpportunity.Competitor__c                    = Acc.Id;
        newOpportunity.IsAddOn_Extension_Opportunity__c = true;
        newOpportunity.RenewalCreated__c                = false;
        newOpportunity.Reason_Won__c                    ='Existing Customer / Client Relationship';
        newOpportunity.Effective_Date__c                = EOCD;
        newOpportunity.SABER_Original_Opportunity_ID__c = oldOpportunity.Id;
        newOpportunity.Estimated_Start_Date__c          = EOCD;
       
        
       
        if(optyType == 'AddOn/UpSell')
        {
           // newOpportunity.Estimated_Start_Date__c      = EOCD;
            newOpportunity.StageName                    = 'Prospect (0-14%)';
        }
        else if(optyType == 'Extension Opportunity'){
             
           // newOpportunity.Estimated_Start_Date__c = newOpportunity.CloseDate;
            newOpportunity.StageName                        = 'Prospect (0-14%)';
        }
        else if(optyType == 'Renewal Opportunity'){
            newOpportunity.StageName = 'Prospect (0-14%)';
            newOpportunity.Initiate_Renewal__c  =  InitiateRenewal;
            newOpportunity.AutoCreateRenewal__c =  true;
            newOpportunity.RenewalCreated__c    = false;
          //  newOpportunity.AddOnUpSaleEndDate__c   = newOpportunity.Estimated_Start_Date__c.addMonths( Integer.valueOf(oldOpportunity.Estimated_Duration__c)).addDays(-1);
           system.debug('RenewalTap####'+newOpportunity.AddOnUpSaleEndDate__c);
            newOpportunity.Next_Renewal_Date__c    = newOpportunity.Estimated_Start_Date__c.addMonths( Integer.valueOf(newOpportunity.Estimated_Duration__c));
            //newOpportunity.Product_with_Service_or_Product__c = 0;
            //newOpportunity.Product_with_Geography__c  = 0;
            //newOpportunity.Product_with_Practice__c = 0;
            newOpportunity.CountOpportunityContactRole__c = 1;
            
        }
        newOpportunity.AddOnUpSaleEndDate__c=(newOpportunity.Estimated_Start_Date__c.addMonths(Integer.valueOf(newOpportunity.Estimated_Duration__c)).addDays(-1));
        insert newOpportunity;
        newMapopportunity.put(oldOpportunity.id, newOpportunity);
        system.debug('new opp--'+newMapopportunity);
       
        
       
         /** Looking For OpportunityContactRole **/
        List<OpportunityContactRole> listOppContactRole = [SELECT Id, OpportunityId, ContactId, Role FROM OpportunityContactRole where OpportunityId =: recordId];
        List<OpportunityContactRole> listOppContactRoleToUpdate = new List<OpportunityContactRole>();
        
        for(OpportunityContactRole oRc:listOppContactRole){
            OpportunityContactRole newORCObj = oRc.clone(false, True, false, false);
            newORCObj.OpportunityId = newOpportunity.Id;
            listOppContactRoleToUpdate.add(newORCObj);
        }
        
        if(listOppContactRoleToUpdate.size()>0){
            insert listOppContactRoleToUpdate ;
        }
        List<OpportunityLineItem> mapOfOLISToUpdate = mapNewOppToOppLines(newOpportunity,offList);
        
       /** updating the opportunity with type Renwal to  Commit stage **/
        if(optyType == 'Renewal Opportunity'){
           Opportunity OpportunityToUpdate = new Opportunity(Id = newOpportunity.Id,bypassvalidation__c = true, stageName='Commit (85-99%)');
          //  Opportunity OpportunityToUpdate = new Opportunity(Id = newOpportunity.Id,stageName='Commit (85-99%)');
           system.debug('OpportunityToUpdate--'+OpportunityToUpdate);   
            update OpportunityToUpdate;
            
            //newMapopportunity.put(oldOpportunity.id, newOpportunity);
            
            if(newMapopportunity.containsKey(oldOpportunity.Id)){
                Opportunity OldOpportunityToUpdate = new Opportunity(Id = oldOpportunity.Id);
                    OldOpportunityToUpdate.RenewalCreated__c = true;
                    oppNew.add(OldOpportunityToUpdate);
                    update OldOpportunityToUpdate;
                    } 
            
        }
        
        
        list<sales_credit_employee__c> salescredit_employee = [select Id,Role__c,Sales_Credit__c,Name,Split__c,Huron_Employee__c,RecordTypeId, Opportunity_on_sc__c from sales_credit_employee__c where  Opportunity_on_sc__c =: recordId];
        list<sales_credit__c> salescredit_old = [select id, Name, Opportunity__c,Meets_Criteria__c,RecordTypeId from sales_credit__c where  Opportunity__c =: recordId];
        system.debug('salescredit-old--'+salescredit_old);
        system.debug('salescreditemployee-old--'+salescredit_employee);
        
        //mapNewsalescredit(newOpportunity, salescredit_employee); 
        List<sales_credit__c> salesCredit_New = mapSalesCreditNew(newOpportunity,salescredit_old); 
        List<sales_credit_employee__c> salesCreditEmployee_New = mapSalesCreditEmployeeNew(newOpportunity,salescredit_employee ,salesCredit_New ); 
        
        return newOpportunity;
    }
    
    public static List<sales_credit__c> mapSalesCreditNew(Opportunity newOpp,List<sales_credit__c> sc_old){
        list<sales_credit__c> sc = new list<sales_credit__c>();
        
        for(sales_credit__c s : sc_old)
        {
            sales_credit__c sNew = s.clone(false,true);
            sNew.Opportunity__c = newOpp.Id;
            sc.add(sNew);
        }
        
        if(sc!=NULL && sc.size()>0)
        {
            insert sc;
        }
        return sc;
    }
    
    public static List<sales_credit_employee__c> mapSalesCreditEmployeeNew(Opportunity newOpp,List<sales_credit_employee__c> scEmp_old , List<sales_credit__c> sc_new){
        list<sales_credit_employee__c> sc = new list<sales_credit_employee__c>();
        for(sales_credit_employee__c s : scEmp_old)
        {
            sales_credit_employee__c sNew = s.clone(false,true);
            sNew.Sales_Credit__c = sc_new[0].Id;
            sc.add(sNew);
            
        }
        
        if(sc!=NULL && sc.size()>0)
        {
            insert sc;
        }
        return sc;
    }
    
    /****  Method to clone OLI * **
*   parameters(recId,OppLineItems)   
*/ 
    public static List<OpportunityLineItem> mapNewOppToOppLines(Opportunity newOpp,List<OfferingWrapper> OppLineItems){
        List<OpportunityLineItem> oLIlistToBeInserted = new List<OpportunityLineItem>();
        Set<id> opportunityLineItemIds = new set<id>();
        Map<Id,Id> oldOlisToNewOlis = new Map<Id,Id>();        
        
        for(OfferingWrapper oli : OppLineItems){
            OpportunityLineItem newOLiObj = oli.optyLine.clone(false, true);
            newOLiObj.OpportunityId = newOpp.Id;
            system.debug('**************'+oli.salesPrice);
            newOLiObj.UnitPrice     = oli.salesPrice;
            newOLiObj.Amount__c     = oli.salesPrice;
            newOLiObj.Offering_Actual_Revenue_Rollup__c     = oli.salesPrice;
            //newOLiObj.Estimated_Duration__c = (Decimal)oli.duration;
            //newOLiObj.PriceBookEntryId= oli.PriceBookEntryId;
            //opportunityLineItemIds.add(oli.id);  
            oLIlistToBeInserted.add(newOLiObj);            
        }
        
        IF(oLIlistToBeInserted.size()>0){
            insert oLIlistToBeInserted;
        }
        system.debug('oLIlistToBeInserted:'+oLIlistToBeInserted);
        
        
        /** --------------------OpportunityLineItemSchdule Creation------**/       
        List<OpportunityLineItemSchedule> oLISchduleToBeInserted = new List<OpportunityLineItemSchedule>();
        for(OpportunityLineItem eachOLI : oLIlistToBeInserted){
            system.debug(eachOLI);
            for(Integer i=0 ; i< newOpp.Estimated_Duration__c ; i++)
            {
                OpportunityLineItemSchedule newSched = new OpportunityLineItemSchedule();
                newSched.OpportunityLineItemId  = eachOLI.Id;
                newSched.Type                   = 'Revenue';
                newSched.Revenue                = (eachOLI.UnitPrice*eachOLI.quantity)/(newOpp.Estimated_Duration__c);
                newSched.ScheduleDate           = datemodificationnew(newOpp.Estimated_Start_Date__c,i);
                oLISchduleToBeInserted.add(newSched);
            }
        }
        
        if(oLISchduleToBeInserted.size()>0){
            system.debug('OLIS--->>'+oLISchduleToBeInserted);
            insert oLISchduleToBeInserted;
        }               
        return oLIlistToBeInserted;
    } 
    
    
    public static date datemodificationnew(date startdate,Integer i)
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