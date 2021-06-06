({
    fetchAccHelper : function(component, event, helper) {
        var action = component.get("c.fetchOpportunities");
        action.setParams({ accid : component.get("v.recordId")
                         });
        action.setCallback(this, function(response){
            var state = response.getState();
            var res = response.getReturnValue(); 
            if (state === "SUCCESS") {
                component.set("v.acctList", response.getReturnValue());
                res.forEach(function(record){
                    record.linkName = '/'+record.Id;
                    record.AccountName = record.Account.Name;
                    record.AccountId = '/' + record.AccountId;
                    record.oppowner = record.Owner.Name;
                    record.OwnerId = '/' + record.OwnerId;
                });
                
            }
        });
        $A.enqueueAction(action);
    },
    filterbystage  : function(component, event, helper) {
        var searchKey = component.find("PicklistId").get("v.value");
        console.log('searchKey:::::'+searchKey);
        var action = component.get("c.findByName");
        action.setParams({
            "searchKey": component.get("v.Stages"),
            Accountid : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var res = response.getReturnValue();
            if (state === "SUCCESS") {
                
                res.forEach(function(record){
                    record.linkName = '/'+record.Id;
                    record.AccountName = record.Account.Name;
                    record.AccountId = '/' + record.AccountId;
                    record.oppowner =  record.Owner.Name;
                    record.OwnerId = '/' + record.OwnerId;
                    
                });
                component.set("v.acctList", response.getReturnValue());
            }
            
        });
        $A.enqueueAction(action);
    },
    sortData: function ( component, fieldName, sortDirection ) {  
        var data = component.get( "v.acctList" );  
        var reverse = sortDirection !== 'asc';  
        data.sort( this.sortBy( fieldName, reverse ) )  
        component.set( "v.acctList", data );  
    },
    
        sortDataBy: function (cmp, fieldName, sortDirection) {
        var fname = fieldName;
        var data = cmp.get("v.accList2");
        var reverse = sortDirection !== 'asc';
        data.sort(this.sortByfunc(fieldName, reverse))
        cmp.set("v.accList2", data);
        },
        
       sortDataAt: function (cmp, fieldName, sortDirection) {
        var fname = fieldName;
        var data = cmp.get("v.accList1");
        var reverse = sortDirection !== 'asc';
        data.sort(this.sortByfunc(fieldName, reverse))
        cmp.set("v.accList1", data);
        },
    
    sortByfunc: function (field, reverse,primer ) {
         var key = primer ?
            function(x) {return primer(x[field])} :
            function(x) {return x[field]};
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a)?key(a):'', b = key(b)?key(b):'', reverse * ((a > b) - (b > a));
        }
    },
    
    sortBy: function ( field, reverse, primer ) {  
        var key = primer ?  
            function( x ) { return primer( x[ field ] ) } :  
        function( x ) { return x[ field ] };  
        reverse = !reverse ? 1 : -1;  
        if(field == 'Total_Contract_Value__c'){
            console.log("inside");
            return function ( a, b ) {  
                console.log("inside return");
                
                if(reverse===1){
                     console.log("inside return1");
                    return (key(b) != null) - (key(a) != null) || key(a) - key(b);	
                }
                else{
                     console.log("inside return2");
                    return (key(a) != null) - (key(b) != null) || key(b) - key(a);
                }
            }  
        }
        else {
            return function ( a, b ) {  
                return a = key( a ), b = key( b ), reverse * ( ( a.toLowerCase()) > (b.toLowerCase()) ) - ( (b.toLowerCase()) > (a.toLowerCase() ) );  
            }  
        }      
        
    } ,
    
   
    fetchConHelper : function(component, event, helper){
        var action = component.get("c.fetchContacts");
        action.setParams({ aAccId : component.get("v.recordId")
                         });
        action.setCallback(this, function(response){
            var state = response.getState();
            var res = response.getReturnValue(); 
            if (state === "SUCCESS") {
                component.set("v.accList1", response.getReturnValue());
                console.log('=====eres'+JSON.stringify(response.getReturnValue()));
                res.forEach(function(record){
                    record.linkName = '/'+record.Id;
                    record.AccountName = record.Account.Name;
                    record.AccountId = '/' + record.AccountId;
                    
                });
                
            }
        });
        $A.enqueueAction(action);
        
        console.log('----v.accList1---'+JSON.stringify(component.get("v.accList1")));
    },
    
   
    
    fetchConnectionsHelper : function(component, event, helper){
        var action = component.get("c.fetchConnections");
        action.setParams({ aAccId : component.get("v.recordId")
                         });
        action.setCallback(this, function(response){
            var state = response.getState();
            var res = response.getReturnValue(); 
            if (state === "SUCCESS") {
                component.set("v.accList2", response.getReturnValue());
                console.log('=====eres'+JSON.stringify(response.getReturnValue()));
                res.forEach(function(record){
                    record.Name = record.Name;
                    record.ConnectionName = '/'+record.Id;
                    record.Account__c= record.Account__r.Name;
                    record.AccountId = '/'+record.Account__r.Id;
                    record.Contact__c = record.Contact__r.Name;
                    record.ContactId = '/'+record.Contact__r.Id;               
                    record.OwnerId =  record.Owner.Name;
                    
             
                });
                
            }
        });
        $A.enqueueAction(action);
        
        // console.log('----v.accList2---'+JSON.stringify(component.get("v.accList2")));
    },
    
})