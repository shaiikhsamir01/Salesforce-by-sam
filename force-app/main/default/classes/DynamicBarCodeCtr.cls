/**
 * Created by : Arun Kumar
 * ***********************************************
 * Change history : 
 * Changed By : Mohit Aggarwal
 * Changed Date : 29/05/2020
 * description - Added line 76, 104, 143, 447 to avoid repeatation in barcodeValueOuterList by clearing it.
 * ***********************************************************
 * Changed By : Mohit Agarwal
 * Changed Date: 05/06/2020
 * Description : Added logic to add new Barcode Formats Code11, Code93, Code25
 *              Added logic to generate barcode in Attchment, Email the Attachment
 *              Added logic to generate the barcode of new format Code11, Code93, Code25 in lightning Component
 *              Correct logic of Barcode attachment for List view 
 *              Correct Indentation
 *              Add barCodeFormatCompatibilityCheck() function to check the field value is compatible for the selected barcode format
 *              Added logic to close apex message on vf page automatically after 10 seconds.
 *              
 *
*/
public with sharing class DynamicBarCodeCtr {  
    public boolean showMessage{get;set;}
    public boolean timer {get; set;}
    public String selectedField {get;set;}
    public String idlist{get;set;}
    public static Map<String,String> objectNameWithPrefix {get;set;}
    public List<String> listOfIds {get;set;}
    public Set<Id> selectedRecordsIds {get; set;}
    public String objectName {get;set;}
    public List<SelectOption> options {get;set;}
    public List<SelectOption> formatType {get;set;}
    public List<String> barcodeValue {get;set;}
    public List<List<String>> barcodeValueOuterList {get;set;}
    public String format {get;set;}
    private Map<String,String> idWithValue {get;set;}
    public String emailId {get;set;}
    public Boolean setupSuccess{get;set;}
    public Boolean AuthError{get;set;}
    public String authenticationError{get;set;}
    
    public DynamicBarCodeCtr() {    
        format = 'Code 128';
        setupSuccess = false;
        barcodeValue = new List<String>();
        barcodeValueOuterList = new List<List<String>>();
        options = new List<SelectOption>();
        formatType = new List<SelectOption>();
        formatType.add(new  SelectOption('Code 128','Code 128'));
        formatType.add(new  SelectOption('Code 39','Code 39'));
        formatType.add(new  SelectOption('EAN 13','EAN 13'));
        formatType.add(new  SelectOption('EAN 8','EAN 8'));
        /******* Added By Mohit ******/
        formatType.add(new  SelectOption('Code 93','Code 93'));
        formatType.add(new  SelectOption('Code 11','Code 11'));
        formatType.add(new  SelectOption('Code 25','Code 25'));
        /***** END ***/
        objectNameWithPrefix = new Map<String,String>();
        listOfIds = new List<String>();
        idWithValue = new Map<String,String>();
        if(apexpages.currentpage().getparameters().get('conid') != null) {
            listOfIds = apexpages.currentpage().getparameters().get('conid').split(',');
            
        }
        Map<String,Schema.SobjectType> gd = Schema.getGlobalDescribe();
        selectedRecordsIds = new Set<Id>();
        for(String idStr : listOfIds) {
            selectedRecordsIds.add(idStr);
        }
        for(Schema.SObjectType f : gd.values()) {
            if(f.getDescribe().getKeyPrefix() != null && listOfIds[0].startswith(f.getDescribe().getKeyPrefix())) {
                objectNameWithPrefix.put(f.getDescribe().getName(),f.getDescribe().getKeyPrefix());
                objectName = f.getDescribe().getName();
                
            }
        }
        SObjectType objToken1 = gd.get(objectName);
        DescribeSObjectResult objDef1= objToken1.getDescribe();
        Map<String,Schema.SObjectField> fieldMap = objDef1.fields.getMap();
        
        for(SObjectField sfield : fieldMap.values()) {
            if(String.valueof(sfield.getDescribe().getType())  != 'BOOLEAN' && (sfield.getDescribe().isAccessible())) {
                options.add(new SelectOption(sfield.getDescribe().getName(),sfield.getDescribe().getLabel()));   
            }
        }
    }
    
    public pagereference generateBarcode() {
        List<sobject> queryResult=new List<sobject>();
        String query='select '
            +String.escapeSingleQuotes(selectedField)
            +' from '+ String.escapeSingleQuotes(objectName) 
            +' where id IN : selectedRecordsIds';
        SObjectType schemaType = Schema.getGlobalDescribe().get(objectName);
        Map<String, SObjectField> fields = schemaType.getDescribe().fields.getMap();
        DescribeFieldResult fieldDescribe = fields.get(selectedField).getDescribe();
        if(fieldDescribe.isAccessible()) {
            queryResult = Database.query(query);
        }
        
        barcodeValue.clear();
        barcodeValueOuterList.clear();
        for(Sobject s:queryResult) {
            if(String.valueof(s.get(selectedField)) != null ) {
                if(barCodeFormatCompatibilityCheck(format,String.valueof(s.get(selectedField)))) {
                    barcodeValue.add(String.valueof(s.get(selectedField)));
                    if(barcodeValue.size() == 999) {
                        barcodeValueOuterList.add(barcodeValue);
                        barcodeValue = new List<String>();
                    }
                    idWithValue.put(String.valueof(s.get('id')),String.valueof(s.get(selectedField)));
                }
            }
            else {
                ApexPages.addmessage(
                    new ApexPages.message(
                        ApexPages.Severity.WARNING,
                        'Field value of '+selectedField+' is missing'
                    )
                );
            }
        }
        barcodeValueOuterList.add(barcodeValue);
        timerOn();
        return null;
    }
    
    public PageReference generateBarcodePDF() {
        List<sobject> queryResult = new List<sobject>();
        String query = 'select '
            +String.escapeSingleQuotes(selectedField)
            +' from '+ String.escapeSingleQuotes(objectName) 
            +' where id IN : selectedRecordsIds ';
        SObjectType schemaType = Schema.getGlobalDescribe().get(objectName);
        Map<String, SObjectField> fields = schemaType.getDescribe().fields.getMap();
        DescribeFieldResult fieldDescribe = fields.get(selectedField).getDescribe();
        if(fieldDescribe.isAccessible()) {
            queryResult = Database.query(query);
        }
        barcodeValue.clear();
        barcodeValueOuterList.clear();
        for(Sobject s:queryResult) {
            if(String.valueof(s.get(selectedField)) != null ) {
                if(barCodeFormatCompatibilityCheck(format,String.valueof(s.get(selectedField)))) {
                    barcodeValue.add(String.valueof(s.get(selectedField)));
                    if(barcodeValue.size() == 999) {
                        barcodeValueOuterList.add(barcodeValue);
                        barcodeValue = new List<String>();
                    }
                    idWithValue.put(String.valueof(s.get('id')),String.valueof(s.get(selectedField)));
                }
            }
            else {
                ApexPages.addmessage(
                    new ApexPages.message(
                        ApexPages.Severity.WARNING,'Field value of '+selectedField+' is missing'
                    )
                );
                
            }
        }
        if(barcodeValue.size() == 0){
            ApexPages.addmessage(
                new ApexPages.message(
                    ApexPages.severity.WARNING,'No Field value is available to Generate Barcode'
                )
            );
            return null;
        }
        else {
            barcodeValueOuterList.add(barcodeValue);
            Pagereference pg = new PageReference('/apex/DynamicBarCodePDF');
            pg.setRedirect(false);
            return pg;
        }
        
    }
    
    public pagereference storeIntoAttachment() {
        String query = '';
        if(selectedField == 'ID') {
            query = 'select '
                +String.escapeSingleQuotes(selectedField)
                +' from '+ String.escapeSingleQuotes(objectName) 
                +' where id IN : selectedRecordsIds ';
        }
        else {
            query = 'select id, '
                +String.escapeSingleQuotes(selectedField)
                +' from '+ String.escapeSingleQuotes(objectName)
                +' where id IN : selectedRecordsIds ';
        }
        List<sobject> queryResult = new List<sobject>();
        SObjectType schemaType = Schema.getGlobalDescribe().get(String.escapeSingleQuotes(objectName));
        Map<String, SObjectField> fields = schemaType.getDescribe().fields.getMap();
        DescribeFieldResult fieldDescribe = fields.get(String.escapeSingleQuotes(selectedField)).getDescribe();
        if(fieldDescribe.isAccessible()) {
            queryResult = Database.query(query);
        }
        barcodeValue.clear();
        barcodeValueOuterList.clear();
        
        for(Sobject s:queryResult) {
            if(String.valueof(s.get(selectedField))!=null ) {
                if(barCodeFormatCompatibilityCheck(format,String.valueof(s.get(selectedField)))) {
                    barcodeValue.add(String.valueof(s.get(selectedField)));
                    if(barcodeValue.size()==999) {
                        barcodeValueOuterList.add(barcodeValue);
                        barcodeValue = new List<String>();
                    }
                    idWithValue.put(String.valueof(s.get('id')),String.valueof(s.get(selectedField)));
                }
            }
            else {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Field value of '+selectedField+' is missing'));
            }
        }
        if(barcodeValue.size()==0)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'No Field value is available to Generate Barcode'));
            return null;
        }
        else{
            if(selectedRecordsIds.size()>50){
                ApexPages.addmessage(
                    new ApexPages.message(
                        ApexPages.Severity.WARNING,'Currently It Attach as Pdf only for 50 Records.Please select 50 or less than 50 records'
                    )
                );
                return null;
            }
            else{
                barcodeValueOuterList.add(barcodeValue);
                List<Attachment> attachList =new List<Attachment>();
                List<ContentVersion> contentVersionList = new List<ContentVersion>();
                List<ContentDocumentLink> contentDocumentLinkList1 = new List<ContentDocumentLink>();
                List<ContentDocumentLink> contentDocumentLinkList2 = new List<ContentDocumentLink>();
                
                PageReference pdf;
                if(format =='Code 128') {
                    pdf = Page.Code128;
                }
                if(format =='Code 39') {
                    pdf = Page.Code39;
                }
                if(format =='EAN 13') {
                    pdf = Page.EAN13;
                }
                if(format =='EAN 8') {
                    pdf = Page.Ean8;
                }
                if(format == 'Code 93'){
                    pdf = Page.Code93;
                }
                if(format == 'Code 11'){
                    pdf = Page.Code11;
                }
                if(format == 'Code 25'){
                    pdf = Page.Code25;
                }
                Map<String,String> idVsCvr = new Map<String,String>();
                for(String recordId: idWithValue.keyset()) {
                    pdf.getParameters().put('sourceCodeValue',idWithValue.get(recordId));
                    Blob b;
                    if (Test.IsRunningTest()) {
                        b = Blob.valueOf('UNIT.TEST');
                    }
                    else{
                        b = pdf.getContentasPDF();
                        
                    }
                    
                    ContentVersion cvr = new Contentversion();
                    cvr.PathOnClient = selectedField+'-'+format+'.pdf';  //Title of the Attachment
                    cvr.versiondata = b;
                    if(Schema.SObjectType.ContentVersion.fields.PathOnClient.isCreateable() && 
                       Schema.SObjectType.ContentVersion.fields.versiondata.isCreateable()){
                           insert cvr;
                    }
                    
                    ///////////////////////////////////////
                    //contentVersionList.add(cvr);
                    /*
                    * Just did this thing just because of less time
                    * One can do this using Maps.
                    * This code may mot work for bulk records.
                    */
                    ContentDocumentLink cl = new ContentDocumentLink(LinkedEntityId = recordId, ShareType = 'V',contentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cvr.Id].ContentDocumentId);
                    contentDocumentLinkList1.add(cl);
                }
                for(ContentDocumentLink cdL:contentDocumentLinkList1) {
                    ContentDocumentLink cdL1 = new ContentDocumentLink();
                    cdL1.ContentDocumentId = cdl.ContentDocumentId;
                    cdl1.LinkedEntityId = cdL.LinkedEntityId;
                    cdL1.ShareType = cdL.ShareType;
                    contentDocumentLinkList2.add(cdL1);
                }
                if(contentDocumentLinkList2.size()>0)
                {
                    try {
                        if(Schema.SObjectType.ContentDocumentLink.fields.LinkedEntityId.isCreateable() && 
                           Schema.SObjectType.ContentDocumentLink.fields.ContentDocumentId.isCreateable() && 
                           Schema.SObjectType.ContentDocumentLink.fields.ShareType.isCreateable()) {
                               insert contentDocumentLinkList2;
                           }
                        //insert attachList;
                        ApexPages.addMessage(
                            new ApexPages.Message(
                                ApexPages.Severity.CONFIRM,'BarCode Generated Successfully and Stored as Attachment!!!'
                            )
                        );
                        timerOn();
                        //selectedField = null;
                        idWithValue = new Map<String,String>();
                        contentDocumentLinkList2 = new List<contentDocumentLink>();
                        contentVersionList = new List<ContentVersion>();
                    }
                    catch(Exception ex) {
                        System.debug('Exception in ContentDocumentLink:='+ex);
                    }
                }
                return null;
            }
        }
    }
    
    @AuraEnabled
    public static LightingWrapperClass dynamicBarCodeCtrMethod(String recordId) {
        String nameObject;
        Map<String,Schema.SobjectType> gd = Schema.getGlobalDescribe();
        
        for(Schema.SObjectType f : gd.values()) {
            if(f.getDescribe().getKeyPrefix() !=null && recordId.startswith(f.getDescribe().getKeyPrefix())) {
                nameObject = f.getDescribe().getName();
            }
        }
        SObjectType objToken1 = gd.get(NameObject);
        List<String> fieldsName = new List<String>();
        Map<String,String> fieldNameWithAPI = new Map<String,String>();
        DescribeSObjectResult objDef1 = objToken1.getDescribe();
        Map<String, SObjectField> fieldMap = objDef1.fields.getMap();
        for(SObjectField sfield : fieldMap.values()) {
            if(String.valueof(sfield.getDescribe().getType()) != 'BOOLEAN') {
                fieldsName.add(sfield.getDescribe().getlabel());
                fieldNameWithAPI.put(sfield.getDescribe().getName(),sfield.getDescribe().getlabel());
            }
        }
        LightingWrapperClass lighting = new LightingWrapperClass (nameObject,fieldsName,'',fieldNameWithAPI,recordId);
        return lighting;
    }
    
    @AuraEnabled
    public static LightingWrapperClass generateBarcodeLighting(boolean generatePdf,
                                                               String selectedRecord, 
                                                               String selectedField,
                                                               String selectedFormat, 
                                                               String objName,
                                                               Map<String,String> mapValue) {
                                                                   Map<String,String> fieldNameWithAPIMap = mapValue;
                                                                   String fieldName;
                                                                   for(String key : fieldNameWithAPIMap.keyset()) {
                                                                       if((String.escapeSingleQuotes(selectedField)) == fieldNameWithAPIMap.get(key)) {
                                                                           fieldName = key;               
                                                                       }
                                                                   }
                                                                   String query = 'Select '
                                                                       +String.escapeSingleQuotes(fieldName)
                                                                       +' From '+ String.escapeSingleQuotes(objName) 
                                                                       +' Where id=\''
                                                                       +String.escapeSingleQuotes(selectedRecord)
                                                                       +'\'';
                                                                   String barcodeValue;
                                                                   boolean valueNull = false;
                                                                   List<sobject> queryResult = new List<sobject>();
                                                                   SObjectType schemaType = Schema.getGlobalDescribe()
                                                                       .get(String.escapeSingleQuotes(objName));
                                                                   Map<String, SObjectField> fields = schemaType.getDescribe().fields.getMap();
                                                                   DescribeFieldResult fieldDescribe = fields 
                                                                       .get(String.escapeSingleQuotes(fieldName))
                                                                       .getDescribe();
                                                                   if(fieldDescribe.isAccessible()) {
                                                                       queryResult = Database.query(query);
                                                                   }
                                                                   for(Sobject s:queryResult) {
                                                                       if(String.valueof(s.get(fieldName)) != null ) {
                                                                           barcodeValue = String.valueof(s.get(fieldName));
                                                                       }
                                                                       else {
                                                                           valueNull = true;
                                                                       }
                                                                   }
                                                                   String returnvalue='';
                                                                   PageReference pdf;
                                                                   Blob b;
                                                                   if(selectedFormat == 'Code 128' && barcodeValue != '') {
                                                                       if(generatePdf) {
                                                                           pdf = Page.Code128;
                                                                           pdf.getParameters().put('sourceCodeValue',barcodeValue);
                                                                           if(Test.IsRunningTest()) {
                                                                               b=Blob.valueOf('UNIT.TEST');
                                                                           }
                                                                           else {
                                                                               b = pdf.getContentAsPDF();
                                                                           }
                                                                       }
                                                                       else {
                                                                           returnvalue = BarCodeUsing128Ctr.generateCode128(barcodeValue);  
                                                                           system.debug('returnvalue==>'+returnvalue);
                                                                       }   
                                                                   }
                                                                   if(selectedFormat == 'Code 39'&& barcodeValue != '') {
                                                                       if(generatePdf) {
                                                                           pdf = Page.Code39;
                                                                           pdf.getParameters().put('sourceCodeValue',barcodeValue);
                                                                           if(Test.IsRunningTest()) {
                                                                               b = Blob.valueOf('UNIT.TEST');}
                                                                           else {
                                                                               b = pdf.getContentAsPDF();
                                                                           }
                                                                       }
                                                                       else {
                                                                           returnvalue = BarCodeUsing39Ctr.generateCode39(barcodeValue); 
                                                                       }
                                                                   }
                                                                   if(selectedFormat =='EAN 13'&& barcodeValue != '') {
                                                                       if(barcodeValue.length() <= 13 && barcodeValue.isNumeric()){
                                                                           Integer addDigit = 12-barcodeValue.length();
                                                                           for(Integer i = 1;i <= addDigit; i++){
                                                                               barcodeValue = '0'+barcodeValue;
                                                                           } 
                                                                           Integer lastdigit = 0;
                                                                           if(barcodeValue.length() == 13){
                                                                               lastdigit = Integer.valueOf(barcodeValue.subString(12,13));
                                                                           }
                                                                           if(generatePdf) {
                                                                               pdf = Page.EAN13;
                                                                               pdf.getParameters().put('sourceCodeValue',barcodeValue);
                                                                               
                                                                               if (Test.IsRunningTest()) {
                                                                                   b = Blob.valueOf('UNIT.TEST');
                                                                               }
                                                                               else {
                                                                                   b = pdf.getContentAsPDF();
                                                                               }
                                                                           }
                                                                           else {
                                                                               if(barcodeValue.length() == 13){
                                                                                   if(EAN13Encoding.checksumDigit(barcodeValue.length()-1,barcodeValue) == lastdigit){
                                                                                       returnvalue = EAN13Encoding.EAN13EncodingMethod(barcodeValue);
                                                                                   }
                                                                                   else{
                                                                                       valueNull = true;
                                                                                   }
                                                                               }else{
                                                                                   returnvalue = EAN13Encoding.EAN13EncodingMethod(barcodeValue); 
                                                                               }
                                                                           }
                                                                       }
                                                                       else {
                                                                           valueNull = true;
                                                                       }
                                                                   }
                                                                   if(selectedFormat== 'EAN 8' && barcodeValue != '') {
                                                                       if(barcodeValue.length() <= 7 && barcodeValue.isNumeric()) {
                                                                           Integer addDigit = 7-barcodeValue.length();
                                                                           for(Integer i = 1; i <= addDigit; i++) {
                                                                               barcodeValue = '0'+barcodeValue;
                                                                           }               
                                                                           if(generatePdf) {
                                                                               pdf = Page.EAN8;
                                                                               pdf.getParameters().put('sourceCodeValue',barcodeValue);
                                                                               if (Test.IsRunningTest()) {
                                                                                   b = Blob.valueOf('UNIT.TEST');
                                                                               }
                                                                               else {
                                                                                   b = pdf.getContentAsPDF();
                                                                               }
                                                                           }
                                                                           else {
                                                                               returnvalue = EAN8Encoding.EAN8EncodingMethod(barcodeValue); 
                                                                           }
                                                                       }
                                                                       else {
                                                                           valueNull = true;
                                                                       }
                                                                   }
                                                                   /*******Added By MOHIT********/
                                                                   if(selectedFormat== 'Code 93' && barcodeValue != '') {
                                                                       Pattern numberFormat = Pattern.Compile('[0-9A-Z\\-\\. \\$/\\+%]*');
                                                                       Matcher numberMatch = numberFormat.matcher(barcodeValue);
                                                                       if(numberMatch.Matches()) {
                                                                           if(generatePdf) {
                                                                               pdf = Page.Code93;
                                                                               pdf.getParameters().put('sourceCodeValue',barcodeValue);
                                                                               if (Test.IsRunningTest()) {
                                                                                   b = Blob.valueOf('UNIT.TEST');
                                                                               }
                                                                               else {
                                                                                   b = pdf.getContentAsPDF();
                                                                               }
                                                                           }
                                                                           else {
                                                                               BarcodeCode93 code93 = new BarcodeCode93();
                                                                               returnvalue = code93.getComputeBarcodeBars(barcodeValue); 
                                                                           }
                                                                       }
                                                                       else {
                                                                           valueNull = true;
                                                                       }
                                                                   }
                                                                   if(selectedFormat== 'Code 11' && barcodeValue != '') {
                                                                       Pattern numberFormat = Pattern.Compile('[0-9\\-]*');
                                                                       Matcher numberMatch = numberFormat.matcher(barcodeValue);
                                                                       if(numberMatch.Matches()) {
                                                                           if(generatePdf) {
                                                                               pdf = Page.Code11;
                                                                               pdf.getParameters().put('sourceCodeValue',barcodeValue);
                                                                               if (Test.IsRunningTest()) {
                                                                                   b = Blob.valueOf('UNIT.TEST');
                                                                               }
                                                                               else {
                                                                                   b = pdf.getContentAsPDF();
                                                                               }
                                                                           }
                                                                           else {
                                                                               BarcodeCode11 code11 = new BarcodeCode11();
                                                                               returnvalue = code11.getComputeBarcodeBars(barcodeValue); 
                                                                               system.debug('returnvalue==>'+returnvalue);
                                                                           }
                                                                       }
                                                                       else {
                                                                           valueNull = true;
                                                                       }
                                                                   }
                                                                   if(selectedFormat== 'Code 25' && barcodeValue != '') {
                                                                       if(barcodeValue.isNumeric()) {
                                                                           if(generatePdf) {
                                                                               pdf = Page.Code25;
                                                                               pdf.getParameters().put('sourceCodeValue',barcodeValue);
                                                                               if (Test.IsRunningTest()) {
                                                                                   b = Blob.valueOf('UNIT.TEST');
                                                                               }
                                                                               else {
                                                                                   b = pdf.getContentAsPDF();
                                                                               }
                                                                           }
                                                                           else {
                                                                               BarcodeUsingCode25 code25 = new BarcodeUsingCode25();
                                                                               returnvalue = code25.getComputeBarcodeBars(barcodeValue); 
                                                                           }
                                                                       }
                                                                       else {
                                                                           valueNull = true;
                                                                       }
                                                                   }                               
                                                                   /************** END**********************/
                                                                   if(generatePdf) {
                                                                       ContentVersion cvr = new Contentversion();
                                                                       cvr.PathOnClient = selectedField+'.pdf';  //Title of the Attachment
                                                                       cvr.versiondata = b;
                                                                       try  {
                                                                           if(Schema.SObjectType.ContentVersion.fields.PathOnClient.isCreateable() && 
                                                                              Schema.SObjectType.ContentVersion.fields.versiondata.isCreateable()){
                                                                                  insert cvr;
                                                                              }
                                                                       }
                                                                       catch(Exception ex){
                                                                           System.debug('Exception in contentVersion:='+ex);
                                                                       }
                                                                       System.debug('1111111 '+cvr);
                                                                       ContentVersion cv = new ContentVersion();
                                                                       if(Schema.SObjectType.ContentVersion.fields.ContentDocumentId.isAccessible()) {
                                                                           cv = [
                                                                               select ContentDocumentId
                                                                               from ContentVersion
                                                                               where Id =: cvr.Id
                                                                           ];
                                                                       }
                                                                       ContentDocumentLink cl = new ContentDocumentLink(LinkedEntityId = selectedRecord,
                                                                                                                        ContentDocumentId = cv.ContentDocumentId,
                                                                                                                        ShareType = 'V');
                                                                       try{
                                                                           if(Schema.SObjectType.ContentDocumentLink.fields.LinkedEntityId.isCreateable() && 
                                                                              Schema.SObjectType.ContentDocumentLink.fields.ContentDocumentId.isCreateable() && 
                                                                              Schema.SObjectType.ContentDocumentLink.fields.ShareType.isCreateable()) {
                                                                                  insert cl;
                                                                              }
                                                                       }
                                                                       catch(Exception ex) {
                                                                           system.debug('Exception in ContentDocumentLink:='+ex);
                                                                       }
                                                                   }
                                                                   LightingWrapperClass wrapper = new LightingWrapperClass();
                                                                   wrapper.objectName = objName;
                                                                   wrapper.selectedFormat = selectedFormat;
                                                                   wrapper.fieldNameWithAPI = fieldNameWithAPIMap;
                                                                   wrapper.selectedField = selectedField;
                                                                   wrapper.recordId = selectedRecord;
                                                                   wrapper.barcodeValue = barcodeValue;
                                                                   if(returnvalue != '') {
                                                                       wrapper.generatedValue = returnvalue.split('');
                                                                   }
                                                                   if(valueNull) {
                                                                       wrapper.NotSuccess=true;
                                                                   }
                                                                   return wrapper;
                                                               }
    
    public pagereference sendAsAttachment() {
        
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; // source: <a href="http://www.regular-expressions.info/email.html" target="_blank" rel="nofollow">http://www.regular-expressions.info/email.html</a>
        Pattern MyPattern = Pattern.compile(emailRegex);
        
        String query ='select '
            +String.escapeSingleQuotes(selectedField)
            +' from '+ String.escapeSingleQuotes(objectName)
            +' where id IN : selectedRecordsIds ';
        List<sobject> queryResult = new List<sobject>();
        SObjectType schemaType = Schema.getGlobalDescribe().get(objectName );
        Map<String, SObjectField> fields = schemaType.getDescribe().fields.getMap();
        DescribeFieldResult fieldDescribe = fields.get(selectedField).getDescribe();
        if(fieldDescribe.isAccessible()) {
            queryResult = Database.query(query);
        }
        barcodeValue.clear();
        barcodeValueOuterList.clear();
        for(Sobject s:queryResult) {
            if(String.valueof(s.get(selectedField)) != null ) {
                if(barCodeFormatCompatibilityCheck(format,String.valueof(s.get(selectedField)))) {
                    barcodeValue.add(String.valueof(s.get(selectedField)));
                    if(barcodeValue.size() == 999) {
                        barcodeValueOuterList.add(barcodeValue);
                        barcodeValue = new List<String>();
                    }
                    idWithValue.put(String.valueof(s.get('id')),String.valueof(s.get(selectedField)));   
                }
                else {
                    return Null;
                }
            }
        }
        if(barcodeValue.size() == 0) {
            ApexPages.addmessage(
                new ApexPages.message(
                    ApexPages.Severity.WARNING,
                    'No Field value is available to Generate Barcode'
                )
            );
        }
        else {
            if(String.isBlank(emailid)) {
                ApexPages.addmessage(
                    new ApexPages.message(
                        ApexPages.Severity.WARNING,
                        'Email Field is Empty.'
                    )
                );
                return null;
            }
            else if(!String.isBlank(emailid))
            {
                Matcher MyMatcher = MyPattern.matcher(emailid);
                if(!MyMatcher.matches()) {
                    system.debug('Email is not valid');
                    ApexPages.addmessage(
                        new ApexPages.message(
                            ApexPages.Severity.WARNING,
                            'Email Address is not valid.Please Enter Valid Email Address.'
                        )
                    );
                    return null;
                }
                else {
                    Pagereference pdf; 
                    pdf = Page.DynamicBarCodeEmail;
                    Blob b;
                    String combinedDataAsBase64 = '';
                    List<Blob> pdfcontent = new List<Blob>();
                    pdf.getParameters().put('sourceCodeValue',String.join(barcodeValue, '~'));
                    pdf.getParameters().put('format',format);
                    if (Test.IsRunningTest()){
                        b = Blob.valueOf('UNIT.TEST');
                    }
                    else{
                        b = pdf.getContentasPdf();
                    }
                    {
                        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                        efa.setFileName(objectName+'-'+selectedField+'-'+format+'.pdf');
                        efa.setBody(b);
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
                        email.setSubject('PDF of BarCode - '+selectedField+' of '+objectName);
                        email.setToAddresses( new List<String>{emailid} );
                        email.sethtmlBody('Hi,<br/><br/> '
                                          +'Please find the attached BarCode PDF.'
                                          +'<br/><br/>'+'Thank you');
                        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
                        try {
                            Messaging.SendEmailResult [] result = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
                        }
                        catch(System.Exception e) {
                            if(e.getMessage().contains('SINGLE_EMAIL_LIMIT_EXCEEDED')) {
                                ApexPages.addmessage(
                                    new ApexPages.message(
                                        ApexPages.Severity.WARNING,
                                        'SINGLE_EMAIL_LIMIT_EXCEEDED'
                                    )
                                );
                                return null;
                            }
                        } 
                    }        
                    ApexPages.addMessage(
                        new ApexPages.Message(
                            ApexPages.Severity.CONFIRM,
                            'BarCode Generated Successfully and sent to your provided email id.Thank you!'
                        )
                    );
                    timerOn();
                    return null;
                }
            }
            return null;
        }
        return null;
    }
    
    public static Boolean barCodeFormatCompatibilityCheck(String format,String sourceValue) {
        if(format != Null && sourceValue != Null) {
            if(format == 'Code 128') {
                Pattern patternFormat = Pattern.compile('[ !\\\"#\\$%&\'\\(\\)\\*\\+,\\-\\./0-9:;<=>\\?@A-Z\\[\\\\\\]\\^_`a-z\\{\\|\\}]*');
                Matcher patternMatch = patternFormat.matcher(sourceValue);
                if(!patternMatch.matches()) {
                    errormsg(format,sourceValue);
                    return false;
                }
                else {
                    return true;
                }
            }
            else if(format == 'Code 39') {
                sourceValue = sourceValue.toUpperCase();
                Pattern numberFormat = Pattern.Compile('[0-9A-Z\\-\\. \\$/\\+%]*');
                Matcher numberMatch = numberFormat.matcher(sourceValue);
                if(!numberMatch.matches()) {
                    errormsg(format,sourceValue);
                    return false;
                }
                else {
                    return true;
                }
            }
            else if(format == 'EAN 13') {
                if(!(sourceValue.isNumeric() && sourceValue.length() <= 13))
                {
                    errormsg(format,sourceValue);
                    return false;
                }
                else {
                    return true;
                }
            }
            else if(format == 'EAN 8') {
                if(!(sourceValue.isNumeric() && sourceValue.length() <= 7))
                {
                    errormsg(format,sourceValue);
                    return false;
                }
                else {
                    return true;
                }
            }
            else if(format == 'Code 93') {
                sourceValue = sourceValue.toUpperCase();
                Pattern numberFormat = Pattern.Compile('[0-9A-Z\\-\\. \\$/\\+%]*');
                Matcher numberMatch = numberFormat.matcher(sourceValue);
                if(!numberMatch.matches()) {
                    errormsg(format,sourceValue);
                    return false;
                }
                else {
                    return true;
                }
            }
            else if(format == 'Code 11') {
                Pattern numberFormat = Pattern.Compile('[0-9\\-]*');
                Matcher numberMatch = numberFormat.matcher(sourceValue);
                if(!numberMatch.Matches()) {
                    errormsg(format,sourceValue);
                    return false;
                }
                else {
                    return true;
                }
            }
            else if(format == 'Code 25') {
                if(!sourceValue.isNumeric())
                {
                    errormsg(format,sourceValue);
                    return false;
                }
                else {
                    return true;
                }
            }
            else {
                return false;
            }
        }
        else{
            return false;
        }
    }
    
    public static void errormsg(String format, String sourceValue) {
        if(format != null) {
            ApexPages.addmessage(
                new ApexPages.message(
                    ApexPages.Severity.WARNING,
                    'Input Value '+sourceValue+' is not compatible with '+format+' format'
                )
            );
        }
    }
    
    @AuraEnabled
    public static Boolean emailPdf(String selectedRecord,
                                   String selectedField,
                                   String selectedFormat,
                                   String objName,
                                   Map<String,String> mapValue,
                                   String emailaddress) {
        
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; 
        // source: <a href="http://www.regular-expressions.info/email.html" target="_blank" rel="nofollow">http://www.regular-expressions.info/email.html</a>
        Pattern MyPattern = Pattern.compile(emailRegex);
        
        Map<String,String> fieldNameWithAPIMap = mapValue;
        String fieldName;
        for(String key : fieldNameWithAPIMap.keyset()) {
            if((String.escapeSingleQuotes(selectedField)) == fieldNameWithAPIMap.get(key)) {
                fieldName = key;               
            }
        }
        String query = 'Select '
            +String.escapeSingleQuotes(fieldName)
            +' From '+ String.escapeSingleQuotes(objName) 
            +' Where id=\''
            +String.escapeSingleQuotes(selectedRecord)
            +'\'';
        String barcodeValue;
        boolean valueNull = false;
        List<sobject> queryResult = new List<sobject>();
        SObjectType schemaType = Schema.getGlobalDescribe().get(String.escapeSingleQuotes(objName));
        Map<String, SObjectField> fields = schemaType.getDescribe().fields.getMap();
        DescribeFieldResult fieldDescribe = fields.get(String.escapeSingleQuotes(fieldName)).getDescribe();
        if(fieldDescribe.isAccessible()) {
            queryResult = Database.query(query);
        }
        for(Sobject s:queryResult) {
            if(String.valueof(s.get(fieldName)) != null ) {
                barcodeValue = String.valueof(s.get(fieldName));
            }
            else {
                valueNull = true;
            }
        }
        PageReference pdf;
        Blob b;
        if(selectedFormat == 'Code 128' && barcodeValue != '') {
            pdf = Page.Code128;
            pdf.getParameters().put('sourceCodeValue',barcodeValue);
            
        }
        if(selectedFormat == 'Code 39' && barcodeValue != '') {
            pdf = Page.Code39;
            pdf.getParameters().put('sourceCodeValue',barcodeValue);
        }
        if(selectedFormat == 'EAN 13 ' && barcodeValue != '') {
            pdf = Page.EAN13;
            pdf.getParameters().put('sourceCodeValue',barcodeValue);
        }
        if(selectedFormat == 'EAN 8' && barcodeValue != '') {
            pdf = Page.EAN8;
            pdf.getParameters().put('sourceCodeValue',barcodeValue);
        }
        if(selectedFormat == 'Code 93' && barcodeValue != '') {
            pdf = Page.Code93;
            pdf.getParameters().put('sourceCodeValue',barcodeValue);
        }
        if(selectedFormat == 'Code 11' && barcodeValue != '') {
            pdf = Page.Code11;
            pdf.getParameters().put('sourceCodeValue',barcodeValue);
        }
        if(selectedFormat == 'Code 25' && barcodeValue != '') {
            pdf = Page.Code25;
            pdf.getParameters().put('sourceCodeValue',barcodeValue);
        }
        if(Test.IsRunningTest()) {
            b=Blob.valueOf('UNIT.TEST');
        }
        else {
            b = pdf.getContentAsPDF();
        }
        {
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(fieldName+'-'+selectedFormat+'.pdf');
            efa.setBody(b);
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
            email.setSubject('PDF of BarCode - '+fieldName);
            email.setToAddresses( new List<String>{emailaddress} );
            email.sethtmlBody('Hi,<br/><br/> '
                              +'Please find the attached BarCode PDF.'
                              +'<br/><br/>'+'Thanks you');
            email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
            try {
                Messaging.SendEmailResult [] result = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            }
            catch(System.Exception e) {
            } 
        }        
        return true;
    }
    
    public void clearMessage(){
        ApexPages.getMessages().clear();

    }

    public void timerOn(){
        timer = true;
    }

    public void timerOff(){
        timer = false;
    }
    
}