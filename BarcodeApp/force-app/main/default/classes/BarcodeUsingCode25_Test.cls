@isTest
public with sharing class BarcodeUsingCode25_Test {
    
    @isTest
    public static void testComputewithChecksum() {
        BarcodeUsingCode25 code25 = new BarcodeUsingCode25();
        code25.checksum='true';
        code25.sourceCodeValue = '1234';
        code25.barcodeValueOuterList = new List<String>{};
        code25.barcodeContainerPadding = '';    
        code25.barcodeWidthInPixels = '';
        code25.barcodeHeightInPixels = '';
        code25.getBarCodeBars();
        system.assertEquals('true', code25.checksum);
    }
    
    @isTest
    public static void testComputewithvalueContainswhiteSpace(){
        BarcodeUsingCode25 code25 = new BarcodeUsingCode25();
        code25.sourceCodeValue = '3 2';
        code25.getBarCodeBars();
        system.assertEquals('3 2', code25.sourceCodeValue);
    }
    
    @isTest
    public static void testComputewithChecksumFalse(){
        BarcodeUsingCode25 code25 = new BarcodeUsingCode25();
        code25.checksum='false';
        code25.sourceCodeValue = '32';
        code25.getBarCodeBars();
        system.assertEquals('32', code25.sourceCodeValue);
    }
    
    @isTest
    public static void testComputewithAlphabets(){
        BarcodeUsingCode25 code25 = new BarcodeUsingCode25();
        code25.sourceCodeValue = 'Testvalue';
        code25.getBarCodeBars();
        system.assertEquals('Testvalue', code25.sourceCodeValue);
    }
    
    @isTest
    public static void testComputewithchecksumNull(){
        BarcodeUsingCode25 code25 = new BarcodeUsingCode25();
        code25.checksum = Null;
        code25.sourceCodeValue = '23423';
        code25.getBarCodeBars();
        system.assertEquals('23423', code25.sourceCodeValue);
    }
    
    @isTest
    public static void testComputewithSourceValueNull(){
        BarcodeUsingCode25 code25 = new BarcodeUsingCode25();
        code25.sourceCodeValue = Null;
        PageReference pageRef = Page.code25;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('sourceCodeValue','3243');
        code25.getBarCodeBars();
        system.assertEquals('3243', code25.sourceCodeValue);
    }
}