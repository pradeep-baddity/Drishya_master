public class ProductMapAssignment {
    @InvocableMethod
    public static void autoMapProduct(List<Id> oLI){
    system.debug('Called--'+oli);
        Map<string,MetadataLoader__c> mapDepartmentMetadata = new Map<string,MetadataLoader__c>();
        set<id> setId = new set<id>();
        list<OpportunityLineitem> oplineList = new list<OpportunityLineitem>();
        map<id,OpportunityLineitem> newMapvalues = new  map<id,OpportunityLineitem>();
        
        for(MetadataLoader__c departmentMDT : [SELECT Name,Elite_Department__c,
                                               Elite_Department_Id__c,
                                               Elite_Service_Line__c,
                                               Elite_ServiceLine_Id__c , NameKeyValue__c,Task_Code__c,EDU_Segment__c,Industry__c, practice__c
                                               FROM MetadataLoader__c Limit 50000])
        {
            mapDepartmentMetadata.put(departmentMDT.NameKeyValue__c, departmentMDT);
            system.debug('mapDepartmentMetadata--'+mapDepartmentMetadata);
        }
        system.debug('oli--'+oli);
        list<opportunitylineitem> oplinenew = [select id,Offering__c , Service_Line_or_Product__c ,Geography__c , practice__c,SG_Market_Team__c ,Module_or_Accelerator2__c , 
                                          Industry__c ,
                                          Elite_Department_Id__c,
                                          Elite_Service_Line__c,
                                          Elite_Service_Line_ID__c,
                                          Elite_Department__c,
                                          EDU_Segment__c,
                                          Task_Code__c from opportunitylineitem where Id IN : oLI] ;
         system.debug('oplinenew--'+oplinenew);
        for(opportunitylineitem opline : oplinenew)
        
        {
            system.debug('opline --'+opline );
            String keyValue1 = opline.Offering__c +''+opline.Service_Line_or_Product__c +''+opline.Geography__c+''+opline.practice__c;
            String keyValue3 = opline.Offering__c +''+opline.Service_Line_or_Product__c +''+opline.Geography__c+''+opline.Module_or_Accelerator2__c +''+opline.practice__c ; 
            String keyValue4 = opline.Offering__c +''+opline.Service_Line_or_Product__c +''+opline.Geography__c+''+opline.Module_or_Accelerator2__c+''+opline.Industry__c+''+opline.practice__c ; 
            String keyValue6 = opline.Offering__c +''+opline.Service_Line_or_Product__c +''+opline.Geography__c+''+opline.Industry__c+''+opline.practice__c ;
             
            system.debug('keyValue1 --'+keyValue1 );
            system.debug('keyValue3 --'+keyValue3 );
            system.debug('keyValue4 --'+keyValue4 );
            system.debug('keyValue6 --'+keyValue6 );
          
            if(mapDepartmentMetadata.get(keyValue1) != null){
                system.debug('keyValue1-->'+keyValue1);
                opline.Elite_Department_ID__c = mapDepartmentMetadata.get(keyValue1).Elite_Department_Id__c;
                opline.Elite_Service_Line__c=mapDepartmentMetadata.get(keyValue1).Elite_Service_Line__c;
                opline.Elite_Service_Line_ID__c=mapDepartmentMetadata.get(keyValue1).Elite_ServiceLine_Id__c;
                opline.Elite_Department__c=mapDepartmentMetadata.get(keyValue1).Elite_Department__c;
                opline.EDU_Segment__c =mapDepartmentMetadata.get(keyValue1).EDU_Segment__c;
                opline.Task_Code__c=mapDepartmentMetadata.get(keyValue1).Task_Code__c;
                system.debug('opline1--'+opline);
                oplineList.add(opline);
                newMapvalues.put(opline.id, opline);
            }
            
            if(mapDepartmentMetadata.get(keyValue3) != null){
                system.debug('keyValue3-->'+keyValue3);
                opline.Elite_Department_ID__c = mapDepartmentMetadata.get(keyValue3).Elite_Department_Id__c;
                opline.Elite_Service_Line__c=mapDepartmentMetadata.get(keyValue3).Elite_Service_Line__c;
                opline.Elite_Service_Line_ID__c=mapDepartmentMetadata.get(keyValue3).Elite_ServiceLine_Id__c;
                opline.Elite_Department__c=mapDepartmentMetadata.get(keyValue3).Elite_Department__c;
                opline.EDU_Segment__c =mapDepartmentMetadata.get(keyValue3).EDU_Segment__c;
                opline.Task_Code__c=mapDepartmentMetadata.get(keyValue3).Task_Code__c;
                system.debug('opline3--'+opline);
                newMapvalues.put(opline.id, opline);
                //oplineList.add(opline);
            }
           if(mapDepartmentMetadata.get(keyValue4) != null){
                system.debug('keyValue4-->'+keyValue4);
                opline.Elite_Department_ID__c = mapDepartmentMetadata.get(keyValue4).Elite_Department_Id__c;
                opline.Elite_Service_Line__c=mapDepartmentMetadata.get(keyValue4).Elite_Service_Line__c;
                opline.Elite_Service_Line_ID__c=mapDepartmentMetadata.get(keyValue4).Elite_ServiceLine_Id__c;
                opline.Elite_Department__c=mapDepartmentMetadata.get(keyValue4).Elite_Department__c;
                opline.EDU_Segment__c =mapDepartmentMetadata.get(keyValue4).EDU_Segment__c;
                 opline.Task_Code__c=mapDepartmentMetadata.get(keyValue4).Task_Code__c;
                system.debug('opline4--'+opline);
                newMapvalues.put(opline.id, opline);
                //oplineList.add(opline);
            }  

            if(mapDepartmentMetadata.get(keyValue6) != null){
                system.debug('keyValue6-->'+keyValue6);
                opline.Elite_Department_ID__c = mapDepartmentMetadata.get(keyValue6).Elite_Department_Id__c;
                opline.Elite_Service_Line__c=mapDepartmentMetadata.get(keyValue6).Elite_Service_Line__c;
                opline.Elite_Service_Line_ID__c=mapDepartmentMetadata.get(keyValue6).Elite_ServiceLine_Id__c;
                opline.Elite_Department__c=mapDepartmentMetadata.get(keyValue6).Elite_Department__c;
                opline.EDU_Segment__c =mapDepartmentMetadata.get(keyValue6).EDU_Segment__c;
                opline.Task_Code__c=mapDepartmentMetadata.get(keyValue6).Task_Code__c;
                system.debug('opline6--'+opline);
                newMapvalues.put(opline.id, opline);
                //oplineList.add(opline);
            }          
            
        }
        system.debug('oplineList--'+oplineList);
        if(oplineList!= NULL && oplineList.size() >0)
        {
        //update oplineList;
        }
        system.debug('map--'+newMapvalues);
        if(newMapvalues.size () >0)
        {
        update newMapvalues.values();
        } 
    }
}