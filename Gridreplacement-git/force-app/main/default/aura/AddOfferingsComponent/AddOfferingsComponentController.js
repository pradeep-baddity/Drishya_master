({
    fetchproducts : function(component, event, helper) {
        component.set("v.openModal", true);
        component.set('v.mycolumns', [
            {label: 'Product Name', fieldName: 'Name', sortable: true,type: 'text'},
            //type: 'url',typeAttributes: {label: { fieldName: 'AccountName' }, sortable: true, target: '_blank'}},
            {label: 'Practice', fieldName: 'Practice__c', sortable: true,type: 'text'},
            {label: 'Expertise', fieldName: 'Expertise__c',sortable: true, type: 'text'},
            {label: 'Service', fieldName: 'Service__c', sortable: true,type: "text"},
            {label: 'Capability', fieldName: 'Capability__c',sortable: true, type: 'text'}
        ]);
        // helper.getProducts(component, event, helper,'_empty');
        var action = component.get("c.getOfferinggs");
        console.log("Opp RecordId"+component.get("v.recordId"));
        //console.log("mode==>"+mode);
        action.setParams({
            opportunnityID : component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            try{   
                var state = response.getState();
                console.log('state--'+state);
                if (state === "SUCCESS") {
                    var res = response.getReturnValue();
                    console.log('res'+res)
                    component.set("v.prodList", res);
                    console.log('prodlist--'+JSON.stringify(response.getReturnValue()));
                    /*res.forEach(function(record){
                        record.linkName = '/'+record.Id;
                        record.AccountName = record.Account.Name;
                        record.AccountId = '/' + record.AccountId;
                        record.oppowner = record.Owner.Name;
                        record.OwnerId = '/' + record.OwnerId;
                    });*/
                }
            }
            catch (ex){
                console.log('Error SearchKey'+ex);
            }
        });
        $A.enqueueAction(action);
    },
    updateSelectedText: function (cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        cmp.set('v.selectedRowsCount', selectedRows.length);
        let obj =[];
        for(var i =0; i<selectedRows.length; i++){
            obj.push(selectedRows[i]);
            console.log('Selected rows name '+selectedRows[i].Id);
            //Here you can get all the needed fields output and print on the next page
        }
        cmp.set("v.selectedSearchableList", obj);
		console.log('obj---'+(JSON.stringify(obj)));
    },
    searchKeyChange: function(component, event) {
        var searchKey = component.get("v.searchKeyword");
        console.log('searchKey-->'+searchKey);
        component.set('v.mycolumns', [
            {label: 'Product Name', fieldName: 'Name', sortable: true,type: 'text'},
            //type: 'url',typeAttributes: {label: { fieldName: 'AccountName' }, sortable: true, target: '_blank'}},
            {label: 'Practice', fieldName: 'Practice__c', sortable: true,type: 'text'},
            {label: 'Expertise', fieldName: 'Expertise__c',sortable: true, type: 'text'},
            {label: 'Service', fieldName: 'Service__c', sortable: true,type: "text"},
            {label: 'Capability', fieldName: 'Capability__c',sortable: true, type: 'text'}
        ]);
        var action = component.get("c.searchbyProdname");
        action.setParams({
            "searchKeyword": searchKey,
            oppID : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state--'+state);
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                component.set("v.prodList", res);
                console.log('prodlist--'+res);
            }
        });
        $A.enqueueAction(action);
    },
    onNext: function(component,event,helper){  selectedrowslist
        if(component.get("v.isNext")){            
            component.set("v.isNext",false);
        }
        else{
            
            var selectedRows = event.getParam('selectedRows');
           
            console.log('lis=='+selectedRows);
            let atLeastOneSelected=false;
            let multipleRows=[];
            for(let i =0;i<selectedRows.length;i++){
                
                atLeastOneSelected=true;  
                console.log('---lis[i]---'+selectedRows[i].OpportunityId);
                var objOLIInsert = {
                    "OpportunityId": selectedRows[i].OpportunityId,
                    "PricebookEntryId": selectedRows[i].PricebookEntryId,
                    "UnitPrice": 0,
                    "Product2Id": selectedRows[i].Id 
                }
                
                console.log('---1---'+JSON.stringify(selectedRows[i]));
                selectedrowslist.push(objOLIInsert);
                
            }
            if(!atLeastOneSelected){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type": "error",
                    "message": "Please Select at least one Offering"
                });
                toastEvent.fire();
            }else{
                component.set("v.isNext",true); 
                
            }
        }
    }
})