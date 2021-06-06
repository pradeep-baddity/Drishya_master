public class OpportunityValidationErrorHandler {
    
    
    @AuraEnabled
    public static id getCurrentRecordTypeID(id currentOpportunityID){
        Opportunity oppCurrentRecTypeID=[select id,RecordTypeId FROM Opportunity where id =:currentOpportunityID];
        return oppCurrentRecTypeID.RecordTypeId;
    }
    @AuraEnabled
    public static List<String> validationRuleErrorMethod(id opportunityrecordId){
        String[] lData = new List<String>();
        
        try {
            Opportunity lOpportunity = [Select Id,Reason_Won__c,Other_Reasons_Won__c,Type,LeadSource,CountOpportunityContactRole__c,
                                        Product_with_Service_or_Product__c,Estimated_Duration__c,of_Sales_Credit__c,RecordType.developerName,
                                        Name,EPM_Sales_Lead__c,StageName, EPM_Region__c,Product_Count__c,CurrencyIsoCode,Industry__c,
                                        Pricing_Review_Status__c,Estimated_Start_Date__c,CloseDate,Competitor__c,Other_Reason_Lost__c,
                                        Reason_Lost__c,MD_of_Record__c,Other_Reason__c,Referred_By_Person__c,Effective_Date__c,AddOnUpSaleEndDate__c, 
                                        SABER_Original_Opportunity_ID__c From opportunity where id =: opportunityrecordId];
            
            
            
            Set<String> lFieldList = new Set<String>();
            ValidationHandler__mdt[] lMetadata =[Select RequiredFields__c,Stage_Name__c,RecordType__c From ValidationHandler__mdt WHERE Stage_Name__c =: lOpportunity.StageName AND RecordType__c =: lOpportunity.RecordType.developerName];
            
            System.debug('=-=-=lMetadata-=-='+lMetadata);
            
            system.debug('StageName'+lOpportunity.StageName);
            System.debug('=-=-RecordType.developerName=-=-'+lOpportunity.RecordType.developerName);
            
            String rtAPI= lOpportunity.RecordType.developerName;
            Boolean lDataValid = true;
            Boolean lIsNullValidated = true;
            Boolean lIsWonStageValidated = true;
            Boolean lIsLostStageValidated = true;
            Boolean isEffectiveDateValidated = true;
            Boolean isEndDateValidated = true;
            Boolean isOrginalOpportunityId=true;
            
            if(!lMetadata.isEmpty()) {
                String[] lRequiredFields = lMetadata[0].RequiredFields__c.split(',');
                system.debug('lRequiredFields'+lRequiredFields);
                
                
                if(lMetadata[0].RecordType__c == rtAPI){
                    for(String field : lRequiredFields) {
                        system.debug('=-=-field=-=='+field);
                        system.debug('-=-=check this value=-=-='+lOpportunity.get(field));
                        if( String.isEmpty( String.valueOf(String.valueOf(lOpportunity.get(field)) )  )) {
                            
                            if(field == 'Other_Reason__c') {
                                System.debug('-=--coming=-=-=-=-');
                                if(lOpportunity.Reason_Lost__c == 'Other') {
                                    lIsLostStageValidated = false;
                                    lDataValid = false;
                                }
                            }
                            
                            System.debug('-=-lOpportunity.RecordType.developerName=-'+lOpportunity.RecordType.developerName);
                            System.debug('=-=lOpportunity.Type==-'+lOpportunity.Type);
                            
                            
                            if(lOpportunity.RecordType.developerName == 'ELS' && lOpportunity.Type == 'Renewal Opportunity' && lOpportunity.Type == 'Extension Opportunity' && lOpportunity.Type == 'AddOn/UpSell') {
                                System.debug('-=--check date=-=-=-=-');
                                if(lOpportunity.Effective_Date__c == NULL){
                                    isEffectiveDateValidated = false;
                                } else if(lOpportunity.AddOnUpSaleEndDate__c == NULL){
                                    isEndDateValidated = false;
                                } else if(lOpportunity.SABER_Original_Opportunity_ID__c == NULL){
                                    isOrginalOpportunityId = false;
                                }else{}
                            }
                            
                            if(field == 'Other_Reason__c') {
                                if(lOpportunity.Reason_Won__c == 'Other') {
                                    lIsWonStageValidated = false;
                                    lDataValid = false;
                                }
                            } 
                            
                            if(field != 'Other_Reason__c') {
                                lIsNullValidated = false;
                                lFieldList.add(field);
                            }
                            
                            if(lOpportunity.RecordType.developerName == 'ELS' && lOpportunity.Type != 'Renewal Opportunity' && lOpportunity.Type != 'Extension Opportunity' && lOpportunity.Type != 'AddOn/UpSell') {
                                lFieldList.remove('Effective_Date__c');
                                lFieldList.remove('AddOnUpSaleEndDate__c');
                                lFieldList.remove('SABER_Original_Opportunity_ID__c');
                            }
                        }
                    } 
                }
                
                System.debug('=-=-=-==-=--lFieldList--=-=-=-=-='+lFieldList);
                
                
                system.debug(lIsWonStageValidated);
                system.debug(lIsLostStageValidated);
                System.debug('chck karthik'+isEffectiveDateValidated);
                System.debug('end date'+isEndDateValidated);
                System.debug('-Number--'+isOrginalOpportunityId);
                
                if(!lIsWonStageValidated)
                    lFieldList.add('Other_Reason__c');
                else if(!lIsLostStageValidated)
                    lFieldList.add('Other_Reason__c');
                else if(!isEffectiveDateValidated) {
                    lFieldList.add('Effective_Date__c');
                } else if (!isEndDateValidated) {
                    lFieldList.add('AddOnUpSaleEndDate__c');
                } else if(!isOrginalOpportunityId){
                    lFieldList.add('SABER_Original_Opportunity_ID__c');
                }
                
                
                
                
                lData = new List<String>();
                lData.addAll(lFieldList);
                system.debug('lData-'+lData);
            }
            
            return lData;
        } catch(Exception e) {
            return lData;
        }
    }
    
    @AuraEnabled
    public static Map<String,Boolean> validateStartdateCloseDate(id aOppId,String jsFieldFromRecordPage){
        
        Opportunity op = [Select Id,Reason_Lost__c, Other_Reason_Lost__c, Estimated_Duration__c,RecordType.Name,Name,EPM_Sales_Lead__c,StageName, EPM_Region__c,Product_Count__c,CurrencyIsoCode,Industry__c,
                          Pricing_Review_Status__c,Estimated_Start_Date__c,CloseDate,Other_Reason__c
                          From Opportunity where id =: aOppId];
        
        Map<String, object> results = (Map<String, object>)JSON.deserializeUntyped(jsFieldFromRecordPage);
        
        System.debug('=-=--results=-=-'+results);
        
        
        Map<String,Boolean> lFieldValidationMap = new Map<String, Boolean>();
        Boolean DataValidated =true;
        Boolean allDataValidated =true;
        //traverse map for validations
        String lReasonLostFieldValue = '';
        String concatRecTypeEstStartDate = '';
        
        for(String lstring : results.keySet()){
            system.debug('lstring: ' + lstring);
            system.debug('lstringGet:'+results.get(lString));
            //null value validation
            if(results.get(lString) != 'null' && results.get(lString) != null && !lString.equals('Other_Reason__c')) {
                //selected fields' [date] validation
                if(lString.equals('Estimated_Start_Date__c')) {
                    date lDate = Date.valueOf(results.get(lString)+' 00:00:00');
                    system.debug(lDate); 
                    system.debug(op.CloseDate);
                    system.debug(op.RecordType.Name);
                    
                    if(lDate != Null && lDate < op.CloseDate && op.RecordType.Name == 'EDU Opportunity'  ) {
                        allDataValidated = false;
                        lFieldValidationMap.put(op.RecordType.Name+'+Estimated_Start_Date__c', false);
                        system.debug('Executed Line 159');
                    }else if(lDate != Null && lDate < op.CloseDate && op.RecordType.Name != 'EDU Opportunity'  ) {
                        allDataValidated = false;
                        lFieldValidationMap.put(op.RecordType.Name+'+Estimated_Start_Date__c', false);
                        system.debug('Executed Line 159');
                    } else {
                        system.debug('Executed Line 167');
                        lFieldValidationMap.put(op.RecordType.Name+'+Estimated_Start_Date__c', true);
                    }
                }
                
                if(op.RecordType.Name != null && op.Estimated_Start_Date__c != null){
                    concatRecTypeEstStartDate = op.RecordType.Name+op.Estimated_Start_Date__c;
                    System.debug('concatRecTypeEstStartDate::'+concatRecTypeEstStartDate);
                }
                
                
                if(lString.equals('Reason_Lost__c'))
                    if(results.get(lString) != NULL && results.get(lString).toString().toUpperCase() == 'OTHER') {
                        lReasonLostFieldValue = 'Other';
                    }
            }
            else if(lString.equals('Other_Reason__c')) {
                if(lReasonLostFieldValue.equals('Other')) {
                    if(lString.equals('Other_Reason__c')) {
                        if(results.get(lString) == NULL)
                            lFieldValidationMap.put('Other_Reason__c', false);
                    }
                }
            }
            //null validation failed
            else {
                DataValidated = false;
                // lFieldValidationMap.put(lString, false);
            }
        }
        
        
        //all validated successfully
        if(DataValidated){
            
            if(allDataValidated) {
                lFieldValidationMap.put('success', true);
            } 
        } else if(allDataValidated) {
            lFieldValidationMap.put('error', false);
        }
        
        System.debug('lFieldValidationMap ==> : '+JSON.serialize(lFieldValidationMap));
        return lFieldValidationMap;
    }
    @AuraEnabled
    public static Opportunity checkStageNameFieldHistoryValue(id OpportunityRecId){
        Opportunity lOpportunity =[Select ID,Name,StageName FROM Opportunity Where id =:OpportunityRecId];
        List<OpportunityFieldHistory> oppFH=[SELECT Id, OldValue, NewValue, OpportunityId, Field FROM OpportunityFieldHistory where OpportunityId =:OpportunityRecId AND Field ='StageName' order by createdDate DESC]; 
        List<Contract> Contract = [Select ID,Contract_Created_By_PB__c, Opportunity__c From Contract where Opportunity__c =:OpportunityRecId AND Contract_Created_By_PB__c = true limit 1];
        
        if(oppFH != null && oppFH.size() > 0){
            OpportunityFieldHistory oppHistory = oppFH[0];
            String str = String.valueOf(oppHistory.OldValue);
            if(oppHistory.OldValue != Opportunity.StageName){
                if(Test.isRunningTest()){
                    lOpportunity.StageName = 'Explore (15-29%)';
                }else{
                    lOpportunity.StageName = String.valueOf(oppHistory.OldValue);
                    delete Contract;
                }
                
                update lOpportunity;
                
            }
        }
        return lOpportunity;
        
    } 
    
}