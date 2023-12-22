trigger PracticeAccountTrigger on Account (before insert,after insert, after update,before update,after delete,before delete,after undelete) {
    switch on Trigger.operationType{
        when BEFORE_INSERT{
            for(Account acc: Trigger.new)
            {
                if(acc.BillingStreet !=null){
                    acc.ShippingStreet=acc.BillingStreet;
                }
                if(acc.BillingCity !=null){
                    acc.ShippingCity=acc.BillingCity;
                }
                if(acc.BillingState !=null){
                    acc.ShippingState=acc.BillingState;
                }
                if(acc.BillingPostalCode !=null){
                    acc.ShippingPostalCode=acc.BillingPostalCode;
                }
                if(acc.BillingCountry !=null){
                    acc.ShippingCountry=acc.BillingCountry;
                }
            }
        }
        when AFTER_UPDATE{
            set<Id> accountIds = new set<Id>();
            for(Account acc : Trigger.new){
                 accountIds.add(acc.Id);
            }
            List<Opportunity> opps = [SELECT Id,AccountId,StageName,CreatedDate,CloseDate FROM Opportunity WHERE AccountId IN :accountIds];
            List<Opportunity> oppsToUpdate = new List<Opportunity>();
            DateTime day30 = System.now()-30;
            if(opps.size()>0 && opps != null) {
                 for(Opportunity op : opps){
                     if(op.CreatedDate <day30 && op.stageName!='Closed Won'){
                 op.stageName='Closed Lost';
                   op.CloseDate=system.Today();
                    oppsToUpdate.add(op);
                }
            }
            }
            if( oppsToUpdate.size()>0){
                update  oppsToUpdate;
            }
        }
        when BEFORE_UPDATE{
            set<Id> accountIds = new set<Id>();
            for(Account acc: Trigger.new)
            {
                accountIds.add(acc.Id);
            }
            List<AggregateResult> results = [SELECT AccountId , SUM(Amount) TotalAmount FROM Opportunity WHERE AccountId IN :accountIds GROUP BY  AccountId ];
           Map<Id,double> amountMap = new  Map<Id,double>();
            for(AggregateResult result :results){
                String accId = String.valueOf(result.get('AccountId'));
                double totalAmount = double.valueOf(result.get('TotalAmount'));
               amountMap.put(accId, totalAmount);
            }
            for(Account acc : Trigger.new)
            {
                if(amountMap.containsKey(acc.Id))
                {
                    acc.Total_Opportunity_Amount__c=amountMap.get(acc.Id);
                }
            }
    }
        when AFTER_INSERT{
            set<Id> accIds = new set<Id>();
            List<Account> accListToUpdate= new List<Account>();
            List<Contact> conList = new List<Contact>();
            for(Account acc: Trigger.new){
                Contact con = new Contact();
                con.LastName=acc.Name;
                con.AccountId=acc.Id;
                conList.add(con);
                accIds.add(acc.id);
            }
            if(conList.size()>0)
            {
                insert conList;
            }
            List<Account> accList = [SELECT Id , Client_Contact__c FROM Account WHERE Id IN: accIds];
            Map<Id,Account> accountsMap = new Map<Id,Account>();
            for(Account acc: accList)
            {
                if(!accountsMap.containsKey(acc.Id))
                {
                    accountsMap.put(acc.Id ,acc);
                }
                
            }
            for(Contact con:conList ){
                if(accountsMap.containsKey(con.AccountId))
                {
                    Account a = accountsMap.get(con.AccountId);
                    a.Client_Contact__c=con.Id;
                    a.Industry='Finance';
                    accListToUpdate.add(a);
                }
            }
            if(accListToUpdate.size()>0)
            {
                UPDATE accListToUpdate;
            }
           /* List<Account> acctest = new List<Account>();
            for(Account acc:Trigger.new)
            {
                /*Account a = new Account(Id=acc.Id);
                a.Industry='Finance';
                acctest.add(a);
                acc.Industry='finance';
                    acctest.add(acc);
            }
            Update acctest;*/
        }
}
}