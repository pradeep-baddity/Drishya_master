({
    convertAmountSI:function(component,event) {
        let enteredValue= event.getSource().get("v.value");
        
        //alert(enteredValue);
        if(enteredValue.includes('k') || enteredValue.includes('K') ||enteredValue.includes('M') || enteredValue.includes('m') || enteredValue > 0 ){
            let val=component.get("v.singleProduct.UnitPrice");
            let multiplier = val.substr(-1).toLowerCase();
            if (multiplier == "k" || multiplier == "K" )
                component.set("v.singleProduct.UnitPrice", parseFloat(val) * 1000);
            else if (multiplier == "m"||multiplier == "M" )
                component.set("v.singleProduct.UnitPrice", parseFloat(val) * 1000000);
            
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