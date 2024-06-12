trigger QuoteTrigger on Quote (after insert, after update,before delete) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert ) {
            QuoteTriggerHandler.onAfterInsert(Trigger.new,Trigger.newMap ,Trigger.old, Trigger.oldMap);
        }
        else if(Trigger.isUpdate) {
            QuoteTriggerHandler.onAfterUpdate(Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);
            
        }
        
    }
    
    else if(Trigger.isBefore)
    {
        if(Trigger.isDelete)
        {
            QuoteTriggerHandler.onBeforeDelete(Trigger.old ,Trigger.oldMap);
        }
    }
    
}