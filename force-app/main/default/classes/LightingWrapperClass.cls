public with sharing class LightingWrapperClass{
        @AuraEnabled public string objectName{get;set;}
        @AuraEnabled public List<string> fieldName{get;set;}
        @AuraEnabled public Map<string,string> fieldNameWithAPI{get;set;}
        @AuraEnabled public String selectedField{get;set;}
        @AuraEnabled public String selectedFormat{get;set;}
        @AuraEnabled public String recordId{get;set;}
        @AuraEnabled public String barCodevalue{get;set;}
        @AuraEnabled public List<String> generatedValue{get;set;}
        @AuraEnabled public boolean notSuccess{get;set;}
    
        public LightingWrapperClass(){
        }
        public LightingWrapperClass(String obj,List<string> nameFields,String selectField,Map<string,string> fieldDetail,String idOfRecord){
            objectName=obj;
            fieldName = nameFields;
            selectedField = selectField;
            fieldNameWithAPI = fieldDetail;
            recordId = IdOfRecord;
        }
    }