({
    /*getProducts : function(component,event,helper,mode) {
        var action = component.get("c.getOfferinggs");
        console.log("Opp RecordId"+component.get("v.recordId"));
        console.log("mode==>"+mode);
        action.setParams({
            opportunnityID : component.get("v.recordId"),
            searchKeyword :mode
        });
        action.setCallback(this,function(response){
            try{   
                var state = response.getState();
                console.log('state--'+state);
                if (state === "SUCCESS") {
                    var res = response.getReturnValue();
                    component.set("v.prodList", JSON.stringify(response.getReturnValue()));
                    console.log('prodlist--'+JSON.stringify(response.getReturnValue()));
                    /*res.forEach(function(record){
                        record.linkName = '/'+record.Id;
                        record.AccountName = record.Account.Name;
                        record.AccountId = '/' + record.AccountId;
                        record.oppowner = record.Owner.Name;
                        record.OwnerId = '/' + record.OwnerId;
                    });*/
            /*    }
            }
            catch (ex){
                console.log('Error SearchKey'+ex);
            }
        });
        $A.enqueueAction(action);
    },*/
})