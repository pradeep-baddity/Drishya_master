({
    
    showMsg:function(component,msg) {
        component.set("v.errorMsgAll",msg)
    },
    hideMsg:function(component) {
        component.set("v.errorMsgAll",'');
    },
})