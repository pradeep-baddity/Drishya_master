({
    doInit : function(cmp) {
       // cmp.set("v.cssStyle", "<style> .slds-modal__container { margin: 0 auto; width: 100%; max-width: 90rem; min-width: 30rem;}</style>");
        //cmp.set("v.cssStyleForheight", "<style> height: auto; max-height: none;</style>");
        
        var action = cmp.get("c.getOppLines");
        action.setParams({ recId : cmp.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                if(!response.getReturnValue())
                    cmp.set("v.IsclosedWonStage",true);
                
                cmp.set("v.OLI",response.getReturnValue());
                console.log(cmp.get("v.OLI "));
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
    
    cancelClick :function(component, event) {
        var closeEvent = $A.get("e.force:closeQuickAction");
        closeEvent.fire();
    },
    getSelectedName: function (cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        console.log(selectedRows);
        cmp.set("v.OLIList", null);
        var listRawSelected = [];
        var selectedLines = [];
        for (var i = 0; i < selectedRows.length; i++){
            listRawSelected.push(selectedRows[i].Id);
            selectedLines.push(selectedRows[i]);
        }
        cmp.set("v.numberOfRawSelected",listRawSelected.length);
        cmp.set("v.OLIList",listRawSelected);
        cmp.set("v.selectedOLIs",selectedLines);
        console.log(cmp.get("v.selectedOLIs"));
    },
    
    getSelectedRows: function (cmp, event) {
        //var selectedRows = event.getParam('selectedRows');
        //console.log(selectedRows);
        var allRows = cmp.get("v.OLI");
        //cmp.set("v.OLIList", null);
        var listRawSelected = [];
        var selectedLines = [];
        for (var i = 0; i < allRows.length; i++){
            if(allRows[i].isSelected){
                selectedLines.push(allRows[i]);
            }            
        }
        cmp.set("v.selectedOLIs",selectedLines);
        console.log(cmp.get("v.selectedOLIs"));
    },
    
    
    createNewOpportunity :function(cmp,event){
        var jsonSelected = cmp.get("v.selectedOLIs");
        // alert('@@@@T-->'+JSON.stringify(jsonSelected));
        var atLeastOneSelected= false;
        console.log(jsonSelected);
        console.log('validated');
        cmp.set("v.saveButtonDisable",true);
        cmp.set("v.IsLoading",true);
        
        for(var i=0; i<jsonSelected.length; i++){
            if(jsonSelected[i].isSelected){
                atLeastOneSelected=true; 
                console.log(jsonSelected[i].isSelected);
            }
        }
        
        var action = cmp.get("c.createOpportunity");
        var OpptyRec = '';
        console.log('action defined');
        //  alert(cmp.get("v.opportunityName"));
        action.setParams({ recordId : cmp.get("v.recordId"),
                          optyType : cmp.get("v.optyType"),
                          estdDate :cmp.get("v.estdDate"),
                          selectedOLI :cmp.get("v.OLIList"),
                          duration : cmp.get("v.duration"),
                          InitiateRenewal : cmp.get("v.InitiateRenewal"),
                          EOCD : cmp.get("v.EOCD"),
                          opportunityName :cmp.get("v.opportunityName"),
                          offeringsList : JSON.stringify(jsonSelected)
                         });
        
        action.setCallback(this,function(response){
            console.log('returned');
            var state = response.getState();
            
            if (cmp.isValid() && state == "SUCCESS"){
                OpptyRec=response.getReturnValue();
                cmp.set("v.OpportunityRec", OpptyRec);
                console.log('OpptyRec  '+OpptyRec);
                
                var OpportunityType = cmp.get("v.optyType");
                if(OpportunityType === ''){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type": "error",
                        "message": "Please Select Opportunity Type"
                    });
                    toastEvent.fire();
                     cmp.set("v.IsLoading",false);
                    cmp.set("v.saveButtonDisable",false);
                
                } else if(OpptyRec.Id != undefined){
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
            } else if( state = "ERROR") {
                var errorMsg = response.getError()[0];
                console.log(errorMsg);
                var toastParams = {
                    title: "Error",
                    //message:response.getError()[0].message ,
                    
                   message:"Something Went Wrong!! Please provide values for all fields OR The Estimated Engagement Start Date must be greater than or equal to the Estimated Opportunity Close Date" ,
                    // message: errorMsg, // Default error message
                    type: "error"
                };
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams(toastParams);
                toastEvent.fire();
                cmp.set("v.IsLoading",false);
                cmp.set("v.saveButtonDisable",false);
                
                console.log(response.getError());
            }else{
                console('Entered Blank');
            }
        });
        console.log('callback defined');
        //  alert(atLeastOneSelected);
        //$A.enqueueAction(action);
        if(atLeastOneSelected){
            $A.enqueueAction(action);
        }else{
            //show toast
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type": "error",
                "message": "Please Select at least one Offering"
            });
            toastEvent.fire();
            cmp.set("v.IsLoading",false);
            cmp.set("v.saveButtonDisable",false);
        } 
        
    }
    
})