public class SearchContactsController {
    public String firstName { get; set; }
    public String lastName { get; set; }
    public String email { get; set; }
    public List<Contact> searchedContacts { get; set; }
    public Boolean showResults { get; set; }

    public SearchContactsController() {
        searchedContacts = new List<Contact>();
        showResults = false;
    }

    public void searchContacts() {
        String query = 'SELECT Id, FirstName, LastName, Email FROM Contact WHERE ';
        if (!String.isBlank(firstName)) {
            query += 'FirstName LIKE \'%' + firstName + '%\' AND ';
        }
        if (!String.isBlank(lastName)) {
            query += 'LastName LIKE \'%' + lastName + '%\' AND ';
        }
        if (!String.isBlank(email)) {
            query += 'Email LIKE \'%' + email + '%\' AND ';
        }
        // Remove the last 'AND' from the query
        if (query.endsWith('AND ')) {
            query = query.substring(0, query.length() - 5);
        }
        searchedContacts = Database.query(query);
        showResults = true;
    }
}