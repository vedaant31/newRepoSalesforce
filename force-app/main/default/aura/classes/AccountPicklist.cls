public class AccountPicklist {
    @AuraEnabled(cacheable = true)
    public static List<String> getPickList(String objApi, String fieldApi){
        List<String> picklistvalues = new List<String>();
        
        try {
            Schema.DescribeSObjectResult objDescribe = Schema.getGlobalDescribe().get(objApi).getDescribe();
            Schema.DescribeFieldResult fieldDescribe = objDescribe.fields.getMap().get(fieldApi).getDescribe();
            
            if (fieldDescribe.getType() == Schema.DisplayType.Picklist) {
                List<Schema.PicklistEntry> picklistEntries = fieldDescribe.getPicklistValues();
                for (Schema.PicklistEntry pickListVal : picklistEntries) {
                    picklistvalues.add(pickListVal.getLabel());
                }
            } 
        } catch (Exception e) {
            picklistvalues.add('Error: ' + e.getMessage());
        }
        
        return picklistvalues;
    }
}