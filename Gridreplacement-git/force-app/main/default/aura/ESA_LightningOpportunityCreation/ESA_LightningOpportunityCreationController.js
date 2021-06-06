({
    doInit: function(component, event, helper) {
        //helper.fetchPickListVal(component);
        helper.getAccount_Name(component);
        component.set('v.OpportunityRec.StageName','Prospect (0-14%)');
        component.set('v.OpportunityRec.Probability',0 ); 
     	//helper.fetchPickListVal(component, 'currencyreq', 'accIndustry');
        var action = component.get("c.getIndustry");
        var inputIndustry = component.find("InputCurrency");
        var opts=[];
        action.setCallback(this, function(a) {
           /* opts.push({
                class: "optionClass",
                label: "U.S. Dollar",
                value: ""
            });*/
            for(var i=0;i< a.getReturnValue().length;i++){
                opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
            component.find("InputCurrency").set("v.value", 'USD - U.S. Dollar');
            inputIndustry.set("v.options", opts);
             
        });
        $A.enqueueAction(action); 

    },
   onPicklistChange: function(component, event, helper) {
        //get the value of select option
        var selectedcurrency = component.find("InputCurrency");
        //alert(selectedcurrency.get("v.value"));
    },
    cancelClick :function(component, event, helper) {
        var closeEvent = $A.get("e.force:closeQuickAction");
        $A.get('e.force:refreshView').fire();
        closeEvent.fire();
    },
    /*SetMSAFalse :function(component, event, helper) {
        if(component.get("v.accMSA")){
            component.set("v.accMSA",false);
        }else{
            component.set("v.accMSA",true);  
        }
    },*/
    handleValueChange :function(component, event, helper) {
        var inputCmp = component.find("amount");
        var value = inputCmp.get("v.value");
        
        if ( value < 0 ) {
            inputCmp.set("v.errors", [{message:"Amount cannot be negative " + value}]);
        } else {
            inputCmp.set("v.errors", null);
        }
        
    },
    saveingOpportunity :function(component, event, helper){
        var accid=component.get("v.recordId");
        var opp=component.find("oppName");
        var stage=component.find("optyStageName");
        var nam=component.find("accountName");
        var prob=component.find("prob");
        var dat=component.find("dat");
        var amount=component.find("amount");
        var currency=component.find("InputCurrency");
        
        var oppVal=opp.get("v.value");
        console.log('opp  '+opp);
        var datVal=dat.get("v.value");
        console.log('datVal  '+datVal);
        var amountVal=amount.get("v.value");
        console.log('amount  '+amount);
        var currencycode = currency.get("v.value");
        console.log('currencycode '+currencycode);
        var oppError=component.find("oppNameReq");
        var stageError=component.find("stageReq");
        var nameError=component.find("nameReq");
        var probError=component.find("probReq");
        var dateError=component.find("dateReq");
        var amountError=component.find("amountReq");
        var currencyError=component.find("currencyReq");
        
        var goToServer;
        
        if($A.util.isEmpty(oppVal)){
            console.log("show error 6");
            $A.util.removeClass(oppError, 'slds-hide');
            $A.util.addClass(oppError, 'slds-show');
            goToServer = 'true';
        }else{
            
            $A.util.removeClass(oppError, 'slds-show');
            $A.util.addClass(oppError, 'slds-hide');
        }
         if($A.util.isEmpty(datVal)){
            console.log("show error 1");
            $A.util.removeClass(dateError, 'slds-hide');
            $A.util.addClass(dateError, 'slds-show');
            goToServer = 'true';
        }else{
            
            $A.util.removeClass(dateError, 'slds-show');
            $A.util.addClass(dateError, 'slds-hide');
        }
        
        if($A.util.isEmpty(amountVal)){
            console.log("show error 2");
            $A.util.removeClass(amountError, 'slds-hide');
            $A.util.addClass(amountError, 'slds-show');
            goToServer = 'true';
        }else{
            
            $A.util.removeClass(amountError, 'slds-show');
            $A.util.addClass(amountError, 'slds-hide');
        } 
        
        if($A.util.isEmpty(currencycode)){
            console.log("show error 3");
            $A.util.removeClass(currencyError, 'slds-hide');
            $A.util.addClass(currencyError, 'slds-show');
            goToServer = 'true';
        }else{
            
            $A.util.removeClass(currencyError, 'slds-show');
            $A.util.addClass(currencyError, 'slds-hide');
        } 
        if(goToServer != 'true'){
            console.log('goToServer'+goToServer);
            var Opps=component.get("v.OpportunityRec");
            var action=component.get("c.saveOpportunityRec");
            var OpptyRec = '';
            action.setParams({
                "opty" : Opps,
                "aAccountRecId" : accid ,
                "currencyNew" : currencycode 
            });
            action.setCallback(this,function(response){
                var state = response.getState();
                if (component.isValid() && state == "SUCCESS"){
                    OpptyRec=response.getReturnValue();
                    component.set("v.OpportunityRec", OpptyRec);
                    //console.log('OpptyRec  '+JSON.parse(OpptyRec));
                    if(OpptyRec.Id != undefined){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success!",
                            "type": "Success",
                            "message": "The record has been Saved successfully."
                        });
                        //toastEvent.fire();
                        
                        console.log("OpportunityRecId"+component.get("v.OpportunityRec.Id"));
                        //below line is added to call the add offerins component on opportunity//
                        var oppId = component.get("v.OpportunityRec.Id");
                        var navigateEvent = $A.get("e.force:navigateToComponent");
                        navigateEvent.setParams({
                            componentDef: "c:Schedules",
                            componentAttributes : {recordId : oppId }
                            
                        });
                        navigateEvent.fire();
                    }
                    else{
                        console.log('in else'+response.getError()); 
                        //alert("Please fill in the required field *.",true);
                    }
                    /* var eUrl= $A.get("e.force:navigateToURL");
                    eUrl.setParams({
                        "url": '/lightning/r/Opportunity/'+component.get("v.OpportunityRec.Id")+'/view' 
                    });
                    eUrl.fire();*/
                } 
            });
            $A.enqueueAction(action);
        }
    },
    checkStageName : function(component, event, helper){
        if (component.get('v.OpportunityRec.StageName') == 'Prospect (0-14%)'){
            component.set('v.OpportunityRec.Probability',0);
        } else if (component.get('v.OpportunityRec.StageName') == 'Explore (15-29%)'){
            component.set('v.OpportunityRec.Probability',15);
        }else if (component.get('v.OpportunityRec.StageName') == 'Design (30-49%)'){
            component.set('v.OpportunityRec.Probability',30);
        }else if (component.get('v.OpportunityRec.StageName') == 'Propose (50-84%)'){
            component.set('v.OpportunityRec.Probability',50);
        }else if (component.get('v.OpportunityRec.StageName') == 'Commit (85-99%)'){
            component.set('v.OpportunityRec.Probability',85);
        }else if (component.get('v.OpportunityRec.StageName') == 'Closed Won (100%)'){
            component.set('v.OpportunityRec.Probability',100);
        }
    }
    
})