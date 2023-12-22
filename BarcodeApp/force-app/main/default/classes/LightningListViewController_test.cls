@isTest
public class LightningListViewController_test {

    public testmethod static void test1(){
        List<Account> accountset = new List<Account>();
        Account obj = new Account(Name ='Test');
        insert obj;
        
        accountset.add(obj);
        
        PageReference pageRef = Page.BarcodeLightningListView;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('id', String.valueOf(obj.Id));
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(accountset);
        Test.startTest();
        LightningListViewController listview = new LightningListViewController(sc);
        listview.recordIds = obj.id;
        listview.redirectToDynamicBarcode();
        listview.back();
        Test.stopTest();
        system.assertEquals(obj.Id, listview.recordIds);
    }
    
    public testmethod static void test2(){
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(new list<Account>());
        Test.startTest();
        LightningListViewController listview = new LightningListViewController(sc);
        listview.recordIds = null;
        listview.redirectToDynamicBarcode();
        listview.back();
        
        Test.stopTest();
        system.assertEquals(null, listview.recordIds);
    }
}