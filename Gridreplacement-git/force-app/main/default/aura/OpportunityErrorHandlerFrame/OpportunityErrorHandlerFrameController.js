({
    doInit : function(component, event, helper) {
        console.log('init called.');
        helper.getRecroTypeId(component,event, helper);
        helper.dataLoaderInit(component, 'init');
        
    },
    
    refreshHandler: function(component, event, helper) {
        console.log('refreshview event fired.');
        helper.dataLoaderInit(component, 'refreshHandler');
    },
    
    handleFieldChange : function(component, event, helper) {
        if(event.getSource().get('v.value'))
            component.set("v.saveButtonDisable", false);
        else
            component.set("v.saveButtonDisable", true);
    },
    
    handleSubmit: function(component, event, helper) {
        
        event.preventDefault();
        var allFields = event.getParam('fields');	// complete record form (includes all fields)
        console.log('allFields ==>'+JSON.stringify(allFields));
        var reqFields = component.get('v.orequiredFields');
        console.log('reqFields ==>'+JSON.stringify(reqFields));
        component.set("v.saveButtonDisable", true);
        component.set("v.showSpinner",true);
        helper.validateStartDateCloseDate(component, event, allFields);
        component.set("v.showSpinner",false);
    },
    
    handleSuccess: function(component, event, helper) {
        var updatedRecord = JSON.parse(JSON.stringify(event.getParams()));
        console.log('onsuccess: ', updatedRecord.response.id);
        component.set("v.isClosed",false);
        //console.log('list value'+component.get("v.orequiredFields"));
        component.set("v.showSpinner",false);
        var resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            "type": 'Success',    
            "title": "Saved",
            "message": "Saved successfully."
        });
        resultsToast.fire();
        $A.get('e.force:refreshView').fire();
    },
    
    handleError: function(component, event) {
        component.set("v.showSpinner",false);
        console.log('Something went wrong.');
    },
    handleCancelClick:function(component,event,helper){
        helper.onCancelMovePreviousStage(component,event);
    },
    callCustomAddOfferingQuickAction:function(component,event,helper){
        console.log('QuickActuionCalled');
        var actionAPI = component.find("quickActionAPI");
        var args = {actionName: "Opportunity.New_Offering_Wizard",
                    targetFileds:[{name:'recordId',
                    value:component.get("v.recordId"), type:'Set'}]};
        actionAPI.selectAction(args).then(function(result){
            //Action selected; show data and set field values
        }).catch(function(e){
            if(e.errors){
                //If the specified action isn't found on the page, show an error message in the my component
            }
        });
    }
})