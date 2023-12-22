@IsTest

public class DynamicBarCodeCtrTest{
    
    public static testmethod void DynamicBarCodeCtrCode128(){
        
        BarCodeUsing128Ctr BarCodeUsing128= new BarCodeUsing128Ctr ();
        Account acc=new Account();
        acc.name='Testing';
        insert acc;
        system.assertNotEquals(acc.id,null);
        Map<string,string> MapValue=new Map<string,string>();
        MapValue.put('Name','Name');
        apexpages.currentpage().getparameters().put('conid',acc.id);
        DynamicBarCodeCtr DynamicBarCode=new DynamicBarCodeCtr ();
        DynamicBarCode.selectedField='Name';
        DynamicBarCode.format='Code 128';
        DynamicBarCode.generateBarcode();
        DynamicBarCode.generateBarcodepdf();
        DynamicBarCode.StoreIntoAttachment();
        DynamicBarCode.emailId='test@gmail.com';
        DynamicBarCode.SendAsAttachment();
        BarCodeUsing128.getBarCodeBars();
        DynamicBarCodeCtr.DynamicBarCodeCtrMethod(acc.id);
        DynamicBarCodeCtr.generateBarcodeLighting(true,acc.id,'Name','Code 128','Account',MapValue);
        DynamicBarCodeCtr.generateBarcodeLighting(false,acc.id,'Name','Code 128','Account',MapValue);
        
    }
    public static testmethod void DynamicBarCodeCtrCode39(){
        
        BarCodeUsing39Ctr BarCodeUsing39 = new BarCodeUsing39Ctr();
        BarCodeUsing39Ctr.sourceCodeValue='1234567';
        Account acc=new Account();
        acc.name='Testing';
        insert acc;
        system.assertNotEquals(acc.id,null);
        Map<string,string> MapValue=new Map<string,string>();
        MapValue.put('Name','Name');
        apexpages.currentpage().getparameters().put('conid',acc.id);
        DynamicBarCodeCtr DynamicBarCode=new DynamicBarCodeCtr ();
        DynamicBarCode.selectedField='Name';
        DynamicBarCode.format='Code 39';
        DynamicBarCode.generateBarcode();
        DynamicBarCode.generateBarcodepdf();
        DynamicBarCode.StoreIntoAttachment();
        DynamicBarCode.emailId='test@gmail.com';
        DynamicBarCode.SendAsAttachment();
        BarCodeUsing39.getBarCodeBars();
        DynamicBarCodeCtr.DynamicBarCodeCtrMethod(acc.id);
        DynamicBarCodeCtr.generateBarcodeLighting(true,acc.id,'Name','Code 39','Account',MapValue);
        DynamicBarCodeCtr.generateBarcodeLighting(false,acc.id,'Name','Code 39','Account',MapValue);
        
    }
    public static testmethod void DynamicBarCodeCtrCode13(){
        
        EAN13Encoding EAN13 = new EAN13Encoding();
        EAN13.sourceCodeValue='1234567';
        Account acc=new Account();
        acc.name='1234455';
        insert acc;
        system.assertNotEquals(acc.id,null);
        Map<string,string> MapValue=new Map<string,string>();
        MapValue.put('Name','Name');
        apexpages.currentpage().getparameters().put('conid',acc.id);
        DynamicBarCodeCtr DynamicBarCode=new DynamicBarCodeCtr ();
        DynamicBarCode.selectedField='Name';
        DynamicBarCode.format='EAN 13';
        DynamicBarCode.generateBarcode();
        DynamicBarCode.generateBarcodepdf();
        DynamicBarCode.StoreIntoAttachment();
        DynamicBarCode.emailId='test@gmail.com';
        DynamicBarCode.SendAsAttachment();
        EAN13.getBarCodeBars();
        DynamicBarCodeCtr.DynamicBarCodeCtrMethod(acc.id);
        DynamicBarCodeCtr.generateBarcodeLighting(true,acc.id,'Name','EAN 13','Account',MapValue);
        DynamicBarCodeCtr.generateBarcodeLighting(false,acc.id,'Name','EAN 13','Account',MapValue);
        
    }
    public static testmethod void DynamicBarCodeCtrCode8(){
        
        EAN8Encoding EAN8 = new EAN8Encoding();
        EAN8.sourceCodeValue='1234567';
        Account acc=new Account();
        acc.name='1234455';
        insert acc;
        system.assertNotEquals(acc.id,null);
        Map<string,string> MapValue=new Map<string,string>();
        MapValue.put('Name','Name');
        apexpages.currentpage().getparameters().put('conid',acc.id);
        DynamicBarCodeCtr DynamicBarCode=new DynamicBarCodeCtr ();
        DynamicBarCode.selectedField='Name';
        DynamicBarCode.format='EAN 8';
        DynamicBarCode.generateBarcode();
        DynamicBarCode.generateBarcodepdf();
        DynamicBarCode.StoreIntoAttachment();
        DynamicBarCode.emailId='test@gmail.com';
        DynamicBarCode.SendAsAttachment();
        EAN8.getBarCodeBars();
        DynamicBarCodeCtr.DynamicBarCodeCtrMethod(acc.id);
        DynamicBarCodeCtr.generateBarcodeLighting(true,acc.id,'Name','EAN 8','Account',MapValue);
        DynamicBarCodeCtr.generateBarcodeLighting(false,acc.id,'Name','EAN 8','Account',MapValue);
        
    }
    
