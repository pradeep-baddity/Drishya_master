({
    doInit : function(cmp) {
        cmp.set('v.columns', [
            
            {label: 'Offering Name', fieldName: 'ProductName__c', type: 'text'},
            {label: 'Expertise', fieldName: 'Expertise__c', type: 'text'},
            {label: 'Service', fieldName: 'Service__c', type: 'text'},
            {label: 'Capability', fieldName: 'Capability_new__c', type: 'text'},
            {label: 'Technology Vendor', fieldName: 'Technology_Vendor__c', type: 'text'},
            {label: 'Technology Capability', fieldName: 'Technology_Capability__c', type: 'text'},
            {label: 'Technology Module', fieldName: 'Technology_Module__c', type: 'text'} 
        ]);
        var action = cmp.get("c.getOppLines");
        action.setParams({ recId : cmp.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var res=response.getReturnValue();
                if( res !=undefined && res.length > 0){
                    var stageValue=res[0].Opportunity.StageName;
                    if(stageValue == 'Closed Won (100%)'  || stageValue =='Closed Lost'){
                        //  SPLITING AN OPPORTUINITY AT “CLOSED WON” STAGE IS NOT ALLOWED
                        var errorMsg='SPLITING AN OPPORTUINITY AT '  + stageValue + ' STAGE IS NOT ALLOWED';
                        cmp.set("v.ErrorMessage",errorMsg);
                        cmp.set("v.IsclosedWonStage",true);
                        
                    }else{
                        cmp.set("v.OLI",response.getReturnValue());
                    }
                }
                cmp.set("v.IsLoading",false);    
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        $A.enqueueAction(action);
    },
    cancelClick :function(component, event, helper) {
        var closeEvent = $A.get("e.force:closeQuickAction");
        closeEvent.fire();
    },
    getSelectedName: function (cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        cmp.set("v.OLIList", null);
        var listRawSelected = [];
        for (var i = 0; i < selectedRows.length; i++){
            listRawSelected.push(selectedRows[i].Id);
        }
        cmp.set("v.numberOfRawSelected",listRawSelected.length);
        cmp.set("v.OLIList",listRawSelected);
        console.log(JSON.stringify(listRawSelected));
    },
    activeButton : function(component,event, helper) {
        let inputText = component.find("inpName").get("v.value");
        component.set("v.oppName",inputText);
        console.log('Name--'+inputText);
        if(inputText.length > 0 && inputText != null){
            //component.set('v.isButtonActive',false);
        }      
    },
    saveOpportunity :function(cmp,event,helper){
        
        if(cmp.get("v.OLIList").length == 0){
            helper.showMsg(cmp,'Please Select at least one Offering ');
            return null;
        }else{
            helper.hideMsg(cmp);
        }
        if(cmp.get("v.OLIList").length == cmp.get("v.OLI").length) {
            helper.showMsg(cmp,'You Cannot Select All Product ');
            return null;
        }else{
            helper.hideMsg(cmp);
        }
        if(cmp.get("v.oppName") == null) {
            helper.showMsg(cmp,'Opportunity Name is required');
            return null;
        }else{
            helper.hideMsg(cmp);
        }
        
        console.log('validated');
        //cmp.set("v.saveButtonDisable",true);
       // cmp.set("v.IsLoading",true);
        
        var action = cmp.get("c.createOpportunity");
        var OpptyRec = '';
        console.log('action defined');
        action.setParams({ recordId : cmp.get("v.recordId"),
                          opportunityName :cmp.get("v.OpportunityRec.Name"),
                          selectedOLI :cmp.get("v.OLIList")});
        
        action.setCallback(this,function(response){
            console.log('returned');
            var state = response.getState();
            
            if (cmp.isValid() && state == "SUCCESS"){
                OpptyRec=response.getReturnValue();
                cmp.set("v.OpportunityRec", OpptyRec);
                console.log('OpptyRec  '+OpptyRec);
                
                if(OpptyRec.Id != undefined){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "type": "Success",
                        "message": "Opportunity has been Created successfully."
                    });
                    toastEvent.fire();
                    cmp.set("v.IsLoading",false);
                    var eUrl= $A.get("e.force:navigateToURL");
                    eUrl.setParams({
                        "url": '/lightning/r/Opportunity/'+cmp.get("v.OpportunityRec.Id")+'/view' 
                    });
                    eUrl.fire();
                    
                }
                else{
                    console.log('in else'+response.getError()); 
                    //alert("Please fill in the required field *.",true);
                }
            } else {
                console.log(response.getError());
               
            }
        });
        
        console.log('callback defined');
        $A.enqueueAction(action);
    }
})