/**
* @author - Nitin Aggarwal (Removed un-used resources, fixed indentation, fixed formatting)
* @modifiedDate - 20 May 2019
* @description This class will be used to Generate Barcode Using Ean 13
* *************************************************************
* Version History
* *************************************************************
* @developer -
* @description - 
*/
public class EAN13Encoding {
    public static List<String> result {get;set;}
    public static List<String> resultString {get;set;}
    public String barcodeContainerPadding {get;set;}
    public String sourceCodeValue { get; set; }
    static String[] decidePriority = new String[] { 
        '000000', '001011', '001101', '001110', 
            '010011', '011001', '011100', '010101', 
            '010110', '011010' 
            };
                static String[] aOddLeft = new String[] {
                    '0001101', '0011001', '0010011', '0111101', 
                        '0100011', '0110001', '0101111', '0111011', 
                        '0110111', '0001011' 
                        };
                            static String[] aEvenLeft = new String[] {  
                                '0100111', '0110011', '0011011', '0100001', 
                                    '0011101', '0111001', '0000101', '0010001', 
                                    '0001001', '0010111' 
                                    };
                                        static String[] aRight = new String[] {
                                            '1110010', '1100110', '1101100', '1000010', 
                                                '1011100', '1001110', '1010000', '1000100', 
                                                '1001000', '1110100' 
                                                };
                                                    
                                                    public String[] getBarCodeBars() {
                                                        if(sourceCodeValue == null){
                                                            sourceCodeValue = apexpages.currentpage().getparameters().get('sourceCodeValue');
                                                        }
                                                        if(sourceCodeValue !=null && sourceCodeValue.length() <=13 && sourceCodeValue.isNumeric()){
                                                            Integer addDigit=12-sourceCodeValue.length();
                                                            for(Integer i=1; i <= addDigit; i++){
                                                                sourceCodeValue = '0' + sourceCodeValue;
                                                            }
                                                        }
                                                        return ean13EncodingMethod(sourceCodeValue).split('');
                                                    }
    
    public static String ean13EncodingMethod(String encodingNumber){    
        boolean ischeckSumEqual = true;
        result = new List<String>();
        if(encodingNumber.isNumeric() ){
            
            Integer iCheckSum = encodingNumber.length() == 13 ? checksumDigit(encodingNumber.length() - 1,encodingNumber) :checksumDigit(encodingNumber.length(),encodingNumber);
            if(encodingNumber.length() == 13 && (Integer.valueOf(encodingNumber.subString(12,13))) != iCheckSum){
                ischeckSumEqual = false;
            }
            if(ischeckSumEqual == true){
                result.add('101');
                encodingNumber += String.valueof(iCheckSum);
                Integer i=1;
                String priorityDecide = decidePriority[Integer.valueof(encodingNumber.subString(0,1))];
                for(String sourceChar: encodingNumber.subString(1,7).split('')) {
                    if(Integer.valueof(priorityDecide.subString(i-1,i))==0){
                        result.add(aOddLeft[Integer.valueof(sourceChar)]);
                    }
                    else{
                        result.add(aEvenLeft[Integer.valueof(sourceChar)]);
                    }
                    i++;
                }
                result.add('01010');
                for(String sourceChar: encodingNumber.subString(7,encodingNumber.length()).split('')) {
                    result.add(aRight[Integer.valueof(sourceChar)]);
                }
                result.add('101');
                resultString=String.join(result,'').split('');
                return String.join(result,'');
            }
            else{
                ApexPages.addmessage(
                    new ApexPages.message(
                        ApexPages.Severity.WARNING,
                        'Wrong checksum digit(13th digit). Correct checksum digit is ='+iCheckSum+'.'+
                        'Please try with correct checksum digit or try with 12 digit input.'
                    )
                );
            }
        }
        
        else {
            ApexPages.addmessage(
                new ApexPages.message(
                    ApexPages.Severity.WARNING,
                    'Enter only Numberic characters'
                )
            );
        }
        return '';
    }
    
    public static Integer checksumDigit(Integer sourceLength,String SourceCodeValue){
        Integer iDigit = 0;
        Integer iSum = 0;
        for( Integer i = sourceLength; i >= 1; i-- )
        {
            iDigit = Integer.valueof(SourceCodeValue.subString( i - 1, i) );
            if(Math.mod(i,2) == 0 ){   // odd
                iSum += iDigit * 3;
            }
            else{   // even
                iSum += iDigit * 1;
            }
        }
        return Math.mod((10 - (Math.mod(iSum ,10))),10);
    }
}