/**
* @author - Nitin Aggarwal (Removed un-used resources, fixed indentation, fixed formatting)
* @modifiedDate - 20 May 2019
* @description This class will be used to Generate Barcode Using Code 39
* *************************************************************
* Version History
* *************************************************************
* @developer -
* @description - 
*/
public class BarCodeUsing39Ctr {
    public static String keys = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-. $/+%*';
    public static String sourceCodeValue{get;set;}			
    public String barcodeContainerPadding {get;set;}
    public List<List<String>> allBarData {
        get {
            allBarData = new List<List<String>>();
            List<String> tempList = new List<String>();
            List<String> repList = getBarCodeBars();
            for(Integer i = 0; i < repList.size(); i++){
                tempList.add(repList[i]);   
                if(i == repList.size()-1 && tempList.size() != 1000) {
                    allBarData.add(tempList);
                }
                if(tempList.size() == 1000){
                    allBarData.add(tempList);
                    tempList = new List<String>();
                }
            }
            return allBarData;
        }
        private set;
    }
    
    static String[] values = new String[] {
        '1010001110111010', '1110100010101110', '1011100010101110', '1110111000101010',
            '1010001110101110', '1110100011101010', '1011100011101010', '1010001011101110',
            '1110100010111010', '1011100010111010', '1110101000101110', '1011101000101110',
            '1110111010001010', '1010111000101110', '1110101110001010', '1011101110001010',
            '1010100011101110', '1110101000111010', '1011101000111010', '1010111000111010',
            '1110101010001110', '1011101010001110', '1110111010100010', '1010111010001110',
            '1110101110100010', '1011101110100010', '1010101110001110', '1110101011100010',
            '1011101011100010', '1010111011100010', '1110001010101110', '1000111010101110',
            '1110001110101010', '1000101110101110', '1110001011101010', '1000111011101010',
            '1000101011101110', '1110001010111010', '1000111010111010', '1000100010001010',
            '1000100010100010', '1000101000100010', '1010001000100010', '1000101110111010' 
            };
                
                public String[] getBarCodeBars() {
                    if(sourceCodeValue == null){
                        sourceCodeValue = apexpages.currentpage().getparameters().get('sourceCodeValue');
                        System.debug(sourceCodeValue);
                    }
                    if(sourceCodeValue!= null){
                        System.debug(sourceCodeValue);
                        sourceCodeValue = sourceCodeValue.toUpperCase();
                        Pattern numberFormat = Pattern.Compile('[0-9A-Z\\-\\. \\$/\\+%]*');
                        Matcher numberMatch = numberFormat.matcher(sourceCodeValue);
                        if (numberMatch.Matches())
                        {
                            System.debug(generateCode39(sourceCodeValue).split(''));
                            return generateCode39(sourceCodeValue).split('');
                        }
                        else {
                            ApexPages.addmessage(
                                new ApexPages.message(
                                    ApexPages.Severity.WARNING,
                                    'Input Format is not compatible with Code39 format'
                                )
                            );
                        }
                    }
                    return new List<String>();
                }
    
    @AuraEnabled
    public static String generateCode39(String source) {
        String finalValue = '';
        List<String> result = new List<String>();
        Integer index, total = 0;  // Checksum calculation
        if(String.isNotBlank(source)) {
            result.add(values[keys.indexOf('*')]);
            for(String sourceChar: source.toUpperCase().split('')) {
                if((index = keys.indexOf(sourceChar)) > -1) {
                    result.add(values[index]);
                    total += index;
                    finalValue += sourceChar;
                }
            }
        }
        if(finalvalue != '') {
            sourceCodeValue = finalvalue;
        }
        result.add(values[keys.indexOf('*')]);
        return String.join(result,'');
    }
}