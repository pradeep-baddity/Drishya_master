({
    saveOli : function(component,event,helper) {
      //  alert('Helper Method Executd');
        var action = component.get("c.saveOpportunityLiItem");
        action.setParams({ listOfOli : JSON.stringify(component.get("v.toSaveproductList")) });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var msg = response.getReturnValue();
          
           // if(msg === "SUCCESS"){
                 //alert(JSON.stringify(msg));
                if (state === "SUCCESS") {
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "type": "Success",
                        "message": "Offering has been Created successfully."
                    });
                    toastEvent.fire();
                   
                    console.log(component.get("v.isLoading"));
                    component.set("v.isLoading",false);
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire();
                    var eUrl= $A.get("e.force:navigateToURL");
                    eUrl.setParams({
                        "url": '/lightning/r/Opportunity/'+component.get("v.recordId")+'/view' 
                    });
                    eUrl.fire();
                    $A.get('e.force:refreshView').fire();                    
                    
                }
                else if (state === "INCOMPLETE") {
                    // do something
                }
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " + 
                                            errors[0].message);
                            }
                        } else {
                            console.log("Unknown error");
                        }
                        component.set("v.isLoading",false);
                    }
          //  }
            else{
                console.log("Entered in MaxError Window");
            }
            $A.get('e.force:refreshView').fire(); 
        });
        console.log('multipleRows: ' + JSON.stringify(component.get("v.multipleRows")));
        console.log('toSaveproductList: ' + JSON.stringify(component.get("v.toSaveproductList")));
        $A.enqueueAction(action);
    },
    
    getProducts : function(component,event,helper,mode) {
        var action = component.get("c.getOfferinggs");
        console.log("Opp RecordId"+component.get("v.recordId"));
        console.log("mode==>"+mode);
        action.setParams({
            opportunnityID : component.get("v.recordId"),
            searchKeyword :mode
        });
        action.setCallback(this,function(response){
            try{   
                var state = response.getState();
                if (state === "SUCCESS") {
                    let listOfOli=response.getReturnValue();
                    if(listOfOli)
                        for(let i=0;i<listOfOli.length;i++){
                            listOfOli[i].isSelected=false;
                            listOfOli[i].quantity=1;
                        }
                    component.set("v.productList",listOfOli);
                    component.set("v.serverCall", false);
                    console.log('ProdList==>'+JSON.stringify(component.get("v.productList")));
                    
                }else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                } 
            } catch (ex){
                console.log('Error SearchKey'+ex);
            }
        });
        $A.enqueueAction(action);
    }
})