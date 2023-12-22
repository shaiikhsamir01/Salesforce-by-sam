public with sharing class BarcodeCode93 {
    
    String table = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-._$/+%';
    public String sourceCodeValue {get;set;}
    public Boolean checksum{get;set;}
    public List<String> barcodeValueOuterList {get;set;}
    public String barcodeContainerPadding {get;set;}
    public Boolean showBarcodeValue {get;set;}
    public String barcodeWidthInPixels {get;set;}
    public String barcodeHeightInPixels {get;set;}
    
    public List<String> encoding = new List<String>{
        '100010100', '101001000', '101000100', '101000010',
            '100101000', '100100100', '100100010', '101010000',
            '100010010', '100001010', '110101000', '110100100',
            '110100010', '110010100', '110010010', '110001010',
            '101101000', '101100100', '101100010', '100110100',
            '100011010', '101011000', '101001100', '101000110',
            '100101100', '100010110', '110110100', '110110010',
            '110101100', '110100110', '110010110', '110011010',
            '101101100', '101100110', '100110110', '100111010',
            '100101110', '111010100', '111010010', '111001010',
            '101101110', '101110110', '110101110', '100100110',
            '111011010', '111010110', '100110010', '101011110'};
                
                public String[] getBarCodeBars() {
                    if(sourceCodeValue == null){
                        sourceCodeValue = apexpages.currentpage().getparameters().get('sourceCodeValue');
                    }
                    sourceCodeValue = sourceCodeValue.toUpperCase();
                    Pattern numberFormat = Pattern.Compile('[0-9A-Z\\-\\. \\$/\\+%]*');
                    Matcher numberMatch = numberFormat.matcher(sourceCodeValue);
                    if (numberMatch.Matches())
                    {
                        return getComputeBarcodeBars(sourceCodeValue).split('');
                    }
                    else {
                        ApexPages.addmessage(
                            new ApexPages.message(
                                ApexPages.Severity.WARNING,
                                'Input Format is not compatible with Code93 format'
                            )
                        );
                    } 
                    return new List<String>();
                }
    
    public String getComputeBarcodeBars(String sourceValue) { 
        
        if(checksum == Null){
            checksum = true;
        }
        
        String result = '';
        
        // start : *
        result = result + this.encoding[47];
        
        integer len = sourceValue.length();
        integer index = 0;
        String[] codeDigits = sourceValue.split('');
        for(String sourceChar : codeDigits) {
            if(sourceChar == ' ') {
                index = table.indexOf('_');
                result = result + this.encoding[index];
            }
            if((index = table.indexOf(sourceChar)) > -1 ){
                result = result + this.encoding[index];
            }
            
        }
        // checksum
        if (checksum){
            integer weightC    = 0;
            integer weightSumC = 0;
            integer weightK    = 1; // start at 1 because the right-most character is 'C' checksum
            integer weightSumK = 0;
            for(integer i=len-1; i>-1; i--){
                weightC = weightC == 20 ? 1 : weightC + 1;
                weightK = weightK == 15 ? 1 : weightK + 1;
                
                if(codeDigits[i] == ' ') {
                    index = table.indexOf('_');
                }
                else{
                    index = table.indexOf(codeDigits[i]);
                }
                weightSumC += weightC * index;
                weightSumK += weightK * index;
            }
            integer c = math.mod(weightSumC, 47);
            weightSumK += c;
            integer k = math.mod(weightSumK, 47);
            system.debug('c==>'+c);
            system.debug('k==>'+k);
            result = result + this.encoding[c];
            result = result + this.encoding[k];
        }
        
        // stop : *
        result = result + this.encoding[47];
        
        // Terminaison bar
        result = result + '1';
        if(result != Null){
            showBarcodeValue = true;
        }
        
        return result;
    }
}