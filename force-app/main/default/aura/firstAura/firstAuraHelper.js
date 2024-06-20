({
    getData : function(component, event, helper) {
    var action = component.get("c.getAllObject");
    action.setCallback(this, function(response) {
    var state = response.getState();
    if (state === "SUCCESS" || state === "DRAFT") {
    var result = response.getReturnValue();
    var listofObjects = [];
    for(var key in result){
    listofObjects.push({key: key, value: result[key]});
    }
    component.set("v.allObject", listofObjects);
    }else if (status === "INCOMPLETE") {
    console.log("No response from server or client is offline.");
    }else if (status === "ERROR") {
    if (errors) {
    if (errors[0] && errors[0].message) {
    console.log("Error message: " + errors[0].message);
    }
    } else {
    console.log("Unknown error");
    }
    }
    });
    $A.enqueueAction(action);
    },
    getAllFields : function(component, event, helper){
    var action = component.get("c.getAllfields");
    action.setParams({
    objectName : component.get('v.selectedObject'),
    })
    action.setCallback(this, function(response) {
    var state = response.getState();
    if (state === "SUCCESS" || state === "DRAFT") {
    var result = response.getReturnValue();
    component.set("v.allField", result);
    }else if (status === "INCOMPLETE") {
    console.log("No response from server or client is offline.");
    }else if (status === "ERROR") {
    if (errors) {
    if (errors[0] && errors[0].message) {
    console.log("Error message: " + errors[0].message);
    }
    } else {
    console.log("Unknown error");
    }
    }
    });
    $A.enqueueAction(action);
    }

    
    })