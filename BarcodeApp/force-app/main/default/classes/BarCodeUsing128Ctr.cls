/**
* @author - Nitin Aggarwal (Removed un-used resources, fixed indentation, fixed formatting)
* @modifiedDate - 20 May 2019
* @description This class will be used to Generate Barcode Using Code 128
* *************************************************************
* Version History
* *************************************************************
* @developer - Mohit Agarwal
* @description - change in keys String to be worked for back slash(\) also
 *              - single backslash(\) does not work in String so to add a single slash in a Sting we need to use double backslash (\\)  
 *              - Add '60' in a Keynumber list which is required to calculate the checksum for backslash(\)
 *              - Add '11101111010' in a values string list  which is encoded value of backslash(\)
 *              - If anyone wants to know about encoding values and keys he/she can refer this link: http://www.barcodeisland.com/code128.phtml 
*/
public class BarCodeUsing128Ctr {
    
    public static String keys = '!"#$%&()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]_abcdefghijklmnopqrstuvwxyz{|}';
    public static Integer remainderValue {get;set;}
    public static String sourceCodeValue {get;set;}
    public static String barcodeContainerPadding {get;set;}
    
    public List<List<String>> allBarData {
        get {
            allBarData=new List<List<String>>();
            List<String> tempList=new List<String>();
            List<String> repList=getBarCodeBars();
            for(Integer i=0;i<repList.size();i++) {
                tempList.add(repList[i]);
                if(i==repList.size()-1 && tempList.size()!=1000){
                    allBarData.add(tempList);
                }
                if(tempList.size()==1000) {
                    allBarData.add(tempList);
                    tempList=new List<String>();
                }
            }
            return allBarData;
        }
        private set;
    }
    
    static String[] values = new String[] {
        '11001101100','11001100110','10010011000','10010001100',
            '10001001100','10011001000','10001100100','11001001000',
            '11001000100','11000100100','10110011100','10011011100',
            '10011001110','10111001100','10011101100','10011100110',
            '11001110010','11001011100','11001001110','11011100100',
            '11001110100','11101101110','11101001100','11100101100',
            '11100100110','11101100100','11100110100','11100110010',
            '11011011000','11011000110','11000110110','10100011000',
            '10001011000','10001000110','10110001000','10001101000',
            '10001100010','11010001000','11000101000','11000100010',
            '10110111000','10110001110','10001101110','10111011000',
            '10111000110','10001110110','11101110110','11010001110',
            '11000101110','11011101000','11011100010','11011101110',
            '11101011000','11101000110','11100010110','11101101000',
            '11101100010','11100011010','11101111010','11001000010',
            '10100110000','10010110000','10010000110','10000101100',
            '10000100110','10110010000','10110000100','10011010000',
            '10011000010','10000110100','10000110010','11000010010',
            '11001010000','11110111010','11000010100','10001111010',
            '10100111100','10010111100','10010011110','10111100100',
            '10011110100','10011110010','11110100100','11110010100',
            '11110010010','11011011110','11011110110','11110110110',
            '10101111000','10100011110'
            };
                
                static String[] KeyNumber = new String[] {
                    '01','02','03','04',
                        '05','06','08','09',
                        '10','11','12','13',
                        '14','15','16','17',
                        '18','19','20','21',
                        '22','23','24','25',
                        '26','27','28','29',
                        '30','31','32','33',
                        '34','35','36','37',
                        '38','39','40','41',
                        '42','43','44','45',
                        '46','47','48','49',
                        '50','51','52','53',
                        '54','55','56','57',
                        '58','59','60','61',
                        '63','65','66','67',
                        '68','69','70','71',
                        '72','73','74','75',
                        '76','77','78','79',
                        '80','81','82','83',
                        '84','85','86','87',
                        '88','89','90','91',
                        '92','93'
                        };
                            
