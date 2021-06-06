({
    init : function(component, event, helper) {
        component.set("v.cssStyle", "<style> .slds-modal__container { margin: 0 auto; width: 90%; max-width: 70rem; min-width: 20rem;}</style>");
        component.set("v.cssStyleForheight", "<style> height: auto; max-height: none;</style>");
        helper.getProducts(component, event, helper,'_empty');  
    },
    
    cancelClick :function(component, event, helper) {
            
        var eUrl= $A.get("e.force:navigateToURL");
        eUrl.setParams({
            "url": '/lightning/r/Opportunity/'+component.get("v.recordId")+'/view' 
        });
        eUrl.fire();
    },
  
    searchKeyChange: function(component, event, helper){
        if(component.get("v.serverCall") == false){
            let searchKeyword=component.get("v.searchKeyword");
            if(searchKeyword  && searchKeyword.length >= 3){
                component.set("v.serverCall", true);
                helper.getProducts(component, event, helper,searchKeyword);
            } else{
                component.set("v.serverCall", true);
                helper.getProducts(component, event, helper,'_empty');  
            }
        }
    },
    savingOpportunityLineItem: function(component,event,helper){
        console.log("save called");
        component.set("v.saveButtonDisable",true);
        component.set("v.isLoading",true);
        let listOfProds=component.get("v.multipleRows");
        console.log('---listOfProds--'+JSON.stringify(listOfProds));
        //cmp.set("v.OLIList", null);
        var listRawSelected = [];
        for (var i = 0; i < listOfProds.length; i++){
            if(listOfProds[i].isSelected){
                let singleProd={};  
                singleProd=listOfProds[i];
                singleProd.quantity=1;
                //singleProd.isSelected=null; 
                //singleProd.quantity=null;
                console.log('singleProd-->'+JSON.stringify(singleProd));
                listRawSelected.push(singleProd);
            }
            console.log('---listRawSelected----'+JSON.stringify(listRawSelected));
        }
        console.log('listRawSelected-->'+JSON.stringify(listRawSelected));
        component.set("v.toSaveproductList",listRawSelected);
        
        helper.saveOli(component,event,helper);
        //$A.get('e.force:refreshView').fire(); 
        
        /****** added by Arif********/
     /*  alert('1 fired');
        var eUrl= $A.get("e.force:navigateToURL");
        eUrl.setParams({
            "url": '/lightning/r/Opportunity/'+component.get("v.recordId")+'/view' 
        });
        eUrl.fire();*/
       // $A.get('e.force:refreshView').fire(); 
        /***********************************/ 
    },
    onNext: function(component,event,helper){
        if(component.get("v.isNext")){            
            component.set("v.isNext",false);
        }else{
            //let rawQuanity=component.get("v.quanitity");
            let lis=component.get("v.productList");
            let atLeastOneSelected=false;
            let multipleRows=[];
            //checking if list has at least one selected product
            for(let i =0;i<lis.length;i++){
                if(lis[i].isSelected){
                    atLeastOneSelected=true;  
                    for(let j=0;j<lis[i].quantity;j++){
                        console.log('---lis[i]---'+lis[i].OpportunityId);
                        var objOLIInsert = {
                                    "OpportunityId": lis[i].OpportunityId,
                                    "PricebookEntryId": lis[i].PricebookEntryId,
                                    "UnitPrice": 0,
                                    "Service_Line_or_Product__c": "",
                                    "Offering__c": lis[i].Offering__c,
                                    "ApexProductName__c": lis[i].ApexProductName__c,
                                    "isSelected": lis[i].isSelected,
                                    "quantity": lis[i].quantity
                                  }
 
                        console.log('---1---'+JSON.stringify(lis[i]));
                        multipleRows.push(objOLIInsert);
                    }
                }
            }
            console.log('multipleRows-->'+JSON.stringify(multipleRows));
            component.set("v.multipleRows",multipleRows);
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