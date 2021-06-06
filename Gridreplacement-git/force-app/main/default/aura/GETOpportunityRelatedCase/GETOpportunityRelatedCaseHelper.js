({
	    fetchCaseHelper : function(component, event, helper){
        var action = component.get("c.getcas");
        action.setParams({ Caseid : component.get("v.recordId")
                         });
        action.setCallback(this, function(response){
            var state = response.getState();
            var res = response.getReturnValue(); 
            if (state === "SUCCESS") {
                component.set("v.CaseList", response.getReturnValue());
                console.log('=====eres'+JSON.stringify(response.getReturnValue()));
                res.forEach(function(record){
                    record.linkName = '/'+record.Id;
                    record.CaseNumber = record.CaseNumber;                    
                });
                
            }
        });
        $A.enqueueAction(action);
        
        console.log('----v.CaseList---'+JSON.stringify(component.get("v.CaseList")));
    },

})