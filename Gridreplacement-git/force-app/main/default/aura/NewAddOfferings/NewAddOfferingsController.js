({
    fetchproducts : function(component, event, helper) {
        component.set("v.openModal", true);
        component.set('v.mycolumns', [
            {label: 'Product Name', fieldName: 'ApexProductName__c', sortable: true,type: 'text'},
            //type: 'url',typeAttributes: {label: { fieldName: 'AccountName' }, sortable: true, target: '_blank'}},
            {label: 'Practice', fieldName: 'Practice__c', sortable: true,type: 'text'},
            {label: 'Expertise', fieldName: 'Expertise__c',sortable: true, type: 'text'},
            {label: 'Service', fieldName: 'Service__c', sortable: true,type: "text"},
            {label: 'Capability', fieldName: 'Capability_new__c',sortable: true, type: 'text'}
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
                    //console.log('res'+res)
                    component.set("v.prodList", res);
                    console.log('prodlist--'+JSON.stringify(response.getReturnValue()));
                    //res.forEach(function(record){
                    // record.name = '/'+record.Id;
                    //record.prodname = record.ApexProductName__c;
                    //record.AccountId = '/' + record.AccountId;
                    //record.oppowner = record.Owner.Name;
                    // record.OwnerId = '/' + record.OwnerId;
                    //});
                }
            }
            catch (ex){
                console.log('Error SearchKey'+ex);
            }
        });
        $A.enqueueAction(action);
    },
    /*updateSelectedText: function (cmp, event) {
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
    },*/
    searchKeyChange: function(component, event) {
        var searchKey = component.get("v.searchKeyword");
        console.log('searchKey-->'+searchKey);
        component.set('v.mycolumns', [
            {label: 'Product Name', fieldName: 'ApexProductName__c', sortable: true,type: 'text'},
            //type: 'url',typeAttributes: {label: { fieldName: 'AccountName' }, sortable: true, target: '_blank'}},
            {label: 'Practice', fieldName: 'Practice__c', sortable: true,type: 'text'},
            {label: 'Expertise', fieldName: 'Expertise__c',sortable: true, type: 'text'},
            {label: 'Service', fieldName: 'Service__c', sortable: true,type: "text"},
            {label: 'Capability', fieldName: 'Capability_new__c',sortable: true, type: 'text'}
        ]);
        var action = component.get("c.searchbyProdname");
        action.setParams({
            "searchKeyword": searchKey,
            oppID : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            //console.log('state--'+state);
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                component.set("v.prodList", res);
                //console.log('prodlist--'+res);
            }
        });
        $A.enqueueAction(action);
    },
    
    handleComponentEvent: function(cmp, event){
        var selectedrowslist = event.getParam("selectedrowslist");
        var isNext = event.getParam("isNext");
        cmp.set("v.selectedSearchableList", selectedrowslist);
        cmp.set("v.isNext", isNext);
        console.log("selectedrowslist ===>", selectedrowslist);
    },
    
    savelineitems: function(cmp,event,helper){
        console.log("save called");        
        let listOfProds=cmp.get("v.selectedSearchableList");
        console.log('listOfProds-->'+JSON.stringify(listOfProds));
        var listRawSelected = [];
        for (var i = 0; i < listOfProds.length; i++){
            
            let singleProd={};  
            singleProd=listOfProds[i];
            
            console.log('singleProd-->'+JSON.stringify(singleProd));
            listRawSelected.push(singleProd);
            
            console.log('---listRawSelected----'+listRawSelected	);
        }
        console.log('listRawSelected-->'+JSON.stringify(listRawSelected));
        cmp.set("v.toSaveproductList",listRawSelected);
        helper.saveoli(cmp,event,helper);
    },
    onPrevious: function(cmp,event,helper){
        console.log("Previous called");   
        cmp.set("v.isNext", true);
    },
    cancelClick :function(cmp,event,helper){
        var eUrl= $A.get("e.force:navigateToURL");
        eUrl.setParams({
            
            "url": '/lightning/r/Opportunity/'+cmp.get("v.recordId")+'/view' 
        });
        eUrl.fire();
    }
})