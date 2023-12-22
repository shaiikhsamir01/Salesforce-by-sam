//We need show that only one contact associated with A account 
trigger SinglePrimaryContactOnAc on Contact (before insert){
set<Id> accIds = new set<Id>();
    if(Trigger.IsInsert && !Trigger.new.isEmpty()){
        for(Contact con:Trigger.new){
            if(con.AccountId != null){
               accIds.add(con.AccountId); 
            }
        }
    }
    List<Contact> conList = [SELECT Name,Id,AccountId FROM Contact WHERE AccountId IN :accIds];
    system.debug(conList);
    system.debug((conList != null )+'null check');
    system.debug(conList.isEmpty()+'empty method');
    Map<Id,set<Contact>> accConMap = new Map<Id,set<Contact>>();
    if(!conList.isEmpty()){
        system.debug('in conlist loop');
         for(Contact con :conList){
             if(con.AccountId != null){
                  if(!accConMap.containsKey(con.AccountId)){
                      accConMap.put(con.AccountId,new set<Contact>());
                  }
                    accConMap.get(con.AccountId).add(con);
             }
    }
}
   
    if(!accConMap.isEmpty()){
         for(Contact con:Trigger.new){    
                  if(con.AccountId != null){
                      system.debug('hello');
                      if(accConMap.get(con.AccountId).size()!= null){
                          system.debug('hello');
                             if(accConMap.get(con.AccountId).size()==1){
                          con.addError('You can have only one contact associated with a Account');
                             }
                      }
         }
      }      
    }
 
}