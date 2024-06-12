trigger ContactTrigger on Contact (after insert, after update, after delete, after undelete) {
     
        
        if(Trigger.isAfter)
        {
            if(Trigger.IsUpdate)
            ContactTriggerHelper.updateAccount(Trigger.new, Trigger.oldMap);
            if(Trigger.isDelete)
                ContactTriggerHelper.updateAccount(Trigger.old, null);
            if(Trigger.isInsert)
                ContactTriggerHelper.updateAccount(Trigger.new, null);
        }
       
    }