    public static testmethod void DynamicBarCodeCtrCode93(){
        
        BarcodeCode93 code93 = new BarcodeCode93();
        code93.sourceCodeValue='1234567';
        Account acc=new Account();
        acc.name='1234455';
        insert acc;
        system.assertNotEquals(acc.id,null);
        Map<string,string> MapValue=new Map<string,string>();
        MapValue.put('Name','Name');
        apexpages.currentpage().getparameters().put('conid',acc.id);
        DynamicBarCodeCtr DynamicBarCode=new DynamicBarCodeCtr ();
        DynamicBarCode.selectedField='Name';
        DynamicBarCode.format='Code 93';
        DynamicBarCode.generateBarcode();
        DynamicBarCode.generateBarcodepdf();
        DynamicBarCode.StoreIntoAttachment();
        DynamicBarCode.emailId='test@gmail.com';
        DynamicBarCode.SendAsAttachment();
        code93.getBarCodeBars();
        DynamicBarCodeCtr.DynamicBarCodeCtrMethod(acc.id);
        DynamicBarCodeCtr.generateBarcodeLighting(true,acc.id,'Name','Code 93','Account',MapValue);
        DynamicBarCodeCtr.generateBarcodeLighting(false,acc.id,'Name','Code 93','Account',MapValue);
        
    }
    
    public static testmethod void DynamicBarCodeCtrCode11(){
        
        BarcodeCode11 code11 = new BarcodeCode11();
        code11.sourceCodeValue='1234567';
        Account acc=new Account();
        acc.name='1234455';
        insert acc;
        system.assertNotEquals(acc.id,null);
        Map<string,string> MapValue=new Map<string,string>();
        MapValue.put('Name','Name');
        apexpages.currentpage().getparameters().put('conid',acc.id);
        DynamicBarCodeCtr DynamicBarCode=new DynamicBarCodeCtr ();
        DynamicBarCode.selectedField='Name';
        DynamicBarCode.format='Code 11';
        DynamicBarCode.generateBarcode();
        DynamicBarCode.generateBarcodepdf();
        DynamicBarCode.StoreIntoAttachment();
        DynamicBarCode.emailId='test@gmail.com';
        DynamicBarCode.SendAsAttachment();
        code11.getBarCodeBars();
        DynamicBarCodeCtr.DynamicBarCodeCtrMethod(acc.id);
        DynamicBarCodeCtr.generateBarcodeLighting(true,acc.id,'Name','Code 11','Account',MapValue);
        DynamicBarCodeCtr.generateBarcodeLighting(false,acc.id,'Name','Code 11','Account',MapValue);
        
    }
    
    public static testmethod void DynamicBarCodeCtrCode25(){
        
        BarcodeUsingCode25 code25 = new BarcodeUsingCode25();
        code25.sourceCodeValue='1234567';
        Account acc=new Account();
        acc.name='1234455';
        insert acc;
        system.assertNotEquals(acc.id,null);
        Map<string,string> MapValue=new Map<string,string>();
        MapValue.put('Name','Name');
        apexpages.currentpage().getparameters().put('conid',acc.id);
        DynamicBarCodeCtr DynamicBarCode=new DynamicBarCodeCtr ();
        DynamicBarCode.selectedField='Name';
        DynamicBarCode.format='Code 93';
        DynamicBarCode.generateBarcode();
        DynamicBarCode.generateBarcodepdf();
        DynamicBarCode.StoreIntoAttachment();
        DynamicBarCode.emailId='';
        DynamicBarCode.SendAsAttachment();
        code25.getBarCodeBars();
        DynamicBarCodeCtr.DynamicBarCodeCtrMethod(acc.id);
        DynamicBarCodeCtr.generateBarcodeLighting(true,acc.id,'Name','Code 25','Account',MapValue);
        DynamicBarCodeCtr.generateBarcodeLighting(false,acc.id,'Name','Code 25','Account',MapValue);
        
    }
    
}