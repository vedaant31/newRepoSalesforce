trigger FirstT on Account (before insert, after insert) {
    for(Account acc: trigger.new)
    {
        if(trigger.isBefore)
        {
            if(acc.Industry!=null && acc.industry=='Media'){
                
                acc.rating='Hot';
            }
            else
            {
                acc.rating='Cold';
            }
        }
        else if(trigger.isAfter)
        {
            
            list<opportunity> tobeinserted= new list<opportunity>();
   
            opportunity opp=new opportunity();
            opp.name=acc.name;
            opp.AccountId=acc.Id;
            opp.StageName='Prospecting';
            opp.CloseDate=System.today();
            tobeinserted.add(opp);
            
            if(!tobeinserted.isEmpty())
            {
                insert tobeinserted;
            }
        }
        
    }
}