public class TriggerHandler {
	/*public static void beforeinsert(List<contact> arr)
    {
        for(contact cnt:arr)
        {
            cnt.description='Test';
        }
    } */
    public static void updateDescripton(List<Account> newList, map<Id, account>oldMap)
    {
        for(Account acc : newList)
        {
            if(oldMap!=null && acc.Phone!=oldMap.get(acc.Id).phone)
            {
                acc.description=' Phone is modified on this account';
            }
        }
    }
    
    public static void updateOppDescription(List<account>newlist,map<Id,account>oldMap)
    {
        map<Id,account>mp=new map<Id,account>();
        List<opportunity>opp=new List<opportunity>();
        for(account acc:newlist)
        {
            if(oldMap!=null && acc.Phone!=oldMap.get(acc.Id).phone)
            {
                mp.put(acc.Id,acc);
            }
        }
        
        
        
    }
}