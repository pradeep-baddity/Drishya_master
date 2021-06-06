({
    doInit : function(component,event,helper){
        component.set("v.cssStyle", "<style> .slds-modal__container { margin: 0 auto; width: 90%; max-width: 70rem; min-width: 20rem;}</style>");
        component.set("v.cssStyleForheight", "<style> height: auto; max-height: none;</style>");
        helper.fetchOLIData(component,helper);
    },
    refreshHandler :function(component,event,helper){
        
    },
    handleCloseModal: function(component, event, helper) {
        //For Close Modal, Set the "openModal" attribute to "fasle"  
        component.set("v.openModal", false);
        
    },    handleLoad : function(component, event, helper) {
        console.log('handle handleLoad');
        
    },
    handleSubmit : function(component, event, helper) {
        console.log('Submit clickd');
        var editForms = component.find('recordEditForm');
        var forms = [].concat(editForms || []);
        /* Now here the forms will always be an array, and won't break your code anymore. */
        forms.forEach( form =>{
            form.submit();
        })
        },
            handleSuccess : function(component, event, helper) {
                //alert('record updated successfully');
                //component.set("v.showSpinner", false);
                // Show toast
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "title": "Success!",
                    "message": "Record has been created successfully."
                });
                toastEvent.fire();
                component.set("v.openModal", false);
            },
            handleError :function(component, event, helper){
                alert('Something went Wrong');
            }
            
        })