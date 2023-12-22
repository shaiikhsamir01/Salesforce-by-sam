/** 
* @ClassName - Barcode11
* @Created Date - 05/06/2020
* @Created By - Mohit Agarwal
* @test - Barcode11_Test
* @Description - This class will be used to generate Code11 Barcode.
*                
*/

public with sharing class BarcodeCode11 {
    
    public String sourceCodeValue {get;set;}
    public Boolean checksum{get;set;}
    public List<String> barcodeValueOuterList {get;set;}
    public String barcodeContainerPadding {get;set;}
    public Boolean showBarcodeValue {get;set;}
    public String barcodeWidthInPixels {get;set;}
    public String barcodeHeightInPixels {get;set;}
    
    public String[] encoding = new String[] {
        '101011','1101011','1001011','1100101',
            '1011011','1101101','1001101','1010011',
            '1101001','110101','101101' 
            };
                
                public String[] getBarCodeBars() {
                    if(sourceCodeValue == null){
                        sourceCodeValue = apexpages.currentpage().getparameters().get('sourceCodeValue');
                    }
                    if(sourceCodeValue.containsWhitespace()){
                        ApexPages.addmessage(
                            new ApexPages.message(
                                ApexPages.Severity.WARNING,
                                'Can Not Generate Barcode. Input Contains Spaces.'
                            )
                        );
                        return new List<String>();
                    }
                    else{
                        system.debug('Inside Caculation');
                        Pattern numberFormat = Pattern.Compile('[0-9\\-]*');
                        Matcher numberMatch = numberFormat.matcher(sourceCodeValue);
                        if (numberMatch.Matches())
                        {
                           return getComputeBarcodeBars(sourceCodeValue).split('');
                        }
                        else {
                            ApexPages.addmessage(
                                new ApexPages.message(
                                    ApexPages.Severity.WARNING,
                                    'Enter only Numberic and '+'-'+' character'
                                )
                            );
                        }
                        return new List<String>();
                    }
                }
    
    public String getComputeBarcodeBars(String sourceValue){
        
        if(checksum == Null){
            checksum = true;
        }
        
        String result = '';
        String intercharacter = '0';
        
        result = result +'1011001'+ intercharacter;
        String[] codeDigits = sourceValue.split('');
        integer len = sourceValue.length();
        for(integer i=0; i<len; i++){
            integer index = codeDigits[i] == '-' ? 10 : Integer.valueof(''+codeDigits[i]);
            result = result+ (this.encoding[index] + intercharacter);
        }
        if(checksum){
            integer weightC    = 0;
            integer weightSumC = 0;
            integer weightK    = 1; // start at 1 because the right-most character is 'C' checksum
            integer weightSumK = 0;
            for(integer i=len-1; i>-1; i--){
                weightC = weightC == 10 ? 1 : weightC + 1;
                weightK = weightK == 10 ? 1 : weightK + 1;
                
                integer index = codeDigits[i] == '-' ? 10 : Integer.valueof(''+codeDigits[i]);
                
                weightSumC += weightC * index;
                weightSumK += weightK * index;
            }    
            integer c = math.mod(weightSumC,11);
            weightSumK += c;
            integer k = math.mod(weightSumK,11);
            
            result = result + (this.encoding[c] + intercharacter);
            
            if (len >= 10){
                result= result +(this.encoding[k] + intercharacter);
            }
        }
        
        
        result = result + '1011001';
        barcodeValueOuterList = result.split('');
        
        if(barcodeValueOuterList != Null) {
            showBarcodeValue = true;
        }
        return result;
        
    }
}