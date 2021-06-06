({
    fetchOpportunityLineItems: function (component, event, helper){
        
        var action = component.get("c.fetchopportunitylineitem");
        action.setParams({ lineitemId : component.get("v.recordId") });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === 'SUCCESS') {
                var records = response.getReturnValue();
                records.forEach(function(record){
                  record.Product2Id = '/'+record.Product2Id;
                  record.ProductName = record.Product2.Name;
                 // record.AccountId = '/' + record.AccountId;
                  //record.oppowner =  record.Owner.Name;
                 // record.OwnerId = '/' + record.OwnerId;
                         
               	});
                    component.set("v.oppLineItemList",records);
                }
              //  $A.get('e.force:refreshView').fire();
            
            if(state == 'ERROR'){
                var toast = $A.get("e.force:showToast");
                if(toast){
                    toast.setParams({
                        "title": "Error",
                        "message": response.getError()[0].message
                    });
                }
                toast.fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    defaultschedulevalues : function (component, event){
    	var action = component.get("c.getscheduleinformation");
    	action.setParams({ lineitemId : component.get("v.selectedRowid") });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === 'SUCCESS') {
                var rows = response.getReturnValue();
                if(rows != null){
                    component.set("v.ScheduleDate",rows.ScheduleDate);
                    component.set("v.Revenue",rows.Revenue);
                    component.set("v.Quantity",rows.Quantity);
                    component.set("v.Offering",rows.Offering__c);
                }
            }
            if(state == 'ERROR'){
                var toast = $A.get("e.force:showToast");
                if(toast){
                    toast.setParams({
                        "title": "Error",
                        "message": response.getError()[0].message
                    });
                }
                toast.fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    sortData: function (component, fieldName, sortDirection) {
     var data = component.get("v.oppLineItemList");
     var reverse = sortDirection !== 'asc';
     //sorts the rows based on the column header that's clicked
     data.sort(this.sortBy(fieldName, reverse))
     component.set("v.oppLineItemList", data);
     component.set("v.sortedBy", fieldName);
     component.set("v.sortedDirection", sortDirection);
     },
 	
    sortBy: function (field, reverse, primer) {
        var key = primer ? function(x) {return primer(x[field])} : function(x) {return x[field]};
        //checks if the two rows should switch places
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    }
})