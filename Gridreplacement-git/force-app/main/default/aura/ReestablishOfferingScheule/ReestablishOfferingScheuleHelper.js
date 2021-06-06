({
    
    helperdoInit : function(component, event, helper) {
        var action=component.get("c.estimatedFieldsCheckOnOpty");
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
    
    
    ScheduleRecreation : function(component, event ,helper) {
        
        var action=component.get("c.ScheduleRecreation");      
        action.setParams({ opportunityrecordId : component.get("v.recordId")
                         });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            console.log('state-->'+JSON.stringify(response.getState()))
            if(state === "SUCCESS"){
                 //component.set('v.IsLoading',false);
                //helper.updateOpty(component,event,helper);
                console.log('response.getReturnValue()'+JSON.stringify(response.getReturnValue()));
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type": "Success",
                    "message": "Opportunity schedules are updated successfully."
                });
               
                toastEvent.fire();              
                helper.updateOpty(component,event,helper);
                
            }
            else  {
                console.log('error---');
            }
        });
        $A.enqueueAction(action);
        
    },
    
    updateOpty : function(component, event, helper){
        //debugger;
        console.log(component.get("v.recordId"));
        var action1=component.get("c.updateOptyOldValues");
        action1.setParams({ opportunityrecordId : component.get("v.recordId")
                          });
        action1.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log('state-->'+JSON.stringify(response.getState()))
            
            if(state === "SUCCESS"){
                var eUrl= $A.get("e.force:navigateToURL");
                eUrl.setParams({
                    "url": '/lightning/r/Opportunity/'+component.get("v.recordId")+'/view'
                });
                eUrl.fire();
                $A.get('e.force:refreshView').fire();
            }
            else  {
                console.log('error---');
            }
        });
        $A.enqueueAction(action1);
    },
    
    
})