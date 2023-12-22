@isTest
public with sharing class BarcodeCode11_Test {
   
    @isTest
    public static void testComputewithChecksumFalse() {
        BarcodeCode11 code11 = new BarcodeCode11();
        code11.sourceCodeValue = '0123456789';
        code11.checksum = true;
        code11.barcodeValueOuterList = new List<String>{};
        code11.barcodeContainerPadding = '';    
        code11.barcodeWidthInPixels = '';
        code11.barcodeHeightInPixels = '';
        code11.getBarCodeBars();
        system.assertEquals('0123456789', code11.sourceCodeValue);
    }
    
    @isTest
    public static void testComputewithChecksumTrue(){
        BarcodeCode11 code11 = new BarcodeCode11();
        code11.checksum = true;
        code11.showBarcodeValue = false;
        code11.sourceCodeValue = '3 2';
        code11.getBarCodeBars();
        system.assertEquals('3 2', code11.sourceCodeValue);
    }
    
    @isTest
    public static void testComputewithAlphabets(){
        BarcodeCode11 code11 = new BarcodeCode11();
        code11.checksum = true;
        code11.sourceCodeValue = 'Testvalue';
        code11.getBarCodeBars();
        system.assertEquals('Testvalue', code11.sourceCodeValue);
    }
    
    @isTest
    public static void testComputewithNullsourceValue(){
        BarcodeCode11 code11 = new BarcodeCode11();
        code11.sourceCodeValue = Null;
        code11.checksum = Null;
        PageReference pageRef = Page.code11;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('sourceCodeValue','3243');
        code11.getBarCodeBars();
        system.assertEquals(true, code11.checksum);
    }
    
}