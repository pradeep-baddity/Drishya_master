({
    doInit : function(component,event,helper) {
    },
    refreshHandler: function(component,event,helper) {
        console.log('refreshview event fired.');
        helper.helperdoInit(component,'refreshHandler');
    },
    cancelClick : function(component,event,helper){
        var action=component.get("c.clickNo");
        action.setParams({ opportunityrecordId : component.get("v.recordId")
                         });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log('state-->'+JSON.stringify(response.getState()));
            
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
        $A.enqueueAction(action);
        
    },
    clicksubmit:function(component,event,helper){
    	 var oppId = component.get("v.recordId");
        var navigateEvent = $A.get("e.force:navigateToComponent");
                        navigateEvent.setParams({
                            componentDef: "c:NewAddOfferings",
                            componentAttributes : {recordId : oppId }
                            
                        });
                        navigateEvent.fire();
    },
    
})