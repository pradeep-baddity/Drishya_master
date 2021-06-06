({
    sendEmail: function(component, event, helper) {
        var a = document.createElement("a"),
            contact = component.get("v.contact");
        a.href = "mailto:"+encodeURIComponent(contact.Email)+
            "?subject="+encodeURIComponent(contact.Subject)+
            "&body="+encodeURIComponent(contact.Description);
        a.click();
        $A.get("e.force:closeQuickAction").fire();
    }
})