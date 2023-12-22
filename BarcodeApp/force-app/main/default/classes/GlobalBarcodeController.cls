public with sharing class GlobalBarcodeController {
    public String sourceCodeValue {get;set;}
    public Boolean checksum{get;set;}
    public List<String> barcodeValueOuterList {get;set;}
    public String barcodeContainerPadding {get;set;}
    public Boolean showBarcodeValue {get;set;}
    public String barcodeWidthInPixels {get;set;}
    public String barcodeHeightInPixels {get;set;}
    public String barcodeType {get;set;}
    
     public Type getType() {
        return GlobalBarcodeController.class;
    }
    
    public String getLocalType() {
        return 'SnowCase';
    }
    
    public String[] getBarCodeBars() {
        
        if(barcodeType == Null){
            system.debug('Error barcode format is not available');
            return new  List<String>();
        }
        
        if(barcodeType == 'Code11' || barcodeType == 'code11') {
            system.debug('barcodeType==>'+barcodeType);
            BarcodeCode11 code11 = new BarcodeCode11();
            showBarcodeValue = true;
            List<String> barcodelist = code11.getComputeBarcodeBars(sourceCodeValue).split('');
            system.debug('barcodelist==>'+barcodelist);
            return barcodelist;
        }
        
        if(barcodeType == 'Code93' || barcodeType == 'code93') {
            system.debug('barcodeType==>'+barcodeType);
            BarcodeCode93 code93 = new BarcodeCode93();
            showBarcodeValue = true;
            List<String> barcodelist = code93.getComputeBarcodeBars(sourceCodeValue).split('');
            system.debug('barcodelist==>'+barcodelist);
            return barcodelist;
        }
        
        if(barcodeType == 'Code25' || barcodeType == 'code25') {
            system.debug('barcodeType==>'+barcodeType);
            BarcodeUsingCode25 code25 = new BarcodeUsingCode25();
            showBarcodeValue = true;
            List<String> barcodelist = code25.getComputeBarcodeBars(sourceCodeValue).split('');
            system.debug('barcodelist==>'+barcodelist);
            return barcodelist;
        }
        
        if(barcodeType == 'Code128' || barcodeType == 'code128') {
            system.debug('barcodeType==>'+barcodeType);
            BarCodeUsing128Ctr code128 = new BarCodeUsing128Ctr();
            showBarcodeValue = true;
            List<String> barcodelist = BarCodeUsing128Ctr.generateCode128(sourceCodeValue).split('');
            system.debug('barcodelist==>'+barcodelist);
            return barcodelist;
        }
        
        if(barcodeType == 'Code39' || barcodeType == 'code39') {
            system.debug('barcodeType==>'+barcodeType);
            BarCodeUsing39Ctr code39 = new BarCodeUsing39Ctr();
            showBarcodeValue = true;
            List<String> barcodelist = BarCodeUsing39Ctr.generateCode39(sourceCodeValue).split('');
            system.debug('barcodelist==>'+barcodelist);
            return barcodelist;
        }
        
        if(barcodeType == 'Ean13' || barcodeType == 'EAN13') {
            system.debug('barcodeType==>'+barcodeType);
            showBarcodeValue = true;
            EAN13Encoding ean8 = new EAN13Encoding();
            ean8.sourceCodeValue = sourceCodeValue;
            List<String> barcodelist = ean8.getBarCodeBars();
            system.debug('barcodelist==>'+barcodelist);
            return barcodelist;
        }
        
        if(barcodeType == 'Ean8' || barcodeType == 'EAN8') {
            system.debug('barcodeType==>'+barcodeType);
            showBarcodeValue = true;
            EAN8Encoding ean8 = new EAN8Encoding();
            ean8.sourceCodeValue = sourceCodeValue;
            List<String> barcodelist = ean8.getBarCodeBars();
            system.debug('barcodelist==>'+barcodelist);
            return barcodelist;
        }
        return new  List<String>();
    }
}