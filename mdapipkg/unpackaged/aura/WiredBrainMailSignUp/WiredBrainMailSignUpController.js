({
    submit : function(component, event, helper) {
        var signup = component.get("c.submitAction");

        signup.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                alert(response.getReturnValue());
            }
            else
            {
                console.log("Unknown error");
            }
        });

        $A.enqueueAction(signup);
    },

    unsub : function(component, event, helper) {
        var unsubscribe = component.get("c.unsubscribe");

        unsubscribe.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                alert(response.getReturnValue());
            }
            else 
            {
                console.log("Unknown error");
            }
        });

        $A.enqueueAction(unsubscribe);
    }
})