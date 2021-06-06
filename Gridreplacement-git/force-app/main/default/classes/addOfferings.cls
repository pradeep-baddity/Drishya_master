public class addOfferings {
    @AuraEnabled 
    public static list<OpportunityLineItem> getOfferinggs(id opportunnityID){
        list<OpportunityLineItem> prodlist= new list<OpportunityLineItem>();
        system.debug('opportunnityID ==>'+opportunnityID);
        opportunity opps =[SELECT Id, Name, Pricebook2Id, StageName, probability,currencyIsocode FROM opportunity where id =: opportunnityID]; 
        system.debug('opps--->'+opps);
        //Get list of all product from the pricebook that associated with the opportunity
        if(opps.probability >= 30){
            system.debug('inside if-->');
            List<PricebookEntry> pbe= new List<PricebookEntry> ();
            pbe =[SELECT Id, Name, Pricebook2Id, product2Id,Product2.Name,product2.Capability__c,product2.Is_Undefined__c,product2.Expertise__c, product2.Practice__c,product2.Service__c,currencyIsoCode,(select id,ApexProductName__c from opportunitylineitems where currencyIsoCode =: opps.currencyIsoCode) FROM PricebookEntry 
                  where Pricebook2Id =: opps.Pricebook2Id AND IsActive= TRUE AND currencyIsoCode =: opps.currencyIsoCode AND UseStandardPrice = false AND product2.Is_Undefined__c = false]; 
            system.debug('pbe1-->'+pbe);
            for(PricebookEntry pb :pbe)
            {
                OpportunityLineItem oppline          = new OpportunityLineItem();
                oppline.ApexProductName__c           = pb.product2.Name;
                oppline.Capability_new__c            = pb.product2.Capability__c;
                oppline.Expertise__c                 = pb.product2.Expertise__c;
                oppline.Practice__c                  = pb.product2.Practice__c;
                oppline.Service__c                   = pb.product2.Service__c;
                oppline.OpportunityId                = opportunnityID;
                oppline.pricebookentryId             = pb.Id;
                oppline.product2Id					 = pb.product2Id;
                
                prodlist.add(oppline);
            }
            system.debug('prodlist-->'+prodlist);
        }
        else {
            system.debug('inside else-->');
            List<PricebookEntry> pbe= new List<PricebookEntry> ();
            pbe =[SELECT Id, Name, Pricebook2Id, product2Id,Product2.Name,product2.Capability__c,product2.Is_Undefined__c,product2.Expertise__c, product2.Practice__c,product2.Service__c,currencyIsoCode,(select id,ApexProductName__c from opportunitylineitems where currencyIsoCode =: opps.currencyIsoCode) FROM PricebookEntry 
                  where Pricebook2Id =: opps.Pricebook2Id AND IsActive= TRUE AND currencyIsoCode =: opps.currencyIsoCode AND UseStandardPrice = false]; 
            system.debug('pbe2-->'+pbe);
            for(PricebookEntry pb :pbe)
            {
                OpportunityLineItem oppline          = new OpportunityLineItem();
                oppline.ApexProductName__c           = pb.product2.Name;
                oppline.Capability_new__c            = pb.product2.Capability__c;
                oppline.Expertise__c                 = pb.product2.Expertise__c;
                oppline.Practice__c                  = pb.product2.Practice__c;
                oppline.Service__c                   = pb.product2.Service__c;
                oppline.OpportunityId                = opportunnityID;
                oppline.pricebookentryId             = pb.Id;
                oppline.product2Id					 = pb.product2Id;
                
                prodlist.add(oppline);
            }
            system.debug('prodlist-->'+prodlist);
        }
        return prodlist;
        
    }
    
    @AuraEnabled
    public static List<OpportunityLineItem> searchbyProdname(String searchKeyword, id oppID) {
        String name =  '%'+searchKeyword +'%';
        list<OpportunityLineItem> filteredproducts = new list<OpportunityLineItem >();
        system.debug('search--'+name);
        opportunity opps =[SELECT Id, Name, Pricebook2Id, currencyIsocode FROM opportunity where id =:oppID]; 
        //Get list of all product from the pricebook that associated with the opportunity
        List<PricebookEntry> pbe= new List<PricebookEntry> ();
        if(string.isNotBlank(name)){
            pbe =[SELECT Id, Name, Pricebook2Id, product2Id,Product2.Name,product2.Capability__c,product2.Expertise__c, product2.Practice__c,product2.Service__c,currencyIsoCode FROM PricebookEntry 
                  where Pricebook2Id =: opps.Pricebook2Id AND IsActive= TRUE AND currencyIsoCode =: opps.currencyIsoCode AND UseStandardPrice = false AND (Product2.Name like :name)];   
            system.debug('pbe-->'+pbe);
        }
        
        else{
            pbe =[SELECT Id, Name, Pricebook2Id, product2Id,Product2.Name,product2.Capability__c,product2.Expertise__c, product2.Practice__c,product2.Service__c,currencyIsoCode FROM PricebookEntry 
                  where Pricebook2Id =: opps.Pricebook2Id AND IsActive= TRUE AND currencyIsoCode =: opps.currencyIsoCode AND UseStandardPrice = false];   
            
        }
        system.debug('pbe2-->'+pbe);
        for(PricebookEntry pb :pbe)
        {
            OpportunityLineItem oppline          = new OpportunityLineItem();
            oppline.ApexProductName__c           = pb.product2.Name;
            oppline.Capability_new__c            = pb.product2.Capability__c;
            oppline.Expertise__c                 = pb.product2.Expertise__c;
            oppline.Practice__c                  = pb.product2.Practice__c;
            oppline.Service__c                   = pb.product2.Service__c;
            oppline.OpportunityId                = oppID;
            oppline.pricebookentryId             = pb.Id;
            oppline.product2Id					= pb.product2Id;
            filteredproducts.add(oppline);
        }
        system.debug('filteredproducts-->'+filteredproducts);
        return filteredproducts;
    }
    
    @Auraenabled
    public static List<OpportunityLineItem> saveOpportunityLiItems(String listOfOli){
        map<string, opportunitylineitem> undefinedMap = new map<string, opportunitylineitem>();
        map<string, opportunitylineitem> deleteMap = new map<string, opportunitylineitem>();
        list<opportunitylineitem> deletelineitem = new list<opportunitylineitem>();
        list<opportunity> newOpp = new list<opportunity>();
        List<OpportunityLineItem> mapOfOpps = (List<OpportunityLineItem>)JSON.deserialize(listOfOli,list<OpportunityLineItem>.class);
        system.debug('mapOfOpps-->'+mapOfOpps);
        insert mapOfOpps;
        system.debug('after insertion-->'+mapOfOpps);
        set<Id> oppid = new set<Id>();
        for(Opportunitylineitem op : mapOfOpps)
        {
            oppid.add(op.OpportunityId);
        }
        system.debug('opportunity Id--'+oppid);
        for(opportunitylineitem lineitem : [select id, service__c, opportunityid,Opportunity_Stage__c,opportunity_probability__c ,Is_Undefined__c, opportunity.StageName, opportunity.probability from opportunitylineitem where opportunityid IN : oppid and Is_Undefined__c = True])
        {
            system.debug('inside for loop--->');
            undefinedMap.put(lineitem.service__c,lineitem);
            
        }
        system.debug('undefinedMap-->'+undefinedMap);
        for(opportunitylineitem lineitemNew : mapOfOpps)
        {
            if(undefinedMap.containskey(lineitemNew.service__c))
            {
                deletelineitem.add(undefinedMap.get(lineitemNew.service__c));
            }
            else{
                
            }
        }
        deleteMap.putall(deletelineitem);
        system.debug('deletelineitem-->'+deletelineitem);
        for(opportunity op :[select id, stageName, probability from opportunity where id In: oppid and probability >= 30])
        {
            system.debug('Check probability--->');
            if(deletelineitem.size() >0 && deletelineitem != null){
                //delete deletelineitem; 
                delete deleteMap.values();
            }
        }
        for(opportunity op : [select id,StageName,Stage_Prior_value__c,Undefined_offerings__c from opportunity where Id IN : oppid])
        {
            if(op.Undefined_offerings__c > 0)
            {
                opportunity opnew = new opportunity(id=op.id);
                opnew.StageName = op.Stage_Prior_value__c;
                opnew.Stage_Prior_value__c = '';
                newOpp.add(opnew);
            }
        }
        system.debug('newOpp==>'+newOpp);
        if(newOpp.size() >0 && newOpp != null)
        {
            update newOpp;
        }
        return mapOfOpps;
    }
     @Auraenabled
    public static List<OpportunityLineItem> saveOLiItems(String listOfOli){
         List<OpportunityLineItem> mapOfOpps = (List<OpportunityLineItem>)JSON.deserialize(listOfOli,list<OpportunityLineItem>.class);
        system.debug('mapOfOpps-->'+mapOfOpps);
        insert mapOfOpps;
        system.debug('after insertion-->'+mapOfOpps);
        return mapOfOpps;
    }
}