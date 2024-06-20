public class testPoc {

    public List<Opportunity> temp { get; set; }

    public testPoc() {
        temp = new List<Opportunity>();
        
        temp = [SELECT Name, Id FROM Opportunity WHERE TestPoc__c != null];
    }
}