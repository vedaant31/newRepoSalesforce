trigger AccountTrigger on Account (before insert, after insert ,before update, after update) {
    
    if(trigger.isUpdate)
    {
        
        if(trigger.isBefore)
        {       
            TriggerHandler.updateDescripton(trigger.New, trigger.oldMap);
        }
        else if(trigger.isAfter)
        {
            TriggerHandler.updateOppDescription(trigger.New, trigger.oldMap);
        }
        
    }
}