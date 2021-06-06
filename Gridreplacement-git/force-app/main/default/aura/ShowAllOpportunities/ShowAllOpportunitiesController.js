({
    handleOpenModal : function(component, event, helper) {
        component.set("v.openModal", true);
        component.set('v.mycolumns', [
            {label: 'Account Name', fieldName: 'AccountId', sortable: true,
             type: 'url',typeAttributes: {label: { fieldName: 'AccountName' }, sortable: true, target: '_blank'}},
            {label: 'Opportunity Name', fieldName: 'linkName', sortable: true,type: 'url', 
             typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}},
            
            {label: 'Practice', fieldName: 'Practice__c', sortable: true,type: 'text'},
            {label: 'Stage', fieldName: 'StageName',sortable: true, type: 'text'},
            {label: 'TCV Amount', fieldName: 'Total_Contract_Value__c', sortable: true,type: 'currency', typeAttributes: { currencyCode : { fieldName: 'CurrencyIsoCode' }}},
            //{label: 'TCV', fieldName: 'Amt', sortable: true,type: 'text'},//typeAttributes: { currencyDisplayAs :"code" }},
            {label: 'Estimated Opportunity Close Date', fieldName: 'CloseDate', sortable: true,type: "date-local", typeAttributes:{month: "numeric",day: "numeric",alignment: 'right'}},
            {label: 'Opportunity Owner Name', fieldName: 'OwnerId',sortable: true, type: 'url', 
             typeAttributes: {label: { fieldName: 'oppowner' }, target: '_blank'}}
        ]);
        helper.fetchAccHelper(component, event, helper);
    },
    handleOpenContact : function(component, event, helper) {
        component.set("v.openContact", true);
        component.set('v.mycontacts',[
            {label: 'Account Name', fieldName: 'AccountId', type: 'url',sortable: true,
             typeAttributes: {label: { fieldName: 'AccountName' }, sortable: true,  target: '_blank'}},
            {label: 'Contact Name', fieldName: 'linkName',type: 'url',sortable: true, 
             typeAttributes: {label: { fieldName: 'Name' },sortable: true, target: '_blank'}},
            {label: 'Title', fieldName: 'Title', type: 'text',sortable: true},
            {label: 'Phone', fieldName: 'Phone', type: 'phone',sortable: true},
            {label: 'Email', fieldName: 'Email', type: 'Email',sortable: true}
        ]);
        helper.fetchConHelper(component, event, helper);
    },
    
    handleopenHuronconnection : function(component, event, helper) {
        component.set("v.openHuronconnection", true);
        component.set('v.myhuronconnections',[
           
           {label: 'Contact Name', fieldName: 'ContactId',type: 'url', sortable: true,
             typeAttributes: {label: { fieldName: 'Contact__c' },sortable: true, target: '_blank'}},
           {label: 'Account Name', fieldName: 'AccountId',sortable: true,
             type: 'url',typeAttributes: {label: { fieldName: 'Account__c' },sortable: true, target: '_blank'}},
           {label: 'Huron Connection Name', fieldName: 'OwnerId',sortable: true, type: 'text'},
           {label: 'Relationship', fieldName: 'Relationship__c', type: 'text', sortable: true },
           {label: 'Connection Strength', fieldName: 'Connection_Strength__c',sortable: true, type: 'text'},
            
        ]);
            helper.fetchConnectionsHelper(component, event, helper);
            },
            
            // this function automatic call by aura:waiting event  
            showSpinner: function(component, event, helper) {
            // make Spinner attribute true for display loading spinner 
            //component.set("v.Spinner", true); 
            },
            
            // this function automatic call by aura:doneWaiting event 
            hideSpinner : function(component,event,helper){
            // make Spinner attribute to false for hide loading spinner    
            //component.set("v.Spinner", false);
            },
            handleCloseModal: function(component, event, helper) {
            component.set("v.openModal", false);
            var eUrl= $A.get("e.force:navigateToURL");
            eUrl.setParams({
            "url": '/lightning/r/Opportunity/'+component.get("v.recordId")+'/view' 
            });
            eUrl.fire();
            },
            updateColumnSorting: function(component, event, helper) {
            var fieldName = event.getParam( 'fieldName' );  
            component.set( "v.sortedBy", fieldName );  
            if ( fieldName === 'AccountId' )  
            fieldName = 'AccountName';  
            if ( fieldName === 'linkName' )  
            fieldName = 'Name'; 
            if ( fieldName === 'OwnerId' )  
            fieldName = 'oppowner';  
            var sortDirection = event.getParam( 'sortDirection' );  
            component.set( "v.sortedDirection", sortDirection );  
            helper.sortData( component, fieldName, sortDirection );  
            },
            
        updateSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortDataBy(cmp, fieldName, sortDirection);
    },
        updateContactSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortDataAt(cmp, fieldName, sortDirection);
    },
            
            
            searchKeyChange: function(component, event, helper) {
            var searchKey = component.find("PicklistId").get("v.value");
            console.log('searchKey:::::'+searchKey);
            component.set('v.mycolumns', [
            {label: 'Account Name', fieldName: 'AccountId', sortable: true,type: 'url', 
            typeAttributes: {label: { fieldName: 'AccountName' }, target: '_blank'}},
            {label: 'Opportunity Name', fieldName: 'linkName', sortable: true,type: 'url', 
            typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}},
            
            {label: 'Practice', fieldName: 'Practice__c', sortable: true,type: 'text'},
            {label: 'Stage', fieldName: 'StageName', sortable: true,type: 'text'},
            {label: 'TCV Amount', fieldName: 'Total_Contract_Value__c', sortable: true,type: 'currency', typeAttributes: { currencyCode : { fieldName: 'CurrencyIsoCode' }}},
            {label: 'Estimated Opportunity Close Date', fieldName: 'CloseDate', sortable: true,type: "date-local", typeAttributes:{month: "numeric",day: "numeric",alignment: 'right'}},
            {label: 'Opportunity Owner Name', fieldName: 'OwnerId',sortable: true, type: 'url', 
            typeAttributes: {label: { fieldName: 'oppowner' }, target: '_blank'}}
        ]);
        helper.filterbystage(component, event, helper);
    } ,
    
    navigateToAccountHierarchy: function(cmp, event, helper) {
        var acctId = cmp.get('v.recordId');
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef: "sfa:hierarchyFullView",
            componentAttributes: {
                recordId: acctId,
                sObjectName: "Account"
            }
        });
        evt.fire();
    }
})