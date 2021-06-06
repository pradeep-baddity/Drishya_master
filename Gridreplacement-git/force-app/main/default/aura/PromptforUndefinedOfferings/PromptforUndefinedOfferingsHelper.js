({
    helperdoInit : function(component, event, helper) {
        var action=component.get("c.checkforundefined");
        action.setParams({ opportunityrecordId : component.get("v.recordId")
                         });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log('state-->'+JSON.stringify(response.getState()));
            
            if(state === "SUCCESS"){
                
                console.log('response.getReturnValue()'+response.getReturnValue());
                // component.set('v.OpportunityLineItemRecord',response.getReturnValue());
                if( response.getReturnValue()){
                    component.set('v.disabled',true);
                    console.log('If---'); 
                }
            }
            else  {
                console.log('error---');
            }
        });
        $A.enqueueAction(action);
    },
    

})