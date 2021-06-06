({
    getAccount_Name : function(component) {
        var recid=component.get("v.recordId");
        var action=component.get("c.getAccountName");
        
        action.setParams({
            recordId: recid 
        })
        action.setCallback(this,function(response){
            var state = response.getState();
            if (component.isValid() && state == "SUCCESS"){
                var accountVar = response.getReturnValue();
                component.set("v.accName", accountVar.Name);
                //component.set("v.accMSA", accountVar.MSA__c);
                component.set("v.OpportunityRec.AccountId" , accountVar.Id);
                //component.set("v.OpportunityRec.RecordType.Name" , 'EPM_Single_Service_Line');
            }
        });
        $A.enqueueAction(action);
    }
    
    /*fetchPickListVal: function(component, fieldName, elementId) {
        var action = component.get("c.getPicklistValues");
        
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                
                var allValues = JSON.parse(response.getReturnValue());
                var optstageName = [];
                //Stage Values
                if(allValues.StageName != null){
                    if (allValues != undefined && allValues.StageName.length > 0) {
                        
                        for (var i = 0; i < allValues.StageName.length; i++) {
                            optstageName.push({
                                class: "optionClass",
                                label: allValues.StageName[i],
                                value: allValues.StageName[i]
                            });
                        }
                    }
                    component.set("v.stageOptions", optstageName);
                    
                }
                //type
                var Opttype = [];
                if(allValues.Type != null){
                    
                    if (allValues != undefined && allValues.Type.length > 0) {
                        
                        for (var i = 0; i < allValues.Type.length; i++) {
                            console.log(allValues.Type[i]);
                            Opttype.push({
                                class: "optionClass",
                                label: allValues.Type[i],
                                value: allValues.Type[i]
                            });
                        }
                    }
                    component.set("v.TypeOptions", Opttype);
                    
                }
                var optcurrencyisocode = [];
                if(allValues.currencyisocode != null){
                    
                    if (allValues != undefined && allValues.currencyisocode.length > 0) {
                        
                        for (var i = 0; i < allValues.currencyisocode.length; i++) {
                            //console.log(allValues.currencyisocode[i]);
                            optcurrencyisocode.push({
                                class: "optionClass",
                                label: allValues.currencyisocode[i],
                                value: allValues.currencyisocode[i]
                            });
                        }
                    }
                    component.set("v.CurrencyOptions", optcurrencyisocode);
                    
                }
                
                //region
                var regionPicklist = [];
                if(allValues.epmregion != null){
                    
                    if (allValues != undefined && allValues.epmregion.length > 0) {
                        
                        for (var i = 0; i < allValues.epmregion.length; i++) {
                            //console.log(allValues.epmregion[i]);
                            regionPicklist.push({
                                class: "optionClass",
                                label: allValues.epmregion[i],
                                value: allValues.epmregion[i]
                            });
                        }
                    }
                    component.set("v.Regionoptions", regionPicklist);
                    
                }
                
                //	reasonwon
                var reasonwonPicklist = [];
                if(allValues.reasonwon != null){
                    
                    if (allValues != undefined && allValues.reasonwon.length > 0) {
                        
                        for (var i = 0; i < allValues.reasonwon.length; i++) {
                            //console.log(allValues.reasonwon[i]);
                            reasonwonPicklist.push({
                                class: "optionClass",
                                label: allValues.reasonwon[i],
                                value: allValues.reasonwon[i]
                            });
                        }
                    }
                    component.set("v.PrimaryReasonWonoptions", reasonwonPicklist);
                }
                //ReasonLost 
                var ReasonLostPicklist = [];
                if(allValues.ReasonLost != null){
                    
                    if (allValues != undefined && allValues.ReasonLost.length > 0) {
                        
                        for (var i = 0; i < allValues.ReasonLost.length; i++) {
                            //console.log(allValues.ReasonLost[i]);
                            ReasonLostPicklist.push({
                                class: "optionClass",
                                label: allValues.ReasonLost[i],
                                value: allValues.ReasonLost[i]
                            });
                        }
                    }
                    component.set("v.PrimaryReasonLostoptions", ReasonLostPicklist);
                }
                //BDMRole
                var BDMRolePicklist = [];
                if(allValues.BDMRole != null){
                    
                    if (allValues != undefined && allValues.BDMRole.length > 0) {
                        
                        for (var i = 0; i < allValues.BDMRole.length; i++) {
                            //console.log(allValues.BDMRole[i]);
                            BDMRolePicklist.push({
                                class: "optionClass",
                                label: allValues.BDMRole[i],
                                value: allValues.BDMRole[i]
                            });
                        }
                    }
                    component.set("v.BDMRoleoptions", BDMRolePicklist);
                }
                //leadsource 
                var leadsourcePicklist = [];
                if(allValues.leadsource != null){
                    
                    if (allValues != undefined && allValues.leadsource.length > 0) {
                        
                        for (var i = 0; i < allValues.leadsource.length; i++) {
                            //console.log(allValues.leadsource[i]);
                            leadsourcePicklist.push({
                                class: "optionClass",
                                label: allValues.leadsource[i],
                                value: allValues.leadsource[i]
                            });
                        }
                    }
                    component.set("v.leadsourceoptions", leadsourcePicklist);
                }
                //ProposalFeedbackReceived  
                var ProposalFeedbackReceivedPicklist = [];
                if(allValues.leadsource != null){
                    
                    if (allValues != undefined && allValues.ProposalFeedbackReceived.length > 0) {
                        
                        for (var i = 0; i < allValues.ProposalFeedbackReceived.length; i++) {
                            //console.log(allValues.ProposalFeedbackReceived[i]);
                            ProposalFeedbackReceivedPicklist.push({
                                class: "optionClass",
                                label: allValues.ProposalFeedbackReceived[i],
                                value: allValues.ProposalFeedbackReceived[i]
                            });
                        }
                    }
                    component.set("v.ProposalFeedbackReceivedoptions", ProposalFeedbackReceivedPicklist);
                }
            }
            
        });
        $A.enqueueAction(action);
    }*/

})