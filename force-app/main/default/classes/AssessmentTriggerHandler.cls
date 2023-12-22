public class AssessmentTriggerHandler {
    //this is my code for interview
    //commenting because i am testing github
    public static void method(List<Opportunity> oppList,Map<Id,Opportunity> oldMap){
        set<Id> accId = new  set<Id>();
        List<Account> accToUpdate = new List<Account>();
        if(oldMap != null){
            for(Opportunity op:oppList){
                if(op.AccountId != null && op.AccountId != oldMap.get(op.Id).AccountId){
                    accId.add(oldMap.get(op.Id).AccountId);
                }
                accId.add(op.AccountId); 
            }  
        }else{
            for(Opportunity op:oppList){
                if(op.AccountId != null){
                    accId.add(op.AccountId);
                }
            } 
        }
        
        /*List<AggregateResult> aggList=[SELECT AccountId,SUM(Amount) totalAmount from Opportunity WHERE AccountId IN:accId
                                       GROUP BY AccountId];
       
        
        if(!aggList.isEmpty()){
            for(AggregateResult ag : aggList){
                Account a = new Account(Id=(Id)ag.get('AccountId'),Total_Opportunity_Amount__c=(decimal)ag.get('totalAmount'));
                accToUpdate.add(a);
            }
        }*/
        
        List<Account> accList =[SELECT Id,(SELECT Id,Amount FROM Opportunities) FROM Account WHERE Id IN:accId];
        Map<Id,Decimal> accountsMap = new  Map<Id,Decimal>();
        
        for(Account a:accList){
            decimal total=0;
            for(Opportunity op:a.Opportunities){
                total+=op.Amount;
            }
           accountsMap.put(a.Id,total);
        }
        
        for(Id ac :accountsMap.keySet()){
            
        }
        
        if(!accToUpdate.isEmpty()){
            UPDATE accToUpdate;   
        }
    }
}