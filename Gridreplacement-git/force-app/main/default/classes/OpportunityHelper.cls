/***************************************************************************************
Class Name        : OpportunityHelper
Description       : This class is a helper class calling from Opportunity Master trigger
Created By        : Arif Hussain
Created Date      : Oct-7-2017
Last Modified By  : Arif Hussain
****************************************************************************************/
Public with sharing Class OpportunityHelper{

public static void Opportunitycreation(List<Opportunity> oppty){
    try{
        list<Opportunity> newp = new list<Opportunity>();
        Map<Id,Opportunity> mapParentOpps = new Map<Id,Opportunity>();
        system.debug('inserted 1 -->');
        for(Opportunity op : oppty)
        {
        if(op.Related_Opportunity__c == NULL && op.recordtypeid == '012U0000000Mfhr')
        {
           Opportunity newOpp = new Opportunity();
           system.debug('inserted 2 -->');
           newOpp.recordtypeid                 = '012U0000000MXbG';
           newOpp.Name                         = op.Name /*+ ' - Multi-Service'*/ ;
           newOpp.AccountId                    = op.AccountId;
           newOpp.EPM_Sub_Solution__c          = op.EPM_Sub_Solution__c ;
           newOpp.EPM_Sales_Lead__c            = op.EPM_Sales_Lead__c ;
           newOpp.EPM_Region__c                = op.EPM_Region__c;
           newOpp.StageName                    = op.StageName;
           newOpp.CurrencyIsoCode              = op.CurrencyIsoCode;
           newOpp.closeDate                    = op.closeDate;
           newOpp.EPM_Sub_Solution__c          = op.EPM_Sub_Solution__c;
           newOpp.EPM_Department__c            = op.EPM_Department__c;
           newOpp.EPM_Service_Line__c          = op.EPM_Service_Line__c; 
           newOpp.ES_A_BDM_Role__c              = op.ES_A_BDM_Role__c;
           newOpp.Estimated_Start_Date__c      = op.Estimated_Start_Date__c;
           newOpp.Total_Opportunity_Amount__c  = op.Amount;
           newOpp.Estimated_Duration__c        = op.Estimated_Duration__c;
           newOpp.NextStep                    = op.NextStep;
           newOpp.Next_Step_Stamp__c            = op.Next_Step_Stamp__c;
           newOpp.Referred_Company__c         = op.Referred_Company__c;
           newOpp.Type                        = op.Type;
             
                
           //newp.add(newOpp); 
           mapParentOpps.put(op.Id,newOpp);
        } 
        }
        if(!mapParentOpps.isEmpty())
        {
            upsert mapParentOpps.values();
            system.debug('inserted-->'+mapParentOpps);
        }
        
        for(Opportunity op : [select Id, Related_Opportunity__c from Opportunity where Id in : oppty])
        {
           
         op.Related_Opportunity__c = mapParentOpps.get(op.Id).Id;
         system.debug('This is op update '+op);
         system.debug('This is op update '+op.Related_Opportunity__c);
         newp.add(op);
        }
        if(newp.size() >0 && newp.size() !=NULL){
        update newp;
        }
   }
  catch(exception e)
  {
  system.debug('exception e-->'+e);
  }
 
 }
}