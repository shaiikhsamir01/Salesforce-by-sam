public class TestBarcodeMail {

    public Decimal decPoints {
            get {
                if (decPoints == null) {
                    system.debug('decPoints==>'+decPoints);
                    decPoints = 0;
                }
                return decPoints;
            }
            set {
            system.debug('decPoints==>'+decPoints);
            decPoints = 15;
            }
        }
    public void myEmail(){
        /* List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage
string[]toAdd=new string[]{'mohitagarastreait@gmail.com'};
mail.setReplyTo('mohitagarastreait@gmail.com');
mail.setSenderDisplayName('CRM Support');
//Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail 
//  list<account> acclist = new list<Account>();
//  acclist = [select   SmartBarcode__Barcode__c from Account where id = '0017F000003DxSh'];
list<account> acclist = new list<Account>();
acclist = [select   SmartBarcode__Barcode__c from Account where id = '0017F000003DxSh'];
// Add to attachment
for(Account a : acclist)
{
Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
efa.setFileName('barcode.pdf');
efa.setBody(blob.toPDF(a.SmartBarcode__Barcode__c));
// Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
mail.setSubject('PDF of BarCode - ');
mail.setToAddresses(toAdd);
mail.sethtmlBody('Hi,<br/><br/> '
+'Barcode PDF.'+ a.SmartBarcode__Barcode__c
+'<br/><br/>');
mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
mails.add(mail);
}
Messaging.sendEmail(mails);*/
        //Send email
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Account a = new Account();
        a.name = 'test';
        if(Schema.SObjectType.Account.fields.Name.isCreateable()){
               insert a;
           }
       
        List<Account> acclist = new List<Account>(
            [
                select id,SmartBarcode__Barcode__c 
                from Account 
                where id =: a.Id
            ]
        );
        for(Account e :acclist){  
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.setContentType('application/pdf');
            attach.setFileName('barcode.pdf');
            String body;
            body = '<html><h1 style=\"text-align:center;\">Barcode testing</h1><br/><br/><table align=\"center\"><tr><td>Barcode</td><td>' + e.SmartBarcode__Barcode__c  + '</td></tr></table></html>';
            System.debug('HTML is ' + body);
            attach.Body = Blob.toPDF(body);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            string[]toAdd=new string[]{'nitin.astrea@gmail.com'};
                mail.setToAddresses(toAdd);
            mail.setSubject('PDF Generation');
            mail.setHtmlBody('<html><h1 style=\"text/css-align:center;\">Barcode testing</h1><br/><br/><table align=\"center\"><tr><td>Barcode</td><td>' + e.SmartBarcode__Barcode__c  + '</td></tr></table></html>');
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });    
            mails.add(mail); 
        }
        if(!mails.isEmpty()) {
            Messaging.SendEmail(mails);
        }
    }
}