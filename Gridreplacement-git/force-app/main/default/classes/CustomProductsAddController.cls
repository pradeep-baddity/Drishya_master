public class CustomProductsAddController {
    
    @AuraEnabled 
    public static list<opportunityLineItem> getOfferinggs(id opportunnityID,string searchKeyword){
        system.debug('searchKeyword===>'+searchKeyword);
        
        list<opportunityLineItem> listOfOLI= new list<opportunityLineItem>();
        system.debug('opportunnityID ==>'+opportunnityID);
        opportunity opps =[SELECT Id, Name, Pricebook2Id, currencyIsocode FROM opportunity where id =:opportunnityID]; 
        //Get list of all product from the pricebook that associated with the opportunity
        List<PricebookEntry> pbe= new List<PricebookEntry> ();
        set<string> setProduct =  new set<string>();
        if(searchKeyword =='_empty'){
            system.debug('search inside');
            pbe =[SELECT Id, Name, Pricebook2Id, Product2.Name,currencyIsoCode, (select id,Offering__c, Service_Line_or_Product__c from opportunitylineitems where currencyIsoCode =: opps.currencyIsoCode LIMIT 100) FROM PricebookEntry 
                  where Pricebook2Id =: opps.Pricebook2Id AND IsActive= TRUE AND currencyIsoCode =: opps.currencyIsoCode AND UseStandardPrice = false];   
            
        }else {
            system.debug('searchKeyword called');
            searchKeyword='%'+searchKeyword+'%';
            pbe =[SELECT Id, Name, Pricebook2Id, Product2.Name,currencyIsoCode, (select id,Offering__c, Service_Line_or_Product__c from opportunitylineitems where currencyIsoCode =: opps.currencyIsoCode) FROM PricebookEntry 
                  where Pricebook2Id =: opps.Pricebook2Id 
                  AND IsActive= TRUE 
                  AND currencyIsoCode =: opps.currencyIsoCode 
                  AND UseStandardPrice = false
                  AND Product2.Name LIKE :searchKeyword];   
            
        }
        system.debug('pbe-->'+pbe);
        //Cretaing the productList in backend
        for(PricebookEntry pb :pbe)
        {
            opportunityLineItem singleOLi= new opportunityLineItem();
            singleOLi.OpportunityId=opportunnityID;
            singleOLi.PricebookEntryId=pb.Id;
            singleOLi.UnitPrice=0;
            singleOLi.Service_Line_or_Product__c='';
            singleOli.Offering__c=''; 
            singleOli.ApexProductName__c   =pb.product2.Name;
            listOfOLI.add(singleOli);
            
        }
        return listOfOLI;
    }
    
    @AuraEnabled
    public static void getListedRows(String aRow){
        system.debug('aRow'+aRow);
    }
    
    public class selectedWrapper{
        public String PdId;
        public Double currencyValue;
        public selectedWrapper(String a,Double b){
            this.PdId=a;
            this.currencyValue=b;
        }
    }
    @AuraEnabled
    public static List<OpportunityLineItem> saveOpportunityLiItem(String listOfOli){
        
        List<OpportunityLineItem> mapOfOpps = (List<OpportunityLineItem>)JSON.deserialize(listOfOli,list<OpportunityLineItem>.class);
        system.debug('maps-->'+mapOfOpps);
        insert mapOfOpps;
        system.debug('-->'+mapOfOpps);
        return mapOfOpps;
    }
}