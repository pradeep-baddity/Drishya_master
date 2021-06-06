({
    fetchoppline : function(component, event, helper) {
        component.set('v.mycolumns', [
            {type: "button", 
             initialWidth: 5,
             typeAttributes: {
                 iconName: 'utility:edit',
                 name: 'Edit',
                 title: 'Edit',
                 disabled: false,
                 value: 'edit',
                 iconPosition: 'left'
             }},
            {type: "button", 
             initialWidth: 5,
             typeAttributes: {
                 iconName: 'utility:delete',
                 name: 'Delete',
                 title: 'Delete',
                 disabled: { fieldName: 'is_Non_Restricted_User__c'},
               //	 disabled: false,
                 value: 'Delete',
                 iconPosition: 'left'
             }},
            {type: "button", 
             initialWidth: 10,
             typeAttributes: {
                 iconName: 'utility:event',
                 name: 'Schedule',
                 title: 'Schedule',
                 disabled: false,
                 value: 'Schedule',
                 iconPosition: 'left'
             }},
           // {label: 'Offering', fieldName: 'Product2Id',type: 'Text',sortable: true},
            {label: 'Name', fieldName: 'Product2Id',sortable: true, type: 'url',typeAttributes:  {label: { fieldName: 'ProductName' }, target: '_blank'}},
            {label: 'Practice', fieldName: 'Practice__c', type: 'Text',sortable: true},
            {label: 'SalesPrice', fieldName: 'Amount__c', type: 'currency', typeAttributes: { currencyCode : { fieldName: 'CurrencyIsoCode' }}},
            {label: 'Capability', fieldName: 'Capability_new__c', type: 'text',sortable: true},
            {label: 'Expertise', fieldName: 'Expertise__c', type: 'text',
             cellAttributes: {
                 iconName: { fieldName: 'utility:check' }}
            }
            
        ]);
        helper.fetchOpportunityLineItems(component, event, helper);
    },
    /*refreshHandler: function(component, event, helper) {
        console.log('refreshview event fired.');
        if( component.get("v.RefreshingBoolean")){
          $A.get('e.force:refreshView').fire();   
        }
       
    },*/
    
    showSpinner : function(component,event,helper){
        // display spinner when aura:waiting (server waiting)
        component.set("v.toggleSpinner", true);  
    },
    
    hideSpinner : function(component,event,helper){
        // hide when aura:downwaiting
        component.set("v.toggleSpinner", false);
    },
    
    buttonActions : function(component, event, helper) {
        var recId = event.getParam('row').Id;
        var OppId = component.get("v.recordId");
        var actionName = event.getParam('action').name;
        if ( actionName == 'Edit' ) {
            var editRecordEvent = $A.get("e.force:editRecord");
            editRecordEvent.setParams({
                "recordId": recId
            });
            editRecordEvent.fire();
             component.set("v.RefreshingBoolean",true); 
            //$A.get('e.force:refreshView').fire();
        } 
        else if(actionName == 'Delete' ){
            component.set("v.openModalDelete", true);
            component.set("v.selectedRowid",recId);
        }
        else if(actionName == 'Schedule'){
                component.set("v.openModal", true);
                component.set("v.selectedRowid",recId);
                helper.defaultschedulevalues(component, event);
        }
    },
    
    updateColumnSorting: function(component, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);
        helper.sortData(component, fieldName, sortDirection);
    },
    
    handleCloseModal: function(component, event, helper) {
        //For Close Modal, Set the "openModal" attribute to "false"  
        component.set("v.openModal", false);
        component.set("v.openModalDelete", false);
    },
    
    handleOnload: function(component, event, helper) {
        //For Close Modal, Set the "openModal" attribute to "false"  
        //component.set("v.openModal", false);
        //alert('entered');
        //component.set("v.openModalDelete", false);
    },
    
    deleteLineItem: function(component, event, helper) {
        var recId = component.get('v.selectedRowid');
        var OppId = component.get('v.recordId');

        var action = component.get("c.deleteopportunitylineitemId");
        action.setParams({
            lineItemId:recId,
            OpportunityId:OppId
        });
        action.setCallback(this, function(response) {
            if(response.getState() == 'SUCCESS'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type": "Success",
                    "message": "The record has been deleted successfully."
                });
                toastEvent.fire();
                component.set("v.oppLineItemList",response.getReturnValue());
            }
            else if(response.getState() == 'ERROR'){
                var toast = $A.get("e.force:showToast");
                if(toast){
                    toast.setParams({
                        "title": "Error",
                        "message": response.getError()[0].message
                    });
                }
                toast.fire();
            }            
        });
        $A.enqueueAction(action);
        component.set("v.openModalDelete", false);
    },    
    
    callCustomAddOfferingQuickAction:function(component,event,helper){
        console.log('QuickActionCalled');
        var actionAPI = component.find("quickActionAPI");
        var OpportunityId = component.get('v.recordId');
     //   var fields = {name:'recordId', value:component.get("v.recordId")};
     //   alert('fields::'+fields);
       /* var args = { actionName : "New_Offering_Wizard", 
                     recordId: "recordId",
                    type: "QuickAction"
                   //	targetFields : fields
                   };
        actionAPI.getSelectedActions(args).then(function() {
            alert('success');
        }).catch(function(e) {
             alert('error'+e.errors);
            console.error(e.errors);
        });*/
        
           var navigateEvent = $A.get("e.force:navigateToComponent");
                        navigateEvent.setParams({
                            componentDef: "c:AddOfferingsPrompt",
                            componentAttributes : {recordId : OpportunityId }
                            
                        });
                        navigateEvent.fire();
                    
 
    },
    
    saveLineItem :function(component, event, helper) {
        //alert();
        
        var recId = component.get('v.selectedRowid');      
        var ScheduleDate = component.find("ScheduleDate").get("v.value");
        var Revenue = component.find("Revenue").get("v.value");
        var Installments = component.find("Installments").get("v.value");
    	//console.log('revenue--'+Revenue);
        console.log('Installments : '+Installments);
        var action = component.get("c.recreateSchedules");
        action.setParams({
            lineItemId:recId, schdate : ScheduleDate, rev : Revenue, duemonths : Installments
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type": "Success",
                    "message": "The record has been Saved Successfully."
                });
                toastEvent.fire();
            }
            else if(response.getState() == 'ERROR'){
                var toast = $A.get("e.force:showToast");
                if(toast){
                    toast.setParams({
                        "title": "Error",
                        "message": response.getError()[0].message
                    });
                }
                toast.fire();
            }
        });
        
        $A.enqueueAction(action);
        component.set("v.openModal", false);
    }
})