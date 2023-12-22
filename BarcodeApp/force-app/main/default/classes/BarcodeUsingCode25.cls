/** 
* @ClassName - BarcodeUsingCode25
* @Created Date - 08/06/2020
* @Created By - Mohit Agarwal
* @test - BarcodeUsingCode25_Test
* @Description - This call will be used to generate Code25 Barcode.
*                This class is used to generate Interleaved form of Code25 Barcode
*/       
public with sharing class BarcodeUsingCode25 {
    
    public String sourceCodeValue {get;set;}
    public String checksum{get;set;}
    public boolean crc;
    public List<String> barcodeValueOuterList {get;set;}
    public String barcodeContainerPadding {get;set;}
    public static Boolean showBarcodeValue {get;set;}
    public String barcodeWidthInPixels {get;set;}
    public String barcodeHeightInPixels {get;set;}
    
    public List<String> encoding = new List<String>{
        'NNWWN','WNNNW', 'NWNNW', 'WWNNN', 'NNWNW',
            'WNWNN', 'NWWNN', 'NNNWW', 'WNNWN', 'NWNWN'
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
                        if (sourceCodeValue.isNumeric())
                        {
                            return getComputeBarcodeBars(sourceCodeValue).split('');
                        }
                        else {
                            ApexPages.addmessage(
                                new ApexPages.message(
                                    ApexPages.Severity.WARNING,
                                    'Enter only Numberic characters'
                                )
                            );
                        }
                        return new List<String>();
                    }
                }
    
    // CRC is used for checksum. 
    //If user want to add checksum in the code then he/she will make checksum True otherwise false
    public String getComputeBarcodeBars(String sourceValue) {
        //sourceCodeValue = code;
        String result = '';
        if(String.isBlank(checksum)) {
            checksum = 'false';
        }
        crc = Boolean.valueof(checksum);
        // Checking Checksum is True of False
        if(!crc) {
            if(math.mod(sourceValue.length(),2)==1) {//if length of sourceValue is ODD
                sourceValue = '0' + sourceValue;
            }
        }
        else {
            if(math.mod(sourceValue.length(),2)==0) {
                sourceValue = '0'+sourceValue;
            }
            
            // The Logic below is used to calculate the checkum that will be append at the end of code.
            Boolean odd = True;
            integer sum = 0;
            String[] codeDigits = sourceValue.split('');
            for(integer i=sourceValue.length()-1; i>-1; i--) {
                integer v = Integer.valueof(codeDigits[i]);
                sum += (odd ? 3 * v : v);
                odd = ! odd;
            } 
            
            sourceValue += ''+ (math.mod((10 - math.mod(sum,10)),10));  
            
        }
        
        // must be append at the Start of barcode
        result = result + '1010';
        
        // the logic below is to convert the code into binary form.
        // Then that binary form will be used to create the barcode.
        integer codeLength = sourceValue.length() / 2;
        String[] codeDigits = sourceValue.split('');
        for(integer i=0;i<codeLength;i++) {
            
            integer c1 = Integer.valueof(''+codeDigits[2*i]);
            integer c2 = Integer.valueof(''+codeDigits[2*i+1]);
            
            for(integer j=0; j<5; j++){
                
                result += '1';
                if (this.encoding[c1].split('')[j] == 'W') {
                    result += '1';
                }
                result = result + '0';
                if (this.encoding[c2].split('')[j] == 'W'){
                    result += '0';
                }
            }
        }
        // must be append at the End of barcode
        result += '1101';
        if(result != null){
            showBarcodeValue = true;
        }
        return result;
    }  
    
}