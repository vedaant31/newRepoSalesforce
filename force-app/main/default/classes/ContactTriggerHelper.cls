public class ContactTriggerHelper {
    public Static void updateAccount(List<Contact> contList, Map<Id, Contact> oldMap)
    {       
         Set<Id> acctIdSet = new Set<Id>();
        for(Contact con: contList){
            if(con.AccountId != null || (oldMap.get(con.Id).AccountId != con.AccountId))
                acctIdSet.add(con.accountId);
            System.debug('Test1');
            if(oldMap != null && oldMap.containsKey(con.Id)){
                acctIdSet.add(oldMap.get(con.Id).AccountId);
            }
        }            
        List<Account> accList =  new List<Account>();
        
                //is map mei ek account ke related jitne contacts hai unki information hai        
                /*  Map<Id, Account> accMap = new Map<Id, Account>
        ([SELECT Id, (SELECT Id, lastName FROM Contacts) 
        from Account where Id IN: acctIdSet]);
        
        for( Id accId: accMap.keySet())
        {
        Account acc = new Account();
        List <Contact> contactList = accMap.get(accId).Contacts;
        acc.Id = accId;
        acc.NoOfContact__c = String.valueOf(contactList.size());
        accList.add(acc);
        } */     
        
        //METHOD -2 USING AGGEREGATE FUNCTIONS
        AggregateResult[] grouped_result= [SELECT AccountId AcctId, Count(id) ContactCount FROM Contact
                                   WHERE AccountId in: acctIdSet GROUP BY AccountId];
        for (AggregateResult ar :grouped_result )
        {                
             Account a = new Account();
             a.Id = (Id) ar.get('AcctId');
            system.debug('AcctId');
            system.debug('only' + ar.get('AcctId'));
            system.debug((Id) ar.get('AcctId'));
             a.NoOfContact__c = String.valueOf(ar.get('ContactCount'));
             accList.add(a);
        }  
        if(accList.size() >= 0){            
            update accList;        
        }               
    }
}