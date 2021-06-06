public class healthcareHelper {
    
    public static void extensioncreation(List<Opportunity> oppty, map<Id,opportunity> newmap1, map<Id,opportunity> oldmap1){
        try
        {
         list<Opportunity> newp = new list<Opportunity>();
         list<Opportunity> newOpr = new list<Opportunity>();
                 for(Opportunity opp : oppty )
                 { 
                 Opportunity oldOpp = oldmap1.get(opp.ID);
                 Opportunity newOpp1 = newmap1.get(opp.ID);
                  
            if( newOpp1.AutoCreateRenewal__c != oldOpp.AutoCreateRenewal__c && opp.recordtypeid == '012U0000000Mdat' && opp.Healthcare_Solutions2__c == 'Healthcare-IT Services :1458' && opp.AutoCreateRenewal__c == True && Opp.RenewalCreated__c == False && (!opp.StageName.contains('Closed Lost')))
                {
                    
                       Opportunity newOpp                    = new Opportunity();
                       newOpp.recordtypeid                   = '012U0000000Mdat';
                       //newOpp.Related_Opportunity__c       = opp.Id;
                       newOpp.Name                           = opp.Name + ' - Auto Extension' ;
                       newOpp.AccountId                      = opp.AccountId;
                       newOpp.Owner                          = opp.Owner ;
                       newOpp.Healthcare_Solutions2__c       = opp.Healthcare_Solutions2__c ;
                       newOpp.Healthcare_Solutions__c        = opp.Healthcare_Solutions__c;
                       newOpp.type                           = 'Extension Opportunity';
                       newOpp.Estimated_Duration__c          = opp.Estimated_Duration__c;
                       newOpp.AutoCreateRenewal__c           = False;
                       newOpp.StageName                      = 'Exploration (0% - 39%)';
                       newOpp.Probability                    = 10;
                       date newDate                          = (opp.closeDate).addMonths((Integer)opp.Estimated_Duration__c);
                       newOpp.CloseDate                      = newDate ;
                       date newDate1                         = (opp.closeDate).addMonths((Integer)opp.Estimated_Duration__c);
                       newOpp.Effective_Date__c              =  SABERdatemodification(newDate1) ;
                       newOpp.Estimated_Start_Date__c        =  SABERdatemodification(newDate1) ;
                       date newDate2                         = (newOpp.Effective_Date__c).addMonths((Integer)opp.Estimated_Duration__c);
                       newOpp.AddOnUpSaleEndDate__c          = SABERdatemodification(newDate2)  ;
                       newOpp.Amount                         = opp.Amount; 
                       newOpp.LeadSource                     = opp.LeadSource;
                       newOpp.AddOnUpSaleEngagementNumber__c = opp.AddOnUpSaleEngagementNumber__c;
                       newp.add(newOpp);
                       opp.RenewalCreated__c = true;
                       newOpr.add(opp);
                    }
                }
                 if(newp.size() >0 && newp.size() !=NULL){
                insert newp;
                update newOpr;
                } 
            }
            catch(exception e)
          {
          system.debug('exception e-->'+e);
          }
    }
        public static date SABERdatemodification(date effectivedate)
        {
            date mydate ;
            if(effectivedate != null && effectivedate.day()==31 && (effectivedate.month() == 1 || effectivedate.month() == 3 || effectivedate.month() == 5 || effectivedate.month() == 7 || effectivedate.month() == 8  || effectivedate.month() == 10 || effectivedate.month() == 12 ) ){
                 mydate =   effectivedate.addDays(1);
                }   
            else if(effectivedate != null && effectivedate.day()==30 && (effectivedate.month() == 4 || effectivedate.month() == 6 || effectivedate.month() == 9 || effectivedate.month() == 11 )){
                 mydate =   effectivedate.addDays(1);
            }
            else if(effectivedate != null && (effectivedate.day()==29 ||effectivedate.day()==28) && effectivedate.month() == 2){
                mydate =   effectivedate.addDays(1);
            }else{
               mydate= effectivedate; 
            }               
            return mydate;
        }
        
}