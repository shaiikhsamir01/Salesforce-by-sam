@isTest
public with sharing class BarcodeCode93_Test {
   
    @isTest
    public static void testComputewithChecksumFalse() {
        BarcodeCode93 code93 = new BarcodeCode93();
        code93.checksum=False;
        code93.sourceCodeValue = '123';
        code93.barcodeValueOuterList = new List<String>{};
        code93.barcodeContainerPadding = '';    
        code93.barcodeWidthInPixels = '';
        code93.barcodeHeightInPixels = '';
        //code93.getComputeBarcodeBars('234234');
        code93.getBarCodeBars();
        system.assertEquals('123', code93.sourceCodeValue);
    }
    
    @isTest
    public static void testComputewithChecksumTrue(){
        BarcodeCode93 code93 = new BarcodeCode93();
        code93.checksum=true;
        code93.showBarcodeValue = false;
        code93.sourceCodeValue = '3( )2';
        code93.getBarCodeBars();
        system.assertEquals('3( )2', code93.sourceCodeValue);
    }
    
    @isTest
    public static void testComputewithAlphabets(){
        BarcodeCode93 code93 = new BarcodeCode93();
        code93.sourceCodeValue = 'Testv alue';
        code93.getBarCodeBars();
        system.assertEquals('TESTV ALUE', code93.sourceCodeValue);
    }
    
    @isTest
    public static void testComputewithSourceValueNull(){
        BarcodeCode93 code93 = new BarcodeCode93();
        code93.sourceCodeValue = Null;
        PageReference pageRef = Page.Code93;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('sourceCodeValue','3243');
        code93.getBarCodeBars();
        system.assertEquals('3243', code93.sourceCodeValue);
    }
}