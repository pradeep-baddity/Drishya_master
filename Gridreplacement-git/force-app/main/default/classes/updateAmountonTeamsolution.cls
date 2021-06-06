public class updateAmountonTeamsolution {

    public static void amountupdate(list<opportunitylineitem> oppty)
    {
        set<id> setid = new set<Id>();
        Map<Id,opportunitylineitem> amountMap =  new map<Id,opportunitylineitem>();
        Map<Id,Team_solution__c> productMap =  new map<Id,Team_solution__c>();
        list<Team_solution__c> ts =  new list<Team_solution__c>();
        list<opportunitylineitem>   oplist = [select id, product2Id, product2.name,amount__c, opportunity_productid__c,Offering_Estimated_Contract_Value_ECV__c,Service_Line_or_Product__c, offering__c from opportunitylineitem where Id in : oppty  AND offering__c = 'Performance Improvement' ];
        if(oplist != NULL && oplist.size()>0){
            for(opportunitylineitem op :oplist){
              amountMap.put(op.opportunity_productid__c ,op);
            }
            system.debug('amountMap-->'+amountMap);
            Team_solution__c[] tList = [select Id,Price__c, opportunity_productid__c,ServiceLine_or_product__c from Team_solution__c where opportunity_productid__c IN: amountMap.Keyset()];
            system.debug('tList'+tList);
            for(Team_solution__c teamsol : tList)
            {
                system.debug('forloop-->');
                productMap.put(teamsol.opportunity_productid__c, teamsol);
            }
            system.debug('productMap-->'+productMap);
            team_solution__c tsol;
            for(opportunitylineitem oppline : oplist){
                if(!productMap.isEmpty() && productMap.keyset().contains(oppline.opportunity_productid__c) && productMap.get(oppline.id) != null){
                    system.debug('Inside if-->');
                    tsol = new Team_solution__c(Id = productMap.get(oppline.id).Id);
                    tsol.Price__c  = amountMap.get(oppline.opportunity_productid__c).Offering_Estimated_Contract_Value_ECV__c;
                    tsol.ServiceLine_or_product__c  = amountMap.get(oppline.opportunity_productid__c).Service_Line_or_Product__c ;
                    ts.add(tsol);
                } 
            }
            
            database.update(ts,false);
            system.debug('ts-->'+ts);
        }  
    }

}