                            static String[] KeyIndexforBinary= new String[] {
                                '01','02','03','04','05','06','07','08','09','10','11','12','13',
                                    '14','15','16','17','18','19','20','21','22','23','24','25','26',
                                    '27','28','29','30','31','32','33','34','35','36','37','38','39',
                                    '40','41','42','43','44','45','46','47','48','49','50','51','52',
                                    '53','54','55','56','57','58','59','60','61','62','63','64','65',
                                    '66','67','68','69','70','71','72','73','74','75','76','77','78',
                                    '79','80','81','82','83','84','85','86','87','88','89','90','91',
                                    '92','93','94','95','96','97','98','99','100','101','102','103',
                                    '104','105'
                                    };                                       
                                        static String[] KeyIndexforBinaryValue= new String[] {
                                            '11001101100','11001100110','10010011000','10010001100','10001001100','10011001000','10011000100',
                                                '10001100100','11001001000','11001000100','11000100100','10110011100','10011011100','10011001110',
                                                '10111001100','10011101100','10011100110','11001110010','11001011100','11001001110','11011100100',
                                                '11001110100','11101101110','11101001100','11100101100','11100100110','11101100100','11100110100',
                                                '11100110010','11011011000','11011000110','11000110110','10100011000','10001011000','10001000110',
                                                '10110001000','10001101000','10001100010','11010001000','11000101000','11000100010','10110111000', 
                                                '10110001110','10001101110','10111011000','10111000110','10001110110','11101110110','11010001110',
                                                '11000101110','11011101000','11011100010','11011101110','11101011000','11101000110','11100010110',
                                                '11101101000', '11101100010','11100011010','11101111010','11001000010','11110001010','10100110000',
                                                '10100001100','10010110000','10010000110','10000101100','10000100110','10110010000','10110000100',
                                                '10011010000','10011000010', '10000110100','10000110010','11000010010','11001010000','11110111010',
                                                '11000010100','10001111010','10100111100','10010111100','10010011110','10111100100','10011110100',
                                                '10011110010','11110100100','11110010100','11110010010','11011011110','11011110110','11110110110',
                                                '10101111000','10100011110','10001011110','10111101000','10111100010','11110101000','11110100010',
                                                '10111011110','10111101110','11101011110','11110101110','11010000100','11010010000','11010011100'  
                                                };
                                                    
                                                    public String[] getBarCodeBars() {
                                                        if(sourceCodeValue == null) {
                                                            return generateCode128(apexpages.currentpage().getparameters().get('sourceCodeValue')).split('');
                                                        }
                                                        return generateCode128(sourceCodeValue).split('');
                                                    }
    
    @AuraEnabled
    public static String generateCode128(String source) {
        String FinalValue = '';
        String[] result = new String[0];
        Integer totalForCheckSum = 104;
        Integer num = 1;
        Integer index,total = 0;  // Checksum calculation
        if(String.isNotBlank(source)) {
            result.add('11010010000');
            for(String sourceChar: source.split('')) {
                if((index = keys.indexOf(sourceChar)) > -1) {
                    result.add(values[index]);
                    total += index;
                    totalForCheckSum = totalForCheckSum + (Integer.valueof(KeyNumber[index]) * num);
                    finalValue = finalValue + sourceChar;
                    num ++;
                }
                if(sourceChar == ' '){
                    result.add('11011001100');
                    total += index;
                    totalForCheckSum = totalForCheckSum + (0 * num);
                    finalValue = finalValue + ' ';
                    num ++;
                }                
            }
            remainderValue = math.mod(totalForCheckSum, 103);
            for(Integer j=0;j<keyIndexforBinary.size();j++){
                if(Integer.valueof(keyIndexforBinary[j])==remainderValue){
                    result.add(keyIndexforBinaryValue[j]);
                }
            }
            result.add('1100011101011');
        }
        if(finalValue != ''){
            sourceCodeValue = finalValue;
        }
        return String.join(result,'');
    }
}