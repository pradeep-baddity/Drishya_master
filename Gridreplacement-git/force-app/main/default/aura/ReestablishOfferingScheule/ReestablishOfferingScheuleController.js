({
    doInit : function(component,event,helper) {
        
        
    },
    
    refreshHandler: function(component,event,helper) {
        console.log('refreshview event fired.');
        helper.helperdoInit(component, 'refreshHandler');
    },
    
    
    clicksubmit : function(component,event,helper){
        console.log('saved.');
        component.set('v.IsLoading',true);
        helper.ScheduleRecreation(component,event,helper);
        helper.helperdoInit(component, 'refreshHandler');
    },
   
    cancelClick : function(component,event,helper){
        helper.updateOpty(component,event,helper );
        component.set('v.IsLoading',true);
        

    }
    
    
    
    
    
})