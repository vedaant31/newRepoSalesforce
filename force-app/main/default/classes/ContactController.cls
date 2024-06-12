public  with sharing class ContactController {
    
  @AuraEnabled(cacheable=true)
    public static List<Contact>getContacts(){
        //return [select Id, FirstName ,LastName, Email from Contact ];
        throw new AuraHandledException('Forced error');

    }
        }