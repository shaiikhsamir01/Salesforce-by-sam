/**
* Created By: Mohit Agarwal
* Created Date : 12 Jan 2021
* Description : This class is used to get the record ids of the selected record of list view
* Test : LightningListViewController_test
*/
global with sharing class LightningListViewController  {
    public String recordIds;
    public List<SObject> selectedIds;
    public ApexPages.StandardSetController cntrlc;
    // Constructor
    global LightningListViewController(ApexPages.StandardSetController cntlr){
        selectedIds = cntlr.getSelected();
        recordIds = '';  
        if(selectedIds.size() != 0){
            for(SObject record: selectedIds){
                recordIds += record.get('id') + ',';
            }
            recordIds = recordIds.removeEnd(','); 
        }
        else{
            recordIds = null;
            cntrlc = cntlr;
        }
    } 
    
    global PageReference redirectToDynamicBarcode(){
        if(recordIds != Null){
            String returnUrl = '/apex/DynamicBarCode?conid='+recordIds ;
            PageReference pgReturnPage = new PageReference(returnUrl);
            pgReturnPage.setRedirect(true);
            return pgReturnPage;
        }
        else {
            ApexPages.addmessage(
                new ApexPages.message(
                    ApexPages.Severity.WARNING,
                    'NO record is seleced, Please Select Atleast One record'
                )
            );
            return null;
        }
    }
    
    global PageReference back(){
        return cntrlc.cancel();
    }
    
}