trigger PracticeTaskTrigger on Task (before delete) {
Id pid = userInfo.getProfileId();
 Profile pname=[select Name from Profile where id=:pid];
    for(Task t : Trigger.old)
    {
        if(pname.Name !='System Administrator')
        {
          t.addError('You can\'t delete this record') ; 
        }
    }
}