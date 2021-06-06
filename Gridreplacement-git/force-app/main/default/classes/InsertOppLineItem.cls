public class InsertOppLineItem {
    public static void Updateoppline(list<Opportunitylineitem> opline){
        
        system.debug('oppty-->'+opline);
        
        List<opportunitylineItem> UpdateOpp = new List<opportunitylineItem>();
        
        for(opportunitylineItem oppline :[select id,Technology_Capability__c,Capability_new__c,Service__c,
                                          Capability__c,Is_Undefined__c,Expertise__c,Practice__c,Amount__c,Name,
                                          Opportunity_ProductID__c,opportunityId,product2Id,Product2.Name,
                                          Product2.Capability__c,Product2.Technology_Product__c,Product2.Default_Cost_Center__c,
                                          Product2.Service__c,Product2.Mod_Picklist_ID__c,Product2.Practice__c,Product2.Family,
                                          Product2.Technology_Capability__c,Product2.Default_Project_Hierarchy__c,
                                          Product2.Is_Undefined__c,Product2.Technology_Vendor__c,
                                          Product2.Expertise__c from Opportunitylineitem where Id In : opline])
            
                {
                    if(oppline.Product2.Id != Null && oppline.Product2.Practice__c == 'ES&A' 
                       && oppline.Product2.Family == 'Technology Services')
                    {
                        oppline.Capability_new__c = oppline.Product2.Capability__c;
                        oppline.Technology_Capability__c = oppline.Product2.Technology_Capability__c;
                        oppline.Default_Cost_Center__c = oppline.Product2.Default_Cost_Center__c;
                        oppline.Default_Project_Hierarchy__c = oppline.Product2.Default_Project_Hierarchy__c;
                        oppline.Is_Undefined__c = oppline.Product2.Is_Undefined__c;
                        oppline.Service__c = oppline.Product2.Service__c;
                        oppline.Expertise__c = oppline.Product2.Expertise__c;
                        oppline.Mod_Picklist_ID__c = oppline.Product2.Mod_Picklist_ID__c;
                       // oppline.Technology_Module__c = oppline.Product2.Technology_Product__c;
                        oppline.Technology_Product__c = oppline.Product2.Technology_Product__c;
                        oppline.Technology_Vendor__c = oppline.Product2.Technology_Vendor__c;
                        UpdateOpp.add(oppline);
                    }  
                    
                    else{
                        oppline.Capability_new__c = oppline.Product2.Capability__c;
                        oppline.Technology_Capability__c = oppline.Product2.Technology_Capability__c;
                        oppline.Default_Cost_Center__c = oppline.Product2.Default_Cost_Center__c;
                        oppline.Default_Project_Hierarchy__c = oppline.Product2.Default_Project_Hierarchy__c;
                        oppline.Is_Undefined__c = oppline.Product2.Is_Undefined__c;
                        oppline.Service__c = oppline.Product2.Service__c;
                        oppline.Expertise__c = oppline.Product2.Expertise__c;
                        oppline.Mod_Picklist_ID__c = oppline.Product2.Mod_Picklist_ID__c;
                        oppline.Technology_Module__c = oppline.Product2.Technology_Product__c;
                        oppline.Technology_Product__c = oppline.Product2.Technology_Product__c;
                        oppline.Technology_Vendor__c = oppline.Product2.Technology_Vendor__c;
                        UpdateOpp.add(oppline);
                    }
                   
                }
        system.debug('UpdateOpp==>'+UpdateOpp);
       update UpdateOpp;
        
              
    }

}