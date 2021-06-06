({
	 handleEvent : function(component, event, helper) {
        var name =event.getParam("Review_Result");
        console.log('name:::'+JSON.stringify(name));
        component.set("v.ParentAttribute",name); 
     }
})