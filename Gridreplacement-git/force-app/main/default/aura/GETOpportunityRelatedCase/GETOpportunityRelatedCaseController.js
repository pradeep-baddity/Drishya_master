({
	FetchCases : function(component, event, helper) {
        // component.set("v.openHuronconnection", true);
        component.set('v.mycases',[
           
            {label: 'Case Number', fieldName: 'linkName',type: 'url', sortable: false , hideDefaultActions: true,         
           type: 'url',typeAttributes: {label: { fieldName: 'CaseNumber' },sortable: true, target: '_blank'}},
           {label: 'Case Type', fieldName: 'Type',sortable: false, type: 'text',hideDefaultActions: true},
           {label: 'Priority', fieldName: 'Priority', type: 'text', sortable: false ,hideDefaultActions: true },            
        ]);
            helper.fetchCaseHelper(component, event, helper);
            },
            
        showSpinner : function(component,event,helper){
        // display spinner when aura:waiting (server waiting)
        component.set("v.toggleSpinner", true);  
    },
    
        hideSpinner : function(component,event,helper){
        // hide when aura:downwaiting
        component.set("v.toggleSpinner", false);
    },
		
	})