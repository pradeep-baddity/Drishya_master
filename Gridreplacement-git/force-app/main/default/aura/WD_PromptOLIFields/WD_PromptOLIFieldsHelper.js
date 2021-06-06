({
    fetchOLIData : function(component,event,helper) {
        var action= component.get("c.fetchOpportunityProducts");
        action.setParams({
            aRecordID :component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            var state = response.getState();  
            if(state === "SUCCESS"){
                var OLIResponse = response.getReturnValue();
                //alert('OLIResponse'+JSON.stringify(OLIResponse));
                if(OLIResponse != null){
                    component.set("v.openModal",true);
                      component.set("v.oppLineItems",OLIResponse);
                } else{
                    console.log('No Offrings Record Found');
                }
                //var totalRecord = OLIResponse.length;
            } 
                else{
                    console.log('Something went Wrong');
                }       
            });
        $A.enqueueAction(action);		
    },
})