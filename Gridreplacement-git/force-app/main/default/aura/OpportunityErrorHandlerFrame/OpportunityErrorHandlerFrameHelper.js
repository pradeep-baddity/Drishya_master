({
    getRecroTypeId: function(component,event,helper){
        var action= component.get("c.getCurrentRecordTypeID");
        action.setParams({
            currentOpportunityID :component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            var state = response.getState();  
            if(state === "SUCCESS"){
                var recordtypeID = response.getReturnValue();
                console.log('recordtypeID==>' +recordtypeID)
                component.set("v.RecordTypeID",recordtypeID);
            } else{
                console.log('Something went Wrong With RecordtypeID');
            }       
        });
        $A.enqueueAction(action);
        
    },
    dataLoaderInit : function(component) {
        
        var action=component.get("c.validationRuleErrorMethod");
        action.setParams({ opportunityrecordId : component.get("v.recordId")
                         });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if(state === "SUCCESS"){
                var lData = [];
                lData = response.getReturnValue();
                console.log(' console.log(JSON.stringify(response.getReturnValue()));'+JSON.stringify(response.getReturnValue()));
                if(lData.length > 0) {
                    component.set("v.isClosed",true);
                    component.set('v.orequiredFields', lData);
                    console.clear();
                    console.log('test ---------------'+JSON.stringify(response.getReturnValue()));
                } else {
                    component.set("v.isClosed",false);
                }
            }
            else {
                console.log('error---');
                
            }
        });
        $A.enqueueAction(action);
    },
    validateStartDateCloseDate :function(component,event, allFields){
        console.log('test@@@@'+JSON.stringify(allFields));
        var action=component.get("c.validateStartdateCloseDate");
        action.setParams({ aOppId : component.get("v.recordId") ,
                          jsFieldFromRecordPage :JSON.stringify(allFields)});
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if(state === "SUCCESS"){
                component.set("v.fieldValidator", response.getReturnValue());
                var validatorMap = response.getReturnValue();
                console.log('record type '+JSON.stringify(response.getReturnValue()));
                var jsonVals = Object.keys(response.getReturnValue());
                var recordType;
                var consoleChar;
                
                if(jsonVals[0].indexOf('+') != -1){
                    recordType = jsonVals[0].split('+');
                    recordType = recordType[1];
                    consoleChar = recordType[1];
                    
                }else{
                    recordType = jsonVals[0];
                    consoleChar = '';
                }
                //var recordType = jsonVals[0].split('+');
                console.log('jsonVals '+jsonVals[0].split('+'));
                console.log('record Type '+recordType[0]);
                
                for(var key in validatorMap ){
                    
                    
                    if(key.localeCompare('success') === 0 && validatorMap[key] === true) {
                        var errorID = component.find("errorID");
                        $A.util.addClass(errorID, 'slds-hide');
                        errorID = component.find("errorIDreasonLost");
                        $A.util.addClass(errorID, 'slds-hide');
                        errorID = component.find("errorIDCompetitor");
                        $A.util.addClass(errorID, 'slds-hide');
                        errorID = component.find("errorIDEDU");
                        $A.util.addClass(errorID, 'slds-hide');
                        errorID = component.find("errorIDGeneral");
                        $A.util.addClass(errorID, 'slds-hide');
                        component.find('recordEditForm').submit(allFields);
                    } else {
                        component.set("v.showSpinner",false);
                        console.log('=-=-consoleChar=-=-'+consoleChar);
                        console.log('=-=-validatorMap[key]=-=-'+validatorMap[key]);
                        console.log('=-=-recordType=-=-'+recordType);
                        
                        /* if( recordType == 'Estimated_Start_Date__c' && validatorMap[key] === false ){
                            console.log('date not validated for EDU');
                            var errorID = component.find("errorIDEDU");
                            $A.util.removeClass(errorID, 'slds-hide');
                            break;
                        } */
                        if(key.localeCompare('error') === 0 && validatorMap[key] === false) {
                            console.log('date not validated');
                            var errorID = component.find("errorIDGeneral");
                            $A.util.removeClass(errorID, 'slds-hide');
                             break;
                        } 
                        if(recordType == 'Competitor__c' && validatorMap[key] === false) {
                            console.log('Competitor missing');
                            var errorID = component.find("errorIDCompetitor");
                            $A.util.removeClass(errorID, 'slds-hide');
                            break;
                        }if(recordType == 'Estimated_Start_Date__c' && validatorMap[key] === false ) {
                            console.log('date not validated');
                            var errorID = component.find("errorID");
                            $A.util.removeClass(errorID, 'slds-hide');
                            
                            break;
                        }else if(recordType == 'Estimated_Start_Date__c'  && validatorMap[key] === true) {
                            console.log('date YES validated');
                            var errorID = component.find("errorID");
                            $A.util.addClass(errorID, 'slds-hide');
                        }
                        
                        if(recordType == 'Other_Reason__c' && validatorMap[key] === false) {
                            console.log('Other_Reason_Lost__c not validated');
                            var errorID = component.find("errorIDreasonLost");
                            $A.util.removeClass(errorID, 'slds-hide');
                            break;
                        }
                        if(recordType == 'Reason_Lost__c' && validatorMap[key] === false) {
                            console.log('Reason_Lost__c not validated');
                            var errorID = component.find("errorIDreasonLost");
                            $A.util.removeClass(errorID, 'slds-hide');
                            break;
                        } else {
                            console.log('Reason_Lost__c validated');
                            var errorID = component.find("errorIDreasonLost");
                            $A.util.addClass(errorID, 'slds-hide');
                        } // Reson Won
                        if(recordType == 'Other_Reason__c' && validatorMap[key] === false) {
                            console.log('Other_Reasons_Won__c not validated');
                            var errorID = component.find("errorIDreasonWon");
                            $A.util.removeClass(errorID, 'slds-hide');
                            break;
                        }if(recordType == 'Reason_Won__c' && validatorMap[key] === false) {
                            console.log('Reason_Won__c not validated');
                            var errorID = component.find("errorIDreasonWon");
                            $A.util.removeClass(errorID, 'slds-hide');
                            break;
                        } else {
                            console.log('Reason_Won__c validated');
                            var errorID = component.find("errorIDreasonWon");
                            $A.util.addClass(errorID, 'slds-hide');
                        }
                    }
                }
                
            }else{
                console.log('tetetestestestest');
                
            }
        });
        $A.enqueueAction(action);
    },
    onCancelMovePreviousStage: function(component,event){
        var action=component.get("c.checkStageNameFieldHistoryValue");
        action.setParams({
            OpportunityRecId : component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.isClosed",false);
                console.log('clicked cancel');
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "type": 'Success',    
                    "title": "Saved",
                    "message": "Hey!! Going Back to Previous Stage"
                });
                resultsToast.fire();
                //var reqFields = component.set('v.orequiredFields', []);
                $A.get('e.force:refreshView').fire();
                console.log(component.get('v.isClosed'));
                console.log(component.get('v.orequiredFields'));
            }
        });
        
        $A.enqueueAction(action);
        
    },
    
    
})