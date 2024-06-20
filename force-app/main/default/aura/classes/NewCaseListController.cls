public class NewCaseListController {

    Public  list<case> getNewCases(){

        List<Case> CsList = [Select id,CaseNumber from Case where Status='new'];

        return CsList;

    }

}