//Prevent duplicate account on the basis of names
trigger PreventDuplicate on Account (before insert,before update) {
set<String> names = new set<String>();
    if(Trigger.Isbefore && (Trigger.IsInsert ||Trigger.IsUpdate)){
        if(!Trigger.new.isEmpty()){
            for(Account ac:Trigger.new){
                if(ac.Name!= null){
               names.add(ac.Name);
                }
            }
        }
    }
    Map<String,Account> accountsMap = new Map<String,Account>();
    for(Account ac:[SELECT Name,Id FROM Account WHERE Name IN :names]){
                 if(ac.Name!= null){
                       accountsMap.put(ac.Name, ac);
                 }
    }
    for(Account a :Trigger.new){
        if(a.Name != null){
            if(accountsMap.containsKey(a.Name)){
                a.addError('Duplicate Account Name.Kindly change it');
            }
        }
    }
}