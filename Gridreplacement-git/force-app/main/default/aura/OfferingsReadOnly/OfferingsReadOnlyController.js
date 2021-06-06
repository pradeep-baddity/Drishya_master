({
	fetchOpportunityLineItems: function (comp, event){
        
        var action = comp.get("c.offeringReadOnlyRecords");
        action.setParams({ 
            lineitemId : comp.get("v.recordId") 
        });
        action.setCallback(this, function(response){
            comp.set("v.opplinelist",response.getReturnValue());
        });
        $A.enqueueAction(action);
    }
})