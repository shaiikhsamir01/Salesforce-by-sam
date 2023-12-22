public class oneGo {
public Account acc {get;set;}
public Contact con{get;set;}
public Opportunity opp{get;set;}
      public oneGo(){
acc = new Account();
con = new Contact();
opp = new Opportunity();
}
public pagereference save(){
 //Account acc= new Account(Name=accName,phone=phone,AccountNumber=AccountNumber);
insert acc;
//Contact con= new Contact(accountId=acc.Id,lastName=conName,Email=email,Department=department);
//insert con;
//Opportunity opp= new Opportunity(Name=oppName,CloseDate=closeDate,accountId=acc.Id,Amount=oppAmount,StageName='Needs Analysis');
con.accountId=acc.Id;
opp.accountId=acc.Id;
insert con;
insert opp;
pagereference pf = new pagereference('/'+acc.id);
return pf;
}
}