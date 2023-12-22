public class PDF417BarcodeGenerator {
    @AuraEnabled(cacheable=true)
    public static List<ResponseWrapper> getAllSobjectFields(Id objectApiName) {
        List<ResponseWrapper> resList = new List<ResponseWrapper>();
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.SObjectType sobjType = gd.get(objectApiName.getSObjectType().getDescribe().getName());
        Schema.DescribeSObjectResult r = sobjType.getDescribe();
        Map<String, Schema.SObjectField> mapOfFields = r.fields.getMap();
        for (String fieldName : mapOfFields.keySet()) {
            ResponseWrapper res = new ResponseWrapper();
            Schema.SObjectField field = mapOfFields.get(fieldName);
            res.label = field.getDescribe().getLabel();
            res.value = field.getDescribe().getName();
            resList.add(res);
        }
        return resList;
    }
    @AuraEnabled(cacheable=true)
    public static String getSelectedFieldValue(String fieldApiName, Id recId) {
        String query = 'SELECT ' + fieldApiName;
        query += ' FROM '+ recId.getSObjectType().getDescribe().getName() + ' WHERE Id = :recId';
        List<Sobject> accounts = Database.query(query);
        if (!accounts.isEmpty() && accounts[0].get(fieldApiName) != null) {
            return String.valueOf(accounts[0].get(fieldApiName));
        }
        return '';
    }
    @AuraEnabled                            
    public static Id saveTheChunkFile(Id parentId, String fileName, String base64Data, String contentType, String fileId, String fieldName, String barcodeVer){
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        if ( String.isBlank(fileId) ) {
            fileId = saveFiles(parentId, fileName, base64Data,fieldName,barcodeVer );
        }
        return Id.valueOf(fileId);
    }
     @AuraEnabled
    public static Id saveFiles(Id recordId, String fileName, String base64Data, String selectFieldName, String barcodeType )  { 
        ContentVersion contentToInsert =new ContentVersion(); 
        contentToInsert.Title =fileName; 
        contentToInsert.VersionData=EncodingUtil.base64Decode(base64Data);
        contentToInsert.PathOnClient= recordId.getSObjectType().getDescribe().getName()+'-'+selectFieldName+'-'+barcodeType+'.pdf';
        contentToInsert.IsMajorVersion = false;
		contentToInsert.Title = recordId.getSObjectType().getDescribe().getName()+'-'+selectFieldName+'-'+barcodeType;
	    insert contentToInsert; 
        contentToInsert = [select id, ContentDocumentId from ContentVersion WHERE Id =: contentToInsert.Id];
        ContentDocumentLink cl = new ContentDocumentLink();
        cl.ContentDocumentId = contentToInsert.ContentDocumentId;
        cl.LinkedEntityId = recordId; 
        cl.ShareType = 'V';
        cl.Visibility = 'AllUsers';
        insert cl;
        return contentToInsert.ContentDocumentId;
    }
    @AuraEnabled(cacheable=true)
        public static Integer getAttachmentCount(Id recordId) {
        return [SELECT COUNT() FROM Attachment WHERE ParentId = :recordId];
    }

    @AuraEnabled
    public static List<String> convertStringtoListId(List<String> selectedIds){
        List<String> selectedId = new List<String>();
        for(String key : selectedIds){
            selectedId.add(key);
        }
        return selectedId;
    }

     @AuraEnabled
    public static Boolean sendEmailAttachment(String emailId, String base64Data, Id recId, String selectFieldName, String barcodeType ){
        Boolean isSuccess = false;
        try{
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            attachment.setFileName(recId.getSObjectType().getDescribe().getName() + '-' + selectFieldName + '-' +barcodeType+'.pdf');
            attachment.setBody(EncodingUtil.base64Decode(base64Data));
            attachment.setContentType('application/pdf');
            Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
            emailMessage.setToAddresses(new List<String>{ emailId });
            emailMessage.setSubject('Barcode PDF Attachment');
            emailMessage.setPlainTextBody('Hi,\n\nPlease find the attached barcode PDF.\n\nThanks & Best Regards');
            emailMessage.setFileAttachments(new Messaging.EmailFileAttachment[]{attachment});
            List<Messaging.SendEmailResult> results =  Messaging.sendEmail(new Messaging.Email[]{ emailMessage });
            System.debug('results'+results);
            isSuccess = true;
        }catch(exception e){
            System.debug('exp'+e);
        }
        return isSuccess;
    }
    public class ResponseWrapper {
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String value;
    }
}