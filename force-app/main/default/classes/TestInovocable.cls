public class TestInovocable {
    @invocablemethod
    public static void modifyContact(List<Id> conids){
        List<Contact> contactsToupdate = new List<Contact>();
        List<Contact> conList =[SELECT id ,lastname,phone,email from Contact WHERE id =:conids];
        for(Contact con :conList){
            con.LastName=con.LastName +''+con.Phone;
            contactsToupdate.add(con);
        }
        UPDATE contactsToupdate;
    }
}