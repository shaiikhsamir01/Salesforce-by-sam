/**
* @author - Nitin Aggarwal (Removed un-used resources, fixed indentation, fixed formatting)
* @modifiedDate - 20 May 2019
* @description This class will be used to Generate Barcode Using Code Ean 8
* *************************************************************
* Version History
* *************************************************************
* @developer -
* @description - 
*/
public class EAN8Encoding {
    public static List<String> result {get;set;}
    public static List<String> resultString {get;set;}
    public String barcodeContainerPadding {get;set;}
    public String sourceCodeValue {get; set;}
    static String[] aOddLeft = new String[] { 
        '0001101', '0011001', '0010011', '0111101', 
            '0100011', '0110001', '0101111', '0111011', 
            '0110111', '0001011' 
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
                                if(sourceCodeValue !=null && sourceCodeValue.length() <=7 && sourceCodeValue.isNumeric()){
                                    Integer addDigit = 7 - sourceCodeValue.length();
                                    for(Integer i=1; i<= addDigit; i++){
                                        sourceCodeValue = '0' + sourceCodeValue;
                                    }
                                }
                                else{
                                    system.debug('Invalid Format');
                                    return new List<String>();
                                }
                                return ean8EncodingMethod(sourceCodeValue).split('');
                            }
    
    public static String ean8EncodingMethod(String encodingNumber){
        Integer iSum = 0;
        Integer iDigit = 0;
        result = new List<String>();
        if(encodingNumber.isNumeric()){
            for( Integer i = encodingNumber.Length(); i >= 1; i-- ){
                iDigit = Integer.valueof(encodingNumber.subString( i - 1, i) );
                if(math.mod(i,2) == 1 ){   // odd
                    iSum += iDigit * 3;
                }
                else{   // even
                    iSum += iDigit * 1;
                }
            }
            Integer iCheckSum = math.mod(( 10 - ( math.mod(iSum ,10))  ),10);
            result.add('101');
            encodingNumber += String.valueof(iCheckSum);
            for(String sourceChar: encodingNumber.subString(0,4).split('')) {
                result.add(aOddLeft[Integer.valueof(sourceChar)]);                         
            }
            result.add('01010');
            for(String sourceChar: encodingNumber.subString(4,encodingNumber.length()).split('')) {
                result.add(aRight[Integer.valueof(sourceChar)]);
            }
            result.add('101');
            resultString=String.join(result,'').split('');
            return String.join(result,'');
        }
        else {
            ApexPages.addmessage(
                new ApexPages.message(
                    ApexPages.Severity.WARNING,
                    'Enter only Numberic characters'
                )
            );
            return null;
        }
        
    }
}