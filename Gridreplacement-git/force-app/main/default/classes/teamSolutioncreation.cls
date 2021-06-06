global  class  teamSolutioncreation
{
   // @future
    public static void teamsolution(list<Opportunitylineitem> oppty)
    {    
        system.debug('oppty-->'+oppty);
        set<Id> setId = new set<Id>();
        Integer maxSize = 78;
        string tname,teamName;
        list<Team_Solution__c> tmnew = new list<Team_Solution__c>();
        
        system.debug('setId-->'+setid);
        for(Opportunitylineitem oppNew : [select id,UnitPrice,Capability_new__c,Service__c,Expertise__c,Practice__c,Amount__c,Name,Opportunity_ProductID__c,opportunityId,product2Id,Product2.Name from Opportunitylineitem where Id In : oppty])
            
        {
            system.debug('oppNew======='+oppNew);
            system.debug('for--->'+oppNew.Expertise__c);
            system.debug('for1--->'+oppNew.Practice__c);
          // boolean capCheck = oppNew.Capability_new__c =='Care' || oppNew.Capability_new__c =='Cost'|| oppNew.Capability_new__c =='Medical Group' || oppNew.Capability_new__c =='Revenue';
           // boolean capsChecking = oppNew.Capability_new__c =='Learning - Conferences' || oppNew.Capability_new__c =='Learning - Digital / Online'|| oppNew.Capability_new__c =='Learning - Workshops' || oppNew.Capability_new__c =='Learning - Skills Assessment' || oppNew.Capability_new__c =='Learning - Consulting'|| oppNew.Capability_new__c =='Learning - Managed Services';
            if((oppNew.Expertise__c == 'Business Operations' && oppNew.Service__c == 'Performance Improvement Assessment and Design' && oppNew.Capability_new__c =='Care' || oppNew.Capability_new__c =='Cost'|| oppNew.Capability_new__c =='Medical Group' || oppNew.Capability_new__c =='Revenue')|| 
               (oppNew.Expertise__c == 'Business Operations' && oppNew.Service__c == 'Performance Improvement Implementation' && oppNew.Capability_new__c =='Care' || oppNew.Capability_new__c =='Cost'|| oppNew.Capability_new__c =='Medical Group' || oppNew.Capability_new__c =='Revenue' )||
               (oppNew.Expertise__c == 'Business Operations' && oppNew.Service__c == 'Sustained Performance Services' && oppNew.Capability_new__c =='Care' || oppNew.Capability_new__c =='Cost'|| oppNew.Capability_new__c =='Medical Group' || oppNew.Capability_new__c =='Revenue')||
               (oppNew.Expertise__c == 'Organizational Transformation' && oppNew.Service__c == 'Learning Solutions' && oppNew.Capability_new__c =='Learning - Conferences' || oppNew.Capability_new__c =='Learning - Digital / Online'|| oppNew.Capability_new__c =='Learning - Workshops' || oppNew.Capability_new__c =='Learning - Skills Assessment' || oppNew.Capability_new__c =='Learning - Consulting'|| oppNew.Capability_new__c =='Learning - Managed Services'))
                
            {
                system.debug('inside if--');
                Team_Solution__c tm = new Team_Solution__c ();
                teamName = oppNew.product2.Name + ' - Team Solution';
                system.debug('------>'+teamName);
                
                if((teamName).length() > maxSize ){
                    tname= (teamName).substring(0, maxSize);
                }
                else {
                    tname = teamName;
                }
                system.debug('tname-->'+tname);
                tm.name = tname;
                tm.Opportunity_productId__c = oppNew.Opportunity_productId__c;
                tm.Opportunity__c = oppNew.OpportunityId;
                tm.Price__c = oppNew.UnitPrice;
                tm.Capability__c = oppNew.Capability_new__c;
                tm.Service__c = oppNew.Service__c;
                // tm.ServiceLine_or_product__c = oppNew.Service_Line_or_Product__c;
                tmNew.add(tm);
            }
            
        }
        system.debug('tmNew-->'+tmNew);
        insert tmNew;
        system.debug('tmNew-->'+tmNew);
    }
}