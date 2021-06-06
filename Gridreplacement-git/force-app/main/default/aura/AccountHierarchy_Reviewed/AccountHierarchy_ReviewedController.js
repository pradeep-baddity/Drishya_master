(
  {
    doInit: function(component) 
      {
         var action = component.get("c.getAccount");
        action.setParams({
            "aid": component.get("v.recordId")
        }); 
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('response.getReturnValue()'+response.getReturnValue());
             if (state === "SUCCESS") {
                  $A.get('e.force:refreshView').fire();
                 component.set("v.mycolumns", response.getReturnValue());
                  console.log( 'Data - ' + JSON.stringify( response.getReturnValue() ) );
             
            }
        });
        $A.enqueueAction(action);
    },
        
 cancelClick :function(component, event, helper) 
      {
        var closeEvent = $A.get("e.force:closeQuickAction");
        closeEvent.fire();
      },
 clickYes :function(component) 
      {
         var action = component.get("c.UpdateAccount");
        action.setParams({
            "aid": component.get("v.recordId")
        }); 
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('response.getReturnValue()'+response.getReturnValue());
             if (state === "SUCCESS") {
                 $A.get('e.force:refreshView').fire();
                 
                 var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success',
            message: 'Reviewed Successfully,Thank you for reviewing this account.',
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
                   var closeEvent = $A.get("e.force:closeQuickAction");
                 closeEvent.fire();
                 console.log( 'Data - ' + JSON.stringify( response.getReturnValue() ) );
                
            }
        });
        $A.enqueueAction(action);
    }
}
 
 
   
    )