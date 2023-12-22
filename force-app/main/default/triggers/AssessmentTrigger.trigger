trigger AssessmentTrigger on Opportunity (after insert,after update,after delete){
    if(Trigger.isUpdate){
        AssessmentTriggerHandler.method(Trigger.new,Trigger.oldMap);
    }
    else if(Trigger.isDelete){
           AssessmentTriggerHandler.method(Trigger.old,null);
    }
    else{
       AssessmentTriggerHandler.method(Trigger.new,null); 
    }
}