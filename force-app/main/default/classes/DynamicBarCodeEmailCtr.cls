public with sharing class DynamicBarCodeEmailCtr {

    public List<String> barcodeValue {get;set;}
    public List<List<String>> barcodeValueOuterList {get;set;}
    public String format{get;set;}
    public String SourceCode{get;set;}
    
    public void barcodeList() {
        format = apexpages.currentpage().getparameters().get('format');
        String SourceCode = apexpages.currentpage().getparameters().get('sourceCodeValue');
        barcodeValue = SourceCode.split('~');
    }
}