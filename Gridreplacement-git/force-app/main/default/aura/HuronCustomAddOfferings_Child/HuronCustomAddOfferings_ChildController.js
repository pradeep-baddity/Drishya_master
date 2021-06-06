({
    doInit: function(component, event, helper) {
        
    },
    validateQuantitySize :function(component, event, helper){
        if(component.get("v.singleProd.quantity") > 12){
            // alert('Quantity should be less than 12');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type": "error",
                "message": "Quantity should be less than 12"
            });
            toastEvent.fire();
        } else if(component.get("v.singleProd.quantity")<0){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type": "error",
                "message": "Quantity should be greater than 0"
            });
            toastEvent.fire();
        }
    },
    valueChanged : function(component,event) {
        console.log('singleProd in child: ' + JSON.stringify(component.get("v.singleProd")));
    },
    
    updateSelectedMap : function(component,event) {
        component.set("v.reRenderFlag",false);
        //alert(event.target.id);
        if(component.get("v.singleProd.isSelected")){
            component.set("v.singleProd.isSelected",false);
        }else{
            component.set("v.singleProd.isSelected",true);
        }
        
        //On Selecting of offering update offering picklist
        if(component.get("v.singleProd.isSelected") == true){
            component.set("v.singleProd.Offering__c",component.get("v.singleProd.ApexProductName__c"));
            component.set("v.reRenderFlag",true);
        }else if(component.get("v.singleProd.isSelected") == false){
            component.set("v.singleProd.Offering__c",'--None--');
            component.set("v.reRenderFlag",true);
        }
        
    },
    
    handleValueChange :function(component, event, helper) {
        var inputCmp = component.find('UnitPrice');
        //alert(inputCmp);
        var value = inputCmp.get('v.value');
        
        if ( value < 0 ) {
            inputCmp.set("v.errors", [{message:"Amount cannot be negative " + value}]);
            inputCmp.showHelpMessageIfInvalid();
        } else {
            inputCmp.set("v.errors", null);
        }
    },
    
    offeringChange:function(component,event) {
        var OfferingValues=event.getSource().get("v.value");
        component.set("v.singleProd.Offering__c",OfferingValues);
    },
    serviceChange:function(component,event) {
        var ServiceLineValues=event.getSource().get("v.value");
        //alert(ServiceLineValues);
        component.set("v.singleProd.Service_Line_or_Product__c",ServiceLineValues);
        //console.log(event.getSource());
    },
    
    convertAmountSI:function(component,event) {
        let enteredValue= event.getSource().get("v.value");
        
        //alert(enteredValue);
        if(enteredValue.includes('k') || enteredValue.includes('K') ||enteredValue.includes('M') || enteredValue.includes('m') || enteredValue > 0 ){
            let val=component.get("v.singleProd.UnitPrice");
            let multiplier = val.substr(-1).toLowerCase();
            if (multiplier == "k" || multiplier == "K" )
                component.set("v.singleProd.UnitPrice", parseFloat(val) * 1000);
            else if (multiplier == "m"||multiplier == "M" )
                component.set("v.singleProd.UnitPrice", parseFloat(val) * 1000000);
            
        }else if(enteredValue == '' ){
        }else{
            // alert('Quantity should be less than 12');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type": "error",
                "message": "SalesPrice should not be less than 0 "
            });
            toastEvent.fire();
            event.getSource().set("v.value",'');  
        }
        
       
    }
})