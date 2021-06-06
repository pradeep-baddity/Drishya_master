({
    getTableColumns: function(component){
        component.set('v.mycolumns', [
            {label: 'Product Name', fieldName: 'ApexProductName__c', sortable: true,type: 'text'},
            //type: 'url',typeAttributes: {label: { fieldName: 'AccountName' }, sortable: true, target: '_blank'}},
            {label: 'Practice', fieldName: 'Practice__c', sortable: true,type: 'text'},
            {label: 'Expertise', fieldName: 'Expertise__c',sortable: true, type: 'text'},
            {label: 'Service', fieldName: 'Service__c', sortable: true,type: "text"},
            {label: 'Capability', fieldName: 'Capability_new__c',sortable: true, type: 'text'}
        ]);  
    },
    updateSelectedText: function (cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        cmp.set('v.selectedRowsCount', selectedRows.length);
        var count = cmp.get("v.selectedRowsCount");
        console.log('count-->'+count);
        var setRows = [];
        for(var i = 0; i < selectedRows.length; i++){
            setRows.push(selectedRows[i]);
        }
        cmp.set("v.oppLineItemList", setRows);
        if (count > 0)
        {
            cmp.set ("v.enableNext", false);
        }
        else {
            cmp.set ("v.enableNext", true);
        }
    },
    onNext: function(cmp, event){
        var cmpEvent = cmp.getEvent("selectProv");
        cmpEvent.setParams({
            selectedrowslist : cmp.get("v.oppLineItemList"),
            isNext : false 
        });
        cmpEvent.fire();
    },
    cancelClick : function (cmp,event){
        console.log('Cancel called')
        var eUrl= $A.get("e.force:navigateToURL");
        eUrl.setParams({
            
            "url": '/lightning/r/Opportunity/'+cmp.get("v.OppId")+'/view' 
        });
        eUrl.fire();
    }
})