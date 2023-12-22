@isTest
public class TestDataFactory {
	public static void insertAccounts(Integer numberOfAccounts, boolean performInsertion){
       	List<Account> accList = new List<Account>();
        for(Integer i=0;i<numberOfAccounts; i++){
            accList.add(new Account(name = 'Test Account '+i, numberOfEmployees = i+100, description = 'sample description'));
        }
        if(numberOfAccounts>0 && performInsertion){
            insert accList;
        }
    }
}