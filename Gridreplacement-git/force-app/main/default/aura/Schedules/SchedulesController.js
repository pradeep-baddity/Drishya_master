({
	doInit : function(component, event, helper) {
		
	},
     cancelClick :function(component, event, helper) {
        /*var closeEvent = $A.get("e.force:closeQuickAction");
        $A.get('e.force:refreshView').fire();
        closeEvent.fire();*/
         console.log("OpportunityRecId-->"+component.get("v.OpportunityRec.Id"));
         
          var eUrl= $A.get("e.force:navigateToURL");
                    eUrl.setParams({
                        "url": '/lightning/r/Opportunity/'+component.get("v.recordId")+'/view' 
                    });
                    eUrl.fire();
    },
    
    submitDetails : function(component, event, helper){
       // alert('submitted');
       var oppId = component.get("v.recordId");
        var navigateEvent = $A.get("e.force:navigateToComponent");
                        navigateEvent.setParams({
                            componentDef: "c:AddOfferingsPrompt",
                            componentAttributes : {recordId : oppId }
                            
                        });
                        navigateEvent.fire();
    },
    
})