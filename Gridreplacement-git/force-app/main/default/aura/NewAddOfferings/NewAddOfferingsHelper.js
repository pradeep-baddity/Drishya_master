({
    saveoli : function(cmp,event,helper) {
        console.log('helper method called--');
        var action = cmp.get("c.saveOpportunityLiItems");
        action.setParams({ listOfOli : JSON.stringify(cmp.get("v.toSaveproductList")),
                          oppId : cmp.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            var msg = response.getReturnValue();
            if (state === "SUCCESS") {
                console.log('status');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type": "Success",
                    "message": "Offering has been Created successfully."
                });
                toastEvent.fire();
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
                var eUrl= $A.get("e.force:navigateToURL");
                eUrl.setParams({
                    "url": '/lightning/r/Opportunity/'+cmp.get("v.recordId")+'/view' 
                });
                eUrl.fire();
                $A.get('e.force:refreshView').fire();                    
                
            }
        });
        $A.enqueueAction(action);
    }
})