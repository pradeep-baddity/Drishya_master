({
   handleCloseModal: function(component, event, helper) {
        //For Close Modal, Set the "openModal" attribute to "false"  
        component.set("v.showModal", false);
        
    },

    refreshHandler : function(component, event, helper) {
        
        var changeType = event.getParams().changeType;
        var oppRec=component.get("v.OpportunityRecord");
        console.log("@@@:"+JSON.stringify(oppRec.StageName));
      //  console.log('=--=opp record-=--'+OpportunityRecord);
        if (changeType === "CHANGED") { 
          if(oppRec.StageName == 'Closed Won (100%)'){
       component.set("v.showModal", true);
        }
        }
    }
    
})