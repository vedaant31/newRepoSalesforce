({
    init : function(component, event, helper) {
    helper.getData(component, event, helper);
    },
    handleChange : function(component, event, helper){
    helper.getAllFields(component, event, helper);
    
    },
    saveSelectedFields : function(component, event, helper) {
        var selectedFields = component.get("v.selectedField");
        var objName=component.get('v.selectedObject');
        console.log('heyy,',component.get('v.selectedObject'));


        var payload = {
            selectedFields: selectedFields,
            objName:objName
        };
        console.log('payy',JSON.stringify(payload));
        component.find("sampleMessageChannel").publish(payload);
        console.log('done');
       
       
    },
    wa:function(component,event,helper)
    {
        component.set("v.showButton", true);
    }
    })