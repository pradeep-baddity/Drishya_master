({
    navigateToAccountHierarchy: function(cmp, event, helper) {
        var acctId = cmp.get('v.recordId');
        var urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
      "url": 'https://huron2--offnew.lightning.force.com/p/opp/SelectSearch?addTo=0066s000003FIuS&retURL=%2F0066s000003FIuS'
    });
    urlEvent.fire();
    }
})