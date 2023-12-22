/**
* Change histoty : 
* Changed By : Nitin Aggarwal
* Changed Date : 09/04/2019
* description - Added line 53 to hide loading spinner which was keeps on showing when user clicks on generate barcode without selecting any field.
*
*/
({
    doInit : function(component, event, helper) {
        var action=component.get("c.dynamicBarCodeCtrMethod");
        action.setParams({
            "recordId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set('v.objectName', response.getReturnValue().objectName);
                component.set("v.fieldsName", response.getReturnValue().fieldName); 
                component.set("v.apiNameWithFieldName", response.getReturnValue().fieldNameWithAPI); 
                component.set("v.idRecord", response.getReturnValue().recordId); 
            }
            else {
                var errors = response.getError();
                if(errors[0] && errors[0].message){
                    console.log(errors[0].message);
                }
                else if(errors[0] && errors[0].pageErrors){   
                    console.log(errors[0].pageErrors[0].message);
                }
            }
        });        
        $A.enqueueAction(action);
    },
    generateBarcodeValue : function(component, event, helper) {
        component.set("v.isSending", true);
        component.set("v.generateValue",null); 
        var selectedfieldName = component.find("selectedField").get("v.value");
        var selectedformat = component.find("formatType").get("v.value");
        var selectedObjectName = component.get("v.objectName");
        var MapValue = component.get("v.apiNameWithFieldName");
        var RecordValue = component.get("v.idRecord");
        if(selectedfieldName=='--None--'){
            component.set("v.hasErrors", true);
            component.set("v.showErrorMessage", 'Please select Field Name');
            component.set("v.isSending", false);
        }
        else{
            var action=component.get("c.generateBarcodeLighting");
            var whichOne = event.getSource().getLocalId();
            if(whichOne=='Generate'){
                component.set("v.showValue", true);
                action.setParams({
                    "generatePdf": false,
                    "selectedRecord":RecordValue,
                    "selectedField" :selectedfieldName,
                    "selectedFormat" : selectedformat,
                    "objName":selectedObjectName,
                    "mapValue" :MapValue
                }); 
            }
            else{
                component.set("v.showValue", false);
                action.setParams({
                    "generatePdf": true,
                    "selectedRecord":RecordValue,
                    "selectedField" :selectedfieldName,
                    "selectedFormat" : selectedformat,
                    "objName":selectedObjectName,
                    "mapValue" :MapValue
                });
            }
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                component.set("v.isSending", false);
                if (component.isValid() && state === "SUCCESS") {
                    component.set("v.generateValue",response.getReturnValue().generatedValue); 
                    component.set("v.barcodeValue",response.getReturnValue().barCodevalue); 
                    console.log(response.getReturnValue().notSuccess);
                    $A.get('e.force:refreshView').fire();
                    if(response.getReturnValue().notSuccess){
                        if(component.find("formatType").get("v.value") === 'EAN 13'){
                            component.set("v.hasErrors", true);
                        	component.set("v.showErrorMessage", 
                                      'Plese Check either Field value is Null Or Not Realted to the Format or the 13th character not equals to checksum or Please try with correct checksum digit or try with 12 digit input.');  
                        }else{
                            component.set("v.hasErrors", true);
                        	component.set("v.showErrorMessage", 
                                      'Plese Check either Field value is Null Or Not Realted to the Format');  
                        }     
                    }
                    else{
                        component.set("v.hasErrors",false);
                        component.set("v.showErrorMessage", '');        
                    }
                }
            });           
            $A.enqueueAction(action);
        }
    },
    
    emailasPdf : function(component, event, helper) {
        var emailaddress = component.get("v.emailaddress");
        var selectedfieldName = component.find("selectedField").get("v.value");
        var selectedformat = component.find("formatType").get("v.value");
        var selectedObjectName = component.get("v.objectName");
        var MapValue = component.get("v.apiNameWithFieldName");
        var RecordValue = component.get("v.idRecord");
        if(selectedfieldName=='--None--'){
            component.set("v.hasErrors", true);
            component.set("v.showErrorMessage", 'Please select Field Name');
            component.set("v.isSending", false);
        }
        else{
            var action = component.get("c.emailPdf");
            action.setParams({
                "selectedRecord":RecordValue,
                "selectedField" :selectedfieldName,
                "selectedFormat" : selectedformat,
                "objName":selectedObjectName,
                "mapValue" :MapValue,
                "emailaddress" :emailaddress
            }); 
            action.setCallback(this, function(response) {
                console.log("response==>"+response);
                var state = response.getState();
                console.log("state==>"+state);
                component.set("v.isSending", false);
                if (state === "SUCCESS") {
                    console.log("Inside success block");
                    if(response.getReturnValue()){
                        console.log("response.getValue()==>"+response.getReturnValue());
                    }
                }
            }); 
            $A.enqueueAction(action);
        }
        
    }
})